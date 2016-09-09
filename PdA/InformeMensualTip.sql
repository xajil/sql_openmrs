/* Informe Mensual PdA */

-- concepto Ciclo de préstamo
-- No cambia el ciclo de préstamo dentro del mismo mes. 
-- buscar el ciclo de prestamo más reciente.
select concept_name.name, concept.* from concept
inner join concept_name
on concept.concept_id = concept_name.concept_id
where concept.concept_id = 163138
and concept_name.voided=0
and locale = 'es';

select value_numeric as ciclo_de_prestamo from obs where concept_id = 163138;



select 
     patient_identifier.identifier, patient_identifier.* 
     from patient_identifier
     where patient_identifier.identifier = 45665;

select * from obs
where concept_id = 162972
and person_id = 1856;

/* 
Concepto llamado# examen pelvico inicial- tota. (concept_id= 162991 y value_coded = 1267 en la observacion) Validar si Form es de Primera Visita.
En Agencia sololá las señoras que tienen CiclodePrestamo >= 3 (El más certero el Concepto) Utilizar también la ficha de primera visita.+
En Agencia sololá las señoras que tienen CiclodePrestamo < 3 (El más certero el Concepto, buscar la ultima obs con este concepto ) También validar ficha de primera visita
*/ 
select * from concept
inner join concept_name
on concept.concept_id = concept_name.concept_id
where concept.concept_id = 162991 -- value_coded=1267
and concept_name.voided=0
and locale = 'es';


-- EIP Enfermedad Inflamatoria Pélvica
-- Examen bimanual y con espéculo: <obs conceptId="162969"/>
/*
Concepto llamado Examen bimanual y con espéculo, resultados y que apareza como Hecho. 
(concept_id= 162969 y value_coded = 162968 en la observacion) (EIP Enfermedad Inflamatoria Pélvica)
# clientes con EIP recibiendo tratamiento
# pareja recibiendo EIP tratamiento
*/
select * from concept
inner join concept_name
on concept.concept_id = concept_name.concept_id
where concept.concept_id = 162969 -- value_coded=162968
and concept_name.voided=0
and locale = 'es';

-- Ejemplo de paciente:
select 
     patient_identifier.identifier, patient_identifier.* 
     from patient_identifier
     where patient_identifier.identifier = 1931;

-- Ejemplo de observacion que cumple criterio
select * from obs
where concept_id = 162969
and person_id = 186;

	-- EIP Enfermedad Inflamatoria Pélvica Identificada en Primera Consulta, 
	-- Ref(en ficha de Examen Pélvico e ITS existe otro concept_id =156660 que corresponde a Reconsulta)
	-- Con tratamiento obs conceptId=163057
    -- obs.value_coded= 2 = ("NO" TIENE TRATAMIENTO)
    -- obs.value_coded=1  ("SI" TIENE TRATAMIENTO)
    
/* BUSCAR MEJOR POR REGIMEN  Y NO POR EL CONCEPTO ACA COMENTADO 
select * from obs
where concept_id = 163057
and  voided=0
and value_coded =1
and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
;
*/
-- and person_id = 1604;

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


select 
     patient_identifier.identifier, patient_identifier.* 
     from patient_identifier
     where patient_id= 1604;
-- 1604 

	-- Con tratamiento obs conceptId=163057
select * from obs
where concept_id = 163057
and  voided=0
and value_coded =2;
-- and person_id = 1604;

select 
     patient_identifier.identifier, patient_identifier.* 
     from patient_identifier
     where patient_id= 1576;

select * from obs
where concept_id = 163057
and  voided=0
-- and value_coded =1;
and person_id = 1576;


select 
     patient_identifier.identifier, patient_identifier.* 
     from patient_identifier
     where patient_identifier.identifier = 31705;

/*
# glucosa inicial (nuevos pacientes)
# clientes eligibles-glucosa inicial 
# clientes no eligibles-glucosa inicial 
# glucosa elevada
 */
select * from concept
inner join concept_name
on concept.concept_id = concept_name.concept_id
where concept.concept_id = 163130
and concept_name.voided=0
and locale = 'es';

select * from obs
where concept_id = 163130
and  voided=0
and value_coded = 1267; -- 1267 = hecho
-- and person_id = 1604;

-- GLUCOSA ELEVADA
-- Campo Calculado ENTRE GLUCOSA EN AYUNAS >126  Y GLUCOSA AL AZAR > 200

