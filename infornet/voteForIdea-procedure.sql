DROP PROCEDURE IF EXISTS voteForIdea;
DELIMITER //
 CREATE PROCEDURE voteForIdea(
   userId INT(10),
   objectId INT(10),
   voteVal INT(1),
   voteObject VARCHAR(20)
 )
   BEGIN
    DECLARE voteDone DOUBLE DEFAULT false;
    DECLARE addVote DOUBLE DEFAULT false;
    
    /*SET @sql_text = CONCAT('SELECT 1 INTO voteDone FROM idea_comment_vote WHERE object_id = ', objectId, ' AND user_id = ', userId);
    select @sql_text;*/
    
   	SELECT 1
   	INTO voteDone
    FROM idea_comment_vote
    WHERE object_id = objectId
    AND user_id = userId
    AND object_type = voteObject;
    
    IF (voteDone) THEN
      SELECT 'Na tą pozycję już głosowano' as error;
    ELSE
      INSERT INTO idea_comment_vote VALUES(objectId, userId, voteVal, voteObject);
      
      SELECT ROW_COUNT() INTO addVote;
      
      IF (addVote) THEN
        SELECT SUM(vote_value) AS total_value FROM idea_comment_vote WHERE object_id = objectId AND object_type = voteObject;
      ELSE
        SELECT 'Błąd zapisu db' as error;
      END IF;
    END IF;
   END //
DELIMITER ;
