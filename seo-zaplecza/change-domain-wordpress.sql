UPDATE wp_options
set option_value = REPLACE(option_value, 'erada.pl', 'erada.pl/test')
where option_value like '%erada.pl%'


UPDATE wp_posts
set guid = REPLACE(guid, 'erada.pl', 'erada.pl/test')
where guid like '%erada.pl%'


UPDATE wp_postmeta
set meta_value = REPLACE(meta_value, 'erada.pl', 'erada.pl/test')
where meta_value like '%erada.pl%'
