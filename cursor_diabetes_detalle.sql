CREATE DEFINER=`root`@`localhost` PROCEDURE `diabetes`()
BEGIN

  
  declare sistolica_id int default 5085;
  declare diastolica_id int default 5086;
  declare peso_id int default 5089;	
  declare hemoglobina_id int default 159644;
  declare talla_id int default 5090;
  
  declare var_person_id int;
  declare var_concept_id int;
  declare var_obs_date_created datetime;
  declare var_value_numeric double;
  
  declare var_tot_sis int default 0;
  declare var_tot_peso int default 0;
  declare var_tot_hemo int default 0;
  declare var_tot_dias int default 0;

  declare tmp_person_id int default 0;
  
  declare rec_person_id int; 
  declare rec_numero_open int;
  
  DECLARE fin int default 0;

  declare loop_peso int default 0;
  
  declare obs_fin varchar(100);
  declare obs_fin_2 varchar(10000) default "";
  
  declare cont int default 0;

  Declare var_cont_obs int; 
  
  DECLARE cur_paciente cursor for select person_id , numero_open from tbl_diabeticos_prog ; 
    
DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 1;

  
  OPEN cur_paciente;

  read_loop: LOOP
    FETCH cur_paciente INTO rec_person_id, rec_numero_open ;

  
    IF fin = 1 THEN
		LEAVE read_loop;
	END IF;    
    

	BLOCK2:BEGIN
    
    DECLARE fin_obs int default 0;
    
    declare cur_obs cursor for select person_id, concept_id, date_created, value_numeric from tbl_obs_diabeticos where person_id = rec_person_id 
    and concept_id = talla_id;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin_obs = 1;
	
		open cur_obs;
		obs_loop: loop
			fetch cur_obs into var_person_id, var_concept_id, var_obs_date_created, var_value_numeric; 
			
            if fin_obs =1 then
				leave obs_loop;
			end if;
		    
            set tmp_person_id = var_person_id;
            
                -- set obs_fin = concat( 'peso',loop_peso, '|' , DATE_FORMAT(var_obs_date_created,'%Y-%m-%d'),'|', var_value_numeric, '|');
            	
                set obs_fin = concat( DATE_FORMAT(var_obs_date_created,'%Y-%m-%d'),'|', var_value_numeric, '|');
				
                -- set obs_fin = concat(var_concept_id ,'|', var_person_id, '|');
				
                set obs_fin_2 = concat(obs_fin_2, obs_fin);
                
             -- insert into obs_horizontal ( person_id , obs) values (var_person_id, var_concept_id);
                
		end loop obs_loop;
        
		close cur_obs;
        
	END BLOCK2;
    

		insert into obs_horizontal ( person_id , obs) values (rec_numero_open, obs_fin_2);
		set obs_fin = "";
		set obs_fin_2 = "";
		
    END LOOP read_loop;

  CLOSE cur_paciente;
 
END