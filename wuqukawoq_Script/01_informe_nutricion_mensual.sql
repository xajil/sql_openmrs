select   
  patient_identifier.identifier as numero_open, 
     concat(person_name.given_name,          
     person_name.family_name) as nombre, 
     person.birthdate as fecha_nacimiento, 
     person.gender as genero, 
     location.name as comunidad,
  case WHEN  person.person_id = (
        select ls_person_patient_id  from PIVOTE_OBS 
			where   person.person_id = ls_person_patient_id
				and program_id = 9 
                and datediff ( sysdate(),  date_program_enrolled ) <= 180) 
                then '1'
	   else '0'  END AS viveres,
     case 
	   when person.person_id = (
        select ls_person_patient_id  from PIVOTE_OBS 
			where   person.person_id = ls_person_patient_id
				and program_id = 12 
             
                AND (datediff (  sysdate() , ls_birth ) <= 365)
                )   then  '1' 
       else '0'         END AS formula,
	 case 
     WHEN  person.person_id = (
        select ls_person_patient_id  from PIVOTE_OBS 
			where   person.person_id = ls_person_patient_id
				and ls_concept_id = 1621 
                and ls_dias_obs < 37 
                and (datediff ( sysdate() , ls_birth ) > 182 
                )  
		) then '1'  
	 ELSE '0' END AS Chispitas ,
	 case 
     WHEN  person.person_id = (
        select ls_person_patient_id  from PIVOTE_OBS 
			where   person.person_id = ls_person_patient_id
				and ls_concept_id = 70439
                and (ls_dias_obs >  180 )
                and (datediff (  sysdate() , ls_birth ) > 365 
                )  
		) then '0'  
	 WHEN  person.person_id = (
        select ls_person_patient_id  from PIVOTE_OBS 
			where   person.person_id = ls_person_patient_id
				and ls_concept_id = 70439
                and (ls_dias_obs <=  180 )
                and (datediff (  sysdate() , ls_birth ) > 365 
                )  
		) then '1'
     ELSE '0' END AS Desparasitante, 
	 case 
       WHEN  person.person_id = (
        select ls_person_patient_id  from PIVOTE_OBS 
			where   person.person_id = ls_person_patient_id
				and ls_concept_id = 5089 
                and ls_dias_obs > 90 
                and (datediff ( sysdate() , ls_birth ) between 730 and 1826 
                )  
		) then '0'  
WHEN  person.person_id = (
        select ls_person_patient_id  from PIVOTE_OBS 
			where   person.person_id = ls_person_patient_id
				and ls_concept_id = 5089 
                and ls_dias_obs > 35 
                and (datediff ( sysdate() , ls_birth ) <= 730 
                )  
		) then '0'         
	 ELSE '1' END AS PesoTalla, 
case 
     WHEN  person.person_id = (
        select ls_person_patient_id  from PIVOTE_OBS 
			where   person.person_id = ls_person_patient_id
				and ls_concept_id = 159854 
                and ls_dias_obs < 37 
                and (datediff ( sysdate() , ls_birth ) > 182 
                )  
		) then '1'  
	 ELSE '0' END AS ManiPlus ,
case 
     WHEN  person.person_id = (
        select ls_person_patient_id  from PIVOTE_OBS 
			where   person.person_id = ls_person_patient_id
				and ls_concept_id = 159854 
                and ls_dias_obs < 30 
                )  
		 then '1'  
	 ELSE '0' END AS viveres_completo ,
case 
     WHEN  person.person_id = (
        select ls_person_patient_id  from PIVOTE_OBS 
			where   person.person_id = ls_person_patient_id
				and ls_concept_id = 1595
                and ls_dias_obs < 30 
                )  
		 then '1'  
	 ELSE '0' END AS frijol_huevo ,
case 
     WHEN  person.person_id = (
        select ls_person_patient_id  from PIVOTE_OBS 
			where   person.person_id = ls_person_patient_id
				and ls_concept_id = 5254
                and ls_dias_obs < 30   
		) then '1'  
	 ELSE '0' END AS NAN1 ,
case 
     WHEN  person.person_id = (
        select ls_person_patient_id  from PIVOTE_OBS 
			where   person.person_id = ls_person_patient_id
				and ls_concept_id = 6046
                and ls_dias_obs < 30 
		) then '1'  
	 ELSE '0' END AS NAN2
from person
left join person_name
     on person.person_id = person_name.person_id
left join patient_identifier
     on person.person_id = patient_identifier.patient_id  
     and     patient_identifier.identifier_type=2
left join location
     on patient_identifier.location_id = location.location_id
where 
datediff (  sysdate(), person.birthdate) <= 1826  
and patient_identifier.voided = 0
and person.person_id = 5912
and patient_identifier.identifier is not null
group by numero_open, fecha_nacimiento, genero, comunidad;


