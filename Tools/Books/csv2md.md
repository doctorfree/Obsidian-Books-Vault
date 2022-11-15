# csv2md

```shell
#!/bin/bash
#
# csv2md
#
# Script to generate Markdown format files for each of the books
# in the downloaded CSV format Goodreads export
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
