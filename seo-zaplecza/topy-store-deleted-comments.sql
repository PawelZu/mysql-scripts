DROP TRIGGER IF EXISTS save_comment;
DELIMITER $$
CREATE TRIGGER save_comment 
    BEFORE DELETE ON wp_comments
    FOR EACH ROW BEGIN
    
    DECLARE comment_appr VARCHAR(10);
    
    SET comment_appr = OLD.comment_approved;

    IF(comment_appr != 'spam') THEN
        INSERT INTO wp_comments_zapisane(comment_post_ID,comment_author,comment_author_email,comment_author_url,comment_author_IP,comment_date,comment_content,comment_agent,user_id)
            VALUES(OLD.comment_post_ID,OLD.comment_author,OLD.comment_author_email,OLD.comment_author_url,OLD.comment_author_IP,OLD.comment_date,OLD.comment_content,OLD.comment_agent,OLD.user_id);
    END IF;
END$$
DELIMITER ;