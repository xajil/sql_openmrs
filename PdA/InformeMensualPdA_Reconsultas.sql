/* Informe Mensual PdA Reconsultas  */
/*
a) Determinar si Una Consulta es de Reconsulta.
- se pueden agrupar las consultas que sean encounter_type_id =2
- La ficha puede ser:  ( 13, 7, 4, 2, 1, 15,10 )
*/   

--  TOTAL DE RECONSULTAS
 Select 
    encounter.encounter_id, encounter.encounter_datetime
    from encounter, encounter_type, form
	WHERE encounter.encounter_type = encounter_type.encounter_type_id
    and encounter.form_id  = form.form_id
    and encounter_type.encounter_type_id = 2
	-- and encounter.patient_id = 1729
    -- and form.form_id in ( 13, 7, 4, 2, 1, 15,10 )
    and encounter.encounter_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
    group by encounter.patient_id, encounter.encounter_datetime;      


-- total de pacientes con reconsultas 
 Select 
    encounter.encounter_id, encounter.encounter_datetime
    from encounter, encounter_type, form
	WHERE encounter.encounter_type = encounter_type.encounter_type_id
    and encounter.form_id  = form.form_id
    and encounter_type.encounter_type_id = 2
	-- and encounter.patient_id = 1729
    -- and form.form_id in ( 13, 7, 4, 2, 1, 15,10 )
    and encounter.encounter_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
    group by encounter.patient_id;      
    
-- no estan en puente pero compraron un paquete de tratamiento, se identifican con ciclo=0
-- # no actualmente activo   
 Select 
    encounter.patient_id
    from encounter, encounter_type, form
	WHERE encounter.encounter_type = encounter_type.encounter_type_id
    and encounter.form_id  = form.form_id
    and encounter_type.encounter_type_id = 2
    and encounter.encounter_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
    and exists (select obs.person_id from obs
where concept_id = 163138   
and obs.person_id = encounter.patient_id
and value_numeric=0
and obs.voided = 0
and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')

)  
group by encounter.patient_id;        
   
-- observaciones de pacientes inactivos  en el mes.  
select date_format(obs_datetime,'%Y%m%d') from obs
where concept_id = 163138   
and obs.person_id = 1114
and value_numeric=0
and obs.voided = 0
and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
;

-- # reconsultas por visita de seguimiento anual
-- que tengan una ficha de seguimiento en el mes
 Select 
    encounter.patient_id
    from encounter, encounter_type, form
	WHERE encounter.encounter_type = encounter_type.encounter_type_id
    and encounter.form_id  = form.form_id
    and encounter_type.encounter_type_id = 2
	-- and encounter.patient_id = 1729
    and form.form_id = 16
    and encounter.encounter_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
    group by encounter.patient_id;    


-- # reconsultas solo entrega de Pap
-- se llena en la ficha reconsulta otra  y se marca ENTREGA PAPA que es un CONCEPT_ID = 163137
-- concept_id = 163137

select person_id from obs 
where concept_id = 163137
and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
and obs.voided = 0
group by person_id
;


-- # de examenes de pap incial total (reconsultas) PAP INICIAL EN RECONSULTA
-- papa en reconsulta  y que en primera visita tenga PAPA = NO HECHO
-- concept_id  162978 = PUENTE PAPANICOLAU REPETIDO
-- CUMPLIR LA CONDICIÓN DE PAPA=NO HECHO EN PRIMERA  CONSULTA

select person_id from obs
where concept_id = 162978 
and obs.value_coded = 1267
and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
and obs.voided = 0
-- and obs.person_id = 139
and obs.person_id in  (
select person_id from obs
where concept_id = 162972 
and obs.value_coded <> 1267
-- and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
and obs.voided = 0
-- and obs.person_id = 139
) ;


-- EXAMEN DE PAPA NO HECHO EN PAPA INICIAL
SELECT obs.person_id,  obs.concept_id, obs.value_coded FROM  obs 
WHERE 
-- obs.value_coded <> 1267
obs.concept_id = 162972
and obs.value_coded = 1118
and obs.person_id = 139
;


/* 
select person_id from obs
where concept_id = 162978 
and obs.value_coded = 1267
and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
and obs.voided = 0
-- and obs.person_id = 139
and obs.person_id
exists  
(
SELECT obs_int.person_id FROM obs obs_int
WHERE obs_int.concept_id = 162972
and obs_int.value_coded <> 1267
-- and obs_int.value_coded = 1118
and obs_int.person_id = person_id
and obs_int.voided = 0
);
  */
  


select obs.person_id, obs.value_coded from obs 
where concept_id = 162972
and obs.person_id  in (
select person_id from obs
where concept_id = 162978 
and obs.value_coded = 1267
and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
and obs.voided = 0
-- and obs.person_id = 139
) ;
   
   
-- # Clientes con EIP diagnostico en reconsulta (un examen pelvico inicial o repetido)
--  que el concept_id = 162969  con value_coded = 162968
-- y que se de un encounter_type_id= 2 (que es reconsulta )

select obs.concept_id,encounter.form_id from obs, encounter
	where obs.encounter_id = encounter.encounter_id
    and encounter.encounter_type = 2
    and concept_id = 162969
    and value_coded = 162968
    and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
    and obs.voided = 0
    ;


select * from drug
where concept_id in ( 75222, 79782, 73041) ;

select * from visit, concept
where
visit.indication_concept_id = concept_id;

select * from visit;

 