-- GLUCOSA EN AYUNAS  
select * from concept
inner join concept_name
on concept.concept_id = concept_name.concept_id
where concept.concept_id = 160912
and concept_name.voided=0
and locale = 'es';

select case when (value_numeric>126) then 'Glucosa_elevada' else 'Normal' end, obs.*
 from obs
where concept_id = 160912
and  voided=0
and value_numeric > 126
and person_id= 1521; 

-- o GLUCOSA AL AZAR 

select * from concept
inner join concept_name
on concept.concept_id = concept_name.concept_id
where concept.concept_id = 887
and concept_name.voided=0
and locale = 'es';

select case when (value_numeric>200) then 'Glucosa_elevada' else 'Normal' end, obs.*
 from obs
where concept_id = 887
and  voided=0
and value_numeric > 200
and person_id= 678 ; 



-- ejemplo: 
select 
     patient_identifier.identifier as numero_open, patient_identifier.* 
     from patient_identifier
     where patient_id= 678;
     
     
     
/* # Presion arterial (nuevos pacientes)
    */
select concept.* from concept
inner join concept_name
on concept.concept_id = concept_name.concept_id
where concept.concept_id = 5085
-- and concept_name_id=127387
and concept_name.voided=0
and locale = 'es';

/*
que la presion arterial sistólica sea >= 140 (concept_id=5085 ) o que la presion arterial diastolica >=90 (concept_id = 5086) 
y que sea en una ficha de primera visita
*/

select case when (value_numeric >= 140) then 'Presion Arterial Elevada' else 'Normal' end, obs.*
 from obs
where concept_id = 5085 -- sistolica
and  voided=0
and value_numeric >= 140
-- and person_id= 678 
union
select case when (value_numeric >= 90) then 'Presion Arterial Elevada' else 'Normal' end, obs.*
 from obs
where concept_id = 5086 -- diastolica
and  voided=0
and value_numeric >= 90
; 


-- # Pruebas de embarazos (nuevos pacientes)
-- que vengan de una ficha de primera consulta 

select concept_name.* from concept
inner join concept_name
on concept.concept_id = concept_name.concept_id
where concept.concept_id = 45
-- and concept_name_id=127387
and concept_name.voided=0
and locale = 'es';


    
select value_coded, count(*)
 from obs
where concept_id = 45 
and  voided=0
group by value_coded
;
/*
664	    186  (Negativo)
703	    50   (Positivo)
-- 1118	1303 (No se hizo) esta no se cuenta
1304	1    (Muestra de Baja Calidad)
1138    0    (Indeterminado)
*/     
    
-- Mujeres embarazadas actualmente 
--  ESTADO DE MENSTRUACION  y 	PORQUE NO TIENE UN MÉTODO DE PLANIFICACION FAMILIAR 
select value_coded, count(*) 
 from obs
where concept_id = 160596 -- ESTADO DE MENSTRUACION 
and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
and value_coded = 1434
group by value_coded
;                    

select value_coded, person_id 
 from obs
where concept_id = 163066 -- porque no le dio planificacion
and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
and value_coded = 1434
and obs.voided = 0
group by value_coded, person_id;


select  value_coded, person_id -- , count(*) 
 from obs
where concept_id = 160596   -- estado de menstraucion
and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
and value_coded = 1434
and obs.voided = 0
union
select value_coded, person_id 
 from obs
where concept_id = 163066 -- porque no le dio planificacion
and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
and value_coded = 1434
and obs.voided = 0
group by value_coded, person_id
;   

-- Mujeres embarazadas actualmente 
--  ESTADO DE MENSTRUACION  y 	PORQUE NO TIENE UN MÉTODO DE PLANIFICACION FAMILIAR 
select  person_id -- , count(*) 
 from obs
where concept_id = 160596   -- estado de menstraucion
and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
and value_coded = 1434
and obs.voided = 0
union
select person_id 
 from obs
where concept_id = 163066 -- porque no le dio planificacion
and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
and value_coded = 1434
and obs.voided = 0
UNION 
select  person_id 
 from obs
where concept_id = 5272 -- EMBARAZADA ACTUALMENTE
and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
and value_coded = 1065
and obs.voided = 0
group by  person_id
;   


select value_coded, count(*) 
 from obs
