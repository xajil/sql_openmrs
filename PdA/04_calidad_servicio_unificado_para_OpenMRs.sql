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
-- 1.2  @nefsacuj   20161108    validacion de nul en EIP con tratamiento chima y sololá.
##########################################################################
SELECT IFNULL(SUM(CANT),0) CANT, 'SOLOLA' AGENCIA,  'EIP_CON_TRATAMIENTO' INDICADOR FROM (
select  
COUNT( distinct orders.patient_id) CANT, 
'SOLOLA' AGENCIA, 
'EIP_CON_TRATAMIENTO' INDICADOR
from drug_order, drug, orders
where drug_order.drug_inventory_id = drug.drug_id
and drug_order.order_id = orders.order_id
and orders.discontinued = 1
and orders.concept_id IN( 73041, 79782, 75222) --  juntos siempre
and orders.start_date  between :startDate and :endDate
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
and obs.obs_datetime between :startDate and :endDate
)
group by orders.patient_id
having count(orders.concept_id) = 3
order by orders.patient_id) TMP_EIP_SOLOLA
UNION
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
and obs.obs_datetime between :startDate and :endDate
UNION 
SELECT IFNULL(SUM(CANT),0) CANT, 'CHIMAL' AGENCIA,  'EIP_CON_TRATAMIENTO' INDICADOR FROM (
select  
COUNT( distinct orders.patient_id) CANT, 
'CHIMAL' AGENCIA, 
'EIP_CON_TRATAMIENTO' INDICADOR
from drug_order, drug, orders
where drug_order.drug_inventory_id = drug.drug_id
and drug_order.order_id = orders.order_id
and orders.discontinued = 1
and orders.concept_id IN( 73041, 79782, 75222) 
and orders.start_date  between :startDate and :endDate
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
and obs.obs_datetime between :startDate and :endDate
)
group by orders.patient_id
having count(orders.concept_id) = 3
order by orders.patient_id) TMP_EIP_SOLOLA
UNION
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
and obs.obs_datetime between :startDate and :endDate
UNION
SELECT 
count(*) CANT, 
'SOLOLA' AGENCIA,
'PAP_HECHO' INDICADOR
FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.obs_datetime between  adddate(:startDate, interval - 42 day) and adddate(:endDate, interval - 42 day)
and obs.concept_id  IN ( 162972, 162978) 
and obs.value_coded = 1267
and obs.voided = 0 
and encounter.voided = 0
and encounter.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
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
and obs_int.obs_datetime between adddate(:startDate, interval - 42 day) and adddate(:endDate, interval - 42 day)
and obs_int.concept_id  IN ( 162972, 162978) 
and obs_int.value_coded = 1267
and obs_int.voided = 0 
and enc_int.voided = 0
and obs_int.person_id = obs.person_id
and encounter.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
and datediff(obs.obs_datetime, obs_int.obs_datetime) <= 42
) 
UNION
SELECT 
count(*) CANT, 
'CHIMAL' AGENCIA,
'PAP_HECHO' INDICADOR
FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.obs_datetime between adddate(:startDate, interval - 42 day) and adddate(:endDate, interval - 42 day)
and obs.concept_id  IN ( 162972, 162978) 
and obs.value_coded = 1267
and obs.voided = 0 
and encounter.voided = 0
and encounter.location_id in (26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50) -- CHIMALTENANGO
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
and obs_int.obs_datetime between adddate(:startDate, interval - 42 day) and adddate(:endDate, interval - 42 day)
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
and obs.obs_datetime between adddate(:startDate, interval - 6 week) and adddate(:endDate, interval - 6 week)
and encounter.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
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
and obs_int.obs_datetime between adddate(:startDate, interval - 6 week) and adddate(:endDate, interval - 6 week)
and datediff(obs.obs_datetime, obs_int.obs_datetime) <= 42
)
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
and obs.obs_datetime between adddate(:startDate, interval - 6 week) and adddate(:endDate, interval - 6 week)
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
and obs_int.obs_datetime between adddate(:startDate, interval - 6 week) and adddate(:endDate, interval - 6 week)
and datediff(obs.obs_datetime, obs_int.obs_datetime) <= 42
)
UNION
select COUNT(person_id) CANT ,
'SOLOLA' AGENCIA,
'GLUCOSA ELEVADA' INDICADOR
FROM (
SELECT 
PERSON_ID FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.concept_id = 160912 -- GLUCOSA EN AYUNAS 
and encounter.encounter_type = 1
and obs.voided = 0 
and encounter.voided = 0
and obs.obs_datetime between adddate(:startDate, interval - 6 week) and adddate(:endDate, interval - 6 week)
and obs.value_numeric > 126
and encounter.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
union 
SELECT 
PERSON_ID 	
FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and encounter.encounter_type = 1
and obs.concept_id = 887 -- GLUCOSA azar
and obs.voided = 0 
and encounter.voided = 0
and obs.obs_datetime between adddate(:startDate, interval - 6 week) and adddate(:endDate, interval - 6 week)
and obs.value_numeric > 200
and encounter.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
group by encounter.encounter_type, obs.person_id
) AS GLUCOSA_ELEVADA_SOLOLA
UNION
select 
count(*) CANT,
'SOLOLA' AGENCIA,
'SEGUIMIENTO GLUCOSA_ELEVADA' INDICADOR
from obs obs_ext, encounter
wHERE 
obs_ext.encounter_id = encounter.encounter_id
and encounter.form_id = 2
and obs_ext.concept_id in (160912, 887)
and obs_ext.voided = 0 
and encounter.voided = 0
and exists (
	select * from 
    ( SELECT 
	obs.value_numeric valor_glucosa, obs_datetime, PERSON_ID 			
	FROM obs, encounter
		WHERE 
		obs.encounter_id = encounter.encounter_id
		and obs.concept_id = 160912 -- GLUCOSA EN AYUNAS 
		and encounter.encounter_type = 1
		and obs.voided = 0 
		and encounter.voided = 0		
		and obs.obs_datetime between adddate(:startDate, interval - 6 week) and adddate(:endDate, interval - 6 week)
		and obs.value_numeric > 126
        and encounter.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
		union 
		SELECT 
        obs.value_numeric valor_glucosa, obs_datetime, PERSON_ID
		FROM obs, encounter
		WHERE 
		obs.encounter_id = encounter.encounter_id
		and encounter.encounter_type = 1
		and obs.concept_id = 887 -- GLUCOSA azar
		and obs.voided = 0 
		and encounter.voided = 0		
		and obs.obs_datetime between adddate(:startDate, interval - 6 week) and adddate( :endDate, interval - 6 week)
		and obs.value_numeric > 200
        and encounter.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
		group by encounter.encounter_type , obs.concept_id, obs.person_id
        ) obs_int
        where obs_ext.person_id = obs_int.person_id
        and obs_ext.obs_datetime > obs_int.obs_datetime
        and datediff( obs_ext.obs_datetime , obs_int.obs_datetime ) <= 42
        )
