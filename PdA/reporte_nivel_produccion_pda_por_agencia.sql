##########################################################################
-- Name             : Informe de Produccion Mensual PdA Por Agencias
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

select 
NoOrden, NombreCampo, sum(total_solola) 'Agencia Sololá', sum(total_chimal) 'Agencia Chimaltenango'
from 
(
		select 1 NoOrden, 'Pacientes' NombreCampo, count(distinct patient_id) total_solola, 0 total_chimal
				from pda_pivot_report
				where tipo_consulta in (1,2)
				and agencia = 1 -- sololá
		union         
		select 1 NoOrden, 'Pacientes' NombreCampo, 0 total_solola,  count(distinct patient_id) total_chimal
				from pda_pivot_report
				where tipo_consulta in (1,2)
				and agencia = 2 -- chimaltenango
union        
select 2 NoOrden, 'Embarazadas' NombreCampo, count(distinct patient_id) total_solola, 0 total_chimal
		from pda_pivot_report
		where  embarazada = 1
        and agencia = 1  -- sololá
union
select 2 NoOrden, 'Embarazadas' NombreCampo, 0 total_solola, count(distinct patient_id) total_solola
		from pda_pivot_report
		where  embarazada = 1
        and agencia = 2   -- chimaltenango 
		union
				select 3 NoOrden, 'Consultas Iniciales' NombreCampo, count(encounter_id) total_solola, 0 total_chimal
				from pda_pivot_report
				where tipo_consulta = 1 --  Consultas Iniciales
				and agencia = 1
		union         
				select 3 NoOrden, 'Consultas Iniciales' NombreCampo, 0 total_solola, count(encounter_id) total_chimal
				from pda_pivot_report
				where tipo_consulta = 1 --  Consultas Iniciales
				and agencia = 2
union
select 4 NoOrden, 'Pacientes en Reconsultas' NombreCampo, count(distinct patient_id) total_solola, 0 total_chimal
from pda_pivot_report
where tipo_consulta = 2  --  2 RECONSULTAS                 
and agencia = 1
union
select 4 NoOrden, 'Pacientes en Reconsultas' NombreCampo, 0 total_solola, count(distinct patient_id) total_chimal
from pda_pivot_report
where tipo_consulta = 2  --  2 RECONSULTAS                 
and agencia = 2
		union         
		select 5 NoOrden, 'Numero Reconsultas' NombreCampo, count(*)  total_solola, 0 total_chimal 
        from (
		select  patient_id,  count(encounter_datetime) 
		from pda_pivot_report
			where tipo_consulta = 2    
            and agencia = 1
			group by encounter_datetime, patient_id    
			order by patient_id desc
			) y
		union         
		select 5 NoOrden, 'Numero Reconsultas' NombreCampo,0 total_solola, count(*) total_chimal 
        from (
		select  patient_id,  count(encounter_datetime) 
		from pda_pivot_report
			where tipo_consulta = 2    
            and agencia = 2
			group by encounter_datetime, patient_id    
			order by patient_id desc
			) z     
       		
union 
       select NoOrden, ab.NombreCampo NombreCampo , count(distinct patient_ag1) total_solola, count(distinct patient_ag2)  total_chimal from (        
		select 6 NoOrden, 'Glucosa' NombreCampo, patient_id patient_ag1, null patient_ag2
		from pda_pivot_report
        where agencia = 1 and glucosa_azar <> -1  
        union
        select 6 NoOrden, 'Glucosa' NombreCampo, patient_id patient_ag1, null patient_ag2
		from pda_pivot_report
        where agencia = 1 and  glucosa_ayunas <> -1     
		union 
		select 6 NoOrden, 'Glucosa' NombreCampo, null patient_ag1, patient_id patient_ag2  
				from pda_pivot_report
				where agencia = 2 and glucosa_azar <> -1
		union
		select 6 NoOrden, 'Glucosa' NombreCampo, null patient_ag1, patient_id patient_ag2  
				from pda_pivot_report
				where agencia = 2 and glucosa_ayunas <> -1
        ) ab 
union         
		select 7 NoOrden, 'Pap' NombreCampo, count(distinct patient_id) total_solola, 0 total_chimal 
		from pda_pivot_report
		where pap = 1267
        and agencia = 1
union 
		select 7 NoOrden, 'Pap' NombreCampo, 0 total_solola, count(distinct patient_id) total_chimal 
		from pda_pivot_report
		where pap = 1267
        and agencia = 2
union 
select 8 NoOrden, 'ETS' NombreCampo, count(distinct patient_id) total_solola, 0 total_chimal    
from pda_pivot_report
where ets <> -1        
and agencia = 1
union
select 8 NoOrden, 'ETS' NombreCampo, 0 total_solola, count(distinct patient_id) total_chimal   
from pda_pivot_report
where ets <> -1 
and agencia = 2
union 
		select 9 NoOrden, 'Planificacion' NombreCampo, count(distinct patient_id) total_solola, 0 total_chimal  
		from (
        select * from pda_pivot_report
		where agencia=1 and implante = 1
        union 
		select * from pda_pivot_report
		where agencia=1 and pastillas = 1 
        union
		select * from pda_pivot_report
		where agencia=1 and depo = 1) 
        xy 
        union
		select 9 NoOrden, 'Planificacion' NombreCampo, 0 total_solola, count(distinct patient_id) total_chimal  
		from (
        select * from pda_pivot_report
		where agencia=2 and implante = 1
        union 
		select * from pda_pivot_report
		where agencia=2 and pastillas = 1 
        union
		select * from pda_pivot_report
		where agencia=2 and depo = 1) 
        xy       
union        
select 10 NoOrden,'Tratamiento Inflamacion Severa' NombreCampo, count(distinct patient_id) total_solola, 0 total_chimal 	
from pda_pivot_report
where trat_inflam_severa = 1     
and agencia = 1    
union
select 10 NoOrden,'Tratamiento Inflamacion Severa' NombreCampo, 0 total_solola, count(distinct patient_id) total_chimal 	
from pda_pivot_report
where trat_inflam_severa = 1     
and agencia = 2  
union 
		select 11 NoOrden, 'Vaginosis' NombreCampo, count(distinct patient_id) total_solola, 0 total_chimal 
		from pda_pivot_report
		where trat_vaginosis_bac = 1 
        and agencia = 1
union 
		select 11 NoOrden, 'Vaginosis' NombreCampo, 0 total_solola , count(distinct patient_id) total_chimal
		from pda_pivot_report
		where trat_vaginosis_bac = 1 
        and agencia = 2
union 
select 12 NoOrden, 'Candidiasis' NombreCampo, count(distinct patient_id) total_solola, 0 total_chimal 	
from pda_pivot_report
where trat_candidiasis_vag = 1 and agencia = 1       
union
select 12 NoOrden, 'Candidiasis' NombreCampo, 0 total_solola, count(distinct patient_id) total_chimal	
from pda_pivot_report
where trat_candidiasis_vag = 1 and agencia = 2         
union
		select 13 NoOrden, 'Examen Pelvico' NombreCampo, count(distinct patient_id) total_solola, 0 total_chimal 
		from pda_pivot_report 
		where pelvico = 1267
        and agencia = 1
union
		select 13 NoOrden, 'Examen Pelvico' NombreCampo, 0 total_solola, count(distinct patient_id) total_chimal 
		from pda_pivot_report 
		where pelvico = 1267
        and agencia = 2
union
select 14 NoOrden, 'Examen de Seno' NombreCampo, count(distinct patient_id) total_solola, 0 total_chimal  
from pda_pivot_report 
where seno_examen <> -1 
and agencia = 1
union
select 14 NoOrden, 'Examen de Seno' NombreCampo, 0 total_solola, count(distinct patient_id) total_chimal  
from pda_pivot_report 
where seno_examen <> -1     
and agencia = 2
union
	select 
    * from 
    ( select 
    15 NoOrden, 'Presion Arterial' NombreCampo, COUNT(DISTINCT(PATIENT_ID)) total_solola,  0 total_chimal  
    from pda_pivot_report 
	where   agencia = 1 and presion_sistolica <> -1
    union
    select 
    15 NoOrden, 'Presion Arterial' NombreCampo, COUNT(DISTINCT(PATIENT_ID)) total_solola,  0 total_chimal  
    from pda_pivot_report 
	where   agencia = 1
    and presio_diastolica <> -1
    )
    xyz
    union
    	select 
    * from 
    ( select 
    15 NoOrden, 'Presion Arterial' NombreCampo, 0 total_solola,  COUNT(DISTINCT(PATIENT_ID)) total_chimal  
    from pda_pivot_report 
	where   agencia = 2 and presion_sistolica <> -1
    union
    select 
    15 NoOrden, 'Presion Arterial' NombreCampo, 0 total_solola,  COUNT(DISTINCT(PATIENT_ID)) total_chimal    
    from pda_pivot_report 
	where   agencia = 2
    and presio_diastolica <> -1)
    x_yz
    group by x_yz.NombreCampo
union
	select 16 NoOrden, 'Tratamiento EIP' NombreCampo, count( distinct patient_id) total_solola, 0 total_chimal 
    from pda_pivot_report 
	where eip_tratamiento = 1  
    and agencia = 1
    union
	select 16 NoOrden, 'Tratamiento EIP' NombreCampo, 0 total_solola, count( distinct patient_id) total_chimal 
    from pda_pivot_report 
	where eip_tratamiento = 1 
    and agencia = 2      
 ) a	
