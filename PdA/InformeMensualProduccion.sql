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

-- Cantidad de pruebas de clugosa por proveedro 
select provider_id, provider_name,  count(glucosa) glucosa from (
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


 
SELECT * FROM pda_pivot_report
where patient_id = 2081;


	select   planificacion_familiar, count(*) from
	pda_pivot_report
    group by planificacion_familiar;
    
    
	select  implante, count(*) from
	pda_pivot_report
    group by implante;

	select   pastillas, count(*) from
	pda_pivot_report
    group by pastillas;
    
	select   depo, count(*) from
	pda_pivot_report
    group by depo;
    
    
				SELECT 
				obs.value_coded,  			-- encounter.encounter_type ,
                count(obs.concept_id)
				-- into var_tipo_plan_fam,  	-- var_tip_consul_plan_fam, 
                -- var_cant_plan_fam
				FROM obs, encounter
				WHERE 
				obs.encounter_id = encounter.encounter_id
				and obs.concept_id = 162971 -- PLANIFICACION FAMILIAR
				and obs.voided = 0 
				and encounter.voided = 0
				-- and obs.person_id = var_patient_id
                -- and obs.encounter_id = var_encounter_id
				and obs.obs_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
				group by obs.value_coded;      
                
        if (var_tipo_plan_fam = 7873) then
        elseif (var_tipo_plan_fam = 907 ) then
        elseif (var_tipo_plan_fam =104625 ) then                