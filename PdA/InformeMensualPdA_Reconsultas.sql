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


/*DETERMINAR TRATAMIENTO DE EIP POR SU RÉGIMEN DE MEDICAMENTOS
es mejor esta validación que la del concepto 
*/
select orders.patient_id,count(orders.concept_id), 
patient_id -- , drug.name  
from drug_order, drug, orders
where drug_order.drug_inventory_id = drug.drug_id
and drug_order.order_id = orders.order_id
-- and orders.patient_id = 491
and orders.discontinued = 1
and orders.concept_id IN( 73041, 75222, 79782) --  juntos siempre
and orders.start_date  between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
group by orders.patient_id
having count(orders.concept_id) = 3
order by orders.patient_id;




/**********************************************************************************/
-- TRATAMIENTO PARA INFLAMACION SERVERA, COMO RESULTADO DE PAPA 
-- O COMO FICHA DE PRIMERA CONSULTA --

SELECT * FROM obs
where concept_id = 162974 -- Inflamación severa 
-- este concepto es respuesta de concept_id 885
;

/* PAP ENTREGADO 
CON RESULTADO DE 
INFLAMACIÓN SEVERA 
LA FICHA ES FORMA_ID 12 QUE CORRESPONDE A FICHA DE RECONSULTA "RESULTADOS_PAPANICOLAOU_Y_COLPOSCOPIA"
 */
select  
-- distinct(person_id)
value_coded, value_numeric, encounter.form_id, patient_id 
from obs, encounter
where 
encounter.encounter_id = obs.encounter_id
and concept_id = 885
and value_coded = 162974 
and form_id = 12
and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
;

/* DETERMINAR SI INFLAMACION SEVERA ESTÁ CON TRATAMIENTO */
select  
-- distinct(person_id)
value_coded, value_numeric, encounter.form_id , person_id
from obs, encounter
where 
encounter.encounter_id = obs.encounter_id
and concept_id = 162979
and value_coded = 162982  
and obs.voided = 0
-- and patient_id = 
-- and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
;

-- DETERMINAR SI PACIENTE TIENE TRATAMIENTO INFLAMACION SEVERA POR MEDIO DE SU ORDEN DE DROGAS
-- DEBERÍA TENERER  concept_id = 73041, 71780,79782 juntos siempre
select orders.patient_id, count(orders.concept_id), patient_id  from drug_order, drug, orders
where drug_order.drug_inventory_id = drug.drug_id
and drug_order.order_id = orders.order_id
-- and orders.patient_id = 1497 
and orders.discontinued = 1
and orders.concept_id IN( 73041, 71780, 79782) --  juntos siempre
and orders.start_date  between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
group by orders.patient_id
having count(orders.concept_id) = 3
order by orders.patient_id;


/* determinar personas con tratamiento de 
VAGINOSIS VACTERIANA
*/
select orders.patient_id, count(orders.concept_id) -- , drug.name  
from drug_order, drug, orders
where drug_order.drug_inventory_id = drug.drug_id
and drug_order.order_id = orders.order_id
-- and orders.patient_id = 491
and orders.discontinued = 1
and orders.concept_id = 79782 --  juntos siempre
AND orders.concept_id NOT IN (73041, 71780, 75222 )
and orders.start_date  between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
group by orders.patient_id
-- having count(orders.concept_id) = 3
order by orders.patient_id;


/* determinar personas con tratamiento de 
CANDIDIASIS VAGINAL
*/
select orders.patient_id, count(orders.concept_id) -- , drug.name  
from drug_order, drug, orders
where drug_order.drug_inventory_id = drug.drug_id
and drug_order.order_id = orders.order_id
and orders.discontinued = 1
and orders.concept_id = 960 
and orders.start_date  between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
group by orders.patient_id
order by orders.patient_id;


/* EXAMENTES ETS HECHOS EN EMBARAZADAS */
/* TOTAL DE MUJERES CON EXAMENES ETS 
HECHO = 1267
NO_HECHO = 1118
*/    
select value_coded, obs.*
 from obs
where concept_id = 162992 -- EXAMENES DE ETS EN MUJERES EMBARAZADA
and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
and  voided=0
and value_coded = 1267
-- group by value_coded
;


