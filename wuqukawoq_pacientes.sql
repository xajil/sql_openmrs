/* Script para OpenMRS Wuqu' Kawoq */
select 
	person.person_id,
	patient_identifier.identifier as numero_open,
    concat(person_name.given_name, person_name.family_name) as nombre,
    person.birthdate as fecha_nacimiento,
	YEAR( sysdate() ) - YEAR(person.birthdate) - (DATE_FORMAT( sysdate(), '%m%d') < DATE_FORMAT(person.birthdate, '%m%d')) as edad,
    person.gender as genero,
    obs_pivote.peso, 
    obs_pivote.talla,
    obs_pivote.sistolica,
    obs_pivote.diastolica,
    location.name as comunidad    
    from person
    left join person_name
		on person.person_id = person_name.person_id
	left join obs_pivote
		on person.person_id = obs_pivote.person_id
	left join patient_identifier
		on person.person_id = patient_identifier.patient_id
        and patient_identifier.identifier_type = 2
	left join location
		on patient_identifier.location_id = location.location_id
	where 
    patient_identifier.voided = 0
    and patient_identifier.identifier is not null
    -- and patient_identifier.identifier in ( '0385', '03945')
    group by numero_open, fecha_nacimiento, genero, comunidad;
    
   
-- paciente,peso, talla, edad, genero, presion sistolica, presion diastolica
DROP TABLE obs_pivote;    
create table obs_pivote as 
select person_id, max(peso) peso, max(talla) talla, max(sistólica) sistolica, max(diastólica) diastolica from (
 select 
 person.person_id, 
 obs.concept_id, 
 person.birthdate,  
 max(obs.date_created)  max_obs_date_created , 
 obs.value_numeric peso
 , null talla
 , null sistólica
 , null diastólica
 from person, obs
 where person.person_id = obs.person_id
 -- and person.person_id = 4936
 and obs.concept_id = 5089 -- peso kg
 group by person.person_id, obs.concept_id, person.birthdate, obs.value_numeric 
 union
	 select 
	 person.person_id, 
	 obs.concept_id, 
	 person.birthdate,  
	 max(obs.date_created)  max_obs_date_created  , 
	 null peso,
	 obs.value_numeric talla
	, null sistólica
	, null diastólica
 from person, obs
	 where person.person_id = obs.person_id
	 -- and person.person_id = 4936
	 and obs.concept_id = 5090 -- talla cm 
	 group by person.person_id, obs.concept_id, person.birthdate, obs.value_numeric
 union
	 select 
	 person.person_id, 
	 obs.concept_id, 
	 person.birthdate,  
	 max(obs.date_created)  max_obs_date_created  , 
	 null peso,
	 null talla
	, obs.value_numeric sistólica
	, null diastólica
	 from person, obs
	 where person.person_id = obs.person_id
	 -- and person.person_id = 4936
	 and obs.concept_id = 5085 -- PA SISTÓLICA
	 group by person.person_id, obs.concept_id, person.birthdate, obs.value_numeric
 union
	 select 
	 person.person_id, 
	 obs.concept_id, 
	 person.birthdate,  
	 max(obs.date_created)  max_obs_date_created  , 
	 null peso,
	 null talla
	, null sistólica
	, obs.value_numeric diastólica
	 from person, obs
	 where person.person_id = obs.person_id
	 -- and person.person_id = 4936
	 and obs.concept_id = 5086 -- PA DIASTÓLICA
	 group by person.person_id, obs.concept_id, person.birthdate, obs.value_numeric
 ) as tbl
 group by tbl.person_id;

 select * from obs_pivote;
 
 
/* Observaciones de un paciente sin agrupar  */
 select obs.*
 from person, obs
 where person.person_id = obs.person_id
 and person.person_id = 4936
 and obs.concept_id in ( 5089, -- peso kg
 5090,  -- talla cm
 5085, -- p/a SISTÓLICA
 5086 -- P/A  DIATÓLICA mmHg
 )
 order by obs.date_created desc;


/* Observaciones de un paciente agrupados por el más reciente  */ 
select 
 person.person_id, 
 obs.concept_id, 
 person.birthdate,  
 max(obs.date_created)  max_obs_date_created  , 
 obs.value_numeric
 from person, obs
 where person.person_id = obs.person_id
 and person.person_id = 4936
 and obs.concept_id in ( 5089, -- peso kg
 5090,  -- talla cm
 5085, -- p/a
 5086 -- mmHg
 )
 group by person.person_id, obs.concept_id, person.birthdate;