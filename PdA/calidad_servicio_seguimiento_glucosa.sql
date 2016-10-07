select 
obs_ext.* 
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
		and date_format( obs.obs_datetime, '%Y%m%d') between date_format ( (adddate( STR_TO_DATE('20160901', '%Y%m%d'), interval - 6 week)),  '%Y%m%d') and date_format ( (adddate( STR_TO_DATE('20160930', '%Y%m%d'), interval - 6 week )),  '%Y%m%d')
		and obs.value_numeric > 126
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
		and date_format( obs.obs_datetime, '%Y%m%d') between date_format ( (adddate( STR_TO_DATE('20160901', '%Y%m%d'), interval - 6 week)),  '%Y%m%d') and date_format ( (adddate( STR_TO_DATE('20160930', '%Y%m%d'), interval - 6 week)),  '%Y%m%d')
		and obs.value_numeric > 200
		group by encounter.encounter_type , obs.concept_id, obs.person_id
        ) obs_int
        where obs_ext.person_id = obs_int.person_id
        and obs_ext.obs_datetime > obs_int.obs_datetime
        and datediff( obs_ext.obs_datetime , obs_int.obs_datetime ) <= 42
        );
        

-- NUMERADOR
SELECT 
PERSON_ID 	-- encounter.encounter_type ,
FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.concept_id = 160912 -- GLUCOSA EN AYUNAS 
and encounter.encounter_type = 1
and obs.voided = 0 
and encounter.voided = 0
and date_format( obs.obs_datetime, '%Y%m%d') between date_format ( (adddate( STR_TO_DATE('20160901', '%Y%m%d'), interval - 6 week)),  '%Y%m%d') and date_format ( (adddate( STR_TO_DATE('20160930', '%Y%m%d'), interval - 6 week )),  '%Y%m%d')
and obs.value_numeric > 126
union 
SELECT 
PERSON_ID 	-- encounter.encounter_type ,
FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and encounter.encounter_type = 1
and obs.concept_id = 887 -- GLUCOSA azar
and obs.voided = 0 
and encounter.voided = 0
and date_format( obs.obs_datetime, '%Y%m%d') between date_format ( (adddate( STR_TO_DATE('20160901', '%Y%m%d'), interval - 6 week)),  '%Y%m%d') and date_format ( (adddate( STR_TO_DATE('20160930', '%Y%m%d'), interval - 6 week)),  '%Y%m%d')
and obs.value_numeric > 200
group by encounter.encounter_type, -- obs.concept_id,
 obs.person_id;    
