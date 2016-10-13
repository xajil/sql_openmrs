
select person.person_id,  patient_identifier.voided,
     patient_identifier.identifier as numero_open, 
     concat(person_name.given_name,          
     person_name.family_name) as nombre, 
     person.birthdate as fecha_nacimiento, 
     person.gender as genero, 
     location.name as comunidad,
     --  peso y talla 
     case 
	when ( (datediff (sysdate(), person.birthdate) between 730 and 1826)
		 and ( datediff (sysdate(), ls_date_created) ) > 90 
		 ) and (ls_concept_id = 5089)
		 then 'SI'  
	when (datediff (sysdate(), person.birthdate) <= 730) then 'SI'
    when (datediff (sysdate(), person.birthdate) >= 1826) then 'Mayor 5 años'
	ELSE 'OTRO'
	END AS PESO_TALLA,     
     case
     when (ls_concept_id = 5089) and ( datediff (sysdate(), ls_date_created) ) > 90   then 
     datediff (sysdate(), ls_date_created) 
     ELSE ( datediff (sysdate(), ls_date_created) ) END AS ultima_obs_talla
     --  desparasitante
     --  si es mayor de 1 ano y obs.concept_id = 70439 y fecha de observacion mayor de 180 dias
from person
left join person_name
     on person.person_id = person_name.person_id
left join patient_identifier
     on person.person_id = patient_identifier.patient_id  
     and     patient_identifier.identifier_type=2
left join location
     on patient_identifier.location_id = location.location_id
-- left join obs 
--     on person.person_id = obs.person_id
left join (
		select person_id ls_person_id, concept_id ls_concept_id, max(date_created) ls_date_created  
			from obs
	-- 		where person_id = 473  
			group by person_id, concept_id
		) last_obs  
on  person.person_id = last_obs.ls_person_id   
where 
datediff (sysdate(), person.birthdate) <= 1826  
and patient_identifier.voided = 0
-- and person.person_id=4582
-- and patient_identifier.identifier =  '1299'
and patient_identifier.identifier is not null
-- and ( datediff (sysdate(), ls_date_created) ) > 90
group by numero_open, fecha_nacimiento, genero, comunidad;

select person_id, concept_id, max(date_created)  from obs
	where person_id = 473 
    group by person_id, concept_id;
    
    
select * from person where person_id = 473;
 
select * from person_name where person_id = 473; 
   
select person.birthdate from person 
 left join person_name
     on person.person_id = person_name.person_id
 where person.person_id = 473;    

select * from obs
	where person_id = 4582 
    group by person_id, concept_id;
    
select person_id, concept_id from obs
	where person_id = 6007 
    and concept_id = 5089
    group by person_id, concept_id;    

/* obtener el person_id por medio del nuemero de open 
el número open es el patient_identifier_id de la talba patient_identifier
tomar en cuenta que la columna identifier_type debe ser 2  */
select person.person_id, patient_identifier.patient_identifier_id  from person
left join patient_identifier
     on person.person_id = patient_identifier.patient_id  
     and     patient_identifier.identifier_type=2
     where patient_identifier.patient_identifier_id in ( 00456,  1845) ; 
     
select 
patient_identifier.identifier as numero_open,
concat(person_name.given_name, '   ',          
     person_name.family_name) as nombre, 
     person.birthdate as fecha_nacimiento, 
     person.gender as genero
 from person , person_name, patient_identifier
	where person.person_id = person_name.person_id
    and person.person_id = patient_identifier.patient_id
    and person.person_id=4582;

    