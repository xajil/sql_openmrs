##########################################################################
-- Name             : Tabla pivote para crear informes mensuales de nutrición
-- Date             : 20161208
-- Author           : Neftali Sacuj
-- Organization     : Wuqu' Kawoq
-- Purpose          : Obtener la observación más reciente de cada concepto e insertarlo en la tabla.
-- Usage        	: sqlplus
-- Impact   		: N/A
-- Required grants  : Drop/Create/SELECT
-- Called by        : OpenMRS Sql Data Set
##########################################################################
-- ver  user      date        change  
-- 1.0  @nefsacuj     20161208    initial
##########################################################################
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
 from person, obs, patient_program
 where person.person_id = obs.person_id
	and patient_program.patient_id = person.person_id
	and patient_program.program_id in (12, 13, 14, 9)
	and person.voided = 0
    and obs.voided = 0
    and patient_program.voided = 0
 group by person.person_id, obs.concept_id, person.birthdate
 UNION
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
from patient, patient_program, program, person
 where 
 patient.patient_id = patient_program.patient_id
 and patient.patient_id = person.person_id
 and patient_program.program_id = program.program_id 
 and patient_program.program_id in (12, 13, 14, 9)
 and person.voided = 0
 and program.retired = 0
 and patient_program.voided = 0;