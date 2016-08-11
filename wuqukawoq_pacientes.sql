/* Script para OpenMRS Wuqu' Kawoq */


select 
	person.person_id,
	patient_identifier.identifier as numero_open,
    concat(person_name.given_name, person_name.family_name) as nombre,
    person.birthdate as fecha_nacimiento,
	YEAR( sysdate() ) - YEAR(person.birthdate) - (DATE_FORMAT( sysdate(), '%m%d') < DATE_FORMAT(person.birthdate, '%m%d')) as edad,
    person.gender as genero,
    location.name as comunidad
    from person
    left join person_name
		on person.person_id = person_name.person_id
	left join patient_identifier
		on person.person_id = patient_identifier.patient_id
        and patient_identifier.identifier_type = 2
	left join location
		on patient_identifier.location_id = location.location_id
	where 
    patient_identifier.voided = 0
    and patient_identifier.identifier is not null
    and patient_identifier.identifier in ( '0385', '03945')
    group by numero_open, fecha_nacimiento, genero, comunidad;
    
    
 select 
 person.person_id, 
 obs.concept_id, 
  person.birthdate,  
 max(obs.date_created)                               ls_obs_date_created  , 
 null 												 date_program_enrolled,
 ( datediff ( sysdate(),  max(obs.date_created ) ) ) ls_dias_obs,
 null ls_program
 from person, obs
 where person.person_id = obs.person_id
 and person.person_id = 4936
 group by person.person_id, obs.concept_id, person.birthdate;
 
    
 select obs.*
 from person, obs
 where person.person_id = obs.person_id
 and person.person_id = 4936
 and obs.concept_id in ( 5089, -- peso kg
 5090,  -- talla cm
 5085, -- p/a
 5086 -- mmHg
 )
 order by obs.date_created desc;
 