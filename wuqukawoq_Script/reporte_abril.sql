select 
     patient_identifier.identifier as numero_open, 
     concat(person_name.given_name,          
     person_name.family_name) as nombre, 
     person.birthdate as fecha_nacimiento, 
     person.gender as genero, 
     location.name as comunidad,
     obs.concept_id,
     case when (datediff (sysdate(), person.birthdate) <= 730) then 'MENOR 2 ANIOS'
		ELSE 'OTRO' END
        from person
left join patient_identifier
     on person.person_id = patient_identifier.patient_id  
     and     patient_identifier.identifier_type=2
left join location
     on patient_identifier.location_id = location.location_id
left join person_name
     on person.person_id = person_name.person_id
left join obs 
     on person.person_id = obs.person_id
where datediff (sysdate(), person.birthdate) <= 1826
and obs.person_id = 4582
group by patient_identifier.patient_id
order by comunidad, nombre, fecha_nacimiento, numero_open, genero 


case 
		when ( datediff(sysdate(), person.birthdate) > 730 ) then 'SI'  
		when ( datediff(sysdate(), person.birthdate) <= 730) then 'MENOR 2 ANIOS'
		ELSE 'OTRO'
		END AS PESO_TALLA

datediff( sysdate(), person.birthdate) between 730 and 1826)  
			    and 
datediff( sysdate(),(select max(obs.obs_datetime) from obs where obs.concept_id = 5090)) > 90                 
                

select  datediff( sysdate(), max(obs.obs_datetime) )from 
obs left join person
on obs.person_id = person.person_id 
where  obs.person_id = 4582;

obs.concept_id = 5090 AND

datediff (sysdate, (select max(obs.obs_datetime) from obs where obs.concept_id = 5090) ) > 90 

select obs_id, person_id, concept_id from obs where person_id = 102010


