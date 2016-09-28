##########################################################################
-- Name             : Informe de Produccion Mensual PdA
-- Date             : 201600924
-- Author           : Neftali Sacuj
-- Organization     : Wuqu' Kawoq
-- Purpose          : Conteos Nivel de Producción PdA
-- Usage        	: sqlplus
-- Impact   		: N/A
-- Required grants  : SELECT
-- Called by        : OpenMRS Sql Data Set
##########################################################################
-- ver  user      date        change  
-- 1.0  @nefsacuj     20160924    initial
##########################################################################
select 'Pacientes' NombreCampo, count(distinct patient_id) total_solola
		from pda_pivot_report
		where tipo_consulta in (1,2)
union 
select 'Embarazadas' NombreCampo, count(distinct patient_id) total_solola
		from pda_pivot_report
		where  embarazada = 1
union        
select 'Consultas Iniciales' NombreCampo, count(encounter_id) total_solola
		from pda_pivot_report
		where tipo_consulta = 1 --  Consultas Iniciales
union 
select 'Pacientes en Reconsultas' NombreCampo, count(distinct patient_id) total_solola -- t 
		from pda_pivot_report
		where tipo_consulta = 2  --  2 RECONSULTAS 
union         
select 'Numero Reconsultas' NombreCampo, count(*)  total_solola from (
select  patient_id,  count(encounter_datetime) 
from pda_pivot_report
	where tipo_consulta = 2    
	group by encounter_datetime, patient_id    
    order by patient_id desc
    ) b    
union 
select 'Glucosa' NombreCampo, count(distinct patient_id) total_solola
		from pda_pivot_report
        where glucosa_azar <> -1 or glucosa_ayunas <> -1
union
select 'Pap' NombreCampo, count(distinct patient_id) total_solola
		from pda_pivot_report
		where pap = 1267
union 
select 'ETS' NombreCampo, count(distinct patient_id) total_solola    
		from pda_pivot_report
		where ets <> -1 
union 
select 'Planificacion' NombreCampo, count(distinct patient_id) total_solola	
		from pda_pivot_report
		where implante = 1 or pastillas = 1 or depo = 1
union 
select 'Tratamiento Inflamacion Severa' NombreCampo, count(distinct patient_id) total_solola	
		from pda_pivot_report
		where trat_inflam_severa = 1
union 
	select  'Vaginosis' NombreCampo, count(distinct patient_id) total_solola
		from pda_pivot_report
		where trat_vaginosis_bac = 1 
union 
	select  'Candidiasis' NombreCampo, count(distinct patient_id) total_solola	
		from pda_pivot_report
		where trat_candidiasis_vag = 1 
union 
	select 'Examen Pelvico' NombreCampo, count(distinct patient_id) total_solola 
    from pda_pivot_report 
	where pelvico = 1267
union 
	select 'Examen de Seno' NombreCampo, count(distinct patient_id) total_solola 
    from pda_pivot_report 
	where seno_examen <> -1 
union 
	select 'Presion Arterial' NombreCampo, COUNT(DISTINCT(PATIENT_ID)) total_solola 
    from pda_pivot_report 
	where presion_sistolica <> -1
    or presio_diastolica <> -1
    
union    
	select 'Tratamiento EIP' NombreCampo, count( distinct patient_id) total_solola 
    from pda_pivot_report 
	where eip_tratamiento = 1 ;

    
    /* 
union
select 'Pacientes' NombreCampo, count(distinct patient_id) total_solola
		from pda_pivot_report
		where tipo_consulta in (1,2)
union 
select 'Embarazadas' NombreCampo, count(distinct patient_id) total_solola
		from pda_pivot_report
		where  embarazada = 1
union        
select 'Consultas Iniciales' NombreCampo, count(encounter_id) total_solola
		from pda_pivot_report
		where tipo_consulta = 1 --  Consultas Iniciales
union 
select 'Pacientes en Reconsultas' NombreCampo, count(distinct patient_id) total_solola -- t 
		from pda_pivot_report
		where tipo_consulta = 2  --  2 RECONSULTAS 
union         
select 'Numero Reconsultas' NombreCampo, count(*)  total_solola from (
select  patient_id,  count(encounter_datetime) 
from pda_pivot_report
	where tipo_consulta = 2    
	group by encounter_datetime, patient_id    
    order by patient_id desc
    ) b    
union 
select 'Glucosa' NombreCampo, count(distinct patient_id) total_solola
		from pda_pivot_report
        where glucosa_azar <> -1 or glucosa_ayunas <> -1
union
select 'Pap' NombreCampo, count(distinct patient_id) total_solola
		from pda_pivot_report
		where pap = 1267
union 
select 'ETS' NombreCampo, count(distinct patient_id) total_solola    
		from pda_pivot_report
		where ets <> -1         
union 
select 'Planificacion' NombreCampo, count(distinct patient_id) total_solola	
		from pda_pivot_report
		where 
		implante = 1 or pastillas = 1 or depo = 1
union 
select 'Tratamiento Inflamacion Severa' NombreCampo, count(distinct patient_id) total_solola	
		from pda_pivot_report
		where trat_inflam_severa = 1
union 
	select  'Vaginosis' NombreCampo, count(distinct patient_id) total_solola
		from pda_pivot_report
		where trat_vaginosis_bac = 1 
union 
	select  'Candidiasis' NombreCampo, count(distinct patient_id) total_solola	
		from pda_pivot_report
		where trat_candidiasis_vag = 1 
union 
	select 'Examen Pelvico' NombreCampo, count(distinct patient_id) total_solola 
    from pda_pivot_report 
	where pelvico = 1267
union 
	select 'Examen de Seno' NombreCampo, count(distinct patient_id) total_solola 
    from pda_pivot_report 
	where seno_examen <> -1     
union 
	select 'Presion Arterial' NombreCampo, COUNT(DISTINCT(PATIENT_ID)) total_solola 
    from pda_pivot_report 
	where 
    presion_sistolica <> -1
    or presio_diastolica <> -1   
union    
	select 'Tratamiento EIP' NombreCampo, count( distinct patient_id) total_solola 
    from pda_pivot_report 
	where eip_tratamiento = 1     
;
*/


