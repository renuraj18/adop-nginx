#!/bin/bash
set -e

cp -R /resources/configuration/* /etc/nginx/
cp -R /resources/release_note/* /usr/share/nginx/html/

# Auto populate the release note page with the blueprints
/resources/scripts/reload_release_notes.sh

# Copy and replace tokens
perl -p -i -e 's/###([^#]+)###/defined $ENV{$1} ? $ENV{$1} : $&/eg' < "/templates/configuration/nginx.conf" 2> /dev/null 1> "/etc/nginx/nginx.conf"

/usr/sbin/nginx
