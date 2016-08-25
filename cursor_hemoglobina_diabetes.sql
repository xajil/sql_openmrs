CREATE DEFINER=`root`@`localhost` PROCEDURE `diabetes`()
BEGIN

  declare var_person_id int;
  declare var_concept_id int;
  declare var_max_obs_date_created_hemoglobina datetime;
  
  declare tmp_person_id int default 0;
  declare tmp_concept_id int default 0;
  declare tmp_date_obs datetime;
  
  Declare var_cont_obs int; -- (select count(*) from obs_hemoglobina where person_id = 57 and concept_id = 159644 group by person_id, concept_id) ;
  
  DECLARE cur_paciente cursor for select person_id, concept_id , max_obs_date_created_hemoglobina from obs_hemoglobina where person_id = 57 and concept_id = 159644;-- CURSOR FOR SELECT id,data FROM test.t1;

-- Declaración de un manejador de error tipo NOT FOUND
DECLARE CONTINUE HANDLER FOR NOT FOUND SET @hecho = TRUE;
  
  OPEN cur_paciente;

  read_loop: LOOP
    FETCH cur_paciente INTO var_person_id, var_concept_id ,var_max_obs_date_created_hemoglobina;

	set tmp_person_id = var_person_id;
    set tmp_concept_id = var_concept_id;
    set tmp_date_obs = var_max_obs_date_created_hemoglobina;

    insert into obs_horizontal (person_id, hemoglobina, max_obs_date_created_hemoglobina) 
    values (tmp_person_id, tmp_concept_id, date_format(tmp_date_obs,'%Y-%m-%d'));
	 commit;
     
    IF @hecho THEN
		LEAVE read_loop;
	END IF;    

  END LOOP read_loop;

  CLOSE cur_paciente;
  commit;
  -- CLOSE cur2;

END