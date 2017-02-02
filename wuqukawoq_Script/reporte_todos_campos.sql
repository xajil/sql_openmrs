select 
     patient_identifier.identifier as numero_open, 
     concat(person_name.given_name,          
     person_name.family_name) as nombre, 
     person.birthdate as fecha_nacimiento, 
     person.gender as genero, 
     location.name as comunidad,
     --  PESO Y TALLA 
	 case 
		when ( ls_concept_id = 5089 AND  (datediff ( sysdate() , person.birthdate) between 730 and 1826)
			 and ( datediff ( sysdate(), ls_date_created) ) > 90 
			 )
			 then 'SI' -- concat('SI -->' , ls_concept_id )
		when (datediff ( sysdate(), person.birthdate) <= 730) then 'SI' -- concat('SI  menor 2 años-->', ls_concept_id) 
		when (datediff ( sysdate(), person.birthdate) >= 1826) then concat('Mayor 5 años -->', ls_concept_id)
        else 'NO' -- concat(ls_concept_id , ' --> ' , (datediff ( sysdate() , person.birthdate) ) , ' --> ' , datediff ( sysdate(), ls_date_created)  )
		END AS PESO_TALLA,
       
	-- Desparasitante: si es mayor de 1 ano y obs.concept_id = 70439 y fecha de observacion mayor de 180 dias
      case 
		when ( ls_concept_id = 70439 AND  (datediff ( sysdate() , person.birthdate) > 365)
			 and ( datediff ( sysdate(), ls_date_created) ) < 40 -- > 180 
			 )
			 then 'SI' -- concat('SI -->' , ls_concept_id )
        else 'NO' --  concat(ls_concept_id , ' --> ' , (datediff ( sysdate() , person.birthdate) ) , ' --> ' , datediff ( sysdate(), ls_date_created)  )     
		END AS DESPARASITANTE,  
        
 -- Chispitas: si es mayor de 6 meses y obs.concept_id = 1621 y fecha de observacion mayor de 30 dias 
 -- (aunque tenemos que pensar en esto, porque a veces se estan dando chispitas cada 90 dias en vez de cada 30 dias...)
     case 
		when ( ls_concept_id = 1621 AND  (datediff ( sysdate() , person.birthdate) > 182 )
			 and ( datediff ( sysdate(), ls_date_created) ) < 15  -- > 30 
			 )
			 then 'SI' -- concat('SI -->' , ls_concept_id )
        else   'NO'  --    concat(ls_concept_id , ' --> ' , (datediff ( sysdate() , person.birthdate) ) , ' --> ' , datediff ( sysdate(), ls_date_created)  )
		END AS CHISPITAS
/*     case
     when (ls_concept_id = 5089) and ( datediff ( sysdate() , ls_date_created) ) > 90   then 
     datediff ( sysdate() , ls_date_created) 
     ELSE ( datediff (sysdate(), ls_date_created) ) END AS dias_ultima_obs_talla
*/
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
            -- where person_id = 5850
			group by person_id, concept_id
		) last_obs  
on  person.person_id = last_obs.ls_person_id   
where 
datediff ( sysdate(), person.birthdate) <= 1826  
and patient_identifier.voided = 0
and patient_identifier.identifier is not null
and person.person_id = 5850
group by numero_open, fecha_nacimiento, genero, comunidad, PESO_TALLA, DESPARASITANTE, CHISPITAS ;