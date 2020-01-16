SELECT * FROM `wp_options` t1
LEFT JOIN wp_options_tmp t2 ON t1.`option_name` = t2.`option_name`
WHERE t1.`option_value` != t2.`option_value`
OR t2.`option_value` IS NULL
union
SELECT * FROM `wp_options` t1
right JOIN wp_options_tmp t2 ON t1.`option_name` = t2.`option_name`
WHERE t1.`option_value` != t2.`option_value`
OR t1.`option_value` IS NULL
