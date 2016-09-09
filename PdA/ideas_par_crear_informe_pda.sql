SELECT 
person_id, patient_identifier.identifier as numero_open,
concept_id,    
obs.encounter_id, obs_datetime, value_coded, value_numeric, value_boolean, value_text, 
encounter.encounter_type, form_id, encounter_provider.provider_id 
-- count(*) 
FROM obs, encounter, encounter_provider, patient_identifier
WHERE 
	obs.encounter_id = encounter.encounter_id and
    encounter.encounter_id = encounter_provider.encounter_id and
    obs.person_id = patient_identifier.patient_id and
	obs.person_id = 1622 and
	obs.voided  = 0 and
    encounter.voided = 0 and
    encounter_provider.voided = 0 and
    obs.obs_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
	;       
    
-- 28014
-- 27304
select 28014 - 27304;


SELECT 
person_id, patient_identifier.identifier as numero_open,
concept_id,    
obs.encounter_id, obs_datetime, value_coded, value_numeric, value_boolean, value_text, 
encounter.encounter_type, form_id, encounter_provider.provider_id 
FROM obs-- , encounter, encounter_provider -- , patient_identifier
WHERE 
	-- obs.encounter_id = encounter.encounter_id and
    -- encounter.encounter_id = encounter_provider.encounter_id and
    -- obs.person_id = patient_identifier.patient_id and
	-- obs.person_id = 1622 and
	obs.voided  = 0 and
    --  obs.concept_id = 161577 and
	-- obs.encounter_id = encounter.encounter_id and 
	obs.obs_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
	;      

select * from encounter;