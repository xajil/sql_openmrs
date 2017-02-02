##########################################################################
-- Name             : Informe de Calidad de Servicio Por Agencias
-- Date             : 20161010
-- Author           : Neftali Sacuj
-- Organization     : Wuqu' Kawoq
-- Purpose          : Conteos de Calidad de Servicios Por Agencia
-- Usage        	: sqlplus
-- Impact   		: N/A
-- Required grants  : SELECT
-- Called by        : OpenMRS Sql Data Set
##########################################################################
-- ver  user      	date        change  
-- 1.0  @nefsacuj   20161010    initial
##########################################################################
select provider_id, sum(total_dias) dias_consulta, sum(total_pacientes) total_pacientes from (
select * from (
select 
provider_id, count(distinct encounter_datetime) total_dias, 0 total_pacientes
from encounter, encounter_provider, obs
where
encounter.encounter_id = encounter_provider.encounter_id
and encounter.encounter_id = obs.encounter_id
and encounter.encounter_type in (1,2)
and date_format( obs.obs_datetime, '%Y%m%d') between STR_TO_DATE('20160901', '%Y%m%d') and STR_TO_DATE('20160930', '%Y%m%d')
-- and obs.obs_datetime between :startDate and :endDate
and encounter_provider.provider_id not in (17, 18)
group by provider_id) tbl_jornadas
UNION
select provider_id, total_dias, total_pacientes from (
select 
provider_id, 0 total_dias, count(distinct	obs.person_id) total_pacientes-- , encounter.encounter_datetime
-- avg (distinct	obs.person_id) total_pacientes 
from encounter, encounter_provider, obs
where
encounter.encounter_id = encounter_provider.encounter_id
and encounter.encounter_id = obs.encounter_id
and encounter.encounter_type in (1,2)
and date_format( obs.obs_datetime, '%Y%m%d') between STR_TO_DATE('20160901', '%Y%m%d') and STR_TO_DATE('20160930', '%Y%m%d')
-- and obs.obs_datetime between :startDate and :endDate
and encounter_provider.provider_id  not in (17, 18) -- =  15 --  
group by provider_id
) tbl_pacientes
)  tbl_unificado
group by tbl_unificado.provider_id
;