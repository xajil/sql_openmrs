select 
     patient_identifier.identifier as numero_open, 
     concat(person_name.given_name,          
     person_name.family_name) as nombre, 
     person.birthdate as fecha_nacimiento, 
     person.gender as genero, 
     location.name as comunidad,
     case 
	when ( (datediff ( :date, person.birthdate) between 730 and 1826)
		 and ( datediff ( :date, ls_date_created) ) > 90 
		 )
		 then 'SI'  
	when (datediff ( :date, person.birthdate) <= 730) then 'MENOR 2 ANIOS'
    when (datediff ( :date, person.birthdate) >= 1826) then 'Mayor 5 años'
	ELSE 'OTRO'
	END AS PESO_TALLA,     
     case
     when (ls_concept_id = 5089) and ( datediff ( :date , ls_date_created) ) > 90   then 
     datediff ( :date , ls_date_created) 
     ELSE ( datediff (:date, ls_date_created) ) END AS dias_ultima_obs_talla
from person
left join person_name
     on person.person_id = person_name.person_id
left join patient_identifier
     on person.person_id = patient_identifier.patient_id  
     and     patient_identifier.identifier_type=2
left join location
     on patient_identifier.location_id = location.location_id
left join (
		select person_id ls_person_id, concept_id ls_concept_id, max(date_created) ls_date_created  
			from obs
			group by person_id, concept_id
		) last_obs  
on  person.person_id = last_obs.ls_person_id   
where 
datediff ( :date, person.birthdate) <= 1826  
and patient_identifier.voided = 0
and patient_identifier.identifier is not null
group by numero_open, fecha_nacimiento, genero, comunidad;


/* Scrip versión kate */
select 
     patient_identifier.identifier as numero_open, 
     concat(person_name.given_name,          
     person_name.family_name) as nombre, 
     person.birthdate as fecha_nacimiento, 
     person.gender as genero, 
     location.name as comunidad,
     obs.concept_id,
(select max(obs.obs_datetime) from obs left join person on obs.person_id = person.person_id where obs.concept_id = 5090),
datediff (:date, (select obs.obs_datetime from obs left join person on obs.person_id = person.person_id where obs.concept_id = 5090 order by obs.obs_datetime desc limit 1) ) as dias,     
case 
when ( (datediff (:date, person.birthdate) between 730 and 1826)
     and datediff (:date, (select max(obs.obs_datetime) from obs left join person on obs.person_id = person.person_id where obs.concept_id = 5090) ) > 90 
     )
     then 'SI'  
when (datediff (:date, person.birthdate) <= 730) then 'MENOR 2 ANIOS'
ELSE 'OTRO'
END AS PESO_TALLA

from person
left join obs 
     on person.person_id = obs.person_id
left join patient_identifier
     on person.person_id = patient_identifier.patient_id  
     and     patient_identifier.identifier_type=2
left join location
     on patient_identifier.location_id = location.location_id
left join person_name
     on person.person_id = person_name.person_id


where datediff (:date, person.birthdate) <= 1826 and person.person_id = 4582
group by patient_identifier.patient_id
order by comunidad, nombre, fecha_nacimiento, numero_open, genero 