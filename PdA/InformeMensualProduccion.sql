##########################################################################
-- Name             : Informe de Produccion Mensual PdA
-- Date             : 20160913
-- Author           : Neftali Sacuj
-- Organization     : Wuqu' Kawoq
-- Purpose          : Generar el informe mensual de producción clínica por cada enfermera.
-- Usage        	: sqlplus
-- Impact   		: N/A
-- Required grants  : SELECT
-- Called by        : OpenMRS Sql Data Set
##########################################################################
-- ver  user      date        change  
-- 1.0  Sacuj     20160913    initial
##########################################################################

-- CANTIDAD DE PACIENTES POR PROVEEDOR 
select provider.provider_id,  b.* from provider , -- Cantidad de pacientes por proveedor
(
	select provider_id, provider_name,  count(patient_id) pacientes from (
		select  distinct(patient_id), provider_id, provider_name from
		pda_pivot_report
		-- where 
		-- provider_id = 15
		group by encounter_datetime,  patient_id, provider_id 
	) a
	where provider_id <>  17 -- not in (18, 17)
	group by provider_id
-- ; 
) b
where provider.provider_id = b.provider_id;

-- cantidad de pacientes embarazadas por proveedor
-- proviene del campo embarazada_o_examen_positivo que contiene las mujeres con examen positivo más 
-- las que sin examen son diagnosticadas como embarazadas.
select provider_id, provider_name,  count(DISTINCT PATIENT_ID)  from (
	select   patient_id, embarazada , encounter_datetime, provider_id, provider_name  from
	pda_pivot_report
    where embarazada = 1
 ) a
where provider_id not in (18, 17)
group by provider_id
;


-- Cantidad de pruebas de clugosa por proveedro 
select provider_id, provider_name,  count(DISTINCT PATIENT_ID) glucosa from (
	select   patient_id, glucosa_azar glucosa, encounter_datetime, provider_id, provider_name  from
	pda_pivot_report
    where glucosa_azar <> -1
    -- and provider_id = 20
    union 
 	select   patient_id, glucosa_ayunas glucosa, encounter_datetime, provider_id, provider_name  from
	pda_pivot_report
    where glucosa_ayunas <> -1
    -- and provider_id = 20
    group by encounter_datetime, patient_id
 ) a
where provider_id not in (18, 17)
group by provider_id
;
/*
	select   patient_id, glucosa_azar, encounter_datetime, provider_id, provider_name ,count(*)  from
	pda_pivot_report
    where glucosa_azar <> -1
    and provider_id = 20
    group by encounter_datetime, patient_id
    -- having count(*) > 1
    ;
	select   patient_id, glucosa_ayunas, encounter_datetime, provider_id, provider_name ,count(*)  from
	pda_pivot_report
    where glucosa_ayunas <> -1
    and provider_id = 20
    group by encounter_datetime, patient_id
    -- having count(*) > 1
    ;
*/


-- Cantidad de pruebas ETS 
select provider_id, provider_name,  count(ets) ets from (
	select   patient_id, ets , encounter_datetime, provider_id, provider_name  from
	pda_pivot_report
    where ets <> -1
 ) a
where provider_id not in (18, 17)
group by provider_id
;

-- Cantidad de pruebas vih
select provider_id, provider_name,  count(vih) vih from (
	select   patient_id, vih , encounter_datetime, provider_id, provider_name  from
	pda_pivot_report
    where vih <> -1
 ) a
where provider_id not in (18, 17)
group by provider_id
;


-- Cantidad de pruebas sifilis
select provider_id, provider_name,  count(sifilis) sifilis from (
	select   patient_id, sifilis , encounter_datetime, provider_id, provider_name  from
	pda_pivot_report
    where sifilis <> -1
 ) a
where provider_id not in (18, 17)
group by provider_id
;

