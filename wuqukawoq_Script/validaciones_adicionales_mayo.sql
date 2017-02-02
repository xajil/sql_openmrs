select person.person_id,
     patient_identifier.identifier as numero_open, 
     concat(person_name.given_name,          
     person_name.family_name) as nombre, 
     person.birthdate as fecha_nacimiento 
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
-- and person.person_id=4582
and patient_identifier.identifier =  '00456'
and patient_identifier.identifier is not null
;
-- group by numero_open,fecha_nacimiento;

		select person_id ls_person_id, concept_id ls_concept_id, max(date_created) ls_date_created  
			from obs
	        where person_id in (5414, 4763)  
			group by person_id, concept_id;
            
            
select sysdate();

select 	person.person_id, 
		person.birthdate, 
		person_name.given_name, 
        person_name.family_name from person 
 left join person_name
     on person.person_id = person_name.person_id
 where person.person_id in (5414, 4763);    
 
 /* vALIDACION PARA DETERMINAR OBSERVACIÓN REGISTRO DE DESPARASITANTE */
 -- Desparasitante: si es mayor de 1 ano y obs.concept_id = 70439 y fecha de observacion mayor de 180 dias
 select person_id ls_person_id, concept_id ls_concept_id, max(date_created) ls_date_created  ,    ( datediff ( sysdate(),  max(date_created ) ) )
			from obs
			where concept_id = 70439 
			group by person_id, concept_id;
 -- pacientes que aplican a desparasitante por la regla 
 
 select person.person_id ls_person_id, obs.concept_id ls_concept_id, person.birthdate,  
 max(obs.date_created) ls_date_created  ,    ( datediff ( sysdate(),  max(obs.date_created ) ) )
  from person, obs
 where person.person_id = obs.person_id
 and obs.concept_id = 70439
 and datediff ( sysdate(),  obs.date_created ) < 15
 and datediff ( sysdate(),  person.birthdate ) > 180
 group by person.person_id, obs.concept_id, person.birthdate;             
            
            
 /* vALIDACION PARA DETERMINAR OBSERVACIÓN REGISTRO DE CHISPITAS */
-- Chispitas: si es mayor de 6 meses y obs.concept_id = 1621 y fecha de observacion mayor de 30 dias 
-- (aunque tenemos que pensar en esto, porque a veces se estan dando chispitas cada 90 dias en vez de cada 30 dias...)
 select person_id ls_person_id, concept_id ls_concept_id, max(date_created) ls_date_created  ,    ( datediff ( sysdate(),  max(date_created ) ) )
			from obs
			where concept_id = 1621 
            AND  datediff ( sysdate(),  date_created ) < 30 
			group by person_id, concept_id;        
            
    --  pacientes que aplican a chispitas por validación de la regla         
 select person.person_id ls_person_id, obs.concept_id ls_concept_id, person.birthdate,  
 max(obs.date_created) ls_date_created  ,    ( datediff ( sysdate(),  max(obs.date_created ) ) )
  from person, obs
 where person.person_id = obs.person_id
 and obs.concept_id = 1621
 and datediff ( sysdate(),  obs.date_created ) < 15
 and datediff ( sysdate(),  person.birthdate ) > 182
 group by person.person_id, obs.concept_id, person.birthdate; 
            
            
			select person_id ls_person_id, concept_id ls_concept_id, max(date_created) ls_date_created  
			from obs
            where person_id = 5850
            -- and obs.concept_id = 1621
			group by person_id, concept_id;    
            
--  LISTAR PROGRAMAS DEL PACIENTE

SELECT * FROM patient_program, program , concept , concept_name
WHERE patient_program.PROGRAM_ID = program.PROGRAM_ID
AND program.concept_id = concept.concept_id 
and concept.concept_id = concept_name.concept_id
and UPPER(concept_name.name) like '%NUTRICION%';    

SELECT program.program_id, program.name FROM patient_program, program 
 where patient_program.program_id = program.program_id;
 


select program_id from patient left join patient_program 
 on patient.patient_id = patient_program.patient_id 
 where patient.patient_id = 5912;

SELECT * FROM patient_program;

SELECT program_id, name FROM program;

SELECT * FROM concept;
SELECT * FROM concept_name;


        