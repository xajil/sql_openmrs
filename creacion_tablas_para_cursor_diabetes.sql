-- Ejecución de cursor de pacientes diabeticos.

TRUNCATE TABLE obs_horizontal;
call diabetes();

select * from obs_horizontal order by person_id;


/* Creción de tabla de observaciones   */ 
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
 and obs.concept_id = 5089 -- peso kg
 and obs.voided =0
union
	 select 
	 person.person_id, 
	 obs.concept_id, 
	 person.birthdate,  
	 date_format(obs.date_created,'%Y-%m-%d') date_created,-- obs.date_created, -- max(obs.date_created)  max_obs_date_created_talla  , 
	 obs.value_numeric
 from person, obs
	 where person.person_id = obs.person_id
	 and obs.concept_id = 5090 -- talla cm 
     and obs.voided =0
 union
	 select 
	 person.person_id, 
	 obs.concept_id, 
	 person.birthdate,  
	 date_format(obs.date_created,'%Y-%m-%d') date_created , -- obs.date_created,
	 obs.value_numeric
	 from person, obs
	 where person.person_id = obs.person_id
     and obs.concept_id = 5085 -- PA SISTÓLICA
     and obs.voided =0
 union
	 select 
	 person.person_id, 
	 obs.concept_id, 
	 person.birthdate,  
	 date_format(obs.date_created,'%Y-%m-%d') date_created, -- obs.date_created,-- max(obs.date_created)  max_obs_date_created_diastolica, 
	 obs.value_numeric
	 from person, obs
	 where person.person_id = obs.person_id
	 and obs.concept_id = 5086 -- PA DIASTÓLICA
     and obs.voided =0
 union
	 select 
	 person.person_id, 
	 obs.concept_id, 
	 person.birthdate,  
	 date_format(obs.date_created,'%Y-%m-%d') date_created , -- obs.date_created,-- max(obs.date_created)  max_obs_date_created_hemoglobina,
	 obs.value_numeric
	 from person, obs
	 where person.person_id = obs.person_id
	 and obs.concept_id = 159644 -- hemoglobina
     and obs.voided =0

;


drop table tbl_diabeticos_prog;
create table tbl_diabeticos_prog as 
select 
	person.person_id,
	patient_identifier.identifier as numero_open,
	person.birthdate 
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
    and patient_identifier.identifier in 
    (
'658',
'4090',
'1502',
'8278',
'9950',
'2480',
'329',
'10037',
'431',
'10040',
'7428',
'4058',
'2481',
'2477',
'9931',
'4076',
'4094',
'1605',
'2476',
'8059',
'4075',
'653',
'652',
'050',
'4113',
'10038',
'81',
'654',
'656',
'4122',
'4039',
'650',
'4138',
'4169',
'4125',
'7441',
'484',
'509',
'912',
'900',
'407',
'831',
'1414',
'384',
'1411',
'1423',
'915',
'889',
'1776',
'25',
'331',
'435',
'758',
'016',
'9001',
'026',
'7881',
'2532',
'136',
'029',
'9874',
'015',
'436',
'030',
'027',
'2416',
'1424',
'529',
'527',
'1422',
'8011',
'363',
'046',
'549',
'9911',
'542',
'4066',
'042',
'036',
'347',
'48',
'043',
'8012',
'1421',
'3622',
'2434',
'558',
'13616',
'8102',
'1361',
'1360',
'9611',
'7547',
'9919',
'555',
'487',
'7895',
'1417',
'7655',
'100011'
    ) --  in ( '0385', '03945')
    group by person_id;
    
    
/* Buscar observaciones por person_id o por numero_open  */     
select 
	person.person_id,
	patient_identifier.identifier as numero_open,
    concat(person_name.given_name, person_name.family_name) as nombre,
     person.birthdate ,--  as fecha_nacimiento,
	-- YEAR( sysdate() ) - YEAR(person.birthdate) - (DATE_FORMAT( sysdate(), '%m%d') < DATE_FORMAT(person.birthdate, '%m%d')) as edad
    -- person.gender as genero,
    tbl_obs_diabeticos.concept_id,
    tbl_obs_diabeticos.value_numeric,
    date_format(tbl_obs_diabeticos.date_created,'%Y-%m-%d-'),
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
    -- and person.person_id = 29
    and patient_identifier.identifier is not null
    and patient_identifier.identifier = 43
    order by concept_id, tbl_obs_diabeticos.date_created ;
    
    
 