-- Cantidad de pruebas hepatitis_b
select provider_id, provider_name,  count(hepatitis_b) hepatitis_b from (
	select   patient_id, hepatitis_b , encounter_datetime, provider_id, provider_name  from
	pda_pivot_report
    where hepatitis_b <> -1
 ) a
 where provider_id not in (18, 17)
group by provider_id;


-- Cantidad Planificación Familiar DEPO
select provider_id, provider_name,  count(depo) depo from (
	select   patient_id, depo , encounter_datetime, provider_id, provider_name  from
	pda_pivot_report
    where depo <> -1
    and depo = 1
 ) a
 where provider_id not in (18, 17)
group by provider_id;

-- Cantidad Planificación Familiar Implantes
select provider_id, provider_name,  count(implante) implante from (
	select   patient_id, implante , encounter_datetime, provider_id, provider_name  from
	pda_pivot_report
    where implante <> -1
    and implante = 1
 ) a
 where provider_id not in (18, 17)
group by provider_id;

-- Cantidad Planificación Familiar Pastillas
select provider_id, provider_name,  count(pastillas) pastillas from (
	select   patient_id, pastillas , encounter_datetime, provider_id, provider_name  from
	pda_pivot_report
    where pastillas <> -1
    and pastillas = 1
 ) a
 where provider_id not in (18, 17)
group by provider_id;

-- TOTAL DE CONSULTAS INICIALES
select   provider_id, provider_name , count(encounter_id) from
	pda_pivot_report
    where tipo_consulta = 1  --  1 CONSULTAS INICIALES
    group by provider_id; 
    
-- TOTAL DE RECONSULTAS POR PROVIDER
select   provider_id, provider_name , count(distinct patient_id) from
	pda_pivot_report
    where tipo_consulta = 2  --  2 RECONSULTAS
    group by provider_id
    ; 


-- HASTA AQUÍ LLEGAMOS 

-- TOTAL DE PACIENTES EN RECONSULTA 
select   count(distinct patient_id) from
	pda_pivot_report
    where tipo_consulta = 2  --  2 RECONSULTAS
      ; 
    
select distinct(patient_id) from encounter
where encounter.encounter_type = 2
and voided = 0
and encounter.encounter_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') ;
    
    
    
-- TOTAL PAPA EN PRIMERA VISITA    
select   provider_id, provider_name, count(distinct PATIENT_ID) from
	pda_pivot_report
    where pap = 1267 
    and tipo_consulta = 1  
    group by provider_id;     
    
-- TOTAL PAPA EN RECONSULTA
select  provider_id, provider_name, count(distinct PATIENT_ID) from
	pda_pivot_report
    where pap = 1267 
    and tipo_consulta = 2
    group by provider_id;     



-- TOTAL DE PRUEBAS DE EMBARAZO
select  provider_id, provider_name, count(distinct PATIENT_ID) from
	pda_pivot_report
    where prueba_embarazo = 1 
    group by provider_id;  


-- TOTAL DE TRATAMIENTO DE EIP
select  provider_id, provider_name, count(distinct PATIENT_ID) from
	pda_pivot_report
    where eip_tratamiento = 1 
    group by provider_id;  
    
    
-- TOTAL DE TRATAMIENTO INFLAMACION SEVERA 
-- PATIENT_ID,, PATIENT_ID
select  provider_id, provider_name, count(distinct PATIENT_ID) from
	pda_pivot_report
    where trat_inflam_severa = 1 
    group by provider_id;      

-- TOTAL DE TRATAMIENTO VAGINOSIS BACTERIANA
select  provider_id, provider_name, count(distinct PATIENT_ID) from
	pda_pivot_report
    where trat_vaginosis_bac = 1 
    group by provider_id;     

-- TOTAL DE TRATAMIENTO CANDIDIASIS VAGINAL
select  provider_id, provider_name, count(distinct PATIENT_ID) from
	pda_pivot_report
    where trat_candidiasis_vag = 1 
    group by provider_id;   
    

  
    