        /* eliminar duplicados o devuelven más de un resultado */
		select count(value_numeric), obs.person_id from obs
		where concept_id = 163138 
		-- and person_id = 76
        and obs.voided  = 0
		and obs.obs_datetime between STR_TO_DATE('01/01/2017', '%m/%d/%Y') and STR_TO_DATE('01/31/2017', '%m/%d/%Y')  
        group by person_id, obs.date_created
        having count(value_numeric) > 1; 
        
        select ifnull(
        (
        select count(value_numeric) from obs
		where concept_id = 163138 
		and person_id = 1764
        and obs.voided  = 0
		and obs.obs_datetime between STR_TO_DATE('01/01/2017', '%m/%d/%Y') and STR_TO_DATE('01/31/2017', '%m/%d/%Y')  
        )
        , 0) ;

        select value_numeric -- into var_ciclo_prestamo 
        from obs
		where concept_id = 163138 --  ciclo_prestamo_concept_id 
		and person_id = 1764
        and obs.voided  = 0
		and obs.obs_datetime between STR_TO_DATE('01/01/2017', '%m/%d/%Y') and STR_TO_DATE('01/31/2017', '%m/%d/%Y')  
        and obs.date_created = (
			select max(obs.date_created) 
			from obs
			where concept_id = 163138 --  ciclo_prestamo_concept_id 
			and person_id = 1764
            and obs.voided  = 0
			and obs.obs_datetime between STR_TO_DATE('01/01/2017', '%m/%d/%Y') and STR_TO_DATE('01/31/2017', '%m/%d/%Y')   
        )
        ;

			select max(obs.date_created) 
			from obs
			where concept_id = 163138 --  ciclo_prestamo_concept_id 
			and person_id = 1688
			and obs.obs_datetime between STR_TO_DATE('01/01/2017', '%m/%d/%Y') and STR_TO_DATE('01/31/2017', '%m/%d/%Y')  ;
        
        select value_numeric, obs.obs_datetime, date_created -- into var_ciclo_prestamo 
        from obs
		where concept_id = 163138 --  ciclo_prestamo_concept_id 
		and person_id = 1505
		and obs.obs_datetime between STR_TO_DATE('01/01/2017', '%m/%d/%Y') and STR_TO_DATE('01/31/2017', '%m/%d/%Y')   
        ;


	-- DETERMINA AGENCIA DEL PACIENTE

		select ifnull (
        (
        select count(value) from person_attribute
			where person_attribute_type_id = 8
				and voided = 0 -- voided_reg
                and person_id = 76 -- var_patient_id
                ),0) ; -- into  existe_agencia
                
        select value -- into var_agencia 
        from person_attribute
			where person_attribute_type_id = 8
				and voided = 0 -- voided_reg
                and person_id = 76 -- var_patient_id
                group by person_attribute.value, person_attribute.person_id;   
  
        