UNION
select COUNT(person_id) CANT ,
'CHIMAL' AGENCIA,
'GLUCOSA ELEVADA' INDICADOR
FROM (
SELECT 
PERSON_ID FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.concept_id = 160912 
and encounter.encounter_type = 1
and obs.voided = 0 
and encounter.voided = 0
and obs.obs_datetime between adddate( :startDate, interval - 6 week) and adddate(:endDate, interval - 6 week)
and obs.value_numeric > 126
and encounter.location_id in (26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50) -- CHIMALTENANGO
union 
SELECT 
PERSON_ID 	
FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and encounter.encounter_type = 1
and obs.concept_id = 887 -- GLUCOSA azar
and obs.voided = 0 
and encounter.voided = 0
and obs.obs_datetime between adddate(:startDate, interval - 6 week) and adddate(:endDate, interval - 6 week)
and obs.value_numeric > 200
and encounter.location_id in (26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50) -- CHIMALTENANGO
group by encounter.encounter_type, obs.person_id
) AS GLUCOSA_ELEVADA_CHIMAL
UNION
select 
count(*) CANT,
'CHIMAL' AGENCIA,
'SEGUIMIENTO GLUCOSA_ELEVADA' INDICADOR
from obs obs_ext, encounter
wHERE 
obs_ext.encounter_id = encounter.encounter_id
and encounter.form_id = 2
and obs_ext.concept_id in (160912, 887)
and obs_ext.voided = 0 
and encounter.voided = 0
and exists (
	select * from 
    ( SELECT 
	obs.value_numeric valor_glucosa, obs_datetime, PERSON_ID 			
	FROM obs, encounter
		WHERE 
		obs.encounter_id = encounter.encounter_id
		and obs.concept_id = 160912 -- GLUCOSA EN AYUNAS 
		and encounter.encounter_type = 1
		and obs.voided = 0 
		and encounter.voided = 0		
		and obs.obs_datetime between adddate(:startDate, interval - 6 week) and adddate(:endDate, interval - 6 week)
		and obs.value_numeric > 126
        and encounter.location_id in (26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50) -- CHIMALTENANGO
		union 
		SELECT 
        obs.value_numeric valor_glucosa, obs_datetime, PERSON_ID
		FROM obs, encounter
		WHERE 
		obs.encounter_id = encounter.encounter_id
		and encounter.encounter_type = 1
		and obs.concept_id = 887 -- GLUCOSA azar
		and obs.voided = 0 
		and encounter.voided = 0		
		and obs.obs_datetime between adddate(:startDate, interval - 6 week) and adddate(:endDate, interval - 6 week)
		and obs.value_numeric > 200
        and encounter.location_id in (26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50) -- CHIMALTENANGO
		group by encounter.encounter_type , obs.concept_id, obs.person_id
        ) obs_int
        where obs_ext.person_id = obs_int.person_id
        and obs_ext.obs_datetime > obs_int.obs_datetime
        and datediff( obs_ext.obs_datetime , obs_int.obs_datetime ) <= 42
        )
