
DROP TABLE PIVOTE_OBS; 
CREATE TABLE PIVOTE_OBS 
 select 
 person.person_id                                    ls_person_patient_id, 
 obs.concept_id                                      ls_concept_id, 
 null                                                patient_program_id,
 null                                                program_id,
 person.birthdate                                    ls_birth,  
 max(obs.date_created)                               ls_obs_date_created  , 
 null 												 date_program_enrolled,
 ( datediff ( sysdate(),  max(obs.date_created ) ) ) ls_dias_obs,
 null ls_program
 from person, obs
 where person.person_id = obs.person_id
 group by person.person_id, obs.concept_id, person.birthdate
 union
select 
	patient.patient_id 								ls_person_patient_id, 
    null                                            date_program_enrolled,
    patient_program.patient_program_id				patient_program_id,  
    program.program_id			                    program_id,  
    person.birthdate 								ls_birth,
    null                                            ls_obs_date_created ,  
    patient_program.date_enrolled					date_program_enrolled,
    null 											ls_dias_obs,
    program.name                                    ls_program
from patient 
left join patient_program 
 on patient.patient_id = patient_program.patient_id 
left join program
 on patient_program.program_id = program.program_id
 left join person
on patient.patient_id = person.person_id
 where program.retired = 0
 and patient_program.voided = 0 ;
 