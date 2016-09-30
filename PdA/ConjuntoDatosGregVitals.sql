-- REPORTE DE VITALS --
select 
obs.person_id, patient_identifier.identifier client_code, 
concept_id vitals_id,
case
when (concept_id = 5085 )then 'Systolic'
when (concept_id = 5086 )then 'Diastolic'
when (concept_id = 5090 )then 'height'
when (concept_id = 5089 )then 'weight'
else 'NA'
end vitals_name,
obs.value_numeric vitals_value, 
date_format(obs.obs_datetime,'%Y%m%d') vitals_date ,
date_format(obs.date_created,'%Y%m%d') record_date
from encounter, obs, patient_identifier 
where
encounter.encounter_id = obs.encounter_id
and obs.person_id = patient_identifier.patient_id
and date_format(encounter.encounter_datetime, '%Y%m%d')  between '20160801' and '20160831'
and concept_id in (5085,5086, 5090, 5089)
order by obs.person_id
;


-- DIAGNOSIS --
-- agregar diagnósticos de regímenes 
-- CANDIDIASIS VAGINAL
-- VAGINOSIS BACTIRANA
-- INFLAMACION SEVERA
-- EIP
select 
patient_identifier.patient_id,
patient_identifier.identifier client_code,
program.program_id diagnostic_code,
program.name diagnostic_name,
date_format(patient_program.date_enrolled,'%Y%m%d') enrolled_date
from  patient_identifier , patient_program, program
where
patient_identifier.patient_id = patient_program.patient_id
and patient_program.program_id = program.program_id
and date_format(patient_program.date_enrolled, '%Y%m%d')  between '20160801' and '20160831'
and program.program_id in (2,7,8,9,13,15,16)
order by patient_program.patient_id
;

-- INTERVENCIÓN --
select 
obs.person_id, 
patient_identifier.identifier client_code, 
concept_id procedure_code,
case
when (concept_id = 162990 )then 'examen de seno '
when (concept_id = 162972 )then 'pap'
when (concept_id = 162978 )then 'pap repetido'
when (concept_id = 162991 )then 'examen pélvico'
else 'NA'
end procedure_name,
date_format(obs.obs_datetime, '%Y%m%d') procedure_date, 
date_format(obs.date_created,'%Y%m%d')  record_date
from encounter, obs, patient_identifier 
where
encounter.encounter_id = obs.encounter_id
and obs.person_id = patient_identifier.patient_id
and date_format(encounter.encounter_datetime, '%Y%m%d')  between '20160801' and '20160831'
and concept_id in (
162990, -- examen de seno 
162972,  -- pap
162978,  -- papa repetido
162991 -- examen pélvico
)
and value_coded = 1267 
order by obs.person_id
;

-- ORDENES DE TRATAMIENTO --


-- laboratorio -- 
select 
obs.person_id, patient_identifier.identifier client_code, 
concept_id labs_id,
case
when (concept_id = 160912 )then 'Gucosa AYUNAS'
when (concept_id = 887 )then 'Glucosa_azar'
when (concept_id = 45 )then 'Prueba de embarazo'
when (concept_id = 885 )then 'Resultados Pap'
when (concept_id = 1040 )then 'Resultados VIH'
when (concept_id = 1619 )then 'Resultados sífilis'
when (concept_id = 1322 )then 'Resultados Hepatitis'
end labs_name,
case
when (obs.value_coded is null) then obs.value_numeric
when (obs.value_numeric is null) then obs.value_coded
else 0
end value_result,
-- obs.value_coded lab_value_a, 
-- obs.value_numeric labs_value_b, 
date_format(obs.obs_datetime,'%Y%m%d') lab_date ,
date_format(obs.date_created,'%Y%m%d') record_date
from encounter, obs, patient_identifier-- , concept 
where
encounter.encounter_id = obs.encounter_id
and obs.person_id = patient_identifier.patient_id
and date_format(encounter.encounter_datetime, '%Y%m%d')  between '20160801' and '20160831'
and concept_id in (
160912, -- glucosa ayunas
887, -- glucosa al azar 
45,  -- prueba de embarazo  
-- 162992, -- pruebas ets
885,  -- resultados pap, 
1040, -- vih
1619, -- sífilis 
1322 -- hepatitis
)
-- and value_coded in( 163096, 162975, 162976, 162977 )
-- and value_coded = 1267
order by obs.person_id
;

select * from concept;

select * from concept_name
where concept_id in (
160912, -- glucosa ayunas
887, -- glucosa al azar 
45,  -- prueba de embarazo  
-- 162992, -- pruebas ets
885,  -- resultados pap, 
1040, -- vih
1619, -- sífilis 
1322 -- hepatitis
)
and locale = 'en'
and voided = 0;

select * from concept_name
where concept_id in(
select 
distinct(value_numeric)
from encounter, obs, patient_identifier-- , concept 
where
encounter.encounter_id = obs.encounter_id
and obs.person_id = patient_identifier.patient_id
and date_format(encounter.encounter_datetime, '%Y%m%d')  between '20160801' and '20160831'
and concept_id in (
160912, -- glucosa ayunas
887, -- glucosa al azar 
45,  -- prueba de embarazo  
-- 162992, -- pruebas ets
885,  -- resultados pap, 
1040, -- vih
1619, -- sífilis 
1322 -- hepatitis
)
order by obs.person_id
)
and locale = 'en'
;

/*
664	NEGATIVE
703	POSITIVE
1067	Unknown
1115	Normal
1118	NOT DONE
703	(+)
664	(-)
703	+
664	-
664	NEG
703	POS
159261	vaginal atrophy
162973	Moderate Inflammation
162974	Severe Inflammation
163096	CIS NOS
163096	Carcinoma in Situ-not specified
163101	Slight inflammation

*/

