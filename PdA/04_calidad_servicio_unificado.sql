##########################################################################
-- Name             : Informe de Calidad de Servicio Por Agencias
-- Date             : 20161010
-- Author           : Neftali Sacuj
-- Organization     : Wuqu' Kawoq
-- Purpose          : Conteos de Calidad de Servicios Por Agencia
-- Usage        	: sqlplus
-- Impact   		: N/A
-- Required grants  : SELECT
-- Called by        : OpenMRS Sql Data Set
##########################################################################
-- ver  user      	date        change  
-- 1.0  @nefsacuj   20161010    initial
##########################################################################
-- EIP CON TRATAMIENTO
SELECT * FROM (
select  
COUNT( distinct orders.patient_id) CANT, 
'SOLOLA' AGENCIA, 
'EIP_CON_TRATAMIENTO' INDICADOR
from drug_order, drug, orders
where drug_order.drug_inventory_id = drug.drug_id
and drug_order.order_id = orders.order_id
and orders.discontinued = 1
and orders.concept_id IN( 73041, 79782, 75222) --  juntos siempre
-- and orders.patient_id = var_patient_i
and orders.start_date  between STR_TO_DATE('20160901', '%Y%m%d') and STR_TO_DATE('20160930', '%Y%m%d')
and orders.patient_id in (
SELECT 
obs.person_id FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.concept_id = 162969
and obs.value_coded  = 162968
and obs.voided = 0 
and encounter.voided = 0
and encounter.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
and date_format( obs.obs_datetime, '%Y%m%d') between STR_TO_DATE('20160901', '%Y%m%d') and STR_TO_DATE('20160930', '%Y%m%d')
)
group by orders.patient_id
having count(orders.concept_id) = 3
order by orders.patient_id) TMP_EIP_SOLOLA
UNION
-- EIP HECHO
SELECT 
count(*) EIP_HECHO, 
'SOLOLA' AGENCIA,
'EIP_HECHO' INDICADOR
FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.concept_id = 162969
and obs.value_coded  = 162968
and obs.voided = 0 
and encounter.voided = 0
and encounter.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
and date_format( obs.obs_datetime, '%Y%m%d') between STR_TO_DATE('20160901', '%Y%m%d') and STR_TO_DATE('20160930', '%Y%m%d')

UNION 

