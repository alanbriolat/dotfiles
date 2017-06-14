#!/usr/bin/env python3
from configparser import ConfigParser
from argparse import ArgumentParser
import os
import logging
from pathlib import Path
import subprocess


log = logging.getLogger(__name__)
default_root = Path(__file__).parent


class Config:
    def __init__(self, config_file, src, dest, dry_run=False, relative_symlinks=True):
        self.config = ConfigParser(interpolation=None, allow_no_value=True)
        self.config.optionxform = lambda option: option
        self.config.read_file(config_file)
        self.src = Path(src).absolute()
        self.dest = Path(dest).absolute()
        self.dry_run = dry_run
        self.relative_symlinks = relative_symlinks
        self._env = os.environ.copy()
        self._env['SRC'] = str(self.src)
        self._env['DEST'] = str(self.dest)

    def process(self, sections):
        """Process configuration sections, perform actions.
        """
        for name in sections:
            if name not in self.config:
                raise ValueError('Section "{}" does not exist. Available sections: {}'
                                 .format(name, self.available_sections))
            section = self.config[name]
            log.info('Processing "{}" section...'.format(name))
            for key, value in section.items():
                if value is not None:
                    self.copy(key, value)
                elif key.startswith('$'):
                    self.run(key[1:])
                else:
                    self.symlink(key, key)

    @property
    def available_sections(self):
        return list(k for k in self.config.keys() if k != 'DEFAULT')

    def copy(self, src, dest):
        """Copy *src* in source directory to *dest* in destination directory.
        """
        src = self.src / src
        dest = self.dest / dest
        self._ensure_directory(dest.parent)
        log.info('Copying {} -> {}'.format(src, dest))
        self._do(subprocess.check_output, ['cp', '-a', '-n', str(src), str(dest)])

    def symlink(self, src, dest):
        """Symlink *src* in source directory to *dest* in destination directory.
        """
        src = self.src / src
        dest = self.dest / dest
        self._ensure_directory(dest.parent)
        log.info('Creating {} symlink {} -> {}'
                 .format('relative' if self.relative_symlinks else 'absolute', src, dest))
        cmd = ['ln', '-s', '-T']
        if self.relative_symlinks:
            cmd += ['-r']
        cmd += [str(src), str(dest)]
        self._do(subprocess.check_output, cmd, stderr=subprocess.STDOUT)

    def run(self, cmd):
        """Run shell *cmd* in the destination directory.
        """
        log.info('Running command: {}'.format(cmd))
        self._do(subprocess.check_output, cmd, shell=True, cwd=str(self.dest), stderr=subprocess.STDOUT, env=self._env)

    def _do(self, f, *args, **kwargs):
        """Call ``f(*args, **kwargs)`` only if we're not in "dry run" mode.
        """
        if not self.dry_run:
            try:
                f(*args, **kwargs)
            except subprocess.CalledProcessError as e:
                log.error('Error! ({}) {}'.format(e.returncode, e.output.decode('utf-8').strip()))

    def _ensure_directory(self, path):
        """Make sure the directory at *path* exists.
        """
        if not path.exists():
            log.debug('Creating directory: {}'.format(path))
            self._do(path.mkdir, parents=True, exist_ok=True)


if __name__ == '__main__':
    parser = ArgumentParser()
    parser.add_argument('--src', help='source directory')
    parser.add_argument('--dest', help='destination directory')
    parser.add_argument('--config', help='configuration file (default: {src}/dotfiles.ini)')
    parser.add_argument('--dry-run', action='store_true', default=False,
                        help="don't actually execute any commands")
    parser.add_argument('--absolute-symlinks', action='store_true', default=False,
                        help='use absolute symlinks instead of relative')
    parser.add_argument('--list-sections', action='store_true', default=False,
                        help='list available sections and exit')
    parser.add_argument('--all', action='store_true', default=False,
                        help='apply all configuration sections')
    parser.add_argument('section', nargs='*', help='configuration section to apply')
    args = parser.parse_args()

    logging.basicConfig(format='%(message)s', level=logging.DEBUG)

    src_path = Path(args.src or default_root)
    dest_path = Path(args.dest or os.environ['HOME'])
    config_path = Path(args.config or (src_path / 'dotfiles.ini'))

    with open(str(config_path), 'r') as f:
        config = Config(f,
                        src=src_path,
                        dest=dest_path,
                        dry_run=args.dry_run,
                        relative_symlinks=not args.absolute_symlinks)

        sections = config.available_sections if args.all else args.section
        if args.list_sections or not sections:
            print('Available configuration sections:')
            for name in config.available_sections:
                print('  ' + name)
        else:
            config.process(sections)
