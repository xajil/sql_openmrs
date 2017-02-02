/*
Para el informe de nutricion para las reuniones 
(https://openmrs.wuqukawoq.org/openmrs/module/reporting/datasets/sqlDataSetEditor.form?type=org.openmrs.module.reporting.dataset.definition.SqlDataSetDefinition&uuid=6c0bcd77-0de4-4331-9c2d-0baefc979204) 
me gustaria tener los ultimos dos de chispitas, albendazol, peso, talla, viveres.... 
y no se si haya una manera de hacer un max() para que aparecen los ultimos dos... 
*/

select 
     patient_identifier.identifier as numero_open, 
     concat(person_name.given_name,          
     person_name.family_name) as nombre, 
     person.birthdate as fecha_nacimiento, 
     person.gender as genero, 
     location.name as comunidad,
     case when patient_program.program_id = 9 then date(patient_program.date_enrolled) end as watsi,
     max(case when obs.concept_id = 5089 then obs.value_numeric end) as peso1,
     max(case when obs.concept_id = 5089 then date(obs.obs_datetime) end) as peso_date,
     max(case when obs.concept_id = 5090 then obs.value_numeric end) as talla1,
     max(case when obs.concept_id = 5090 then date(obs.obs_datetime) end) as talla_date,
     max(case when obs.concept_id = 1621 then obs.value_numeric end) as chispitas_numero,
     max(case when obs.concept_id = 1621 then date(obs.obs_datetime) end) as chispitas,
     max(case when obs.concept_id = 1275 then date(obs.obs_datetime) end) as chispitas_CS,
     max(case when obs.concept_id = 159854 then date(obs.obs_datetime) end) as maniplus,
     max(case when obs.concept_id = 70439 then date(obs.obs_datetime) end) as albendazol,
     max(case when obs.concept_id = 5484 then date(obs.obs_datetime) end) as viveres_completo,
     max(case when obs.concept_id = 1595 then date(obs.obs_datetime) end) as frijol_huevo,
     max(case when obs.concept_id = 5254 then date(obs.obs_datetime) end) as NAN1,
     max(case when obs.concept_id = 6046 then date(obs.obs_datetime) end) as NAN2
     
from person
left join patient_identifier
     on person.person_id = patient_identifier.patient_id  
     and     patient_identifier.identifier_type=2
left join patient_program 
     on person.person_id = patient_program.patient_id
left join location
     on patient_identifier.location_id = location.location_id
left join person_name
     on person.person_id = person_name.person_id
left join obs 
     on person.person_id = obs.person_id
where datediff ( sysdate() , person.birthdate) <= 1826 and person.person_id = 5912
group by patient_identifier.patient_id