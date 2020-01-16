DROP PROCEDURE IF EXISTS abc;
DELIMITER //
CREATE PROCEDURE abc()
  BEGIN
      DECLARE a INT Default 0 ;
      simple_loop: LOOP
         SET a=a+1;
         INSERT INTO size_test2 VALUES ('a');
         IF a=1000 THEN
            LEAVE simple_loop;
         END IF;
	  END LOOP simple_loop;
	  SELECT 'ok';
  END //
DELIMITER ;