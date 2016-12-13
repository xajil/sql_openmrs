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
-- 1.1  @nefsacuj     20161212    Unifica conceptos ( 1621 , 461, 1275) y crea virtualmente el concepto:
-- 9999  para agrupar la información de chispitas, independientemente si es proporcionado por wk o 
-- por el centro de salud, e indica la cantidad acual.
##########################################################################
DROP TABLE PIVOTE_OBS; 
CREATE TABLE PIVOTE_OBS 
select 
 person.person_id                                    ls_person_patient_id, 
 x.concept_id                                      ls_concept_id, 
 null                                                patient_program_id,
 null                                                program_id,
 person.birthdate                                    ls_birth,  
 x.obs_datetime                                   ls_obs_date_created  , 
 null 												 date_program_enrolled,
 ( datediff ( sysdate(),  max(x.obs_datetime ) ) ) ls_dias_obs,
 null ls_program,
 x.value_coded 							         value_coded, 
 x.value_numeric                                   value_numeric, 
 x.value_text                                      value_text, 
 x.value_boolean							         value_boolena	
from person, (select * from obs 
	-- where obs.person_id = 6903
	order by obs_id desc) 
as x , 
patient_program
 where person.person_id = x.person_id
	and patient_program.patient_id = person.person_id
	and patient_program.program_id in (12, 13, 14, 9)
	-- and obs.concept_id not in ( 1621 , 461, 1275)
    -- and  x.person_id = 6903
	and person.voided = 0
    and x.voided = 0
    and patient_program.voided = 0
 group by person.person_id, x.concept_id, person.birthdate
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
    program.name                                    ls_program,
 null value_coded, 
 null value_numeric,
 null value_text, 
 null value_boolen 
from patient, patient_program, program, person
 where 
 patient.patient_id = patient_program.patient_id
 and patient.patient_id = person.person_id
 and patient_program.program_id = program.program_id 
 and patient_program.program_id in (12, 13, 14, 9)
 and person.voided = 0
 and program.retired = 0
 and patient_program.voided = 0
 ;
 