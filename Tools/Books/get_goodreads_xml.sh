#!/bin/bash
#
# get_goodreads_xml.sh
#
# Unfortunately, the Goodreads CSV export does not include the book cover images.
# If you want the links to the book covers for your library in Goodreads they are
# available in the RSS feeds for the Goodread shelves you have created. In Goodreads,
# go to a shelf (`My Books` then click on a shelf listed under `Bookshelves`) and at
# the bottom right corner there should be an RSS feed icon. Right click the RSS icon
# and copy the link. The RSS feed link should look something like
#
# https://www.goodreads.com/review/list_rss/XXXXXXX?key=YYYsomelongstringofdigitsandnumbersYYYE&shelf=anthologies
#
# where `XXXXXXX` and `YYYblablablaYYY` are private codes representing your Goodreads
# ID and the shelf key. Take note of the last component of the RSS feed URL, the part
# in the example above with `&shelf=anthologies`. The `anthologies` part is the name
# of the shelf, in your case it will be something else, whatever the name of the shelf
# you selected.
#
# I wrote this script to make it easier to download the bookshelves RSS feed XML data.
# All you need to use this script is the first part of any RSS feed URL in your
# Goodreads bookshelves. In the example above that would be
# https://www.goodreads.com/review/list_rss/XXXXXXX?key=YYYsomelongstringofdigitsandnumbersYYYE&shelf=
# 
# That is, everything but the shelf name.
# 
# Replace the `baseurl` URL in the following script with your Goodreads base URL
# from an RSS feed URL of one of your shelves. Also replace the list of Goodreads
# shelves below in the variable `shelves` with a list of the shelves in your
# Goodreads library that you wish to export to XML.
# 
# After configuring the script with your private base Goodreads RSS feed URL and
# the list of your Goodreads bookshelves, simply run the script and it will
# download all the XML exports for the listed Goodreads shelves. These contain
# the links to the book cover images.
# 
# **[Note:]** Goodreads RSS feeds only include the first 100 entries of a shelf.
# I had to create new shelves and split any existing Goodreads shelves over 100
# entries in size up into multiple shelves. What a pain. So, everything cannot
# be automated because services are lame.

# Enter urls to your goodreads rss feed below.
# You can find it by navigating to one of your goodreads shelves and
# clicking the "RSS" button at the bottom of the page.

baseurl="https://www.goodreads.com/review/list_rss/2401015?key=S32et3Fz0RHR5EvFXCAxe6F3vqx_GasSQVSDLnEQMQ_uO2kT&shelf="

shelves="anthologies biography bob brautigan conklin essays farmer fiction \
         huxley leary literature mathematics mcmurtry murakami nonfiction \
         novels p-k-dick palahniuk philosophy poetry reference robbins science \
         science-fiction short-stories steinbeck vonnegut currently-reading \
         read to-read"

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
