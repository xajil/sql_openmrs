/* Scrip para identificar fichas duplicadas:
*/

select  
count(*) cantidad_reg,
patient_identifier.identifier  no_open,  
patient_identifier.patient_id, 
encounter.location_id, 
location.name,
encounter.encounter_id, 
encounter.encounter_datetime, 
encounter.encounter_type, 
encounter.form_id, 
encounter_provider.provider_id 
	from patient_identifier, location, encounter, encounter_provider
    where encounter.location_id = location.location_id
		and encounter.patient_id = patient_identifier.patient_id
        and encounter.encounter_id = encounter_provider.encounter_id
        and encounter.encounter_datetime  
        between 
	    STR_TO_DATE('01/01/2017', '%m/%d/%Y') AND 
	    STR_TO_DATE('01/31/2017', '%m/%d/%Y')
    --  between var_start_date and var_end_date
        and encounter.voided = 0
        and encounter_provider.voided = 0
		and patient_identifier.voided = 0
        and patient_identifier.patient_id >= 2660
        group by patient_identifier.identifier, 
patient_identifier.patient_id, 
encounter.location_id, 
-- location.name,
-- encounter.encounter_id, 
-- encounter.encounter_datetime, 
encounter.encounter_type, 
encounter.form_id, 
encounter_provider.provider_id 
-- having count(*) > 1
order by  patient_identifier.patient_id asc
; 
        
 -- 2660       
        -- patient id 2660
        

select * from error_log_pda_repo;