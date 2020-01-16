SELECT SQL_NO_CACHE  `ID`, `post_title` 
  FROM wp_posts AS r1 JOIN
       (SELECT (RAND() *
                     (SELECT MAX(ID)
                        FROM wp_posts)) AS id)
        AS r2
 WHERE r1.id >= r2.id
 ORDER BY r1.id ASC
 LIMIT 1;