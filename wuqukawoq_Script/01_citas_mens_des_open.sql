select 
     patient_identifier.identifier as numero_open, 
     concat(person_name.given_name,          
     person_name.family_name) as nombre, 
     person.birthdate as fecha_nacimiento, 
     person.gender as genero, 
     location.name as comunidad,
	 case 
       WHEN  person.person_id = (
        select ls_person_patient_id  from PIVOTE_OBS 
			where   person.person_id = ls_person_patient_id
				and ls_concept_id = 5089 
                and ls_dias_obs > 90 
                and (datediff ( :date , ls_birth ) between 730 and 1826 
                )  
		) then 'SI'  
      WHEN person.person_id = (
        select ls_person_patient_id  from PIVOTE_OBS 
			where   person.person_id = ls_person_patient_id
				AND datediff (  :date, ls_birth ) <= 730 
                GROUP BY ls_person_patient_id)  THEN 'SI'  
                
	 ELSE '' END AS PesoTalla, 
	 case 
     WHEN  person.person_id = (
        select ls_person_patient_id  from PIVOTE_OBS 
			where   person.person_id = ls_person_patient_id
				and ls_concept_id = 70439
                and (ls_dias_obs >  180 )
                and (datediff (  :date , ls_birth ) > 365 
                )  
		) then 'SI'  
	 WHEN  person.person_id = (
        select ls_person_patient_id  from PIVOTE_OBS 
			where   person.person_id = ls_person_patient_id
				and ls_concept_id = 70439
                and (ls_dias_obs <=  180 )
                and (datediff (  :date , ls_birth ) > 365 
                )  
		) then ''
     ELSE 'SI' END AS Desparasitante, 
	 case 
     WHEN  person.person_id = (
        select ls_person_patient_id  from PIVOTE_OBS 
			where   person.person_id = ls_person_patient_id
				and ls_concept_id = 1621 
                and ls_dias_obs > 30 
                and (datediff (  :date , ls_birth ) > 182 
                )  
		) then 'SI'  
     WHEN  person.person_id = (
        select ls_person_patient_id  from PIVOTE_OBS 
			where   person.person_id = ls_person_patient_id
				and ls_concept_id = 1621 
                and ls_dias_obs <= 30 
                and (datediff (  :date , ls_birth ) > 182 
                )  
		) then 'SI'
	 ELSE 'SI' END AS Chispitas ,
	case 
     WHEN  person.person_id = (
        select ls_person_patient_id  from PIVOTE_OBS 
			where   person.person_id = ls_person_patient_id
				and program_id = 9 
                and (datediff ( :date , date_program_enrolled ) <= 90 
                )  
		) then (select concat( 'VC hasta:   ', DATE_ADD(date_program_enrolled,INTERVAL 90 DAY) ) from PIVOTE_OBS 
			where   person.person_id = ls_person_patient_id
				and program_id = 9  ) 
     WHEN  person.person_id = (
        select ls_person_patient_id  from PIVOTE_OBS 
			where   person.person_id = ls_person_patient_id
				and program_id = 9 
                and datediff ( :date, date_program_enrolled ) <= 180
                and datediff ( :date , date_program_enrolled ) > 90
                )
                then (select concat( 'FH hasta:   ', DATE_ADD(date_program_enrolled,INTERVAL 180 DAY)  )from PIVOTE_OBS 
			where   person.person_id = ls_person_patient_id
				and program_id = 9  )  
	   ELSE ''  END AS viveres,
     case 
     WHEN person.person_id = (
        select ls_person_patient_id  from PIVOTE_OBS 
			where   person.person_id = ls_person_patient_id
				and program_id = 12 
                and (datediff (  :date , ls_birth ) <= 180 
                )  
		) then (select concat( 'NAN1 hasta:   ', DATE_ADD(ls_birth,INTERVAL 180 DAY) ) from PIVOTE_OBS 
			where   person.person_id = ls_person_patient_id
				and program_id = 12  ) 
	   when person.person_id = (
        select ls_person_patient_id  from PIVOTE_OBS 
			where   person.person_id = ls_person_patient_id
				and program_id = 12 
                and (datediff (  :date , ls_birth ) >= 180 )
                AND (datediff (  :date , ls_birth ) <= 365)
                )   then 
       (select concat( 'NAN2 hasta:   ', DATE_ADD(ls_birth,INTERVAL 365 DAY)  )from PIVOTE_OBS 
			where   person.person_id = ls_person_patient_id
				and program_id = 12  ) 
       else ''         END AS formula
from person
left join person_name
     on person.person_id = person_name.person_id
left join patient_identifier
     on person.person_id = patient_identifier.patient_id  
     and     patient_identifier.identifier_type=2
left join location
     on patient_identifier.location_id = location.location_id
where 
datediff (  :date, person.birthdate) <= 1826  
and patient_identifier.voided = 0
and patient_identifier.identifier is not null
and identifier
group by numero_open, fecha_nacimiento, genero, comunidad;
