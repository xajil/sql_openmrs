-- NUMERADOR
SELECT 
*
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
and date_format( obs_int.obs_datetime, '%Y%m%d') between date_format ( (adddate( STR_TO_DATE('20161201', '%Y%m%d'), interval - 6 week)),  '%Y%m%d') and date_format ( (adddate( STR_TO_DATE('20161230', '%Y%m%d'), interval - 6 week)),  '%Y%m%d')
and datediff(obs.obs_datetime, obs_int.obs_datetime) <= 42
)
;    

-- DENOMINADOR
SELECT 
* 
FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.concept_id = 159780
and obs.value_coded in (146931,148058,142248)
and obs.voided = 0 
and encounter.voided = 0
and date_format( obs.obs_datetime, '%Y%m%d') between date_format ( (adddate( STR_TO_DATE('20161201', '%Y%m%d'), interval - 6 week)),  '%Y%m%d') and date_format ( (adddate( STR_TO_DATE('20161230', '%Y%m%d'), interval - 6 week)),  '%Y%m%d')
;    
