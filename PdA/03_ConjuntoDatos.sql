##########################################################################
-- Name             : Conjunto de Datos CONSULTAS
-- Date             : 20161006
-- Author           : Neftali Sacuj
-- Organization     : Wuqu' Kawoq
-- Purpose          : Reporte general de registros de Consultas
-- Usage        	: sqlplus
-- Impact   		: N/A
-- Required grants  : SELECT
-- Called by        : OpenMRS Sql Data Set
##########################################################################
-- ver  user          date        change  
-- 1.0  @nefsacuj     20161006    initial
##########################################################################
Select 	
    patient_identifier.patient_id,
    patient_identifier.identifier as client_code,
	encounter.encounter_id,
    date_format(encounter.encounter_datetime, '%Y/%m/%d') as date_encounter ,
    'N/A' encounter_start_ts,
    'N/A' encounter_end_ts,
    encounter_type.encounter_type_id,
    encounter_type.name,
    encounter_type.description, 
    location.name location_name,
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
    and date_format(encounter.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
    group by encounter.encounter_id    
    order by patient_identifier.patient_id desc	; 


##########################################################################
-- Name             : Conjunto de Datos VITALS
-- Date             : 20161006
-- Author           : Neftali Sacuj
-- Organization     : Wuqu' Kawoq
-- Purpose          : Reporte general de registros de Vitals
-- Usage        	: sqlplus
-- Impact   		: N/A
-- Required grants  : SELECT
-- Called by        : OpenMRS Sql Data Set
##########################################################################
-- ver  user          date        change  
-- 1.0  @nefsacuj     20161006    initial
##########################################################################

select 
obs.person_id, 
patient_identifier.identifier client_code, 
concept_id vitals_id,
case
when (concept_id = 5085 )then 'Systolic'
when (concept_id = 5086 )then 'Diastolic'
when (concept_id = 5090 )then 'height'
when (concept_id = 5089 )then 'weight'
else 'NA'
end vitals_name,
obs.value_numeric vitals_value, 
date_format(obs.obs_datetime,'%Y%m%d') vitals_date ,
date_format(obs.date_created,'%Y%m%d') record_date 
from encounter, obs, patient_identifier 
where
encounter.encounter_id = obs.encounter_id
and obs.person_id = patient_identifier.patient_id
and date_format(encounter.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
and concept_id in (5085,5086, 5090, 5089)
and obs.voided = 0
order by obs.person_id
;


##########################################################################
-- Name             : Conjunto de Datos DIAGNOSIS
-- Date             : 20161006
-- Author           : Neftali Sacuj
-- Organization     : Wuqu' Kawoq
-- Purpose          : Reporte general de registros de DIAGNÓSTICOS
-- Usage        	: sqlplus
-- Impact   		: N/A
-- Required grants  : SELECT
-- Called by        : OpenMRS Sql Data Set
##########################################################################
-- ver  user          date        change  
-- 1.0  @nefsacuj     20161006    initial
##########################################################################
select 
patient_identifier.patient_id,
patient_identifier.identifier client_code,
program.program_id diagnostic_code,
program.name diagnostic_name,
date_format(patient_program.date_enrolled,'%Y%m%d') enrolled_date
from  patient_identifier , patient_program, program
where
patient_identifier.patient_id = patient_program.patient_id
and patient_program.program_id = program.program_id
and date_format(patient_program.date_enrolled, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
and program.program_id in (2,7,8,9,13,15,16)
order by patient_program.patient_id
;

##########################################################################
-- Name             : Conjunto de Datos PROCEDURE / INTERVENCIÓN
-- Date             : 20161006
-- Author           : Neftali Sacuj
-- Organization     : Wuqu' Kawoq
-- Purpose          : Reporte general de registros de PROCEDURE / INTERVENCIÓN
-- Usage        	: sqlplus
-- Impact   		: N/A
-- Required grants  : SELECT
-- Called by        : OpenMRS Sql Data Set
##########################################################################
-- ver  user          date        change  
-- 1.0  @nefsacuj     20161006    initial
##########################################################################

select 
obs.person_id, 
patient_identifier.identifier client_code, 
concept_id procedure_code,
case
when (concept_id = 162990 )then 'examen de seno '
when (concept_id = 162972 )then 'pap'
when (concept_id = 162978 )then 'pap repetido'
when (concept_id = 162991 )then 'examen pélvico'
else 'NA'
end procedure_name,
date_format(obs.obs_datetime, '%Y%m%d') procedure_date, 
date_format(obs.date_created,'%Y%m%d')  record_date
from encounter, obs, patient_identifier 
where
encounter.encounter_id = obs.encounter_id
and obs.person_id = patient_identifier.patient_id
and date_format(encounter.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
and obs.voided = 0
and concept_id in (
162990, 
162972,  
162978,  
162991 
)
and value_coded = 1267 
order by obs.person_id
;

-- ORDENES DE TRATAMIENTO --

##########################################################################
-- Name             : Conjunto de Datos LABORATORY
-- Date             : 20161006
-- Author           : Neftali Sacuj
-- Organization     : Wuqu' Kawoq
-- Purpose          : Reporte general de registros de LABORATORIOS
-- Usage        	: sqlplus
-- Impact   		: N/A
-- Required grants  : SELECT
-- Called by        : OpenMRS Sql Data Set
##########################################################################
-- ver  user          date        change  
-- 1.0  @nefsacuj     20161006    initial
##########################################################################
select 
obs.person_id, patient_identifier.identifier client_code, 
concept_id labs_id,
case
when (concept_id = 160912 ) then 'Gucosa AYUNAS'
when (concept_id = 887 )    then 'Glucosa_azar'
when (concept_id = 45 )     then 'Prueba de embarazo'
when (concept_id = 885 )    then 'Resultados Pap'
when (concept_id = 1040 )   then 'Resultados VIH'
when (concept_id = 1619 )   then 'Resultados sífilis'
when (concept_id = 1322 )   then 'Resultados Hepatitis'
end labs_name,
case
when (obs.value_coded is null) then obs.value_numeric
when (obs.value_numeric is null) then obs.value_coded
else 0
end value_result,
case
when (obs.value_coded = 664	) then 'NEGATIVE'
when (obs.value_coded = 703 ) then 'POSITIVE'
when (obs.value_coded = 1118 ) then 'NOT DONE'
when (obs.value_coded = 1115 ) then 'NORMAL'
when (obs.value_coded = 159261 ) then 'vaginal atrophy'
when (obs.value_coded = 162973 ) then 'Moderate Inflammation'
when (obs.value_coded = 162974 ) then 'Severe Inflammation'
when (obs.value_coded = 163096 ) then 'CIS NOS'
when (obs.value_coded = 163101 ) then 'Slight inflammation'
else 'N/A'
end result_description,
date_format(obs.obs_datetime,'%Y%m%d') lab_date ,
date_format(obs.date_created,'%Y%m%d') record_date
from encounter, obs, patient_identifier
where
encounter.encounter_id = obs.encounter_id
and obs.person_id = patient_identifier.patient_id
and obs.voided = 0
-- and patient_identifier.patient_id = 102
and date_format(encounter.encounter_datetime, '%Y%m%d')  between '20160801' and '20160831'
and concept_id in (
160912, 
887, 
45,  
885,  
1040,
1619, 
1322 
)
order by obs.person_id
;


##########################################################################
-- Name             : Conjunto de Datos Tratamientos
-- Date             : 20161006
-- Author           : Neftali Sacuj
-- Organization     : Wuqu' Kawoq
-- Purpose          : Reporte general de registros de ordenes de droga para tratamientos.
-- Usage        	: sqlplus
-- Impact   		: N/A
-- Required grants  : SELECT
-- Called by        : OpenMRS Sql Data Set
##########################################################################
-- ver  user          date        change  
-- 1.0  @nefsacuj     20161006    initial
-- 1.1  @nefsacuj     20161110    cambio de orders.discontinued por orders.voided para tomar los réginemes vigentes.
##########################################################################
select 
orders.patient_id,
patient_identifier.identifier,  
drug.name, 
dose,
drug_order.units,
frequency,
date_format(orders.start_date, '%Y%m%d') start_date
from drug_order, drug, orders, patient_identifier
where drug_order.drug_inventory_id = drug.drug_id
and drug_order.order_id = orders.order_id
and orders.patient_id = patient_identifier.patient_id
and date_format(orders.start_date, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
and orders.voided = 0
and patient_identifier.voided = 0
order by orders.patient_id;


##########################################################################
-- Name             : Conjunto de Datos Entrega de Pap
-- Date             : 20161006
-- Author           : Neftali Sacuj
-- Organization     : Wuqu' Kawoq
-- Purpose          : Reporte general de registros de fechas de Entrega de Resultados Pap.
-- Usage        	: sqlplus
-- Impact   		: N/A
-- Required grants  : SELECT
-- Called by        : OpenMRS Sql Data Set
##########################################################################
-- ver  user          date        change  
-- 1.0  @nefsacuj     20161006    initial
##########################################################################

select 
obs.person_id, patient_identifier.identifier code_client,
date_format(obs.obs_datetime,'%Y%m%d') obs_datetime, 
encounter_provider.provider_id
from obs, encounter, patient_identifier, encounter_provider
	where 
    encounter.encounter_id = obs.encounter_id
    and encounter.encounter_id = encounter_provider.encounter_id
    and patient_identifier.patient_id = obs.person_id
    and obs.concept_id = 163137
    and date_format(encounter.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
    and obs.voided = 0;