where concept_id = 160596 -- estatus de menstruación 
and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
group by value_coded
;         

	
-- # Examenes de ETS (mujeres embarazadas)
select concept_name.* from concept
inner join concept_name
on concept.concept_id = concept_name.concept_id
where concept.concept_id = 162992 -- (1040 , 1619, 1322)   -- and concept_name_id=127387
and concept_name.voided=0
and locale = 'es';    
    
    
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
    /*
1118	278 -- no se hizo
1267	38 -- hecho     
    */
    
-- # Examenes de ETS (mujeres embarazadas)
-- ITS positivo 
select concept_name.* from concept
inner join concept_name
on concept.concept_id = concept_name.concept_id
where concept.concept_id in (1040 , 1619, 1322)   -- and concept_name_id=127387
and concept_name.voided=0
and locale = 'en'
;   

select value_coded, count(*)
 from obs
where concept_id in (1040 , 1619, 1322)
and  voided=0
group by value_coded;
-- 664	79 NEGATIVO
-- 1067	1  
--  703    POSITIVO    


-- # Examenes de seno- (nuevos pacientes)
select concept_name.* from concept
inner join concept_name
on concept.concept_id = concept_name.concept_id
where concept.concept_id = 162990
and concept_name.voided=0
-- and locale = 'es'
;    
    
select value_coded, count(*)
 from obs
where concept_id = 162990 
and  voided=0
group by value_coded
;
/*
1118	346  --  NO HECHO 
1267	1579 --  HECHO
*/

-- examen de seno anormal 
select concept_name.* from concept
inner join concept_name
on concept.concept_id = concept_name.concept_id
where concept.concept_id = 159780
and concept_name.voided=0
and locale = 'es'
; 

select value_coded, count(*)
 from obs
where concept_id = 159780 
and  voided=0
AND VALUE_CODED IN (146931, 148058, 142248 ) 
group by value_coded
;

/* 
1115	1466 = NORMAL
146931	5    = BULTO MAMARIO
148058	1    = LINFADENOPATIA AXILAR
142248	2    = DERRAME POR EL PEZON

118620	1    = CONGESTION MAMARIA
149670	4    =
150623	2    = 
*/


select *
 from obs
where concept_id = 159780 
and  value_coded = 118620
;

select 
     patient_identifier.identifier as numero_open, patient_identifier.* 
     from patient_identifier
     where patient_identifier.patient_id = 1137;
     

# Clientes en total iniciando planificacion familiar (de WK)- (nuevos pacientes)
     select concept_name.* from concept
inner join concept_name
on concept.concept_id = concept_name.concept_id
where concept.concept_id = 162971
and concept_name.voided=0
-- and locale = 'es'
;    
    
select value_coded, count(*)
 from obs
where concept_id = 162990 
and  voided=0
group by value_coded
;


/* --- */
# de clientes total que recibieron un implante (dura 4 años) (nuevos pacientes) (ficha de primera visita=)
     select concept_name.* from concept
inner join concept_name
on concept.concept_id = concept_name.concept_id
where concept.concept_id = 162971
and concept_name.voided=0
and locale = 'es'
;    
    
select value_coded, count(*)
 from obs
where concept_id = 162971 
and  voided=0
group by value_coded
;
/*
# value_coded, count(*)   VALUE_CODED descripcion
'907',         '292'      DEPO-PROVERA (INYECCIÓN DE 3 MESES) 
'1107',        '1666'     NINGUNO 
'1873',        '34'       IMPLANTE QUE DURA 4 AÑOS
'104625',      '22'       PASTILLAS ANTICONCEPTIVAS
*/ 
     
     
     
     
     
/*************************************************************************************************************/
/* Incident con concepto 156660 de ITS */     
select obs_id from obs
where concept_id = 156660
and  voided=0
-- and value_coded =1;
and person_id = 491;

Select encounter.encounter_id,
	encounter.encounter_type,
    encounter.patient_id, 
    encounter.location_id,
    encounter.encounter_datetime, 
    encounter.form_id,
    obs.obs_id, 
    obs.person_id,
    obs.concept_id,
    obs.obs_datetime,
    obs.*
    from encounter, obs
	WHERE encounter.encounter_id=obs.encounter_id 
			and patient_id = 491
            and obs.concept_id = 156660
            and obs.voided = 0
            and encounter.voided = 0
            order by encounter.encounter_id
            ; 