select distinct(agencia) from pda_pivot_report;

-- agencias sololá
-- 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,

-- agencia chimaltenango
-- 26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,


-- examen pelvico
select 'Examen Pelvico' NombreCampo, count(distinct patient_id) total from pda_pivot_report 
	where pelvico = 1267
    ; 

-- examen de seno 
select 'Examen de Seno' NombreCampo, count(distinct patient_id) total from pda_pivot_report 
	where seno_examen <> -1 
    ;  

-- presion arterial 
select 'Presion Arterial' NombreCampo, COUNT(DISTINCT(PATIENT_ID)) total from pda_pivot_report 
	where presion_sistolica <> -1
    or presio_diastolica <> -1;

-- tratamiento eip (PID)
select 'Tratamiento EIP' NombreCampo, count( distinct patient_id) total from pda_pivot_report 
	where eip_tratamiento = 1 
    ;    
  
    
-- planificacion familiar 
-- NO FUNCIONA PORQUE APARECE EL CONCEPTO PERO TIENE VALOR 1107 PARA NINGUNO QUE ACTUALMENTE NO SE DISCRIMINA
select count(planificacion_familiar), planificacion_familiar from pda_pivot_report 
group by planificacion_familiar;
	-- where planificacion_familiar = 1 ;    

select 'Planificacion' NombreCampo, count(distinct patient_id) total	
		from pda_pivot_report
		where implante = 1 or pastillas = 1 or depo = 1;
        
-- libro de indicadores de desempeño hoja: EFICIENCIA_OPERATIVA        
-- Average patients attended by a nurse per workday
-- Promedio de Pacientes Vistos proveedor.
select provider_id,  provider_name , count(distinct patient_id)
from pda_pivot_report
where tipo_consulta in (1,2)
group by provider_id;       

select provider_id,  provider_name , count(distinct encounter_datetime)
from pda_pivot_report
where tipo_consulta in (1,2)
group by provider_id;       
   

-- hoja de estado ESTADO DE SALUD
-- no son para cada mes sino para el mes y un año atrás atraás
select distinct(vih) from   pda_pivot_report; 
select vih from   pda_pivot_report where vih=703; 

select distinct(hepatitis_b) from pda_pivot_report; 
select hepatitis_b from pda_pivot_report where vih=703;

select distinct(sifilis) from   pda_pivot_report; 
select sifilis from pda_pivot_report where vih=703; 

	select value_coded, obs.*
	 from obs
	where concept_id = 1619 -- EXAMENES DE Sífilis
	and obs.obs_datetime between  STR_TO_DATE('08/01/2015', '%m/%d/%Y') and STR_TO_DATE('08/01/2016', '%m/%d/%Y')
	and value_coded = 703 -- POSITIVO 
	and  voided=0
	;

-- Numerator: # diagnosed with atypical lesion on Pap; Denominator: # screened for cervical cancer
select  
value_coded, value_numeric, encounter.form_id 
from obs, encounter
where 
encounter.encounter_id = obs.encounter_id
and concept_id = 885
and value_coded in( 163096, 162975, 162976, 162977 )
and obs.obs_datetime between  STR_TO_DATE('08/30/2015', '%m/%d/%Y') and STR_TO_DATE('08/30/2016', '%m/%d/%Y')
and form_id in(8, 12 )
;

SELECT * FROM form  WHERE FORM_ID IN (8,9,12);
-- denominador 
-- totos los que se hicieron pap  en consuta inical o reconsulta 
			
            SELECT obs.value_coded, 
            count(*) 
            FROM obs, encounter
			WHERE 
			obs.encounter_id = encounter.encounter_id
			and obs.obs_datetime between  STR_TO_DATE('08/30/2015', '%m/%d/%Y') and STR_TO_DATE('08/30/2016', '%m/%d/%Y')
			and obs.concept_id  IN ( 162972, 162978) -- PAP INICIAL Y PAP REPETIDO
			and obs.value_coded = 1267
			-- and obs.person_id = var_patient_id
			and obs.voided = 0 -- voided_reg 
			and encounter.voided = 0 -- voided_reg
            -- and obs.encounter_id = var_encounter_id
			group by obs.value_coded -- , encounter.encounter_type, obs.concept_id, obs.person_id
            ;
            



