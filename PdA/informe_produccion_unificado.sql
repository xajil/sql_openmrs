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

select provider.provider_id,
(		SELECT provider_name FROM pda_pivot_report
		where  pda_pivot_report.provider_id = provider.provider_id
        group by pda_pivot_report.provider_name
        ) nombre
,
(		SELECT COUNT(DISTINCT patient_id) FROM pda_pivot_report
		where  pda_pivot_report.provider_id = provider.provider_id
        ) pacientes        
 from provider
 where provider_id in (
11,
13,
15,
17,
18,
20,
21,
22,
27
 ) ; -- Cantidad de pacientes por proveedor

SELECT sum(ENCUENTROS) FROM ( 
	select  COUNT(DISTINCT encounter_datetime) ENCUENTROS, PROVIDER_ID from
	pda_pivot_report
    where glucosa_azar <> -1
    and provider_id = 11
    union
	select  COUNT(DISTINCT encounter_datetime) ENCUENTROS, PROVIDER_ID from
	pda_pivot_report
    where glucosa_ayunas <> -1
    and provider_id = 11
    ) tbl_glucosa ;
    
    
select  -- COUNT(DISTINCT encounter_datetime) ENCUENTROS 
encounter_datetime
from
	pda_pivot_report
    where 
    pda_pivot_report.provider_id = 11 
   -- and glucosa_ayunas <> -1
    and glucosa_azar <> -1
    ;