-- EIP CON TRATAMIENTO
SELECT * FROM (
select  
COUNT( distinct orders.patient_id) CANT, 
'CHIMAL' AGENCIA, 
'EIP_CON_TRATAMIENTO' INDICADOR
from drug_order, drug, orders
where drug_order.drug_inventory_id = drug.drug_id
and drug_order.order_id = orders.order_id
and orders.discontinued = 1
and orders.concept_id IN( 73041, 79782, 75222) --  juntos siempre
-- and orders.patient_id = var_patient_i
and orders.start_date  between STR_TO_DATE('20160901', '%Y%m%d') and STR_TO_DATE('20160930', '%Y%m%d')
and orders.patient_id in (
SELECT 
obs.person_id FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.concept_id = 162969
and obs.value_coded  = 162968
and obs.voided = 0 
and encounter.voided = 0
and encounter.location_id in (26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50) -- CHIMALTENANGO
and date_format( obs.obs_datetime, '%Y%m%d') between STR_TO_DATE('20160901', '%Y%m%d') and STR_TO_DATE('20160930', '%Y%m%d')
)
group by orders.patient_id
having count(orders.concept_id) = 3
order by orders.patient_id) TMP_EIP_SOLOLA
UNION
-- EIP HECHO
SELECT 
count(*) EIP_HECHO, 
'CHIMAL' AGENCIA,
'EIP_HECHO' INDICADOR
FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.concept_id = 162969
and obs.value_coded  = 162968
and obs.voided = 0 
and encounter.voided = 0
and encounter.location_id in (26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50) -- CHIMALTENANGO
and date_format( obs.obs_datetime, '%Y%m%d') between STR_TO_DATE('20160901', '%Y%m%d') and STR_TO_DATE('20160930', '%Y%m%d')
UNION
SELECT 
count(*) CANT, 
'CHIMAL' AGENCIA,
'PAP_HECHO' INDICADOR
-- date_format( obs.obs_datetime, '%Y%m%d') obs_datetime_formated,
-- obs.* 
FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and date_format( obs.obs_datetime, '%Y%m%d') between date_format ( (adddate( STR_TO_DATE('20160901', '%Y%m%d'), interval - 42 day)),  '%Y%m%d') and date_format ( (adddate( STR_TO_DATE('20160930', '%Y%m%d'), interval - 42 day)),  '%Y%m%d')
and obs.concept_id  IN ( 162972, 162978) 
and obs.value_coded = 1267
and obs.voided = 0 
and encounter.voided = 0
and encounter.location_id in (26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50) -- CHIMALTENANGO
UNION
SELECT 
count(*) CANT, 
'SOLOLA' AGENCIA,
'PAP_HECHO' INDICADOR
-- date_format( obs.obs_datetime, '%Y%m%d') obs_datetime_formated,
-- obs.* 
FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and date_format( obs.obs_datetime, '%Y%m%d') between date_format ( (adddate( STR_TO_DATE('20160901', '%Y%m%d'), interval - 42 day)),  '%Y%m%d') and date_format ( (adddate( STR_TO_DATE('20160930', '%Y%m%d'), interval - 42 day)),  '%Y%m%d')
and obs.concept_id  IN ( 162972, 162978) 
and obs.value_coded = 1267
and obs.voided = 0 
and encounter.voided = 0
and encounter.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
UNION
select 
COUNT(*) CANT, 
'CHIMAL' AGENCIA,
'PAP_ENTREGADO' INDICADOR
from obs, encounter
wHERE 
obs.encounter_id = encounter.encounter_id
and obs.concept_id  = 163137 
and obs.voided = 0 
and encounter.voided = 0
and exists (
SELECT 
obs_int.person_id
FROM obs obs_int, encounter enc_int
WHERE 
obs_int.encounter_id = enc_int.encounter_id
and date_format( obs_int.obs_datetime, '%Y%m%d') between date_format ( (adddate( STR_TO_DATE('20160901', '%Y%m%d'), interval - 42 day)),  '%Y%m%d') and date_format ( (adddate( STR_TO_DATE('20160930', '%Y%m%d'), interval - 42 day)),  '%Y%m%d')
and obs_int.concept_id  IN ( 162972, 162978) 
and obs_int.value_coded = 1267
and obs_int.voided = 0 
and enc_int.voided = 0
and obs_int.person_id = obs.person_id
and encounter.location_id in (26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50) -- CHIMALTENANGO
and datediff(obs.obs_datetime, obs_int.obs_datetime) <= 42
) 
UNION 
select 
COUNT(*) CANT, 
'SOLOLA' AGENCIA,
'PAP_ENTREGADO' INDICADOR
from obs, encounter
wHERE 
obs.encounter_id = encounter.encounter_id
and obs.concept_id  = 163137 
and obs.voided = 0 
and encounter.voided = 0
and exists (
SELECT 
obs_int.person_id
FROM obs obs_int, encounter enc_int
WHERE 
obs_int.encounter_id = enc_int.encounter_id
and date_format( obs_int.obs_datetime, '%Y%m%d') between date_format ( (adddate( STR_TO_DATE('20160901', '%Y%m%d'), interval - 42 day)),  '%Y%m%d') and date_format ( (adddate( STR_TO_DATE('20160930', '%Y%m%d'), interval - 42 day)),  '%Y%m%d')
and obs_int.concept_id  IN ( 162972, 162978) 
and obs_int.value_coded = 1267
and obs_int.voided = 0 
and enc_int.voided = 0
and obs_int.person_id = obs.person_id
and encounter.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
and datediff(obs.obs_datetime, obs_int.obs_datetime) <= 42
) 
UNION
select 
count(*) CANT,
'SOLOLA' AGENCIA,
'DIABETES_IDENTIFICADO' INDICADOR
 from patient_identifier, patient, patient_program
where patient_identifier.patient_id = patient.patient_id
and patient.patient_id = patient_program.patient_id
and patient_program.program_id in (4,5,6)
and date_completed is null
and patient_program.voided = 0
and patient_identifier.voided = 0
and patient_identifier.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
UNION
select 
count(*) CANT,
'CHIMAL' AGENCIA,
'DIABETES_IDENTIFICADO' INDICADOR
 from patient_identifier, patient, patient_program
where patient_identifier.patient_id = patient.patient_id
and patient.patient_id = patient_program.patient_id
and patient_program.program_id in (4,5,6)
and date_completed is null
and patient_program.voided = 0
and patient_identifier.voided = 0
and patient_identifier.location_id in (26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50) -- CHIMALTENANGO
union
select count(*) CANT,
'SOLOLA' AGENCIA,
'DIABETES_CON_TRATAMIENTO' INDICADOR
 from patient_identifier, patient, patient_program
