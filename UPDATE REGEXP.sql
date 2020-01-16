UPDATE wp_terms SET `name` = REPLACE(`name`,'-', ' ') WHERE `name` REGEXP '-'

UPDATE wp_posts SET `post_title` = REPLACE(`post_title`,' [galeria]', '') WHERE `post_type`='galeria'

UPDATE wp_feed_photos SET url = REPLACE(url, 'http://seoib.pl/news', 'http://mdziennik.pl') WHERE url LIKE 'http://seoib.pl/news%'








UPDATE `35092cleard` SET `Bran¿a` = REPLACE(`Bran¿a`, ',   ,', '')
,   ,