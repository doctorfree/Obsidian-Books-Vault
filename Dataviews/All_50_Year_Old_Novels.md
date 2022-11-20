---
banner: "assets/banners/Books-Banner.png"
banner_x: 0.5
banner_y: 0.5
---

# All Novels Published Prior To 1973

This code displays all novels from the Books folder published prior to 1973 sorted by year.

````markdown
```dataview
TABLE WITHOUT ID
  author AS "Author",
  link(file.link, title) as Title,
  published AS "Year"
FROM "Books"
WHERE contains(shelves, "novels") AND author != null AND title != null AND published < 1973
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
WHERE contains(shelves, "novels") AND author != null AND title != null AND published < 1973
SORT published ASC
```
