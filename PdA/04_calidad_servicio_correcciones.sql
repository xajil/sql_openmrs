SELECT 
count(*) CANT, 
'SOLOLA' AGENCIA,
'EXAMEN_DE_SENO' INDICADOR
FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.concept_id = 159780
and obs.value_coded in (146931,148058,142248) -- 
and obs.voided = 0 
and encounter.voided = 0
and date_format( obs.obs_datetime, '%Y%m%d') between date_format ( (adddate( STR_TO_DATE('20161001', '%Y%m%d'), interval - 6 week)),  '%Y%m%d') and date_format ( (adddate( STR_TO_DATE('20161031', '%Y%m%d'), interval - 6 week)),  '%Y%m%d')
and encounter.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
UNION
SELECT 
count(distinct(encounter.encounter_id) )CANT,
'SOLOLA' AGENCIA,
'EXAMEN_SENO_SEGUIMIENTO' INDICADOR
FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and encounter.form_id = 1
and exists (
SELECT 
obs_int.person_id
FROM obs obs_int, encounter
WHERE 
obs_int.encounter_id = encounter.encounter_id
and obs_int.concept_id = 159780
and obs_int.value_coded in (146931,148058,142248)
and obs_int.voided = 0 
and encounter.voided = 0
and obs.person_id = obs_int.person_id
and encounter.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
and date_format( obs_int.obs_datetime, '%Y%m%d') between date_format ( (adddate( STR_TO_DATE('20161001', '%Y%m%d'), interval - 6 week)),  '%Y%m%d') and date_format ( (adddate( STR_TO_DATE('20161031', '%Y%m%d'), interval - 6 week)),  '%Y%m%d')
and datediff(obs_int.obs_datetime, obs.obs_datetime) <= 42
);



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
and date_format( obs.obs_datetime, '%Y%m%d') between date_format ( (adddate( STR_TO_DATE('20161001', '%Y%m%d'), interval - 6 week)),  '%Y%m%d') and date_format ( (adddate( STR_TO_DATE('20161031', '%Y%m%d'), interval - 6 week)),  '%Y%m%d')
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
and date_format( obs_int.obs_datetime, '%Y%m%d') between date_format ( (adddate( STR_TO_DATE('20161001', '%Y%m%d'), interval - 6 week)),  '%Y%m%d') and date_format ( (adddate( STR_TO_DATE('20161031', '%Y%m%d'), interval - 6 week)),  '%Y%m%d')
and datediff(obs.obs_datetime, obs_int.obs_datetime) <= 42
);