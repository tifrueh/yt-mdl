#!/bin/sh

help="usage: yt-mdl URL

options:
    URL         The URL of the YouTube Music playlist that is the album."

if [ $# -ne 1 ]; then
    printf "%s\n" "${help}"
    exit 1
elif [ "$1" == "-h" -o "$1" == "--help" ]; then
    printf "%s\n" "${help}"
    exit 0
fi

yt-dlp \
    --yes-playlist \
    --format 'ba*' \
    --extract-audio \
    --embed-metadata \
    --parse-metadata 'playlist_index:%(track_number)s' \
    --embed-thumbnail \
    --convert-thumbnails 'jpg' \
    --output '%(playlist_index)s %(title)s.%(ext)s' \
    "$1"
