DELETE n1 FROM wp_posts n1, wp_posts n2 WHERE n1.ID > n2.ID AND n1.post_name = n2.post_name;

DELETE FROM wp_term_relationships WHERE object_id NOT IN (
	SELECT ID FROM wp_posts
	UNION
	SELECT link_id FROM wp_links
);

DELETE FROM wp_postmeta WHERE post_id NOT IN (
	SELECT ID FROM wp_posts
)