group by NombreCampo, NoOrden  
order by NoOrden asc      
;    







	select NoOrden,NombreCampo , ab.NombreCampo, sum(total_solola) total_solola, sum(total_chimal)  total_chimal from (        
		select 6 NoOrden, 'Glucosa' NombreCampo, count(distinct patient_id) total_solola, 0 total_chimal 
		from pda_pivot_report
        where agencia = 1 and glucosa_azar <> -1  
        union
        select 6 NoOrden, 'Glucosa' NombreCampo, count(distinct patient_id) total_solola, 0 total_chimal 
		from pda_pivot_report
        where agencia = 1 and  glucosa_ayunas <> -1     
        
		union 
		select 6 NoOrden, 'Glucosa' NombreCampo, 0 total_solola, count(distinct patient_id) total_chimal 
				from pda_pivot_report
				where agencia = 2 and glucosa_azar <> -1
		union
		select 6 NoOrden, 'Glucosa' NombreCampo, 0 total_solola, count(distinct patient_id) total_chimal 
				from pda_pivot_report
				where agencia = 2 and glucosa_ayunas <> -1 
       ) ab
       group by ab.NombreCampo ; 

        
	select 
    * from 
    ( select 
    15 NoOrden, 'Presion Arterial' NombreCampo, COUNT(DISTINCT(PATIENT_ID)) total_solola,  0 total_chimal  
    from pda_pivot_report 
	where   agencia = 1 and presion_sistolica <> -1
    union
    select 
    15 NoOrden, 'Presion Arterial' NombreCampo, COUNT(DISTINCT(PATIENT_ID)) total_solola,  0 total_chimal  
    from pda_pivot_report 
	where   agencia = 1
    and presio_diastolica <> -1
    )
    xyz
    union
    	select 
    * from 
    ( select 
    15 NoOrden, 'Presion Arterial' NombreCampo, 0 total_solola,  COUNT(DISTINCT(PATIENT_ID)) total_chimal  
    from pda_pivot_report 
	where   agencia = 2 and presion_sistolica <> -1
    union
    select 
    15 NoOrden, 'Presion Arterial' NombreCampo, 0 total_solola,  COUNT(DISTINCT(PATIENT_ID)) total_chimal    
    from pda_pivot_report 
	where   agencia = 2
    and presio_diastolica <> -1)
    x_yz
    group by x_yz.NombreCampo ;
    
    
    
    select 
    15 NoOrden, 'Presion Arterial' NombreCampo, COUNT(DISTINCT(PATIENT_ID)) total_solola,  0 total_chimal  
    from pda_pivot_report 
	where   agencia = 2 and presion_sistolica <> -1;
    
    
    select 
    15 NoOrden, 'Presion Arterial' NombreCampo, COUNT(DISTINCT(PATIENT_ID)) total_solola,  0 total_chimal  
    from pda_pivot_report 
	where   agencia = 2
    and presio_diastolica <> -1
    ;
   
        
