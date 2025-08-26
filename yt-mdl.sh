#!/bin/sh

progname="$(basename $0)"

help="usage: ${progname} [ -a ALBUM ] [ -A ARTIST ] URL

options:
    -a, --album ALBUM           Override the album metadata field.
    -A, --artist ARTIST         Override the artist metadata field.
    URL                         The URL of the YouTube Music album."

if [ $# -lt 1 -o $# -gt 5 ]; then
    printf "%s\n" "${help}"
    exit 1
elif [ "$1" == "-h" -o "$1" == "--help" ]; then
    printf "%s\n" "${help}"
    exit 0
fi

while [ $# -gt 0 ]; do
    if [ "$1" = "-a" -o "$1" = "--album" ]; then
        arg_album="--parse-metadata '$2:%(album)s'"
        shift 2
    elif [ "$1" = "-A" -o "$1" = "--artist" ]; then
        arg_artist="--parse-metadata '$2:%(artist)s'"
        shift 2
    elif [ "$1" = "--" ]; then
        url="$2"
        break
    else
        url="$1"
        shift
    fi
done

base="yt-dlp"
arg_audio="--extract-audio --audio-format 'm4a'"
arg_format="--format 'ba*[acodec^=aac]/ba*[acodec^=mp4a.40.]/ba*'"
arg_metadata="--embed-metadata --parse-metadata 'playlist_index:%(track_number)s'"
arg_output="--output '%(playlist_index)s %(title)s.%(ext)s'"
arg_playlist="--yes-playlist"
arg_thumbnail="--embed-thumbnail --convert-thumbnails 'jpg'"

cmd="${base}
    ${arg_audio}
    ${arg_format}
    ${arg_metadata} ${arg_album} ${arg_artist}
    ${arg_output}
    ${arg_playlist}
    ${arg_thumbnail}
    '${url}'"

printf 'Command to be executed:\n\n%s\n\nContinue? [y/N] ' "$cmd"
read cont

if [ "$cont" != "y" -a "$cont" != "Y" ]; then
    exit 1
fi

printf '\n'

eval $cmd
