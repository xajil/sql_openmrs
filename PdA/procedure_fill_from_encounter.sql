CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_fill_from_encounter`()
BEGIN

declare var_patient_id int (11) ;
declare var_numero_open char (50);
declare var_encounter_datetime date;
declare var_location_id int (11);
declare var_location_name  varchar (255);
declare var_ciclo_prestamo int (11) ;
declare var_agencia int (5) default 0;
declare var_elegible int (5) ;
declare var_tipo_consulta int (5) ;

declare var_pap_inicial int (11) ;
declare var_tip_consul_pap int (3);
declare var_cant_pap_inicial int (5) ;

declare var_pelvico int (11);
declare var_tip_consul_pelvico int(3);
declare var_cant_pelvico int (5);

declare var_eip int (11);
declare var_tip_consul_eip int (3);
declare var_cant_eip int (3);
declare var_eip_tratamiento int (3);

declare var_glucosa_ayunas int (11);
declare var_tip_consul_glucosa_ayunas int (3);
declare var_cant_glucosa_ayunas int (3);

declare var_glucosa_azar int (11);
declare var_tip_consul_glucosa_azar int (3);
declare var_cant_glucosa_azar int (3);

declare var_glucosa_elevada int (3);
	-- PRESION ARTERIAL SISTOLICA
		declare var_presion_sistolica int (11);
		declare var_tip_consul_sistolica int (3);
		declare var_cant_sistolica int (3);
   	-- PRESION ARTRRIAL DIASTOLICA
		declare var_presio_diastolica int (11);
		declare var_tip_consul_diastolica int (3);
		declare var_cant_diastolica int (3);
	-- PRESION ELEVADA
		declare var_presion_art_elevada int (3);
-- PRUEBAS DE EMBARAZO        
declare var_prueba_embarazo int (11);
declare var_tip_consul_embarazo int (3);
declare var_cant_prueba_embarazo int (3);
declare var_embarazo_positivo int (3);

declare var_ets int (11);
declare var_vih int (11);
declare var_sifilis int (11);
declare var_hepatitis_b int (3);
declare var_ets_positivo int (11) ; -- cualquiera de las 3 anteriores positvo

declare var_seno_examen int (11);
declare var_tip_consul_seno int (3);
declare var_cant_examen_seno int (3);
declare var_resultado_examen_seno int (11);

declare var_planificacion_familiar int (11);
declare var_implante int (3) default 0;
declare var_depo int (3) default 0;
declare var_pastillas int (3) default 0;

declare var_encounter_id int (11);
declare var_form_id int (11);
declare var_provider_id int (11);


declare var_tipo_plan_fam int (11);
declare var_tip_consul_plan_fam int (11); 
declare var_cant_plan_fam int (11);


declare ciclo_prestamo_concept_id int default 163138;
declare pap_inicial_concept_id int default 162972;
declare hecho_concept_value int default 1267; 
declare pelvico_concept_id int default 162991;
declare eip_concept_id int default 162969; 
declare eip_hecho int default 162968;
declare eip_tratamiento_concept_id int default 163057;
declare glucosa_concept_id int default 163130; 
declare eip_value_con_tratamiento int default 1;
declare voided_reg int default 0;
declare  var_encounter_type int (3);


declare existe_ciclo_prestamo int default 0;
declare existe_agencia int default 0;
declare existe_pap_inicial int default 0;
declare existe_ex_pelvico int default 0;
declare existe_eip int default 0;
declare existe_tratamiento_eip int default 0;
declare existe_ex_glucosa int default 0;
declare existe_glucosa_ayunas int default 0;
declare existe_glucosa_azar int default 0;
declare ayunas_glucosa_valor int (11) default 0;
declare azar_glucosa_valor int (11) default 0;
declare existe_sistolica int default 0;
declare existe_diastolica int default 0;
declare existe_prueba_embarazo int default 0;
declare existe_obs_embarazada int default 0; -- AÚN NO UTILIZADO
declare existe_examen_seno int default 0;
declare existe_plan_familiar int default 0;

declare num_rows int default 0;
declare loop_ctrl int default 0;

DECLARE fin int default 0;



declare cur_patients cursor for 
select  patient_identifier.identifier, patient_identifier.patient_id, encounter.location_id, location.name,
encounter.encounter_id, encounter.encounter_datetime, encounter.encounter_type , encounter.form_id , encounter_provider.provider_id 
	from patient_identifier, location, encounter, encounter_provider
    where patient_identifier.location_id = location.location_id
		and encounter.patient_id = patient_identifier.patient_id
        and encounter.encounter_id = encounter_provider.encounter_id
        and encounter.encounter_datetime  between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
        and encounter.voided = 0
        and encounter_provider.voided = 0
		and patient_identifier.voided = 0    
        -- and patient_identifier.patient_id = 1622
        ; -- ,  -- en wk identifier_type = 2  para asegura que es numero_open
--  and patient_identifier.patient_id in (  139 , 1744 , 1558, 491 , 1646,1521,110,528, 99)


-- declare cur_obs cursor for select concept_id from obs where patient_id = var_patient_id;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 1;

declare exit handler for 1242
    begin
        insert into error_log_pda_repo values 
        ( var_patient_id , var_numero_open, current_date,  'más de un valor de retrono');
    end;


open cur_patients;
select FOUND_ROWS () into num_rows;

	loop_patients: loop
		
        fetch cur_patients into var_numero_open, var_patient_id, var_location_id,var_location_name, var_encounter_id, var_encounter_datetime, var_tipo_consulta, var_form_id, var_provider_id ;
        
        if fin=1 then
			leave loop_patients;            
		end if;
        
        -- fecha de reporte
        -- set var_mes = date_format(sysdate(), '%Y%m%d');
        
        select ifnull(
        (
        select count(value_numeric) from obs
		where concept_id = ciclo_prestamo_concept_id 
		and person_id = var_patient_id
        and obs.voided  = 0
        and obs.encounter_id = var_encounter_id
		and obs.obs_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
        
        )
        , 0) into existe_ciclo_prestamo;
        
        if (existe_ciclo_prestamo > 0) then
        -- ciclo de préstamo
        select value_numeric 
        into var_ciclo_prestamo 
        from obs
		where concept_id = 163138 --  ciclo_prestamo_concept_id 
		and person_id = var_patient_id
		and obs.obs_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
        -- and obs.encounter_id = var_encounter_id
        and obs.voided  = 0
        and obs.date_created = (
			select max(obs.date_created) 
			from obs
			where concept_id = 163138 --  ciclo_prestamo_concept_id 
			and person_id = var_patient_id
            -- and obs.encounter_id = var_encounter_id
            and obs.voided  = 0
			and obs.obs_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
        )
        ;
        else
        set var_ciclo_prestamo = 0;
        end if;
	-- determinar si un cliente es o no ELEGIBLE
        if ( var_ciclo_prestamo >= 3 ) then 
			set var_elegible = 1;
		else 
			set var_elegible = 0;
        end if;         

	-- DETERMINA AGENCIA DEL PACIENTE
		select ifnull (
        (
        select count(value) from person_attribute
			where person_attribute_type_id = 8
				and voided = voided_reg
                and person_id = var_patient_id                
                ),0) into  existe_agencia;
        
        if (existe_agencia > 0) then
        select value into var_agencia from person_attribute
			where person_attribute_type_id = 8
				and voided = voided_reg
                and person_id = var_patient_id
                group by person_attribute.value, person_attribute.person_id;   
                -- person_attribute.value 
        else 
			 -- no se encontró agencia
             set var_agencia = 0;
		end if;         
        


/* PAP Inicial */
	-- set var_pap_inicial, var_tip_consul_pap, var_cant_pap_inicial = (
    SELECT IFNULL (
			(
            SELECT count(obs.concept_id)  FROM obs, encounter
			WHERE 
			obs.encounter_id = encounter.encounter_id
			and obs.obs_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
			and obs.concept_id = pap_inicial_concept_id
			and obs.value_coded = hecho_concept_value
			and obs.person_id = var_patient_id
			and obs.voided = voided_reg 
            and obs.encounter_id = var_encounter_id
			and encounter.voided = voided_reg
            )
    , 0 ) INTO existe_pap_inicial ; 
    
    if (existe_pap_inicial > 0 )then 
			SELECT obs.value_coded, encounter.encounter_type, count(obs.concept_id) 
            into var_pap_inicial, var_tip_consul_pap, var_cant_pap_inicial  FROM obs, encounter
			WHERE 
			obs.encounter_id = encounter.encounter_id
			and obs.obs_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
			and obs.concept_id = pap_inicial_concept_id
			and obs.value_coded = hecho_concept_value
			and obs.person_id = var_patient_id
			and obs.voided = voided_reg 
			and encounter.voided = voided_reg
            and obs.encounter_id = var_encounter_id
			group by obs.value_coded, encounter.encounter_type, obs.concept_id, obs.person_id;
	else 
    set var_pap_inicial = -1;
    set var_tip_consul_pap = -1;
    set var_cant_pap_inicial = -1;
    end if; 
		

-- EXAMEN PÉLVICO    
    SELECT IFNULL (
			(
            SELECT count(obs.concept_id)  FROM obs, encounter
			WHERE 
			obs.encounter_id = encounter.encounter_id
			and obs.obs_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
			and obs.concept_id = pelvico_concept_id
			and obs.value_coded = hecho_concept_value
			and obs.person_id = var_patient_id
			and obs.voided = voided_reg 
            and obs.encounter_id = var_encounter_id
			and encounter.voided = voided_reg
            )
    , 0 ) INTO existe_ex_pelvico ; 
    
    
    if ( existe_ex_pelvico > 0) then
			SELECT 
			obs.value_coded,  encounter.encounter_type ,count(obs.concept_id)
            into var_pelvico,  var_tip_consul_pelvico, var_cant_pelvico
			FROM obs, encounter
			WHERE 
			obs.encounter_id = encounter.encounter_id
			and obs.obs_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
			and obs.concept_id = pelvico_concept_id
			and obs.value_coded = hecho_concept_value
			and obs.voided = voided_reg 
			and encounter.voided = voided_reg
			and obs.person_id = var_patient_id
            and obs.encounter_id = var_encounter_id
			group by obs.value_coded, encounter.encounter_type, obs.concept_id, obs.person_id;
	else 
		set var_pelvico = -1;
		set var_tip_consul_pelvico = -1;
		set var_cant_pelvico = -1;		
    end if ;

        

-- EIP  Examen Bimanual y con Espéculo  
	SELECT ifnull(
			(select count(obs.concept_id) from obs, encounter
			where obs.encounter_id = encounter.encounter_id
			-- and encounter.encounter_type = 2
			and concept_id = eip_concept_id
			and value_coded = eip_hecho
			and obs.person_id = var_patient_id
			and obs.voided = voided_reg
            and obs.encounter_id = var_encounter_id
			and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
			), 0) into existe_eip ;

	if existe_eip > 0 then
    select 
    obs.value_coded,  encounter.encounter_type ,count(obs.concept_id)
    into var_eip, var_tip_consul_eip,var_cant_eip
    from obs, encounter
			where obs.encounter_id = encounter.encounter_id
			-- and encounter.encounter_type = 2
			and concept_id = eip_concept_id
			and value_coded = eip_hecho
			and obs.person_id = var_patient_id
			and obs.voided = voided_reg
            and obs.encounter_id = var_encounter_id
			and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
            group by obs.value_coded, encounter.encounter_type, obs.concept_id, obs.person_id;
    else
	set var_eip = -1;
	set var_tip_consul_eip = -1;
	set var_cant_eip = -1;
    end if;
    
    
/* determinar si tiene tratamietno eip */
select ifnull(
(select count(obs.concept_id) from obs
where concept_id = eip_tratamiento_concept_id
and obs.person_id = var_patient_id
and  voided=voided_reg
and value_coded =eip_value_con_tratamiento -- tiene tratamieto asignado 
and obs.encounter_id = var_encounter_id
and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
)
, 0 )into existe_tratamiento_eip;
-- ;
if existe_tratamiento_eip > 0 then
select obs.value_coded into var_eip_tratamiento from obs
where obs.concept_id = eip_tratamiento_concept_id
and obs.person_id = var_patient_id
and  voided=voided_reg
and value_coded =eip_value_con_tratamiento -- tiene tratamieto asignado 
and obs.encounter_id = var_encounter_id
and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
group by obs.value_coded,  obs.concept_id, obs.person_id; 
-- obs.concept_id,
else 
	set var_eip_tratamiento = -1;
end if;             
			
            /*VALIDACIONES DE GLUCOSA */
            
            /*SELECT ifnull (
            ( select count(obs.concept_id) from obs
			where concept_id = glucosa_concept_id
            and obs.person_id = var_patient_id
			and  voided=voided_reg
			and value_coded = hecho_concept_value
            and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
            )
            ,0 ) into existe_ex_glucosa ;
            
            if existe_ex_glucosa > 0 then
			select 
			obs.value_coded,  encounter.encounter_type ,count(obs.concept_id)
			into var_glucosa, var_tip_consul_glucosa, var_cant_glucosa
			from obs, encounter
			where obs.encounter_id = encounter.encounter_id
			and concept_id = glucosa_concept_id
			and value_coded = hecho_concept_value
			and obs.person_id = var_patient_id
			and obs.voided = voided_reg
			and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y');    			
            
            else
            set var_glucosa = -1;
			set var_tip_consul_glucosa = -1;
			set var_cant_glucosa = -1;
           --  set var_glucosa_elevada= -1;
            end if; 
            */
            
            
            				-- declare ayunas_glucosa_valor int (11);
				select ifnull (
				(
				select 
				count(obs.value_numeric)				
				from obs, encounter
				where obs.encounter_id = encounter.encounter_id
				and concept_id = 160912
				-- and value_coded = hecho_concept_value
				and obs.person_id = var_patient_id
				and obs.voided = voided_reg
                and obs.encounter_id = var_encounter_id
				and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
				),0 ) into existe_glucosa_ayunas;
				
              
				if (existe_glucosa_ayunas > 0) then                
                
				SELECT 
				max(obs.value_numeric),  encounter.encounter_type ,count(obs.concept_id)
				into var_glucosa_ayunas,  var_tip_consul_glucosa_ayunas, var_cant_glucosa_ayunas
				FROM obs, encounter
				WHERE 
				obs.encounter_id = encounter.encounter_id
				and obs.concept_id = 160912
				and obs.voided = voided_reg 
				and encounter.voided = voided_reg
				and obs.person_id = var_patient_id
                and obs.encounter_id = var_encounter_id
				and obs.obs_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
				group by encounter.encounter_type , obs.concept_id, obs.person_id;            
                
				else 
                    set var_glucosa_ayunas = -1 ;
					set var_tip_consul_glucosa_ayunas= -1 ;
					set var_cant_glucosa_ayunas= -1 ;
				end if;
            
		
					select ifnull (
					(select 
					count(obs.value_numeric)
					from obs, encounter
					where obs.encounter_id = encounter.encounter_id
					and concept_id = 887
					-- and value_coded = hecho_concept_value
					and obs.person_id = var_patient_id
					and obs.voided = voided_reg
                    and obs.encounter_id = var_encounter_id
					and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
					),
					0
					) into existe_glucosa_azar;
					-- declare azar_glucosa_valor int (11);
					if (existe_glucosa_azar > 0) then
				SELECT 
				max(obs.value_numeric),  encounter.encounter_type ,count(obs.concept_id)
				into var_glucosa_azar,  var_tip_consul_glucosa_azar, var_cant_glucosa_azar
				FROM obs, encounter
				WHERE 
				obs.encounter_id = encounter.encounter_id
				and obs.concept_id = 887
				and obs.voided = voided_reg 
				and encounter.voided = voided_reg
				and obs.person_id = var_patient_id
                and obs.encounter_id = var_encounter_id
				and obs.obs_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
				group by encounter.encounter_type , obs.concept_id, obs.person_id;      
					else 
					-- set azar_glucosa_valor = 0;
                    set var_glucosa_azar = -1 ;
					set var_tip_consul_glucosa_azar= -1 ;
					set var_cant_glucosa_azar= -1 ;

					end if ;
				
				--  or azar_glucosa_valor > 200 
				if (var_glucosa_ayunas > 126 or var_glucosa_azar > 200 ) then
				set var_glucosa_elevada= 1;
				else 
				set var_glucosa_elevada= 0;
				end if; 	
                
	-- PRESION ARTERIAL SISTOLICA       
        select ifnull (
        (select 
					count(obs.value_numeric)
					-- into azar_glucosa_valor
					from obs, encounter
					where obs.encounter_id = encounter.encounter_id
					and concept_id = 5085 -- sistolica
					and obs.person_id = var_patient_id
					and obs.voided = voided_reg
                    and obs.encounter_id = var_encounter_id
					and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
                    )
        , 0) into existe_sistolica;
        
        
        if (existe_sistolica > 0) then
				SELECT 
				max(obs.value_numeric),  encounter.encounter_type ,count(obs.concept_id)
				into var_presion_sistolica,  var_tip_consul_sistolica, var_cant_sistolica
				FROM obs, encounter
				WHERE 
				obs.encounter_id = encounter.encounter_id
				and obs.concept_id =  5085 -- sistolica
				and obs.voided = voided_reg 
				and encounter.voided = voided_reg
				and obs.person_id = var_patient_id
                and obs.encounter_id = var_encounter_id
				and obs.obs_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
				group by encounter.encounter_type, obs.concept_id, obs.person_id;  
        else
        set var_presion_sistolica = -1;
        set var_tip_consul_sistolica = -1;
        set var_cant_sistolica = -1;
        end if; 

   
	-- PRESION ARTRRIAL DIASTOLICA       
        select ifnull (
        (select 
					count(obs.value_numeric)
					from obs, encounter
					where obs.encounter_id = encounter.encounter_id
					and concept_id = 5086 -- diastolica
					and obs.person_id = var_patient_id
					and obs.voided = voided_reg
                    and obs.encounter_id = var_encounter_id
					and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
                    )
        , 0) into existe_diastolica;
        
        
        if (existe_diastolica > 0) then
				SELECT 
				max(obs.value_numeric),  encounter.encounter_type ,count(obs.concept_id)
				into var_presio_diastolica,  var_tip_consul_diastolica, var_cant_diastolica
				FROM obs, encounter
				WHERE 
				obs.encounter_id = encounter.encounter_id
				and obs.concept_id =  5086 -- diastolica
				and obs.voided = voided_reg 
				and encounter.voided = voided_reg
				and obs.person_id = var_patient_id
                and obs.encounter_id = var_encounter_id
				and obs.obs_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
				group by encounter.encounter_type, obs.concept_id, obs.person_id;  
        else
        set var_presio_diastolica = -1;
        set var_tip_consul_diastolica = -1;
        set var_cant_diastolica = -1;
        end if;         
        
        	-- PRESION ELEVADA
		if ( var_presion_sistolica >= 140 or var_presio_diastolica >= 90) then
        set var_presion_art_elevada = 1;
        else
        set var_presion_art_elevada = 0;
        end if;
        
   
   -- PRUEBAS DE EMBARAZO 
   -- existe_prueba_embarazo
		select ifnull (
        (select 
					count(obs.value_coded)
					-- into azar_glucosa_valor
					from obs, encounter
					where obs.encounter_id = encounter.encounter_id
					and concept_id = 45 -- PRUBA EMBARAZO 
                    AND obs.value_coded in (664, 703, 1304,1138 )
					and obs.person_id = var_patient_id
					and obs.voided = voided_reg
                    and obs.encounter_id = var_encounter_id
					and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
                    )
        , 0) into existe_prueba_embarazo;
        
			if (existe_prueba_embarazo > 0) then
				/*
                SELECT 
				obs.value_coded,  encounter.encounter_type ,count(obs.concept_id)
				into var_prueba_embarazo,  var_tip_consul_embarazo, var_cant_prueba_embarazo
				FROM obs, encounter
				WHERE 
				obs.encounter_id = encounter.encounter_id
				and obs.concept_id =  45 -- PRUBA EMBARAZO 
				and obs.voided = voided_reg 
				and encounter.voided = voided_reg
				and obs.person_id = var_patient_id
                -- AND obs.value_coded in (664, 703, 1304,1138 )
               --  and obs.value_coded <> 1118
				and obs.obs_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
				group by obs.value_coded, obs.concept_id, obs.person_id;  
                */
				set var_prueba_embarazo = 1;
				set var_tip_consul_embarazo = 1;
				set var_cant_prueba_embarazo = 1;
            else 
				set var_prueba_embarazo = -1;
				set var_tip_consul_embarazo = -1;
				set var_cant_prueba_embarazo = -1;
            end if;
            
            -- OBSERVACIÓN QUE INDICA QUE MUJER ESTÁ EMBARAZADA
            -- existe_obs_embarazada
            -- en agosto no existe observacion actualmente embarazada
   
   -- EMBARAZO POSITIVO
   if (var_prueba_embarazo = 703 ) then
	set var_embarazo_positivo = 1;
   else
	set var_embarazo_positivo = 0;
   end if;
   
   
   -- EXAMEN DE SENO HECHO
   -- en agosto no existe con algún valor en EXAMEN HECHO, PERO SÍ EN LOS RESULTADOS
   -- existe_examen_seno
   		select ifnull (
        (select 
					count(obs.value_coded)
					-- into azar_glucosa_valor
					from obs, encounter
					where obs.encounter_id = encounter.encounter_id
					and concept_id = 159780 -- EXAMEN SENO 
					and obs.person_id = var_patient_id
					and obs.voided = voided_reg
                    and obs.encounter_id = var_encounter_id
					and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
                    )
        , 0) into existe_examen_seno;
        
        if (existe_examen_seno > 0) then
        SELECT 
				obs.value_coded,  encounter.encounter_type ,count(obs.concept_id)
				into var_seno_examen,  var_tip_consul_seno, var_cant_examen_seno
				FROM obs, encounter
				WHERE 
				obs.encounter_id = encounter.encounter_id
				and obs.concept_id = 159780 -- EXAMEN SENO 
				and obs.voided = voided_reg 
				and encounter.voided = voided_reg
				and obs.person_id = var_patient_id
                and obs.encounter_id = var_encounter_id
				and obs.obs_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
				group by obs.value_coded, obs.concept_id, obs.person_id;  
        else
				set var_seno_examen = -1;
				set var_tip_consul_seno = -1;
				set var_cant_examen_seno = -1;
        end if;
   
		if (var_seno_examen in (146931, 148058, 142248) ) then
        set var_resultado_examen_seno = 1;
        else 
        set var_resultado_examen_seno = 0;
        end if;
   
   -- PLANIFICACION FAMILIAR 
		select ifnull (
        (select 
					count(obs.value_coded)
					-- into azar_glucosa_valor
					from obs, encounter
					where obs.encounter_id = encounter.encounter_id
					and concept_id = 162971 -- PLANIFICACION FAMILIAR
					and obs.person_id = var_patient_id
					and obs.voided = voided_reg
                    and obs.encounter_id = var_encounter_id
					and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
                    )
        , 0) into existe_plan_familiar;
        
        if( existe_plan_familiar > 0) then
				SELECT 
				obs.value_coded,  encounter.encounter_type ,count(obs.concept_id)
				into var_tipo_plan_fam,  var_tip_consul_plan_fam, var_cant_plan_fam
				FROM obs, encounter
				WHERE 
				obs.encounter_id = encounter.encounter_id
				and obs.concept_id = 162971 -- PLANIFICACION FAMILIAR
				and obs.voided = voided_reg 
				and encounter.voided = voided_reg
				and obs.person_id = var_patient_id
                and obs.encounter_id = var_encounter_id
				and obs.obs_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
				group by obs.value_coded, obs.concept_id, obs.person_id;              
            
            set var_planificacion_familiar = 1;
            
            
            
        else
			set var_planificacion_familiar = 0;
            set var_tipo_plan_fam = -1;
			set var_tip_consul_plan_fam = -1;
			set var_cant_plan_fam = -1;
        end if; 
        
        -- existen otros tipo de planificiación no considerados en este script
        if (var_tipo_plan_fam = 7873) then
        set var_implante=1;
        set var_depo = 0;
        set var_pastillas =0;
        elseif (var_tipo_plan_fam = 907 ) then
        set var_depo = 1;
		set var_implante=0;
        set var_pastillas =0;
        elseif (var_tipo_plan_fam =104625 ) then
        set var_pastillas = 1;
        set var_implante=0;
        set var_depo = 0;
        else 
		set var_pastillas = 0;
        set var_implante=0;
        set var_depo = 0;
        end if;
        
        

 

        
		-- select  var_numero_open, var_patient_id, var_ciclo_prestamo, var_agencia, var_elegible,
        -- var_pap_inicial, var_tip_consul_pap, var_cant_pap_inicial
        -- var_pelvico,  var_tip_consul_pelvico, var_cant_pelvico ;
        -- select var_patient_id, existe_glucosa_ayunas, existe_glucosa_azar, ayunas_glucosa_valor, azar_glucosa_valor, var_glucosa_elevada ;
        
        insert into  pda_pivot_report 
        (
        patient_id, numero_open, encounter_datetime, location_id, location_name, ciclo_prestamo, agencia,elegible,tipo_consulta,
        pap_inicial,cant_pap_inicial,tip_consul_pap,
        pelvico,cant_pelvico, tip_consul_pelvico, 
        eip, tip_consul_eip, cant_eip, eip_tratamiento,

glucosa_ayunas,
tip_consul_glucosa_ayunas,
cant_glucosa_ayunas,
glucosa_azar,
tip_consul_glucosa_azar,
cant_glucosa_azar,
glucosa_elevada,
        
presion_sistolica,
tip_consul_sistolica,
cant_sistolica,
presio_diastolica,
tip_consul_diastolica,
cant_diastolica,
presion_art_elevada,

prueba_embarazo ,
tip_consul_embarazo,
cant_prueba_embarazo,

embarazada_o_examen_positivo,

ETS,ETS_positivo,

seno_examen,
tip_consul_seno,
cant_examen_seno,
resultado_examen_seno,

planificacion_familiar,
implante,
depo,
pastillas,
encounter_id,
form_id,
provider_id


        ) values (
var_patient_id,
var_numero_open,
var_encounter_datetime,
var_location_id,
var_location_name,
var_ciclo_prestamo,
var_agencia,
var_elegible,
var_tipo_consulta,

var_pap_inicial,
var_cant_pap_inicial,
var_tip_consul_pap,

	var_pelvico,
	var_cant_pelvico, 
	var_tip_consul_pelvico,
    
var_eip,
var_tip_consul_eip,
var_cant_eip,
var_eip_tratamiento,

var_glucosa_ayunas,
var_tip_consul_glucosa_ayunas,
var_cant_glucosa_ayunas,
var_glucosa_azar,
var_tip_consul_glucosa_azar,
var_cant_glucosa_azar,
var_glucosa_elevada,


var_presion_sistolica,
var_tip_consul_sistolica,
var_cant_sistolica,
var_presio_diastolica,
var_tip_consul_diastolica,
var_cant_diastolica,
var_presion_art_elevada,

var_prueba_embarazo,
var_tip_consul_embarazo,
var_cant_prueba_embarazo,

var_embarazo_positivo,
var_ETS,
var_ETS_positivo,

var_seno_examen,
var_tip_consul_seno,
var_cant_examen_seno,
var_resultado_examen_seno,

var_planificacion_familiar,
var_implante,
var_depo,
var_pastillas,
var_encounter_id,
var_form_id,
var_provider_id

        );
        
        commit;
        
        set loop_ctrl = loop_ctrl +1;
        
	end loop loop_patients;
    
select  num_rows, loop_ctrl;
			    
close cur_patients;

END