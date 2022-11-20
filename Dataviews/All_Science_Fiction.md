---
banner: "assets/banners/Science-Fiction.png"
banner_x: 0.5
banner_y: 0.5
---

# All Science Fiction

This code displays all science fiction from the Books folder sorted by year published.

````markdown
```dataview
TABLE WITHOUT ID
  author AS "Author",
  link(file.link, title) as Title,
  published AS "Year"
FROM "Books"
WHERE contains(shelves, "science-fiction") AND author != null AND title != null
SORT published ASC
```
````

Output of above code:

```dataview
TABLE WITHOUT ID
  author AS "Author",
  link(file.link, title) as Title,
  published AS "Year"
FROM "Books"
WHERE contains(shelves, "science-fiction") AND author != null AND title != null
SORT published ASC
```
