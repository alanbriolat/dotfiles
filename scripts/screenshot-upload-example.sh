#!/bin/bash
notify-send "Uploading screenshot"
exec screenshot-upload.py \
    --rename "/tmp/%Y%m%d-%H%M%S{ext}" \
    --shadow \
    --url "http://iris.hexi.co/~alan/screenshots/{file}" \
    --launch \
    scp "alan@iris.hexi.co:~/public_html/screenshots/" \
    "$1" >> /tmp/screenshot-upload.log
