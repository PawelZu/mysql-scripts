SELECT * 
FROM  `gazeta_frazy_wiadomosci` 
WHERE LOWER(`fraza`) REGEXP '^[0-9a-f]'
ORDER BY fraza