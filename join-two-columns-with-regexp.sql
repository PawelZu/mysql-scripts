SELECT concat( regex_replace(
				 '[0-9.]',  '',  `Bran¿a wg EKD`
				),
				', ',
				regex_replace(
				 '[0-9.]',  '',  `Bran¿a wg SIC`
				)
)
FROM  `11799firm-program` 