/*Contador de cantidad de observaciones realizadas en cada concepto */
-- Commit desde ubuntu con git(cocacola)
select count(*), person_id, concept_id from obs_hemoglobina
where person_id = 57
and concept_id in (
	5089, -- peso kg
	-- 5090,  -- talla cm
	5085, -- p/a SISTÓLICA
	5086,  -- P/A  DIATÓLICA mmHg
	159644  -- hemoglobina
 )
group by person_id, concept_id; -- where numero_open in (42,50);


/* Listado de todas las observaciones de hemoglobina por fecha de observacion descendente  */
select hemoglobina, date_format(max_obs_date_created_hemoglobina, '%Y-%m-%d') from obs_hemoglobina
where person_id = 57
and concept_id in (
	159644  -- hemoglobina
 )
 order by max_obs_date_created_hemoglobina desc
;

select count(*) from obs_hemoglobina
where person_id = 57
and concept_id = 159644  -- hemoglobina
group by person_id, concept_id;


/* Script para OpenMRS Wuqu' Kawoq */
select 
	person.person_id,
	patient_identifier.identifier as numero_open,
    concat(person_name.given_name, person_name.family_name) as nombre,
    person.birthdate as fecha_nacimiento,
	YEAR( sysdate() ) - YEAR(person.birthdate) - (DATE_FORMAT( sysdate(), '%m%d') < DATE_FORMAT(person.birthdate, '%m%d')) as edad,
    person.gender as genero,
    tbl_obs_diabeticos.concept_id,
    tbl_obs_diabeticos.value_numeric,
    date_format(date_created,'%Y-%m-%d-'),
    location.name as comunidad    
    from person
    left join person_name
		on person.person_id = person_name.person_id
	left join tbl_obs_diabeticos
		on person.person_id = tbl_obs_diabeticos.person_id
	left join patient_identifier
		on person.person_id = patient_identifier.patient_id
        and patient_identifier.identifier_type = 2
	left join location
		on patient_identifier.location_id = location.location_id
	where 
    patient_identifier.voided = 0
    and patient_identifier.identifier is not null
    and patient_identifier.identifier in ( '042','050'
    ) --  in ( '0385', '03945')
    group by numero_open, fecha_nacimiento, genero, comunidad;

select * from tbl_obs_diabeticos;

select * from obs_horizontal;    
truncate table obs_horizontal;

Drop table obs_horizontal;
create table obs_horizontal as select person_id, hemoglobina, max_obs_date_created_hemoglobina from obs_hemoglobina where person_id = 57;      
-- paciente,peso, talla, edad, genero, presion sistolica, presion diastolica

DROP TABLE obs_hemoglobina;    

DROP TABLE tbl_obs_diabeticos;  
create table tbl_obs_diabeticos as 
 select 
 person.person_id, 
 obs.concept_id, 
 person.birthdate, 
 date_format(obs.date_created,'%Y-%m-%d') date_created, -- obs.date_created , -- )  max_obs_date_created_peso , 
 obs.value_numeric
 from person, obs
 where person.person_id = obs.person_id
 -- and person.person_id = 4936
 and obs.concept_id = 5089 -- peso kg
 -- group by person.person_id, obs.concept_id, person.birthdate, obs.value_numeric 
 union
	 select 
	 person.person_id, 
	 obs.concept_id, 
	 person.birthdate,  
	 date_format(obs.date_created,'%Y-%m-%d') date_created,-- obs.date_created, -- max(obs.date_created)  max_obs_date_created_talla  , 
	 obs.value_numeric
 from person, obs
	 where person.person_id = obs.person_id
	 -- and person.person_id = 4936
	 and obs.concept_id = 5090 -- talla cm 
	 -- group by person.person_id, obs.concept_id, person.birthdate, obs.value_numeric
 union
	 select 
	 person.person_id, 
	 obs.concept_id, 
	 person.birthdate,  
	 date_format(obs.date_created,'%Y-%m-%d') date_created , -- obs.date_created,
	 obs.value_numeric
	 from person, obs
	 where person.person_id = obs.person_id
	 -- and person.person_id = 4936
	 and obs.concept_id = 5085 -- PA SISTÓLICA
	--  group by person.person_id, obs.concept_id, person.birthdate, obs.value_numeric
 union
	 select 
	 person.person_id, 
	 obs.concept_id, 
	 person.birthdate,  
	 date_format(obs.date_created,'%Y-%m-%d') date_created, -- obs.date_created,-- max(obs.date_created)  max_obs_date_created_diastolica, 
	 obs.value_numeric
	 from person, obs
	 where person.person_id = obs.person_id
	 -- and person.person_id = 4936
	 and obs.concept_id = 5086 -- PA DIASTÓLICA
	 -- group by person.person_id, obs.concept_id, person.birthdate, obs.value_numeric
 union
	 select 
	 person.person_id, 
	 obs.concept_id, 
	 person.birthdate,  
	 date_format(obs.date_created,'%Y-%m-%d') date_created , -- obs.date_created,-- max(obs.date_created)  max_obs_date_created_hemoglobina,
	 obs.value_numeric
	 from person, obs
	 where person.person_id = obs.person_id
	 -- and person.person_id = 4936
	 and obs.concept_id = 159644 -- hemoglobina
	 -- group by person.person_id, obs.concept_id, person.birthdate, obs.value_numeric     
     -- hemoglobina 159644
;
 
/*
 select * from obs_pivote;
 */
 
/* Observaciones de un paciente sin agrupar  */
/*
 select obs.*
 from person, obs
 where person.person_id = obs.person_id
 and person.person_id = 4936
 and obs.concept_id in ( 5089, -- peso kg
 5090,  -- talla cm
 5085, -- p/a SISTÓLICA
 5086,  -- P/A  DIATÓLICA mmHg
 159644,  -- hemoglobina
 )
 order by obs.date_created desc;
*/

/* Observaciones de un paciente agrupados por el más reciente  */ 

/* select 
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
  */
 
 /* select 
 person.person_id, 
 obs.concept_id, 
 person.birthdate,  
 min(obs.date_created)  min_encuentro_diabetes , 
 obs.value_numeric peso
 , null talla
 , null sistólica
 , null diastólica
 , null  hemoglobina
 from person, obs
 where person.person_id = obs.person_id
and person.person_id = 269
 and obs.concept_id in  -- hemoglobina
 group by person.person_id, obs.concept_id, person.birthdate, obs.value_numeric 
 */