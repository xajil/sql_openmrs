
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
 ( datediff ( STR_TO_DATE('06/30/2016', '%m/%d/%Y') ,  max(obs.date_created ) ) ) ls_dias_obs,
 null ls_program
 from person, obs
 where person.person_id = obs.person_id
 -- and person.person_id=4582
 and obs.date_created <= STR_TO_DATE('06/30/2016', '%m/%d/%Y') 
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
 and patient_program.voided = 0
 -- and person.person_id=4582
 ;
 
 

-- select STR_TO_DATE('04/30/2016', '%m/%d/%Y');

-- SELECT  STR_TO_DATE('30-04-2016', '%mm/%dd/%YYYY');

-- 17:05:00	CREATE TABLE PIVOTE_OBS   select   person.person_id  ls_person_patient_id,   obs.concept_id                                      ls_concept_id,   null                                                patient_program_id,  null                                                program_id,  person.birthdate                                    ls_birth,    max(obs.date_created)                               ls_obs_date_created  ,   null              date_program_enrolled,  ( datediff ( STR_TO_DATE('04/30/2016', '%m/%d/%Y') ,  max(obs.date_created ) ) ) ls_dias_obs,  null ls_program  from person, obs  where person.person_id = obs.person_id  -- and person.person_id=4582  and obs.date_created <= '04/30/2016'  group by person.person_id, obs.concept_id, person.birthdate  union select   patient.patient_id         ls_person_patient_id,      null                                            date_program_enrolled,     patient_program.patient_program_id    patient_program_id,       program.program_id                       program_id,       person.birthdate         ls_birth,     null                                            ls_obs_date_created ,       patient_program.date_enrolled     date_program_enrolled,     null            ls_dias_obs,     program.name                                    ls_program from patient  left join patient_program   on patient.patient_id = patient_program.patient_id  left join program  on patient_program.program_id = program.program_id  left join person on patient.patient_id = person.person_id  where program.retired = 0  and patient_program.voided = 0  -- and person.person_id=4582	743 row(s) affected, 1 warning(s): 1292 Incorrect datetime value: '04/30/2016' for column 'date_created' at row 1 Records: 743  Duplicates: 0  Warnings: 0	1.507 sec

 