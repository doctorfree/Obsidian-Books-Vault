#!/bin/bash

# Enter urls to your goodreads rss feed below.
# You can find it by navigating to one of your goodreads shelves and
# clicking the "RSS" button at the bottom of the page.

baseurl="https://www.goodreads.com/review/list_rss/2401015?key=S32et3Fz0RHR5EvFXCAxe6F3vqx_GasSQVSDLnEQMQ_uO2kT&shelf="

shelves="read2 read3"

# Enter the path to your Vault or XML download folder
vaultpath="/home/ronnie/Documents/Obsidian/Obsidian-Media-Vault/Tools/Books/data/xml"

for shelf in ${shelves}
do
  echo "Processing ${shelf}"
  url="${baseurl}${shelf}"
  # Get the last componenet of the url
  this_shelf=`echo ${url} | awk -F '=' ' { print $NF } '`
  # This grabs the data from the rss feed and formats it
  IFS=$'\n' feed=$(curl --silent "$url" | grep -E '(book_large_image_url>|book_id>)' | \
  sed -e 's/<!\[CDATA\[//' -e 's/\]\]>//' \
    -e "s/Ron.s bookshelf: ${this_shelf}//" \
    -e 's/<book_large_image_url>//' -e 's/<\/book_large_image_url>/ | /' \
    -e 's/<book_id>//' -e 's/<\/book_id>/ | /' \
    -e 's/^[ \t]*//' -e 's/[ \t]*$//' | \
    tail +3 | \
    fmt | paste -s -d' \n'
  )

  # Save the formatted rss feed data
  echo "${feed}" > ${vaultpath}/${this_shelf}.md

  # Save the unformatted rss feed data
  curl --silent "$url" > ${vaultpath}/${this_shelf}.xml
done