where patient_identifier.patient_id = patient.patient_id
and patient.patient_id = patient_program.patient_id
and patient_program.program_id = 13
and date_completed is null
and patient_program.voided = 0
and patient_identifier.voided = 0
and patient_program.patient_id
and patient_identifier.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
UNION
select count(*) CANT,
'CHIMAL' AGENCIA,
'DIABETES_CON_TRATAMIENTO' INDICADOR
 from patient_identifier, patient, patient_program
where patient_identifier.patient_id = patient.patient_id
and patient.patient_id = patient_program.patient_id
and patient_program.program_id = 13
and date_completed is null
and patient_program.voided = 0
and patient_identifier.voided = 0
and patient_program.patient_id
and patient_identifier.location_id in (26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50) -- CHIMALTENANGO
UNION
SELECT 
count(*) CANT, 
'SOLOLA' AGENCIA,
'EXAMEN_DE_SENO' INDICADOR
FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.concept_id = 159780
and obs.value_coded in (146931,148058,142248)
and obs.voided = 0 
and encounter.voided = 0
and date_format( obs.obs_datetime, '%Y%m%d') between date_format ( (adddate( STR_TO_DATE('20160901', '%Y%m%d'), interval - 6 week)),  '%Y%m%d') and date_format ( (adddate( STR_TO_DATE('20160930', '%Y%m%d'), interval - 6 week)),  '%Y%m%d')
and encounter.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
UNION
SELECT 
count(*) CANT, 
'CHIMAL' AGENCIA,
'EXAMEN_DE_SENO' INDICADOR
FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.concept_id = 159780
and obs.value_coded in (146931,148058,142248)
and obs.voided = 0 
and encounter.voided = 0
and date_format( obs.obs_datetime, '%Y%m%d') between date_format ( (adddate( STR_TO_DATE('20160901', '%Y%m%d'), interval - 6 week)),  '%Y%m%d') and date_format ( (adddate( STR_TO_DATE('20160930', '%Y%m%d'), interval - 6 week)),  '%Y%m%d')
-- and encounter.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
and encounter.location_id in (26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50) -- CHIMALTENANGO
UNION
SELECT 
count(*) CANT,
'CHIMAL' AGENCIA,
'EXAMEN_SENO_SEGUIMIENTO' INDICADOR
FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and encounter.form_id = 1
and exists (
SELECT 
obs.person_id
FROM obs obs_int, encounter
WHERE 
obs_int.encounter_id = encounter.encounter_id
and obs_int.concept_id = 159780
and obs_int.value_coded in (146931,148058,142248)
and obs_int.voided = 0 
and encounter.voided = 0
and obs.person_id = obs_int.person_id
and encounter.location_id in (26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50) -- CHIMALTENANGO
and date_format( obs_int.obs_datetime, '%Y%m%d') between date_format ( (adddate( STR_TO_DATE('20160901', '%Y%m%d'), interval - 6 week)),  '%Y%m%d') and date_format ( (adddate( STR_TO_DATE('20160930', '%Y%m%d'), interval - 6 week)),  '%Y%m%d')
and datediff(obs.obs_datetime, obs_int.obs_datetime) <= 42
)
UNION
SELECT 
count(*) CANT,
'SOLOLA' AGENCIA,
'EXAMEN_SENO_SEGUIMIENTO' INDICADOR
FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and encounter.form_id = 1
and exists (
SELECT 
obs.person_id
FROM obs obs_int, encounter
WHERE 
obs_int.encounter_id = encounter.encounter_id
and obs_int.concept_id = 159780
and obs_int.value_coded in (146931,148058,142248)
and obs_int.voided = 0 
and encounter.voided = 0
and obs.person_id = obs_int.person_id
and encounter.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
and date_format( obs_int.obs_datetime, '%Y%m%d') between date_format ( (adddate( STR_TO_DATE('20160901', '%Y%m%d'), interval - 6 week)),  '%Y%m%d') and date_format ( (adddate( STR_TO_DATE('20160930', '%Y%m%d'), interval - 6 week)),  '%Y%m%d')
and datediff(obs.obs_datetime, obs_int.obs_datetime) <= 42
)
; 


-- and encounter.location_id in (26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50) -- CHIMALTENANGO
-- and encounter.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