/* PRUEBA VIH 
VALUECODED PARA Negativo (664)
VALUECODED PARA  Positivo (703)
VALUECODED PARA  Muestra de baja calidad (1304)*/
select value_coded, obs.*
 from obs
where concept_id = 1040 -- EXAMENES VIH
and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
and  voided=0
;

		/* PRUEBA VIH POSITVO */
		select value_coded, obs.*
		 from obs
		where concept_id = 1040 -- EXAMENES VIH
		and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
		and value_coded = 703 -- POSITVO 
		and  voided=0
		;

		/* PRUEBA VIH POSITVO */
		select value_coded, obs.*
		 from obs
		where concept_id = 1040 -- EXAMENES VIH
		and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
		and value_coded = 664 -- NEGATIVO
		and  voided=0
		;

/* PRUEBA DE SÍFILIS */
select value_coded, obs.*
 from obs
where concept_id = 1619 -- EXAMENES DE Sífilis
and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
-- and value_coded = 664 -- NEGATIVO
and  voided=0
;

	select value_coded, obs.*
	 from obs
	where concept_id = 1619 -- EXAMENES DE Sífilis
	and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
	and value_coded = 103 -- POSITIVO 
	and  voided=0
	;

	select value_coded, obs.*
	 from obs
	where concept_id = 1619 -- EXAMENES DE Sífilis
	and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
	and value_coded = 664 -- NEGATIVO
	and  voided=0
	;

	select value_coded, obs.*
	 from obs
	where concept_id = 1619 -- EXAMENES DE Sífilis
	and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
	and value_coded = 1067 -- DESCONOCIDO
	and  voided=0
	;


/* PRUEBA DE HEPATITIS  
value_code para  Positivo (703)
value_code para  Negativo (664)
value_code para  Indeterminado (1138)
value_code para  Muestra de baja calidad (1304)
*/
select value_coded, obs.*
 from obs
where concept_id = 1322 -- HEPATITIS 
and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
-- and value_coded = 664 -- NEGATIVO
and  voided=0
;

select value_coded, obs.*
 from obs
where concept_id = 1322 -- HEPATITIS 
and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
and value_coded = 703 -- POSITIVO
and  voided=0
;


select value_coded, obs.*
 from obs
where concept_id = 1322 -- HEPATITIS 
and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
and value_coded = 664 -- NEGATIVO
and  voided=0
;


/* DICE QUE SE HICERON PRUEBAS DE ETS PERO NO 
EXISTE EL RESULTADO DE CADA UNA (script anidado )
*/
select value_coded, obs.*
 from obs
where concept_id = 162992 -- EXAMENES DE ETS EN MUJERES EMBARAZADA
and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
and  voided=0
and value_coded = 1267
and person_id not in (
select person_id
 from obs
where concept_id = 1040 -- EXAMENES DE ETS EN MUJERES EMBARAZADA
and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
and  voided=0)
;


/* PAP ENTREGADO 
CON RESULTADO NIC  NEOPLASIA INTRAEPITELIAL CERVICAL
LA FICHA ES FORMA_ID 12 QUE CORRESPONDE A FICHA DE RECONSULTA "RESULTADOS_PAPANICOLAOU_Y_COLPOSCOPIA"
 */
 select  
-- distinct(person_id)
value_coded, value_numeric, encounter.form_id 
from obs, encounter
where 
encounter.encounter_id = obs.encounter_id
and concept_id = 885
and value_coded in( 163096, 162975, 162976, 162977 )
and form_id = 12 
;



/**********************************************************************************************/
/* ANEXO PARA REGIMINES DE DROGA */
/**********************************************************************************************/
select * from  patient_identifier where patient_identifier.patient_id in (1739, 1923);

SELECT * FROM orders;

select distinct(obs.value_drug) from obs;

select  drug.name from drug_order, drug
where drug_order.drug_inventory_id = drug.drug_id;


/* ORDENES DE DRUGA ASIGNADOS A CADA PACIENTES 
COMO REGIMENES 
*/
select orders.patient_id,  drug.name, orders.* from drug_order, drug, orders
where drug_order.drug_inventory_id = drug.drug_id
and drug_order.order_id = orders.order_id
and orders.patient_id = 1497 
and orders.discontinued = 1
order by orders.patient_id;

