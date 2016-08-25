CREATE PROCEDURE `diabetes_2` ()
BEGIN


  
  declare sistolica_id int default 5085;
  declare diastolica_id int default 5086;
  declare peso_id int default 5089;	
  declare hemoglobina_id int default 159644;
  
  declare var_person_id int;
  declare var_concept_id int;
  declare var_obs_date_created datetime;
  declare var_value_numeric int;
  
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

  Declare var_cont_obs int; -- (select count(*) from obs_hemoglobina where person_id = 57 and concept_id = 159644 group by person_id, concept_id) ;
  
  DECLARE cur_paciente cursor for select person_id , numero_open from tbl_diabeticos_prog; --  where person_id in( 57, 48) ; -- CURSOR FOR SELECT id,data FROM test.t1;
    

-- Declaración de un manejador de error tipo NOT FOUND
DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 1;

  
  OPEN cur_paciente;

  read_loop: LOOP
    FETCH cur_paciente INTO rec_person_id, rec_numero_open ;

  
    IF fin = 1 THEN
		LEAVE read_loop;
	END IF;    

	set var_tot_peso  = (select max(tbl.tot_concept_id) from (
	select count(concept_id) as tot_concept_id, concept_id, person_id from tbl_obs_diabeticos
	where concept_id = peso_id
	group by person_id,concept_id 
	) as tbl group by tbl.concept_id);
    
    

	BLOCK2:BEGIN
    
    DECLARE fin_obs int default 0;
    
    declare cur_obs cursor for select person_id, concept_id, date_created, value_numeric from tbl_obs_diabeticos where person_id = rec_person_id  and concept_id = peso_id order by concept_id, date_created asc;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin_obs = 1;
	
		open cur_obs;
		obs_loop: loop
			fetch cur_obs into var_person_id, var_concept_id, var_obs_date_created, var_value_numeric; 
			
            if fin_obs =1 then
				leave obs_loop;
                close cur_obs;
                -- set fin = 0;
			end if;
		    
            set tmp_person_id = var_person_id;
            
                -- set obs_fin = concat( 'peso',loop_peso, '|' , DATE_FORMAT(var_obs_date_created,'%Y-%m-%d'),'|', var_value_numeric, '|');
            	/* set obs_fin = concat( var_concept_id,'|',  DATE_FORMAT(var_obs_date_created,'%Y-%m-%d'),'|', var_value_numeric, '|');
				set obs_fin_2 = concat(obs_fin_2, obs_fin);
                */ 
            
            if(var_person_id = tmp_person_id ) then
				set obs_fin = concat( 'peso',loop_peso, '|' , DATE_FORMAT(var_obs_date_created,'%Y-%m-%d'),'|', var_value_numeric, '|');
				set obs_fin_2 = concat(obs_fin_2, obs_fin);            
            set tmp_person_id = 0;    
            set loop_peso= loop_peso +1;
			end if; 
            
            
            while ( loop_peso <= var_tot_peso ) do
            	set obs_fin = concat ('peso',loop_peso,'|||');
				set obs_fin_2 = concat(obs_fin_2, obs_fin);            
            set tmp_person_id = 0;    
            set loop_peso= 0;
            
            end while;
            
		end loop obs_loop;
		close cur_obs;
        
        
        
	END BLOCK2;
    
    insert into obs_horizontal ( person_id , obs) values (rec_numero_open, obs_fin_2);
    
     set obs_fin = "";
     set obs_fin_2 = "";
    
		
    END LOOP read_loop;

  CLOSE cur_paciente;


END
