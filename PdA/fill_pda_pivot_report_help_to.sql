
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
select * from pda_pivot_report;

select 
     patient_identifier.identifier as num_open, patient_id, patient_identifier.* 
     from patient_identifier
     where patient_identifier.patient_id = 139;
     
-- busca ciclo de préstamo
select value_numeric from obs
	where concept_id = 163138 
	and person_id = 139
    and obs.obs_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') ; -- var_patient_id    
     
  
select concept_name.name, concept_name.* from concept_name where concept_id = 162972;
   
   select 
     patient_identifier.identifier, patient_identifier.* 
     from patient_identifier
     where patient_identifier.patient_id in (
139,
1729,
1728,
1732,
1895,
1558,
1926
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
     
     