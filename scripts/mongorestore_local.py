#!/usr/bin/env python2
import subprocess
import argparse
import time
import os.path
import sys


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('db_path')
    parser.add_argument('database')
    parser.add_argument('backup_path')
    parser.add_argument('--port', default='27019')
    args = parser.parse_args()
    mongo_cmd = ['mongod', '--dbpath', args.db_path, '--port', args.port,
                 '--wiredTigerCacheSizeGB', '2']
    print 'Launching mongod:', mongo_cmd
    proc = subprocess.Popen(mongo_cmd)
    print 'Waiting 5 seconds for mongod to start...'
    sock_file = '/tmp/mongodb-{}.sock'.format(args.port)
    count = 10
    while not os.path.exists(sock_file):
        count -= 1
        if count < 0:
            print "Couldn't find socket! Exiting..."
            proc.kill()
            proc.wait()
            sys.exit(1)
        else:
            time.sleep(1)
            print 'Trying to find socket:', sock_file
    print 'Socket found!'

    print 'Dropping database...'
    drop = subprocess.Popen(['mongo', '--host', 'localhost', '--port', args.port, args.database,
                             '--eval', 'db.dropDatabase()'])
    drop.wait()

    restore_cmd = [
            'mongorestore', '--host', 'localhost', '--port', args.port,
            '--db', args.database, '--drop',
    ]
    if os.path.isfile(args.backup_path):
        restore_cmd.extend(['--archive=' + args.backup_path])
        if args.backup_path.endswith('.gz'):
            restore_cmd.extend(['--gzip'])
    else:
        restore_cmd.extend([os.path.join(args.backup_path, args.database)])
    print 'Running mongorestore:', restore_cmd, '...'

    restore = subprocess.Popen(restore_cmd)
    restore.wait()

    print 'Done! Shutting down mongod...'

    proc.terminate()
    proc.wait()

    print 'Done!'
