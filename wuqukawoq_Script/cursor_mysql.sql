DELIMITER $$
CREATE PROCEDURE curdemo()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  -- DECLARE a CHAR(16);
  DECLARE a, b, c INT;
  DECLARE cur1 CURSOR FOR SELECT ls_person_id, ls_concept_id FROM PIVOTE_OBS;
  -- DECLARE cur2 CURSOR FOR SELECT person_id FROM person;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur1;
  -- OPEN cur2;

  read_loop: LOOP
    FETCH cur1 INTO a, b;
    -- FETCH cur2 INTO c;
    IF done THEN
      LEAVE read_loop;
    END IF;
    IF b < c THEN
		select person_id from pivote_obs 
        where ls_person_id = cur1.ls_person_id;
      -- INSERT INTO test.t3 VALUES (a,b);
    ELSE
		select person_id from pivote_obs 
        where ls_person_id = cur1.ls_person_id;
      -- INSERT INTO test.t3 VALUES (a,c);
    END IF;
  END LOOP;

  CLOSE cur1;
  -- CLOSE cur2;
END;
DELIMITER ;


-- drop procedure curdemo;
-- drop table Employee;