UNION
SELECT 
COUNT(*) CANT,
'SOLOLA' AGENCIA,
'MUJERES FERTILES' INDICADOR
FROM obs, encounter, person
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.person_id = person.person_id
and obs.concept_id = 160653
and obs.value_coded in (160652, 162986) 
and encounter.encounter_type = 1
and encounter.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
and obs.voided = 0
and encounter.voided = 0
and obs.obs_datetime between :startDate and :endDate
and person.dead = 0 
and person.voided = 0
and (YEAR(:endDate) - YEAR(birthdate) - (DATE_FORMAT(:endDate, '%m%d') < DATE_FORMAT(birthdate, '%m%d'))) between 18 and 50
UNION
select  
COUNT(distinct orders.patient_id) CANT,
'SOLOLA' AGENCIA,
'MUJERES FERTILES CON PF' INDICADOR
from drug_order, drug, orders
where drug_order.drug_inventory_id = drug.drug_id
and drug_order.order_id = orders.order_id
and orders.discontinued <> 1
and orders.concept_id IN ( 1873, 907, 104625)
and orders.patient_id in (
SELECT 
person.person_id
FROM obs, encounter, person
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.person_id = person.person_id
and obs.concept_id = 160653
and obs.value_coded in (160652, 162986) 
and encounter.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
and encounter.encounter_type = 1
and obs.voided = 0
and encounter.voided = 0
and obs.obs_datetime between :startDate and :endDate
and person.dead = 0 
and person.voided = 0
and (YEAR(:endDate) - YEAR(birthdate) - (DATE_FORMAT(:endDate, '%m%d') < DATE_FORMAT(birthdate, '%m%d'))) between 18 and 50
)
UNION
SELECT 
COUNT(*) CANT,
'CHIMAL' AGENCIA,
'MUJERES FERTILES' INDICADOR
FROM obs, encounter, person
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.person_id = person.person_id
and obs.concept_id = 160653
and obs.value_coded in (160652, 162986) 
and encounter.encounter_type = 1
and encounter.location_id in (26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50) -- CHIMALTENANGO
and obs.voided = 0
and encounter.voided = 0
and obs.obs_datetime between :startDate and :endDate
and person.dead = 0 
and person.voided = 0
and (YEAR(:endDate) - YEAR(birthdate) - (DATE_FORMAT(:endDate, '%m%d') < DATE_FORMAT(birthdate, '%m%d'))) between 18 and 50
UNION
select  
COUNT(distinct orders.patient_id) CANT,
'CHIMAL' AGENCIA,
'MUJERES FERTILES CON PF' INDICADOR
from drug_order, drug, orders
where drug_order.drug_inventory_id = drug.drug_id
and drug_order.order_id = orders.order_id
and orders.discontinued <> 1
and orders.concept_id IN ( 1873, 907, 104625)
and orders.patient_id in (
SELECT 
person.person_id
FROM obs, encounter, person
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.person_id = person.person_id
and obs.concept_id = 160653
and obs.value_coded in (160652, 162986) 
and encounter.location_id in (26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50) -- CHIMALTENANGO
and encounter.encounter_type = 1
and obs.voided = 0
and encounter.voided = 0
and obs.obs_datetime between :startDate and :endDate
and person.dead = 0 
and person.voided = 0
and (YEAR(:endDate) - YEAR(birthdate) - (DATE_FORMAT(:endDate, '%m%d') < DATE_FORMAT(birthdate, '%m%d'))) between 18 and 50
)
UNION
SELECT COUNT(*) CANT,
'SOLOLA' AGENCIA,
'PAP ANORMAL' INDICADOR
FROM obs, encounter
where 
obs.encounter_id = encounter.encounter_id
and concept_id = 885
and value_coded = 162974
and obs.voided = 0
and encounter.voided = 0
and encounter.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
and obs.obs_datetime between adddate(:startDate, interval - 7 month) and adddate(:endDate, interval - 7 month)
UNION
SELECT 
count(*) CANT, 
'SOLOLA' AGENCIA,
'PAP ANORMAL SEGUIMIENTO' INDICADOR
FROM obs, encounter
where 
obs.encounter_id = encounter.encounter_id
and concept_id = 162978
and value_coded = 1267
and obs.voided = 0
and exists (
SELECT obs_int.person_id FROM obs obs_int, encounter
where 
obs_int.encounter_id = encounter.encounter_id
and obs_int.concept_id = 885
and obs_int.value_coded = 162974
and obs_int.voided = 0
and encounter.voided = 0
and encounter.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
and obs_int.obs_datetime between adddate(:startDate, interval - 7 month) and adddate(:endDate, interval - 7 month)
and obs_int.person_id = obs.person_id
and obs.obs_datetime >= obs_int.obs_datetime
)
UNION
SELECT COUNT(*) CANT,
'CHIMAL' AGENCIA,
'PAP ANORMAL' INDICADOR
FROM obs, encounter
where 
obs.encounter_id = encounter.encounter_id
and concept_id = 885
and value_coded = 162974
and obs.voided = 0
and encounter.voided = 0
and encounter.location_id in (26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50) -- CHIMALTENANGO
and obs.obs_datetime between adddate( :startDate, interval - 7 month) and adddate(:endDate, interval - 7 month)
UNION
SELECT 
count(*) CANT, 
'CHIMAL' AGENCIA,
'PAP ANORMAL SEGUIMIENTO' INDICADOR
FROM obs, encounter
where 
obs.encounter_id = encounter.encounter_id
and concept_id = 162978
and value_coded = 1267
and obs.voided = 0
and exists (
SELECT obs_int.person_id FROM obs obs_int, encounter
where 
obs_int.encounter_id = encounter.encounter_id
and obs_int.concept_id = 885
and obs_int.value_coded = 162974
and obs_int.voided = 0
and encounter.voided = 0
and encounter.location_id in (26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50) -- CHIMALTENANGO
and obs_int.obs_datetime between adddate(:startDate, interval - 7 month) and adddate(:endDate, interval - 7 month)
and obs_int.person_id = obs.person_id
and obs.obs_datetime >= obs_int.obs_datetime
)
UNION
select 
count(*) CANT,
'SOLOLA' AGENCIA,
'HYPERTENSIVES' INDICADOR
 from patient_identifier, patient, patient_program