/* PAP Inicial */
	-- set var_pap_inicial, var_tip_consul_pap, var_cant_pap_inicial = (

			SELECT obs.value_coded, encounter.encounter_type, count(obs.concept_id) 
            -- into var_pap_inicial, var_tip_consul_pap, var_cant_pap_inicial  
            FROM obs, encounter
			WHERE 
			obs.encounter_id = encounter.encounter_id
			and obs.obs_datetime between STR_TO_DATE('01/01/2017', '%m/%d/%Y') and STR_TO_DATE('01/31/2017', '%m/%d/%Y')  
			and obs.concept_id = 162972 -- pap_inicial_concept_id
			and obs.value_coded =1267 -- hecho_concept_value
			and obs.person_id = 1688 -- var_patient_id
			and obs.voided = 0 -- voided_reg 
			and encounter.voided = 0 -- voided_reg
			group by obs.value_coded, encounter.encounter_type, obs.concept_id, obs.person_id;

		

-- EXAMEN PÉLVICO    
			SELECT 
			obs.value_coded,  encounter.encounter_type ,count(obs.concept_id)
           --  into var_pelvico,  var_tip_consul_pelvico, var_cant_pelvico
			FROM obs, encounter
			WHERE 
			obs.encounter_id = encounter.encounter_id
			and obs.obs_datetime between STR_TO_DATE('01/01/2017', '%m/%d/%Y') and STR_TO_DATE('01/31/2017', '%m/%d/%Y')  
			and obs.concept_id = 162991 --  pelvico_concept_id
			and obs.value_coded = 1267 -- hecho_concept_value
			and obs.voided = 0 -- voided_reg 
			and encounter.voided = 0 -- voided_reg
			and obs.person_id = 1688 
			group by obs.value_coded, encounter.encounter_type, obs.concept_id, obs.person_id;


  select 
    obs.value_coded,  encounter.encounter_type ,count(obs.concept_id)
    -- into var_eip, var_tip_consul_eip,var_cant_eip
    from obs, encounter
			where obs.encounter_id = encounter.encounter_id
			-- and encounter.encounter_type = 2
			and concept_id = 162969 -- eip_concept_id
			and value_coded =162968 --  eip_hecho
			and obs.person_id = 1688 --  var_patient_id
			and obs.voided = 0 -- voided_reg
			and obs.obs_datetime between  STR_TO_DATE('01/01/2017', '%m/%d/%Y') and STR_TO_DATE('01/31/2017', '%m/%d/%Y')  
            group by obs.value_coded, encounter.encounter_type, obs.concept_id, obs.person_id;

    

select obs.value_coded 
-- into var_eip_tratamiento 
from obs
where obs.concept_id = 162969 -- eip_tratamiento_concept_id
and obs.person_id = 1688
and  voided=0 -- voided_reg
and value_coded = 163057 -- eip_value_con_tratamiento -- tiene tratamieto asignado 
and obs.obs_datetime between  STR_TO_DATE('01/01/2017', '%m/%d/%Y') and STR_TO_DATE('01/31/2017', '%m/%d/%Y')  
group by obs.value_coded,  obs.concept_id, obs.person_id; 

            
            				-- declare ayunas_glucosa_valor int (11);

				SELECT 
				obs.value_numeric,  encounter.encounter_type ,count(obs.concept_id)
				-- into var_glucosa_ayunas,  var_tip_consul_glucosa_ayunas, var_cant_glucosa_ayunas
				FROM obs, encounter
				WHERE 
				obs.encounter_id = encounter.encounter_id
				and obs.concept_id = 160912
				and obs.voided = 0 -- voided_reg 
				and encounter.voided = 0 -- voided_reg
				and obs.person_id = 1688 -- var_patient_id
				and obs.obs_datetime between STR_TO_DATE('01/01/2017', '%m/%d/%Y') and STR_TO_DATE('01/31/2017', '%m/%d/%Y')  
				group by obs.value_numeric,encounter.encounter_type , obs.concept_id, obs.person_id;            
                
		
					
				SELECT 
				max(obs.value_numeric),  encounter.encounter_type ,count(obs.concept_id)
				-- into var_glucosa_azar,  var_tip_consul_glucosa_azar, var_cant_glucosa_azar
				FROM obs, encounter
				WHERE 
				obs.encounter_id = encounter.encounter_id
				and obs.concept_id = 887
				and obs.voided = 0 -- voided_reg 
				and encounter.voided = 0 -- voided_reg
				and obs.person_id = 1688 -- var_patient_id
				and obs.obs_datetime between STR_TO_DATE('01/01/2017', '%m/%d/%Y') and STR_TO_DATE('01/31/2017', '%m/%d/%Y')  
				group by encounter.encounter_type , obs.concept_id, obs.person_id;      
					
				

	-- PRESION ARTERIAL SISTOLICA       
				SELECT 
				max(obs.value_numeric),  encounter.encounter_type ,count(obs.concept_id)
				-- into var_presion_sistolica,  var_tip_consul_sistolica, var_cant_sistolica
				FROM obs, encounter
				WHERE 
				obs.encounter_id = encounter.encounter_id
				and obs.concept_id =  5085 -- sistolica
				and obs.voided = 0 -- voided_reg 
				and encounter.voided = 0 -- voided_reg
				and obs.person_id = 1688 -- var_patient_id
				and obs.obs_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
				group by  encounter.encounter_type, obs.concept_id, obs.person_id;  

   
	-- PRESION ARTRRIAL DIASTOLICA       

				SELECT 
				max(obs.value_numeric),  encounter.encounter_type ,count(obs.concept_id)
				-- into var_presio_diastolica,  var_tip_consul_diastolica, var_cant_diastolica
				FROM obs, encounter
				WHERE 
				obs.encounter_id = encounter.encounter_id
				and obs.concept_id =  5086 -- diastolica
				and obs.voided = 0 -- voided_reg 
				and encounter.voided = 0 -- voided_reg
				and obs.person_id = 1688 -- var_patient_id
				and obs.obs_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
				group by  encounter.encounter_type, obs.concept_id, obs.person_id;  
       
      
   
   -- PRUEBAS DE EMBARAZO 
   -- existe_prueba_embarazo

				SELECT 
				obs.value_coded,  encounter.encounter_type, count(obs.concept_id) 
                -- , obs.obs_datetime
				-- into var_prueba_embarazo,  var_tip_consul_embarazo, var_cant_prueba_embarazo
				FROM obs, encounter
				WHERE 
				obs.encounter_id = encounter.encounter_id
				and obs.concept_id =  45 -- PRUBA EMBARAZO 
				and obs.voided = 0 -- voided_reg 
				and encounter.voided = 0 --  voided_reg
				and obs.person_id = 1688 -- var_patient_id
                -- AND obs.value_coded in (664, 703, 1304,1138 )
                -- and value_coded <> 1118 -- no se hizo
				and obs.obs_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')                 
				group by obs.value_coded, obs.concept_id, obs.person_id;  
                
                
select obs.value_coded, count(obs.value_coded) from obs
				where  obs.concept_id =  45 -- PRUBA EMBARAZO 
				and obs.voided = 0 -- voided_reg 				
                group by obs.value_coded
                ;

            
            -- OBSERVACIÓN QUE INDICA QUE MUJER ESTÁ EMBARAZADA
            -- existe_obs_embarazada
            -- en agosto no existe observacion actualmente embarazada
   

        SELECT 
				obs.value_coded,  encounter.encounter_type ,count(obs.concept_id)
				-- into var_seno_examen,  var_tip_consul_seno, var_cant_examen_seno
				FROM obs, encounter
				WHERE 
				obs.encounter_id = encounter.encounter_id
				and obs.concept_id = 159780 -- EXAMEN SENO 
				and obs.voided = 0 -- voided_reg 
				and encounter.voided =0 --  voided_reg
				and obs.person_id = 2661 -- var_patient_id
				and obs.obs_datetime between STR_TO_DATE('01/01/2017', '%m/%d/%Y') and STR_TO_DATE('01/31/2017', '%m/%d/%Y')  
				group by obs.value_coded, obs.concept_id, obs.person_id;  


SELECT 
				obs.value_coded,  		-- encounter.encounter_type ,
                count(obs.concept_id)
				-- into var_seno_examen,  	-- var_tip_consul_seno, 
                -- var_cant_examen_seno
				FROM obs, encounter
				WHERE 
				obs.encounter_id = encounter.encounter_id
				and obs.concept_id = 159780 -- EXAMEN SENO 
				and obs.voided = 0 
				and encounter.voided = 0
				and obs.person_id = 2661
                -- and obs.encounter_id = var_encounter_id
				and obs.obs_datetime between STR_TO_DATE('01/01/2017', '%m/%d/%Y') and STR_TO_DATE('01/31/2017', '%m/%d/%Y') 
				group by obs.value_coded, obs.concept_id, obs.person_id;
                
  
  -- PLANIFICACION FAMILIAR 
        
				SELECT 
				obs.value_coded,  encounter.encounter_type ,count(obs.concept_id)
				-- into var_tipo_plan_fam,  var_tip_consul_plan_fam, var_cant_plan_fam
				FROM obs, encounter
				WHERE 
				obs.encounter_id = encounter.encounter_id
				and obs.concept_id = 162971 -- PLANIFICACION FAMILIAR
				and obs.voided = 0 -- voided_reg 
				and encounter.voided = 0 -- voided_reg
				and obs.person_id = 1042 -- var_patient_id
				and obs.obs_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
				group by obs.value_coded, obs.concept_id, obs.person_id;              
                
           