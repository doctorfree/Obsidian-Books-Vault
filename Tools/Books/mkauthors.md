# mkauthors

```shell
#!/bin/bash

TOP="${HOME}/Documents/Obsidian/Obsidian-Media-Vault/Books"

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