where patient_identifier.patient_id = patient.patient_id
and patient.patient_id = patient_program.patient_id
and patient_program.program_id = 2
and patient_identifier.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
and date_completed is null
and patient_program.voided = 0
and patient_identifier.voided = 0
UNION
select 
count(*) CANT,
'CHIMAL' AGENCIA,
'HYPERTENSIVES' INDICADOR
 from patient_identifier, patient, patient_program
where patient_identifier.patient_id = patient.patient_id
and patient.patient_id = patient_program.patient_id
and patient_program.program_id = 2
and patient_identifier.location_id in (26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50) -- CHIMALTENANGO
and date_completed is null
and patient_program.voided = 0
and patient_identifier.voided = 0
UNION
select 
count(*) CANT,
'SOLOLA' AGENCIA,
'HIPERTENSA CON TRATAMIENTO' INDICADOR
 from patient_identifier, patient, patient_program
where patient_identifier.patient_id = patient.patient_id
and patient.patient_id = patient_program.patient_id
and patient_program.program_id = 14
and patient_identifier.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
and date_completed is null
and patient_program.voided = 0
and patient_identifier.voided = 0
UNION
select 
count(*) CANT,
'CHIMAL' AGENCIA,
'HIPERTENSA CON TRATAMIENTO' INDICADOR
 from patient_identifier, patient, patient_program
