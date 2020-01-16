DELIMITER //
CREATE FUNCTION `regex_replace`(pattern VARCHAR(1000),replacement VARCHAR(1000),original VARCHAR(1000)) RETURNS varchar(1000) CHARSET latin1
   DETERMINISTIC
BEGIN
DECLARE temp VARCHAR(1000);
DECLARE ch VARCHAR(1);
DECLARE i INT;
DECLARE j INT;
DECLARE qbTemp VARCHAR(1000);

SET i = 1;
SET j = 1;
SET temp = '';
SET qbTemp = '';
 
IF original REGEXP pattern THEN
 loop_label: LOOP
  IF i>CHAR_LENGTH(original) THEN
   LEAVE loop_label; 
  END IF;
  SET ch = SUBSTRING(original,i,1);
  IF NOT ch REGEXP pattern THEN
   SET temp = CONCAT(temp,ch);
  ELSE
   SET temp = CONCAT(temp,replacement);
  END IF;
  SET i=i+1;
 END LOOP;
ELSE
 SET temp = original;
END IF;
SET temp = TRIM(BOTH replacement FROM temp);
SET temp = REPLACE(REPLACE(REPLACE(temp , CONCAT(replacement,replacement),CONCAT(replacement,'#')),CONCAT('#',replacement),''),'#','');
RETURN temp;
END //
DELIMITER ;