--  union-- 

		select 9 NoOrden, 'Planificacion' NombreCampo, 0 total_solola, count(distinct patient_id) total_chimal  
		from pda_pivot_report
		where agencia=2 and implante = 1 or pastillas = 1 or depo = 1; 
        
        
       select NoOrden, ab.NombreCampo NombreCampo , count(distinct patient_ag1) total_solola, count(distinct patient_ag2)  total_chimal from (        
		select 6 NoOrden, 'Glucosa' NombreCampo, patient_id patient_ag1, null patient_ag2
		from pda_pivot_report
        where agencia = 1 and glucosa_azar <> -1  
        union
        select 6 NoOrden, 'Glucosa' NombreCampo, patient_id patient_ag1, null patient_ag2
		from pda_pivot_report
        where agencia = 1 and  glucosa_ayunas <> -1     
		union 
		select 6 NoOrden, 'Glucosa' NombreCampo, null patient_ag1, patient_id patient_ag2  
				from pda_pivot_report
				where agencia = 2 and glucosa_azar <> -1
		union
		select 6 NoOrden, 'Glucosa' NombreCampo, null patient_ag1, patient_id patient_ag2  
				from pda_pivot_report
				where agencia = 2 and glucosa_ayunas <> -1
        ) ab        
       ;
  
  
	
