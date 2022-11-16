# mkbooks

```shell
#!/bin/bash
#
# mkbooks
#
# Generate various indexes into the Markdown format files created in the
# Obsidian vault with the previous scripts. This script can generate lists
# of books sorted by author or title in list or table format.

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
