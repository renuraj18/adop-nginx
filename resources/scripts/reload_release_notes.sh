#!/bin/bash

# Script to reload plugins.json with all the release-notes pages, that are
# available in the usr/share/nginx/html/bp folder.

# Set up initial variables
release_note=/usr/share/nginx/html
release_note_folder=${release_note}/bp
n=0;

# Loop trough the files and add each of them to the webpage
shopt -s nullglob
for f in ${release_note_folder}/*-release-note.htm*
do
  this_path=${release_note_folder}/$f
  this_file=${this_path##*/}
  cat ${release_note}/plugins.json | jq ".blueprints[$n] = {\"url\": \"bp/$this_file\"}" > /tmp/plugins.json.new
  mv /tmp/plugins.json.new ${release_note}/plugins.json
  n=$((n+1))
done
n=0
for f in ${release_note_folder}/*-component.json
do
	cat ${release_note}/plugins.json| jq '.core[0].components'| jq "contains(`cat $f|jq '.components'`)"
        if [ $? -eq 0 ]; then
                echo "adding"
                cat ${release_note}/plugins.json | jq ".core[0].components += `cat $f|jq '.components'`" > $release_note/plugins.json.new
                mv $release_note/plugins.json.new ${release_note}/plugins.json
                n=$((n+1))
        fi
done
