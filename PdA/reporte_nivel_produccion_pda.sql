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
select 'Pacientes' NombreCampo, count(distinct patient_id) total
		from pda_pivot_report
		where tipo_consulta in (1,2)
union 
select 'Embarazadas' NombreCampo, count(distinct patient_id) total
		from pda_pivot_report
		where  embarazada = 1
union        
select 'Consultas Iniciales' NombreCampo, count(encounter_id) total
		from pda_pivot_report
		where tipo_consulta = 1 --  Consultas Iniciales
union 
select 'Pacientes en Reconsultas' NombreCampo, count(distinct patient_id) total -- t 
		from pda_pivot_report
		where tipo_consulta = 2  --  2 RECONSULTAS 
union        
-- agregar total de pacientes vistos en reconsutas  
select 'Numero Reconsultas' NombreCampo, count(*)  total from (
select  patient_id,  count(encounter_datetime) 
from pda_pivot_report
	where tipo_consulta = 2
	group by encounter_datetime, patient_id    
    order by patient_id desc
    ) b    
union 
select 'Glucosa' NombreCampo, count(distinct patient_id) total
		from pda_pivot_report
		where glucosa_azar <> -1 or glucosa_ayunas <> -1
union
select 'Pap' NombreCampo, count(distinct patient_id) total
		from pda_pivot_report
		where pap = 1267
union 
select 'ETS' NombreCampo, count(distinct patient_id) total    
		from pda_pivot_report
		where ets <> -1 
union 
select 'Planificacion' NombreCampo, count(distinct patient_id) total	
		from pda_pivot_report
		where implante = 1 or pastillas = 1 or depo = 1
union 
select 'Tratamiento Inflamacion Severa' NombreCampo, count(distinct patient_id) total	
		from pda_pivot_report
		where trat_inflam_severa = 1
union 
	select  'Vaginosis' NombreCampo, count(distinct patient_id) total
		from pda_pivot_report
		where trat_vaginosis_bac = 1 
union 
	select  'Candidiasis' NombreCampo, count(distinct patient_id) total	
		from pda_pivot_report
		where trat_candidiasis_vag = 1 
union 
	select 'Examen Pelvico' NombreCampo, count(distinct patient_id) total from pda_pivot_report 
	where pelvico = 1267
union 
	select 'Examen de Seno' NombreCampo, count(distinct patient_id) total from pda_pivot_report 
	where seno_examen <> -1 
union 
	select 'Presion Arterial' NombreCampo, COUNT(DISTINCT(PATIENT_ID)) total from pda_pivot_report 
	where presion_sistolica <> -1
    or presio_diastolica <> -1
union    
	select 'Tratamiento EIP' NombreCampo, count( distinct patient_id) total from pda_pivot_report 
	where eip_tratamiento = 1 
;

select * from pda_pivot_report;

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
        
        

-- Promedio de Pacientes Vistos proveedor.
select provider_id,  provider_name , count(distinct patient_id)
from pda_pivot_report
group by provider_id;       

select provider_id,  provider_name , count(distinct encounter_datetime)
from pda_pivot_report
group by provider_id;       
   
   