where patient_identifier.patient_id = patient.patient_id
and patient.patient_id = patient_program.patient_id
and patient_program.program_id = 14
and patient_identifier.location_id in (26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50) -- CHIMALTENANGO
and date_completed is null
and patient_program.voided = 0
and patient_identifier.voided = 0
UNION
SELECT 
COUNT(*) CANT,
'SOLOLA' AGENCIA,
'MUJERES QUE EMPEZARON PF' INDICADOR
FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.concept_id = 162971
and obs.voided = 0
and encounter.voided = 0
and obs.value_coded in (1873, 907, 104625) 
and encounter.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
and obs.obs_datetime between adddate( :startDate, interval - 1 year) and adddate(:endDate, interval - 1 year)
UNION
SELECT 
COUNT(*) CANT,
'CHIMAL' AGENCIA,
'MUJERES QUE EMPEZARON PF' INDICADOR
FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.concept_id = 162971
and obs.voided = 0
and encounter.voided = 0
and obs.value_coded in (1873, 907, 104625) 
and encounter.location_id in (26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50) -- CHIMALTENANGO
and obs.obs_datetime between adddate(:startDate, interval - 1 year) and adddate(:endDate, interval - 1 year)
UNION
select  
COUNT(distinct orders.patient_id) CANT,
'SOLOLA' AGENCIA,
'MUJERES CON SEGUIMIENTO PF' INDICADOR
from drug_order, drug, orders
where drug_order.drug_inventory_id = drug.drug_id
and drug_order.order_id = orders.order_id
and orders.discontinued <> 1
and orders.concept_id IN ( 1873, 907, 104625)
and orders.patient_id in (
SELECT 
obs.person_id
FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.concept_id = 162971
and obs.value_coded in (1873, 907, 104625) 
and encounter.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
and obs.obs_datetime between adddate(:startDate, interval - 1 year) and adddate(:endDate, interval - 1 year)
)
UNION
select  
COUNT(distinct orders.patient_id) CANT,
'CHIMAL' AGENCIA,
'MUJERES CON SEGUIMIENTO PF' INDICADOR
from drug_order, drug, orders
where drug_order.drug_inventory_id = drug.drug_id
and drug_order.order_id = orders.order_id
and orders.discontinued <> 1
and orders.concept_id IN ( 1873, 907, 104625)
and orders.patient_id in (
SELECT 
obs.person_id
FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.concept_id = 162971
and obs.value_coded in (1873, 907, 104625) 
and encounter.location_id in (26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50) -- CHIMALTENANGO
and obs.obs_datetime between adddate(:startDate, interval - 1 year) and adddate(:endDate, interval - 1 year)
)
UNION
SELECT 
count(*) CANT,
'SOLOLA' AGENCIA,
'PRESION ELEVADA CON SEGUIMIENTO' INDICADOR
FROM obs, encounter
	WHERE 
	obs.encounter_id = encounter.encounter_id
    and encounter.form_id = 2
    and concept_id in (5085,5086 )
	and obs.person_id in ( 
			select distinct person_id
			from (
			SELECT 
			max(obs.value_numeric),  
			obs.person_id
			FROM obs, encounter
			WHERE 
			obs.encounter_id = encounter.encounter_id
			and obs.concept_id =  5085 -- sistolica
			and obs.value_numeric >= 140
            and encounter.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
			and encounter.encounter_type = 1
			and obs.voided = 0 
			and encounter.voided = 0
			and obs.obs_datetime between adddate(:startDate, interval - 6 week) and adddate(:endDate, interval - 6 week)
			union    
			SELECT 
			max(obs.value_numeric),  	
			obs.person_id
			FROM obs, encounter
			WHERE 
			obs.encounter_id = encounter.encounter_id
			and obs.concept_id =  5086 -- diastolica
			and obs.value_numeric >= 90
            and encounter.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
			and encounter.encounter_type = 1
			and obs.voided = 0 
			and encounter.voided = 0
			and obs.obs_datetime between adddate(:startDate, interval - 6 week) and adddate(:endDate, interval - 6 week)
			group by obs.person_id 
			) presion_elevada
)
union
select count(distinct person_id) CANT,
'SOLOLA' AGENCIA,
'PRESION ELEVADA' INDICADOR
from (
SELECT 
	max(obs.value_numeric),  	
	obs.person_id
	FROM obs, encounter
	WHERE 
	obs.encounter_id = encounter.encounter_id
	and obs.concept_id =  5085 
	and obs.value_numeric >= 140
    and encounter.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
    and encounter.encounter_type = 1
	and obs.voided = 0 
	and encounter.voided = 0
	and obs.obs_datetime between adddate(:startDate, interval - 6 week) and adddate(:endDate, interval - 6 week )
    union    
SELECT 
max(obs.value_numeric), 
obs.person_id
FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.concept_id =  5086 -- diastolica
and obs.value_numeric >= 90
and encounter.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
and encounter.encounter_type = 1
and obs.voided = 0 
and encounter.voided = 0
and obs.obs_datetime between adddate(:startDate, interval - 6 week) and adddate(:endDate, interval - 6 week)
group by obs.person_id 
) presion_elevada
UNION
SELECT 
count(*) CANT,
'CHIMAL' AGENCIA,
'PRESION ELEVADA CON SEGUIMIENTO' INDICADOR
FROM obs, encounter
	WHERE 
	obs.encounter_id = encounter.encounter_id
    and encounter.form_id = 2
    and concept_id in (5085,5086 )
	and obs.person_id in ( 
			select distinct person_id
			from (
			SELECT 
			max(obs.value_numeric),
			obs.person_id
			FROM obs, encounter
			WHERE 
			obs.encounter_id = encounter.encounter_id
			and obs.concept_id =  5085 
			and obs.value_numeric >= 140
            and encounter.location_id in (26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50) -- CHIMALTENANGO
			and encounter.encounter_type = 1
			and obs.voided = 0 
			and encounter.voided = 0
			and obs.obs_datetime between adddate(:startDate, interval - 6 week) and adddate(:endDate, interval - 6 week )
			union    
			SELECT 
			max(obs.value_numeric),
			obs.person_id
			FROM obs, encounter
			WHERE 
			obs.encounter_id = encounter.encounter_id
			and obs.concept_id =  5086 -- diastolica
			and obs.value_numeric >= 90
            and encounter.location_id in (26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50) -- CHIMALTENANGO
			and encounter.encounter_type = 1
			and obs.voided = 0 
			and encounter.voided = 0
			and obs.obs_datetime between adddate(:startDate, interval - 6 week) and adddate(:endDate, interval - 6 week)
			group by obs.person_id
			) presion_elevada
)
union
select count(distinct person_id) CANT,
'CHIMAL' AGENCIA,
'PRESION ELEVADA' INDICADOR
from (
SELECT 
	max(obs.value_numeric),
	obs.person_id
	FROM obs, encounter
	WHERE 
	obs.encounter_id = encounter.encounter_id
	and obs.concept_id =  5085 -- sistolica
	and obs.value_numeric >= 140
    and encounter.location_id in (26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50) -- CHIMALTENANGO
    and encounter.encounter_type = 1
	and obs.voided = 0 
	and encounter.voided = 0
	and obs.obs_datetime between adddate(:startDate, interval - 6 week) and adddate(:endDate, interval - 6 week)
    union    
SELECT 
max(obs.value_numeric),
obs.person_id
FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.concept_id =  5086 -- diastolica
and obs.value_numeric >= 90
and encounter.location_id in (26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50) -- CHIMALTENANGO
and encounter.encounter_type = 1
and obs.voided = 0 
and encounter.voided = 0
and obs.obs_datetime between adddate(:startDate, interval - 6 week) and adddate(:endDate, interval - 6 week)
group by obs.person_id) 
presion_elevada;
