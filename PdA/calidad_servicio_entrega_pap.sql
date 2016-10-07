-- DENOMINADORR
select 
obs.* 
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
and datediff(obs.obs_datetime, obs_int.obs_datetime) <= 42
) 
;

-- NUMERADOR
SELECT 
date_format( obs.obs_datetime, '%Y%m%d') obs_datetime_formated,
obs.* FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and date_format( obs.obs_datetime, '%Y%m%d') between date_format ( (adddate( STR_TO_DATE('20160901', '%Y%m%d'), interval - 42 day)),  '%Y%m%d') and date_format ( (adddate( STR_TO_DATE('20160930', '%Y%m%d'), interval - 42 day)),  '%Y%m%d')
and obs.concept_id  IN ( 162972, 162978) 
and obs.value_coded = 1267
and obs.voided = 0 
and encounter.voided = 0
;


/*************************************************************************************************************/
select 
datediff(obs.obs_datetime, tmp_obs_pap.obs_datetime ), 
date_format( tmp_obs_pap.obs_datetime, '%Y%m%d') fecha_hecho,
date_format( obs.obs_datetime, '%Y%m%d') fecha_engrega,
obs.* 
from obs, encounter, tmp_obs_pap
wHERE 
obs.encounter_id = encounter.encounter_id
and tmp_obs_pap.person_id = obs.person_id
-- and tmp_obs_pap.encounter_id = obs.encounter_id
and obs.concept_id  = 163137 
and obs.voided = 0 
and encounter.voided = 0
and datediff(obs.obs_datetime, tmp_obs_pap.obs_datetime ) <= 42
/*and exists (
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
and datediff(obs.obs_datetime, obs_int.obs_datetime) <= 42
) 
*/;


select * from tmp_obs_pap;


create table tmp_obs_pap as
SELECT 
-- obs.obs_datetime,
date_format( obs.obs_datetime, '%Y%m%d') obs_datetime_formated,
obs.* FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and date_format( obs.obs_datetime, '%Y%m%d') between date_format ( (adddate( STR_TO_DATE('20160901', '%Y%m%d'), interval - 42 day)),  '%Y%m%d') and date_format ( (adddate( STR_TO_DATE('20160930', '%Y%m%d'), interval - 42 day)),  '%Y%m%d')
and obs.concept_id  IN ( 162972, 162978) 
and obs.value_coded = 1267
and obs.voided = 0 
and encounter.voided = 0
group by obs.value_coded, encounter.encounter_type, obs.concept_id, obs.person_id;





select adddate( STR_TO_DATE('09/30/2016', '%m/%d/%Y'), interval - 42 day);
-- '2016-08-19'

select adddate( STR_TO_DATE('09/01/2016', '%m/%d/%Y'), interval - 42 day);
-- 2016-07-21


select adddate( STR_TO_DATE('10/31/2016', '%m/%d/%Y'), interval - 42 day);
-- 2016-09-19

select adddate( STR_TO_DATE('10/01/2016', '%m/%d/%Y'), interval - 42 day);
-- '2016-08-20'



