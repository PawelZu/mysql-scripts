UPDATE wp_options SET option_value=REPLACE(option_value, 'wiadomosci-gospodarcze.pl', 'gospodarcze.media.pl')

UPDATE wp_options SET option_value=REPLACE(option_value, 'Wiadomości Gospodarcze', 'Gospodarcze Media')

UPDATE wp_posts SET guid=REPLACE(guid, 'wiadomosci-gospodarcze.pl', 'gospodarcze.media.pl')

UPDATE wp_postmeta SET meta_value=REPLACE(meta_value, 'wiadomosci-gospodarcze.pl', 'gospodarcze.media.pl')