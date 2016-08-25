CREATE DEFINER=`root`@`localhost` PROCEDURE `diabetes`()
BEGIN

  declare hemoglobina_id int default 159644;
  declare peso_id int default 5089; 
  declare sistolica_id int default 5085;
  declare diastolica_id int default 5086;
  
  declare var_person_id int;
  declare var_concept_id int;
  declare var_obs_date_created datetime;
  declare var_value_numeric int;
  
  declare tmp_person_id int default 0;
  declare tmp_concept_id int default 0;
  declare tmp_obs_date_created datetime;
  declare tmp_value_numeric int;
  
  DECLARE fin int default 0;
  declare obs_fin varchar(100);
  declare obs_fin_2 varchar(10000) default "";

  Declare var_cont_obs int; -- (select count(*) from obs_hemoglobina where person_id = 57 and concept_id = 159644 group by person_id, concept_id) ;
  
  DECLARE cur_paciente cursor for select person_id, concept_id , date_created, value_numeric from tbl_obs_diabeticos where person_id = 57;-- CURSOR FOR SELECT id,data FROM test.t1;
  
-- Declaración de un manejador de error tipo NOT FOUND
DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 1;
  
  OPEN cur_paciente;

  read_loop: LOOP
    FETCH cur_paciente INTO var_person_id, var_concept_id ,var_obs_date_created, var_value_numeric;

  
    IF fin = 1 THEN
    LEAVE read_loop;
  END IF;    

  set tmp_person_id = var_person_id;
    set tmp_concept_id = var_concept_id;
    set tmp_obs_date_created = var_obs_date_created;
    set tmp_value_numeric = var_value_numeric;
    
    if (var_person_id = tmp_person_id and var_concept_id = hemoglobina_id ) then
    set obs_fin = concat('|', tmp_value_numeric, '|',  convert( (date_format( tmp_obs_date_created,'%Y-%m-%d')), char), '|');
    end if;    
    
  if (var_person_id = tmp_person_id and var_concept_id = peso_id ) then
    set obs_fin = concat('|', tmp_value_numeric, '|',  convert( (date_format( tmp_obs_date_created,'%Y-%m-%d')), char), '|');
    end if;
    
  set obs_fin_2 = concat(obs_fin_2, obs_fin);
    
  END LOOP read_loop;
  
    insert into obs_horizontal (person_id, obs) 
    values (tmp_person_id, obs_fin_2);
    -- values (tmp_person_id, concat(tmp_concept_id, '|',  convert( (date_format( tmp_date_obs,'%Y-%m-%d')), char) ) );
   commit;

  CLOSE cur_paciente;
  commit;
END