SELECT t.name as wojewodztwo, t2.name as miasto FROM wp_term_taxonomy tt
JOIN wp_terms t USING (term_id)
JOIN wp_term_relationships tr ON tt.term_taxonomy_id=tr.term_taxonomy_id
JOIN wp_posts p ON tr.object_id=p.ID
JOIN wp_term_relationships tr2 ON p.ID=tr2.object_id
JOIN wp_term_taxonomy tt2 ON tr2.term_taxonomy_id=tt2.term_taxonomy_id AND tt2.taxonomy='miejscowosc'
JOIN wp_terms t2 ON tt2.term_id=t2.term_id
WHERE tt.taxonomy='wojewodztwo'
GROUP BY tt2.term_taxonomy_id
ORDER BY t.name,t2.name

SELECT tt.term_taxonomy_id, tt.term_id, tt.taxonomy, tt2.term_taxonomy_id, tt.parent, tt.count FROM wp_term_taxonomy tt
JOIN wp_terms t USING (term_id)
JOIN wp_term_relationships tr ON tt.term_taxonomy_id=tr.term_taxonomy_id
JOIN wp_posts p ON tr.object_id=p.ID
JOIN wp_term_relationships tr2 ON p.ID=tr2.object_id
JOIN wp_term_taxonomy tt2 ON tr2.term_taxonomy_id=tt2.term_taxonomy_id AND tt2.taxonomy='wojewodztwo'
WHERE tt.taxonomy='miejscowosc'
GROUP BY tt.term_taxonomy_id, tt2.term_taxonomy_id


INSERT INTO wp_term_taxonomy_tmp (
	SELECT tt.term_taxonomy_id, tt.term_id, tt.taxonomy, tt2.term_taxonomy_id, tt.parent, tt.count FROM wp_term_taxonomy tt
	JOIN wp_terms t USING (term_id)
	JOIN wp_term_relationships tr ON tt.term_taxonomy_id=tr.term_taxonomy_id
	JOIN wp_posts p ON tr.object_id=p.ID
	JOIN wp_term_relationships tr2 ON p.ID=tr2.object_id
	JOIN wp_term_taxonomy tt2 ON tr2.term_taxonomy_id=tt2.term_taxonomy_id AND tt2.taxonomy='wojewodztwo'
	WHERE tt.taxonomy='miejscowosc'
	GROUP BY tt.term_taxonomy_id
)


DELETE FROM wp_term_taxonomy WHERE taxonomy='miejscowosc';
INSERT INTO wp_term_taxonomy (SELECT * FROM wp_term_taxonomy_tmp);


SELECT t.slug as woj, t2.slug as mia, tt2.count
FROM wp_terms t
JOIN wp_term_taxonomy tt ON t.term_id=tt.term_id AND tt.taxonomy='wojewodztwo'
JOIN wp_term_taxonomy tt2 ON tt.term_taxonomy_id=CAST(tt2.description AS UNSIGNED)
JOIN wp_terms t2 ON tt2.term_id=t2.term_id
ORDER BY tt.count DESC, tt2.count DESC


SELECT t.name as woj,
		t.term_id,
		t2.name as mia,
		tt2.count,
		@num := if(@woj = t.term_id, @num + 1, 1) as row_number,
		@woj := t.term_id
FROM wp_terms t
JOIN wp_term_taxonomy tt ON t.term_id=tt.term_id AND tt.taxonomy='wojewodztwo'
JOIN wp_term_taxonomy tt2 ON tt.term_taxonomy_id=CAST(tt2.description AS UNSIGNED)
JOIN wp_terms t2 ON tt2.term_id=t2.term_id
JOIN(SELECT @num := 0, @woj := 1) r
ORDER BY tt.count DESC, tt2.count DESC



SELECT * ,
	@num := IF( @woj = term_taxonomy_id, @num +1, 1 ) AS row_number,
	@woj := term_taxonomy_id
FROM  `wp_term_relationships` 
JOIN (SELECT @num :=0, @woj :=1)r
ORDER BY  `term_taxonomy_id` 


SELECT t.slug as woj, m.slug as mia
FROM wp_terms t
JOIN wp_term_taxonomy tt ON t.term_id=tt.term_id AND tt.taxonomy='wojewodztwo'
JOIN (
	SELECT * FROM wp_term_taxonomy tt2
	JOIN wp_terms t2 ON tt2.term_id=t2.term_id
) m ON m.term_taxonomy_id=CAST(tt.description AS CHAR)
ORDER BY tt.count DESC, tt2.count DESC