---
banner: "assets/banners/Books-Banner.png"
banner_x: 0.5
banner_y: 0.5
---

# All Books

This code displays all books from the Books folder sorted by author.

````markdown
```dataview
TABLE WITHOUT ID
  author AS "Author",
  link(file.link, title) as Title,
  published AS "Year"
FROM "Books"
WHERE author != null AND title != null
SORT author ASC
```
````

Output of above code:

```dataview
TABLE WITHOUT ID
  author AS "Author",
  link(file.link, title) as Title,
  published AS "Year"
FROM "Books"
WHERE author != null AND title != null
SORT author ASC
```
