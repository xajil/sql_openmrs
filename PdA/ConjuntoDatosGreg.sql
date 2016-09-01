select * from encounter;

/* Tipo de encuentro / No necesariamente es una visita física.
como el ingreso de resultados del laboratorio
o como el ingreso de notas por medio de la correspondencia.
Naturaleza de la visita
*/
Select * from encounter_type;


Select encounter.encounter_id,
	encounter.encounter_type,
    encounter.patient_id, encounter.location_id,
	form.name, count(encounter_id) numero_reconsultas,
    encounter.encounter_datetime, 
    encounter.form_id,
    encounter_type.encounter_type_id,
    encounter_type.name,
    encounter_type.description, 
    form.form_id
    from encounter, encounter_type, form
	WHERE encounter.encounter_type = encounter_type.encounter_type_id
    and encounter.form_id  = form.form_id
    and patient_id = 1281
    and form.form_id in ( 13, 11,7, 4, 2, 1)
    group by encounter.encounter_id
    order by encounter.encounter_datetime desc	;  
    
select * from form;


/* Programas que cuentan o indican un diagnóstico */
-- program_id = 13, 7, 2, 15, 16, 9 

select program_id, concept_id, name, description, program.* from program
where program_id in (13, 7, 2, 15, 16, 9 ) ;


select * from patient
	inner join patient_program
    where patient.patient_id = patient_program.patient_id
    and patient.patient_id = 36;

/* Para intervenciones se listan los conceptos que puden ser considerados como intervenciones.*/
-- 162991, 162990, 162972, 162978, 
select * from concept
inner join concept_name
on concept.concept_id = concept_name.concept_id
where concept.concept_id in (162991, 162990, 162972, 162978)
and concept_name.voided=0
and locale = 'es';


/* Para Laboratorio se listan los conceptos que puden ser considerados como Laboratorios.*/
-- 887 , 160912, 45,  1619, 1040, 1322, 21 ,159644, 790



select * from concept_name where name like '%Puente%';



-- CONSULTA


select 
     patient_identifier.identifier, patient_identifier.* 
     from patient_identifier
     where patient_identifier.identifier = 45665;

/* Conjunto de datos CONSULTA*/

Select 
	patient_identifier.identifier as numero_open,
    patient_identifier.patient_id,
	encounter.encounter_id,
    date_format(encounter.encounter_datetime, '%Y/%m/%d') as date_encounter ,
    'N/A' encounter_start_ts,
    'N/A' encounter_end_ts,
    encounter_type.encounter_type_id,
    encounter_type.name,
    encounter_type.description, 
    location.name location_name,
    'N/A' encounter_lat,
    'N/A' encounter_lat,
    'N/A' encounter_long,
    encounter_provider.provider_id,
	person_name.given_name ,
    person_name.family_name, 
    form.form_id,
    form.name form_name
    from encounter, encounter_provider, provider, person, person_name, encounter_type, form, patient_identifier, location
	WHERE encounter.encounter_type = encounter_type.encounter_type_id
    and encounter.encounter_id = encounter_provider.encounter_id
    and encounter_provider.provider_id = provider.provider_id
    and provider.person_id = person.person_id
    and person.person_id = person_name.person_id
    and encounter.form_id  = form.form_id
    and encounter.patient_id = patient_identifier.patient_id
    and encounter.location_id = location.location_id
    and patient_identifier.voided = 0
    and date_format(encounter.encounter_datetime, '%Y%m%d')  between '20160801' and '20160831'
    group by encounter.encounter_id
    order by patient_identifier.patient_id desc	;  


select person_name.* from provider, person, person_name
where provider.person_id = person.person_id
and person_name.person_id = person.person_id;

