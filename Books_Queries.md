---
banner: "assets/banners/Dataview-Banner.png"
banner_x: 1.0
banner_y: 1.0
---

# Dataview Queries

The Obsidian Books Vault markdown contains metadata with tags allowing a variety of queries using the [Dataview](https://blacksmithgu.github.io/obsidian-dataview/) plugin for [Obsidian](https://obsidian.md/). A few example Dataview queries follow.

## Example Books query

The markdown for "Timequake" by Kurt Vonnegut Jr. has the following YAML prelude:

```yaml
---
bookid: 9594
title: Timequake
author: Kurt Vonnegut Jr.
authors: 
isbn: 0099267543
isbn13: 9780099267546
rating: 4
avgrating: 3.72
publisher: Vintage Classics
binding: Paperback
pages: 219
published: 1997
shelves: science-fiction, novels, vonnegut
shelf: read
review: 
---
```

### Dataview_Books_query

The above book metadata can be used to perform Dataview queries to search, filter, and retrieve books as if they are in a database. For example, to produce a table of all books in this vault by Kurt Vonnegut Jr. published prior to 1970 add the following to a markdown file in the vault:

````markdown
```dataview
TABLE
  link(file.link, title) as Title,
  author AS "Author",
  published AS "Year"
FROM "Books"
WHERE author = "Kurt Vonnegut Jr." and published < 1970
SORT published ASC
```
````

The above Dataview code block produces the following output:

```dataview
TABLE
  link(file.link, title) as Title,
  author AS "Author",
  published AS "Year"
FROM "Books"
WHERE author = "Kurt Vonnegut Jr." and published < 1970
SORT published ASC
```

Additional example Dataview book queries can be found in the `Dataviews` folder:

- [All 50 Year Old Novels](Dataviews/All_50_Year_Old_Novels.md)
- [All Books](Dataviews/All_Books.md)
- [All Read Books](Dataviews/All_Read_Books.md)
- [All Unread Books](Dataviews/All_Unread_Books.md)

## See also

- [Index of the Books Vault](Books_Index.md)
- [README](README.md)
- [Process](Process.md)
