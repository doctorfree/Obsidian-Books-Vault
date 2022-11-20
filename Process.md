---
banner: "assets/banners/Process-Banner.png"
banner_x: 0.2
banner_y: 0.8
---

# Process

Several custom scripts and utilities were used to automate the generation of markdown files in the Obsidian Books Vault. For example, the source data used in the generation of the Books vault consisted of a CSV export of a Goodreads library along with XML format RSS feeds of all the bookshelves in that Goodreads library. The CSV and XML were processed using tools like [csvkit](https://csvkit.readthedocs.io/en/latest), `grep`, `sed`, `awk`, and other system utilities.

There are several other techniques for generating, curating, and maintaining media libraries in Obsidian. Some use the commercial service [Readwise](https://readwise.io) which also has an official Obsidian plugin to export from Readwise into Obsidian. These process notes describe the automated workflow to export from Goodreads to Obsidian but Readwise is an excellent service if you can afford the subscription cost and the workflow is much simpler with Readwise.

See the [See also](#see_also) section below for links to some of these other techniques.

## Table of Contents

- [Overview](#overview)
- [Requirements](#requirements)
- [Books library](#books_library)
- [See also](#see_also)

## Overview

If your media libraries are cataloged in an online service such as [Discogs](https://discogs.com) or [Goodreads](https://goodreads.com) or in a media management system such as [CLZ Music](https://connect.collectorz.com) or [Invelos DVD Profiler](http://www.invelos.com/) then it is usually possible to export your online library to a file format that can be converted to markdown. Usually there is an option to export the data to CSV format and that is typically what I used although in some cases all that is available is XML format. Either will work although CSV format is much easier to parse using `csvkit`.

The first step is gathering data sources. That step, for this vault, was exporting data from my Goodreads library.

## Requirements

Most of the download, conversion, creation, and curation process was performed on Linux using the standard utilities included with every Linux distribution. It is probably also possible to use these same tools on Mac OS as its underlying operating system and utilities are BSD. I doubt this will work on Windows but maybe with WSL. Use Linux.

In addition to the standard Linux utilities, some of the conversion tools require either [Pandoc](https://pandoc.org) or [Sqlite](https://www.sqlite.org/index.html).

The CSV and XML were processed using [csvkit](https://csvkit.readthedocs.io/en/latest).

If your Linux distribution does not include `curl` then that will also need to be installed.

## Books_library

My books are catalogued in Goodreads. To export a Goodreads book library, login to Goodreads and click `My Books`. Scroll down and click `Import and export` on the left. Click the `Export` button and wait for Goodreads to generate a link to your library export CSV file. Download that file by right clicking the generated link and saving to local disk.

The following scripts generate Markdown format files for each of the books in the downloaded CSV format Goodreads export, download the Goodreads RSS feed XML for specified bookshelves, and create various indexes of the generated Obsidian vault. Click the arrow to the left of the details link to expand or collapse each script.

<Details markdown="block">

Script to generate Markdown format files for each of the books in the downloaded CSV format Goodreads export.

### [Tools/Books/csv2md](Tools/Books/csv2md.md) (click to collapse/expand)

```shell

#!/bin/bash
#
# Produce markdown table entries with csvcut
# csvcut -c 1,2,3 data/good*.csv | csvformat -D \|
#
# For example:
# echo "| Book Id | Title | Author | Additional Authors | ISBN | ISBN13 | \
#       My Rating | Average Rating | Publisher | Binding | Number of Pages | \
#       Year Published | Bookshelves | Exclusive Shelf | My Review |" > Books.md
# echo "|---------|-------|--------|--------------------|------|--------| \
#       ----------|----------------|-----------|---------|-----------------| \
#       ---------------|-------------|-----------------|-----------|" > Books.md
# csvcut -c 1,2,3,5,6,7,8,9,10,11,12,14,17,19,20 data/good*.csv | csvformat -D \| >> Books.md

BOOKS="../../Books"
update=
[ "$1" == "-u" ] && update=1

[ -d ${BOOKS} ] || mkdir ${BOOKS}

cat data/goodreads_library_export.csv | while read line
do
  if [ "${first}" ]
  then
    title=`echo ${line} | csvcut -c 2`
    filename=`echo ${title} | \
        sed -e "s% %_%g" \
            -e "s%,%_%g" \
            -e "s%(%%g" \
            -e "s%)%%g" \
            -e "s%:%-%g" \
            -e "s%\#%%g" \
            -e "s%\.%%g" \
            -e "s%\"%%g" \
            -e "s%\&%and%g" \
            -e "s%\?%%g" \
            -e "s%\\'%%g" \
            -e "s%'%%g" \
            -e "s%/%-%g"`
    echo "Processing ${filename}"
    author=`echo ${line} | csvcut -c 3`
    authordir=`echo ${author} | \
        sed -e "s% %_%g" \
            -e "s%,%_%g" \
            -e "s%(%%g" \
            -e "s%)%%g" \
            -e "s%:%-%g" \
            -e "s%\#%%g" \
            -e "s%\.%%g" \
            -e "s%\"%%g" \
            -e "s%\&%and%g" \
            -e "s%\?%%g" \
            -e "s%\\'%%g" \
            -e "s%'%%g" \
            -e "s%/%-%g"`
    [ -f ${BOOKS}/${authordir}/${filename}.md ] && continue
    [ -d ${BOOKS}/${authordir} ] || mkdir ${BOOKS}/${authordir}
    bookid=`echo ${line} | csvcut -c 1`
    authors=`echo ${line} | csvcut -c 5 | sed -e "s/^\"//" -e "s/\"$//" -e "s/\"\"/\"/g"`
    isbn=`echo ${line} | csvcut -c 6 | sed -e "s/=//g" -e "s/\"//g"`
    isbn13=`echo ${line} | csvcut -c 7 | sed -e "s/=//g" -e "s/\"//g"`
    rating=`echo ${line} | csvcut -c 8`
    avgrating=`echo ${line} | csvcut -c 9`
    publisher=`echo ${line} | csvcut -c 10 | sed -e "s/^\"//" -e "s/\"$//" -e "s/\"\"/\"/g"`
    binding=`echo ${line} | csvcut -c 11 | sed -e "s/^\"//" -e "s/\"$//" -e "s/\"\"/\"/g"`
    pages=`echo ${line} | csvcut -c 12`
    published=`echo ${line} | csvcut -c 14`
    shelves=`echo ${line} | csvcut -c 17 | sed -e "s/^\"//" -e "s/\"$//" -e "s/\"\"/\"/g"`
    shelf=`echo ${line} | csvcut -c 19 | sed -e "s/^\"//" -e "s/\"$//" -e "s/\"\"/\"/g"`
    review=`echo ${line} | csvcut -c 20 | sed -e "s/^\"//" -e "s/\"$//" -e "s/\"\"/\"/g"`
    echo "---" > ${BOOKS}/${authordir}/${filename}.md
    echo "bookid: ${bookid}" >> ${BOOKS}/${authordir}/${filename}.md
    echo "title: ${title}" >> ${BOOKS}/${authordir}/${filename}.md
    echo "author: ${author}" >> ${BOOKS}/${authordir}/${filename}.md
    echo "authors: ${authors}" >> ${BOOKS}/${authordir}/${filename}.md
    echo "isbn: ${isbn}" >> ${BOOKS}/${authordir}/${filename}.md
    echo "isbn13: ${isbn13}" >> ${BOOKS}/${authordir}/${filename}.md
    echo "rating: ${rating}" >> ${BOOKS}/${authordir}/${filename}.md
    echo "avgrating: ${avgrating}" >> ${BOOKS}/${authordir}/${filename}.md
    echo "publisher: ${publisher}" >> ${BOOKS}/${authordir}/${filename}.md
    echo "binding: ${binding}" >> ${BOOKS}/${authordir}/${filename}.md
    echo "pages: ${pages}" >> ${BOOKS}/${authordir}/${filename}.md
    echo "published: ${published}" >> ${BOOKS}/${authordir}/${filename}.md
    echo "shelves: ${shelves}" >> ${BOOKS}/${authordir}/${filename}.md
    echo "shelf: ${shelf}" >> ${BOOKS}/${authordir}/${filename}.md
    echo "review: ${review}" >> ${BOOKS}/${authordir}/${filename}.md
    echo "---" >> ${BOOKS}/${authordir}/${filename}.md
    echo "" >> ${BOOKS}/${authordir}/${filename}.md
    echo "# ${title}" >> ${BOOKS}/${authordir}/${filename}.md
    echo "" >> ${BOOKS}/${authordir}/${filename}.md
    echo "By ${author}" >> ${BOOKS}/${authordir}/${filename}.md
    echo "" >> ${BOOKS}/${authordir}/${filename}.md
    coverurl=`grep "|${bookid}|" data/book_covers.md | tail -1 | awk -F '|' ' { print $3 } '`
    [ "${coverurl}" ] && {
      echo "![](${coverurl})" >> ${BOOKS}/${authordir}/${filename}.md
      echo "" >> ${BOOKS}/${authordir}/${filename}.md
    }
    echo "## Book data" >> ${BOOKS}/${authordir}/${filename}.md
    echo "" >> ${BOOKS}/${authordir}/${filename}.md
    echo "[GoodReads ID/URL](https://www.goodreads.com/book/show/${bookid})" >> ${BOOKS}/${authordir}/${filename}.md
    echo "" >> ${BOOKS}/${authordir}/${filename}.md
    echo "- ISBN: ${isbn}" >> ${BOOKS}/${authordir}/${filename}.md
    echo "- ISBN13: ${isbn13}" >> ${BOOKS}/${authordir}/${filename}.md
    echo "- Rating: ${rating}" >> ${BOOKS}/${authordir}/${filename}.md
    echo "- Average Rating: ${avgrating}" >> ${BOOKS}/${authordir}/${filename}.md
    echo "- Published: ${published}" >> ${BOOKS}/${authordir}/${filename}.md
    echo "- Publisher: ${publisher}" >> ${BOOKS}/${authordir}/${filename}.md
    echo "- Binding: ${binding}" >> ${BOOKS}/${authordir}/${filename}.md
    echo "- Shelves: ${shelves}" >> ${BOOKS}/${authordir}/${filename}.md
    echo "- Shelf: ${shelf}" >> ${BOOKS}/${authordir}/${filename}.md
    echo "- Pages: ${pages}" >> ${BOOKS}/${authordir}/${filename}.md
    echo "" >> ${BOOKS}/${authordir}/${filename}.md
    [ "${review}" ] && {
      echo "## Review" >> ${BOOKS}/${authordir}/${filename}.md
      echo "" >> ${BOOKS}/${authordir}/${filename}.md
      echo "${review}" >> ${BOOKS}/${authordir}/${filename}.md
      echo "" >> ${BOOKS}/${authordir}/${filename}.md
    }
  else
    first=1
  fi
done

```

</Details>

<Details markdown="block">

Unfortunately, the Goodreads CSV export does not include the book cover images. If you want the links to the book covers for your library in Goodreads they are available in the RSS feeds for the Goodread shelves you have created. In Goodreads, go to a shelf (`My Books` then click on a shelf listed under `Bookshelves`) and at the bottom right corner there should be an RSS feed icon. Right click the RSS icon and copy the link. The RSS feed link should look something like `https://www.goodreads.com/review/list_rss/XXXXXXX?key=YYYsomelongstringofdigitsandnumbersYYYE&shelf=anthologies` where `XXXXXXX` and `YYYblablablaYYY` are private codes representing your Goodreads ID and the shelf key. Take note of the last component of the RSS feed URL, the part in the example above with `&shelf=anthologies`. The `anthologies` part is the name of the shelf, in your case it will be something else, whatever the name of the shelf you selected.

This script makes it easier to download the bookshelves RSS feed XML data. All you need to use this script is the first part of any RSS feed URL in your Goodreads bookshelves. In the example above that would be `https://www.goodreads.com/review/list_rss/XXXXXXX?key=YYYsomelongstringofdigitsandnumbersYYYE&shelf=`. That is, everything but the shelf name.

Replace the `baseurl` URL in the following script with your Goodreads base URL from an RSS feed URL of one of your shelves. Also replace the list of Goodreads shelves below in the variable `shelves` with a list of the shelves in your Goodreads library that you wish to export to XML.

After configuring the script with your private base Goodreads RSS feed URL and the list of your Goodreads bookshelves, simply run the script and it will download all the XML exports for the listed Goodreads shelves. These contain the links to the book cover images.

**[Note:]** Goodreads RSS feeds only include the first 100 entries of a shelf. I had to create new shelves and split any existing Goodreads shelves over 100 entries in size up into multiple shelves. What a pain. So, everything cannot be automated because services are lame.

The script used to generate the Markdown from Goodreads shelf XML RSS feeds:

### [Tools/Books/get_goodreads_xml.sh](Tools/Books/get_goodreads_xml.sh.md) (click to collapse/expand)

```shell

#!/bin/bash

# Enter urls to your goodreads rss feed below.
# You can find it by navigating to one of your goodreads shelves and
# clicking the "RSS" button at the bottom of the page.

baseurl="https://www.goodreads.com/review/list_rss/XXXXXXX?key=YYYsomelongstringofdigitsandnumbersYYYE&shelf="

shelves="anthologies biography bob brautigan conklin essays farmer fiction \
         huxley leary literature mathematics mcmurtry murakami nonfiction \
         novels p-k-dick palahniuk philosophy poetry reference robbins science \
         science-fiction short-stories steinbeck vonnegut currently-reading \
         read to-read"

# Enter the path to your Vault or XML download folder
vaultpath="/home/ronnie/Documents/Obsidian/Books/Tools/data/xml"

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

```

</Details>

<Details markdown="block">

Generate various indexes into the Markdown format files created in the Obsidian vault with the previous scripts. This script can generate lists of books sorted by author or title in list or table format.

### [Tools/Books/mkbooks](Tools/Books/mkbooks.md) (click to collapse/expand)

```shell

#!/bin/bash

VAULT="${HOME}/Documents/Obsidian/Obsidian-Books-Vault"
TOP="${VAULT}/Books"

usage() {
  printf "\nUsage: mkbooks [-A] [-T] [-f] [-p /path/to/Books] [-t] [-u]"
  printf "\nWhere:"
  printf "\n\t-A indicates sort by Author"
  printf "\n\t-T indicates sort by Title (default)"
  printf "\n\t-f indicates overwrite any pre-existing Books index markdown"
  printf "\n\t-p /path/to/Books specifies the full path to the Books folder"
  printf "\n\t(default: ${HOME}/Documents/Obsidian/Obsidian-Books-Vault/Books)"
  printf "\n\t-t indicates create a table rather than listing"
  printf "\n\t-u displays this usage message and exits\n\n"
  exit 1
}

mktable=
overwrite=
sortorder="title"

while getopts "ATfp:tu" flag; do
    case $flag in
        A)
            sortorder="author"
            ;;
        T)
            sortorder="title"
            ;;
        f)
            overwrite=1
            ;;
        p)
            TOP="${OPTARG}"
            ;;
        t)
            mktable=1
            numcols=1
            ;;
        u)
            usage
            ;;
    esac
done
shift $(( OPTIND - 1 ))

[ -d "${TOP}" ] || {
  echo "$TOP does not exist or is not a directory. Exiting."
  exit 1
}

if [ "${mktable}" ]
then
  if [ "${sortorder}" == "title" ]
  then
    book_index="Table_of_Books_by_Title"
  else
    book_index="Table_of_Books_by_Author"
  fi
else
  if [ "${sortorder}" == "title" ]
  then
    book_index="Books_by_Title"
  else
    book_index="Books_by_Author"
  fi
fi

cd "${TOP}"

[ "${overwrite}" ] && rm -f ${VAULT}/${book_index}.md

if [ -f ${VAULT}/${book_index}.md ]
then
  echo "${book_index}.md already exists. Use '-f' to overwrite an existing index."
  echo "Exiting without changes."
  exit 1
else
  echo "# Books" > ${VAULT}/${book_index}.md
  echo "" >> ${VAULT}/${book_index}.md
  if [ "${mktable}" ]
  then
    if [ "${sortorder}" == "title" ]
    then
      echo "## Table of Books by Title" >> ${VAULT}/${book_index}.md
    else
      echo "## Table of Books by Author" >> ${VAULT}/${book_index}.md
    fi
  else
    if [ "${sortorder}" == "title" ]
    then
      echo "## Index of Books by Title" >> ${VAULT}/${book_index}.md
    else
      echo "## Index of Books by Author" >> ${VAULT}/${book_index}.md
    fi
    echo "" >> ${VAULT}/${book_index}.md
    echo "| **[A](#a)** | **[B](#b)** | **[C](#c)** | **[D](#d)** | **[E](#e)** | **[F](#f)** | **[G](#g)** | **[H](#h)** | **[I](#i)** | **[J](#j)** | **[K](#k)** | **[L](#l)** | **[M](#m)** | **[N](#n)** | **[O](#o)** | **[P](#p)** | **[Q](#q)** | **[R](#r)** | **[S](#s)** | **[T](#t)** | **[U](#u)** | **[V](#v)** | **[W](#w)** | **[X](#x)** | **[Y](#y)** | **[Z](#z)** |" >> ${VAULT}/${book_index}.md
    echo "|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|" >> ${VAULT}/${book_index}.md
    echo "" >> ${VAULT}/${book_index}.md
  fi
  echo "" >> ${VAULT}/${book_index}.md
  if [ "${mktable}" ]
  then
    if [ "${sortorder}" == "title" ]
    then
      echo "| **Title by Author** | **Title by Author** | **Title by Author** | **Title by Author** | **Title by Author** |" >> ${VAULT}/${book_index}.md
    else
      echo "| **Author: Title** | **Author: Title** | **Author: Title** | **Author: Title** | **Author: Title** |" >> ${VAULT}/${book_index}.md
    fi
    echo "|--|--|--|--|--|" >> ${VAULT}/${book_index}.md
  else
    if [ "${sortorder}" == "title" ]
    then
      heading="0-9"
    else
      heading="A"
      author_heading=
    fi
    echo "### ${heading}" >> ${VAULT}/${book_index}.md
    echo "" >> ${VAULT}/${book_index}.md
  fi

  if [ "${mktable}" ]
  then
    if [ "${sortorder}" == "title" ]
    then
      ls -1 */*.md | sort -k 2 -t'/' > /tmp/books$$
      while read book
      do
        author=`echo ${book} | awk -F '/' ' { print $1 } '`
        filename=`echo ${book} | awk -F '/' ' { print $2 } ' | sed -e "s/\.md//"`
        [ "${author}" == "${filename}" ] && continue
        authorname=`grep "author:" ${book} | head -1 | \
          awk -F ':' ' { print $2 } ' | sed -e 's/^ *//' -e 's/ *$//'`
        [ "${authorname}" ] || {
          echo "${book} needs an author: tag. Skipping."
          continue
        }
        title=`grep "title:" ${book} | awk -F ':' ' { print $2 } ' | \
          sed -e 's/^ *//' -e 's/ *$//' -e "s/^\"//" -e "s/\"$//"`
        [ "${title}" ] || {
          echo "${book} needs a title: tag. Skipping."
          continue
        }
        if [ ${numcols} -gt 4 ]
        then
          printf "| [${title}](Books/${book}) by ${authorname} |\n" >> ${VAULT}/${book_index}.md
          numcols=1
        else
          printf "| [${title}](Books/${book}) by ${authorname} " >> ${VAULT}/${book_index}.md
          numcols=$((numcols+1))
        fi
      done < <(cat /tmp/books$$)

      while [ ${numcols} -lt 5 ]
      do
        printf "| " >> ${VAULT}/${book_index}.md
        numcols=$((numcols+1))
      done
      printf "|\n" >> ${VAULT}/${book_index}.md
      rm -f /tmp/books$$
    else
      for author in *
      do
        [ "${author}" == "*" ] && continue
        [ -d "${author}" ] || continue
        cd "${author}"
        authorname=
        for book in *.md
        do
          [ "${book}" == "*.md" ] && continue
          [ "${book}" == "${author}.md" ] && continue
          [ "${authorname}" ] || {
            authorname=`grep "author:" ${book} | head -1 | \
              awk -F ':' ' { print $2 } ' | sed -e 's/^ *//' -e 's/ *$//'`
          }
          title=`grep "title:" ${book} | awk -F ':' ' { print $2 } ' | \
            sed -e 's/^ *//' -e 's/ *$//' -e "s/^\"//" -e "s/\"$//"`
          if [ ${numcols} -gt 4 ]
          then
            printf "| ${authorname}: [${title}](Books/${author}/${book}) |\n" >> ${VAULT}/${book_index}.md
            numcols=1
          else
            printf "| ${authorname}: [${title}](Books/${author}/${book}) " >> ${VAULT}/${book_index}.md
            numcols=$((numcols+1))
          fi
        done
        cd ..
      done

      while [ ${numcols} -lt 5 ]
      do
        printf "| " >> ${VAULT}/${book_index}.md
        numcols=$((numcols+1))
      done
      printf "|\n" >> ${VAULT}/${book_index}.md
    fi
  else
    if [ "${sortorder}" == "title" ]
    then
      ls -1 */*.md | sort -k 2 -t'/' > /tmp/books$$
      removetmp=
    else
      mkdir ../../tmp$$
      removetmp=1
      declare -A author_array
      for bookmd in */*.md
      do
        author=`echo ${bookmd} | awk -F '/' ' { print $1 } '`
        filename=`echo ${bookmd} | awk -F '/' ' { print $2 } '`
        [ "${author}.md" == "${filename}" ] && continue
        authorsort=`grep "authorsort:" ${bookmd} | head -1 | \
          awk -F ':' ' { print $2 } ' | sed -e 's/^ *//' -e 's/ *$//' -e "s/,//" -e "s/ /_/g"`
        [ "${authorsort}" ] || {
          echo "${bookmd} needs an authorsort: tag. Skipping."
          continue
        }
        # Make a duplicate Books folder with new filenames based on author sort names
        [ -d "../../tmp$$/${authorsort}" ] || mkdir -p "../../tmp$$/${authorsort}"
        cp ${bookmd} "../../tmp$$/${authorsort}"
        author_array["${authorsort}/${filename}"]="${bookmd}"
      done
      cd "../../tmp$$"
      ls -1 */*.md | sort -k 1 -t'/' > /tmp/books$$
    fi
    while read book
    do
      author=`echo ${book} | awk -F '/' ' { print $1 } '`
      filename=`echo ${book} | awk -F '/' ' { print $2 } ' | sed -e "s/\.md//"`
      [ "${author}" == "${filename}" ] && continue
      if [ "${sortorder}" == "title" ]
      then
        authorname=`grep "author:" ${book} | head -1 | \
          awk -F ':' ' { print $2 } ' | sed -e 's/^ *//' -e 's/ *$//'`
      else
        authorname=`grep "authorsort:" ${book} | head -1 | \
          awk -F ':' ' { print $2 } ' | sed -e 's/^ *//' -e 's/ *$//'`
      fi
      [ "${authorname}" ] || {
        echo "${book} needs an author: tag. Skipping."
        continue
      }
      title=`grep "title:" ${book} | awk -F ':' ' { print $2 } ' | \
        sed -e 's/^ *//' -e 's/ *$//' -e "s/^\"//" -e "s/\"$//"`
      [ "${title}" ] || {
        echo "${book} needs a title: tag. Skipping."
        continue
      }
      if [ "${sortorder}" == "title" ]
      then
        first=${title:0:1}
      else
        first=${authorname:0:1}
      fi
      if [ "${heading}" == "0-9" ]
      then
        [ "${first}" -eq "${first}" ] 2> /dev/null || {
          heading=${first}
          echo "" >> ${VAULT}/${book_index}.md
          echo "### ${heading}" >> ${VAULT}/${book_index}.md
          echo "" >> ${VAULT}/${book_index}.md
        }
      else
        [ "${first}" == "${heading}" ] || {
          heading=${first}
          echo "" >> ${VAULT}/${book_index}.md
          echo "### ${heading}" >> ${VAULT}/${book_index}.md
          echo "" >> ${VAULT}/${book_index}.md
        }
      fi
      if [ "${sortorder}" == "title" ]
      then
        echo "- [${title}](Books/${book}) by ${authorname}" >> ${VAULT}/${book_index}.md
      else
        [ "${authorname}" == "${author_heading}" ] || {
          author_heading=${authorname}
          echo "" >> ${VAULT}/${book_index}.md
          echo "#### ${author_heading}" >> ${VAULT}/${book_index}.md
          echo "" >> ${VAULT}/${book_index}.md
        }
        booklink="${author_array[${book}]}"
        echo "- [${title}](Books/${booklink})" >> ${VAULT}/${book_index}.md
      fi
    done < <(cat /tmp/books$$)
    rm -f /tmp/books$$
    [ "${removetmp}" ] && {
      cd ..
      [ -d tmp$$ ] && rm -rf tmp$$
    }
  fi
fi

```

</Details>

<Details markdown="block">

Generate markdown for each of the authors with a link to their Wikipedia article and links to their books. Also generate a markdown document with a table of all authors.

### [Tools/Books/mkauthors](Tools/Books/mkauthors.md) (click to collapse/expand)

```shell

#!/bin/bash

TOP="${HOME}/Documents/Obsidian/Obsidian-Books-Vault/Books"

[ -d "${TOP}" ] || {
  echo "$TOP does not exist or is not a directory. Exiting."
  exit 1
}

cd "${TOP}"

mkauthors=
numcols=1
overwrite=
remove=
[ "$1" == "-f" ] && overwrite=1
[ "$1" == "-r" ] && remove=1

[ "${remove}" ] || [ "${overwrite}" ] && rm -f ../Authors.md

[ -f ../Authors.md ] || {
  mkauthors=1
  echo "# Authors" > ../Authors.md
  echo "" >> ../Authors.md
  echo "## List of Authors in Vault" >> ../Authors.md
  echo "" >> ../Authors.md
  echo "| **Author Name** | **Author Name** | **Author Name** | **Author Name** | **Author Name** |" >> ../Authors.md
  echo "|--|--|--|--|--|" >> ../Authors.md
}

for author in *
do
  [ "${author}" == "*" ] && continue
  [ -d "${author}" ] || continue
  [ "${remove}" ] && {
    rm -f ${author}/${author}.md
    continue
  }
  if [ "${overwrite}" ]
  then
    rm -f ${author}/${author}.md
  else
    [ -f ${author}/${author}.md ] && continue
  fi
  cd "${author}"
  echo "" > /tmp/sa$$
  echo "## Books" >> /tmp/sa$$
  echo "" >> /tmp/sa$$
  authorname=
  for book in *.md
  do
    [ "${book}" == "*.md" ] && continue
    [ "${book}" == "${author}.md" ] && continue
    [ "${authorname}" ] || {
      authorname=`grep "author:" ${book} | head -1 | \
        awk -F ':' ' { print $2 } ' | sed -e 's/^ *//' -e 's/ *$//'`
    }
    title=`grep "title:" ${book} | awk -F ':' ' { print $2 } ' | \
      sed -e 's/^ *//' -e 's/ *$//' -e "s/^\"//" -e "s/\"$//"`
    echo "- [${title}](${book})" >> /tmp/sa$$
  done
  wikilink=`echo ${authorname} | sed -e "s/ /_/g"`
  echo "# ${authorname}" > /tmp/au$$
  echo "" >> /tmp/au$$
  echo "[Wikipedia entry](https://en.wikipedia.org/wiki/${wikilink})" >> /tmp/au$$
  cat /tmp/au$$ /tmp/sa$$ > ${author}.md
  rm -f /tmp/au$$ /tmp/sa$$
  cd ..
  [ "${mkauthors}" ] && {
    [ -f "${author}/${author}.md" ] && {
      if [ ${numcols} -gt 4 ]
      then
        printf "| [${authorname}](Books/${author}/${author}.md) |\n" >> ../Authors.md
        numcols=1
      else
        printf "| [${authorname}](Books/${author}/${author}.md) " >> ../Authors.md
        numcols=$((numcols+1))
      fi
    }
  }
done

[ "${mkauthors}" ] && {
  while [ ${numcols} -lt 4 ]
  do
    printf "| " >> ../Authors.md
    numcols=$((numcols+1))
  done
  printf "|\n" >> ../Authors.md
}

```

</Details>

## See_also

- [README](README.md)
- [Books Queries](Books_Queries.md)
- [Obsidian Book Search Plugin](https://github.com/anpigon/obsidian-book-search-plugin)
- [Tutorial: Create a Bookshelf in Obsidian](https://thebuccaneersbounty.wordpress.com/2021/08/21/tutorial-how-to-create-a-bookshelf-in-obsidian/)
    - [Example Obsidian Bookshelf](https://github.com/GentryGibson/ObsidianBookshelf)
- [Add books using Quickadd and Google Books API](https://github.com/Elaws/script_googleBooks_quickAdd)
- [Readwise](https://readwise.io)
    - [Official Readwise Obsidian Plugin](https://github.com/readwiseio/obsidian-readwise)
    - [Readwise to Obsidian export How-To](https://help.readwise.io/article/125-how-does-the-readwise-to-obsidian-export-integration-work)
- [Nicole van der Hoeven videos](https://www.youtube.com/@nicolevdh)
    - [Getting Started with Obsidian](https://youtube.com/playlist?list=PL-1Nqb2waX4Vba6QDVS5rhnSb9pZGTO4b)
    - [Readwise Reader](https://youtu.be/uNH1JDOmGJw)
    - [Readwise Obsidian plugin](https://youtu.be/Rw1L5sxlnuU)
