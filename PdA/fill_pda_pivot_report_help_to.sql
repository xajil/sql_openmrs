
/* contador de pacientes en la tabla patient, y patient_identifier 
se tomará como base par cursor de paciente la tabla patient_identifier.
*/
select count(*) from patient; -- '1949'
-- union
select count(*) from patient_identifier
where voided = 0; -- '1949'

select patient_identifier.identifier as num_open, patient_id
	from patient_identifier
		where voided = 0;

        insert into  pda_pivot_report 
        (
        patient_id, numero_open, mes,agencia,elegible,tipo_consulta,papanicolaou,pelvico,EIP,EIP_tratamiento,glucosa,glucosa_elevada,presion_art,presion_art_elevada,prueba_embarazo,embarazo_positivo,ETS,ETS_positivo,seno_examen,resultado_examen_seno,implante,DEPO,pastillas
        ) values (1,1,date_format( sysdate(),'%Y%m%d'),1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        );
        
        commit;
        
call proc_pivot_report_fill; 

truncate table pda_pivot_report; 
      
select * from pda_pivot_report;

select * from error_log_pda_repo;

select 
     patient_identifier.identifier as num_open, patient_id, patient_identifier.* 
     from patient_identifier
     where patient_identifier.patient_id = 139;
     
-- busca ciclo de préstamo en la última  (más reciente) observación de ese més 
select value_numeric from obs
	where concept_id = 163138 
	and person_id = 139
    and voided = 0
    and obs.obs_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
    and obs.date_created = (
		select max(obs.date_created) from obs
		where concept_id = 163138 
		and person_id = 139
		and obs.obs_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
		and voided = 0    
    ) ; -- var_patient_id    


select max(value_numeric), max(obs_datetime), count(*) from obs
		where person_id = 139
        and concept_id = 163138
        group by obs.concept_id ;

select value_numeric, obs_datetime from obs
		where person_id = 139
        and concept_id = 163138
        ;
     

/* obtiene la agencia de esa persona  
la agencia queda como un atributo de la person con 
person_attribute_type_id = 8
El valor del atributo Agencia, tiene un valor de tipo Location, es decir que para conocer la agencia 
se debe buscar el valor hallado en la tabla location.
*/
select value from person_attribute
where person_attribute_type_id = 8
	and voided = 0 ;     
     
select * from person_attribute_type
where person_attribute_type_id = 8;     
  
/* musta los diferentes valores para Agencia, */
select parent_location, count(parent_location) from location
group by parent_location;

/* se determina que se está asignano mal una agencia */
select * from location
	where location_id in (24, 25 , 30 );



/* distintos encuentros de los pacientes durante el mes de Agosto
para un conteo general quietar la agrupacion por paciente 
si aparece un contador mayor a 1 para ADULTO_NUEVO es por un tipo de incidente
*/ 
select encounter.encounter_type, encounter_type.name, encounter_type.description, 
encounter.form_id,
count(encounter.encounter_type) cantidad , patient_id 
from encounter, encounter_type
where 
encounter.encounter_type = encounter_type.encounter_type_id
and 
encounter.encounter_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
and encounter.voided = 0
and encounter_type.retired = 0
 and patient_id = 1744 -- 1393
group by encounter.encounter_type, encounter_type.name, encounter_type.description, patient_id
having count(encounter.encounter_type) > 1
;
   
/* deteterminar si se hizo papanicolau, en primera consulta o reconsulta 
PAP se pude determinar si es PRIMERA CONSULTA O RECONSULTA PORQUE TIENEN CONCEPT_ID diferente-
PAP INICIAL =  162972 value_coded = 1267
PAP RECONSULTA= 
*/   
SELECT obs.value_coded, count(obs.concept_id) ,encounter.encounter_type, encounter.form_id, obs.person_id FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and encounter.encounter_type = 1
and obs.obs_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
and obs.concept_id = 162972
and obs.value_coded = 1267
and obs.voided = 0 
and encounter.voided = 0
and obs.person_id = 1744
group by obs.value_coded, obs.concept_id, obs.person_id;


   
/* EXAMEN PÉLVIO INICIAL O RECONSULTA */
SELECT obs.value_coded, count(obs.concept_id) cantidad, encounter.encounter_type, encounter.form_id, obs.person_id FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and encounter.encounter_type = 1
and obs.obs_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
and obs.concept_id = 162991
and obs.value_coded = 1267
and obs.voided = 0 
and encounter.voided = 0
and obs.person_id = 1744
group by obs.value_coded, obs.concept_id, obs.person_id;


select value_numeric from obs
		where concept_id = 163138 
		and person_id = 1744
		and obs.obs_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
        and obs.obs_datetime = (
        select max(obs_datetime) from obs
		where concept_id = 163138 
		and person_id = 1744
		and obs.obs_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
        group by obs.concept_id, obs.obs_datetime, obs.encounter_id
        )
        ;


select max(obs_datetime) from obs
		where concept_id = 163138 
		and person_id = 1744
		and obs.obs_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
        group by obs.concept_id, obs.obs_datetime, obs.encounter_id;
        
select obs.concept_id, obs.obs_datetime, obs.encounter_id, obs.* from obs
where concept_id = 163138 
		and person_id = 1744;
   
   select 
     patient_identifier.identifier as numero_open, patient_identifier.* 
     from patient_identifier
     where patient_identifier.patient_id in (
1744,
1851, 1393
     );
     
select 
     patient_identifier.identifier, patient_identifier.* 
     from patient_identifier
     where patient_identifier.identifier = 38119;
     
select concept_name.name, obs.concept_id, obs.person_id, obs.value_coded from  obs, concept_name 
where
obs.concept_id = concept_name.concept_id
and 
 obs.person_id = 30
 and concept_name.locale = 'es';    
 
select  * from  obs, concept_name 
where
obs.concept_id = concept_name.concept_id
 and obs.person_id = 139
 and obs.concept_id = 162978
 -- and concept_name.locale = 'es'
 ; 
 
 select distinct(value_coded) from  obs
where obs.person_id = 139
 and obs.concept_id = 162978
 -- and concept_name.locale = 'es'
 ; 
 
 
 
select 
     patient_identifier.identifier, patient_identifier.voided, patient_identifier.* 
     from patient_identifier
     where 
     patient_identifier.identifier_type = 2
     and patient_identifier.identifier in ( 123456789, 111111111)
     ;
     
     