-- NUMERADOR
SELECT * FROM obs, encounter
	WHERE 
	obs.encounter_id = encounter.encounter_id
    and encounter.form_id = 2
    and concept_id in (5085,5086 )
	and obs.person_id in ( 
			select distinct person_id
			from (
			SELECT 
			max(obs.value_numeric),  	-- encounter.encounter_type ,
			obs.person_id
			FROM obs, encounter
			WHERE 
			obs.encounter_id = encounter.encounter_id
			and obs.concept_id =  5085 -- sistolica
			and obs.value_numeric >= 140
			and encounter.encounter_type = 1
			and obs.voided = 0 
			and encounter.voided = 0
			and date_format( obs.obs_datetime, '%Y%m%d') between date_format ( (adddate( STR_TO_DATE('20160901', '%Y%m%d'), interval - 6 week)),  '%Y%m%d') and date_format ( (adddate( STR_TO_DATE('20160930', '%Y%m%d'), interval - 6 week )),  '%Y%m%d')
			union    
			SELECT 
			max(obs.value_numeric),  	-- encounter.encounter_type ,
			obs.person_id
			FROM obs, encounter
			WHERE 
			obs.encounter_id = encounter.encounter_id
			and obs.concept_id =  5086 -- diastolica
			and obs.value_numeric >= 90
			and encounter.encounter_type = 1
			and obs.voided = 0 
			and encounter.voided = 0
			and date_format( obs.obs_datetime, '%Y%m%d') between date_format ( (adddate( STR_TO_DATE('20160901', '%Y%m%d'), interval - 6 week)),  '%Y%m%d') and date_format ( (adddate( STR_TO_DATE('20160930', '%Y%m%d'), interval - 6 week )),  '%Y%m%d')
			group by obs.person_id -- ;     --  obs.concept_id, encounter.encounter_type,
			) presion_elevada
);

-- DENOMINADOR
select distinct person_id
from (
SELECT 
	max(obs.value_numeric),  	-- encounter.encounter_type ,
	obs.person_id
	FROM obs, encounter
	WHERE 
	obs.encounter_id = encounter.encounter_id
	and obs.concept_id =  5085 -- sistolica
	and obs.value_numeric >= 140
    and encounter.encounter_type = 1
	and obs.voided = 0 
	and encounter.voided = 0
	and date_format( obs.obs_datetime, '%Y%m%d') between date_format ( (adddate( STR_TO_DATE('20160901', '%Y%m%d'), interval - 6 week)),  '%Y%m%d') and date_format ( (adddate( STR_TO_DATE('20160930', '%Y%m%d'), interval - 6 week )),  '%Y%m%d')
    union    
SELECT 
max(obs.value_numeric),  	-- encounter.encounter_type ,
obs.person_id
FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.concept_id =  5086 -- diastolica
and obs.value_numeric >= 90
and encounter.encounter_type = 1
and obs.voided = 0 
and encounter.voided = 0
and date_format( obs.obs_datetime, '%Y%m%d') between date_format ( (adddate( STR_TO_DATE('20160901', '%Y%m%d'), interval - 6 week)),  '%Y%m%d') and date_format ( (adddate( STR_TO_DATE('20160930', '%Y%m%d'), interval - 6 week )),  '%Y%m%d')
group by obs.person_id -- ;     --  obs.concept_id, encounter.encounter_type,
) presion_elevada;