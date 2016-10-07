-- numerador 
select avg(total_pacientes)
from 
( select 
provider_id, count(distinct	obs.person_id) total_pacientes , encounter.encounter_datetime
-- avg (distinct	obs.person_id) total_pacientes 
from encounter, encounter_provider, obs
where
encounter.encounter_id = encounter_provider.encounter_id
and encounter.encounter_id = obs.encounter_id
and encounter.encounter_type in (1,2)
and date_format( obs.obs_datetime, '%Y%m%d') between STR_TO_DATE('20160901', '%Y%m%d') and STR_TO_DATE('20160930', '%Y%m%d')
-- and encounter_provider.provider_id  =  15 --  not in (17, 18)
group by provider_id, encounter.encounter_datetime
) pacienetes_por_dia
;

-- denominador 
select avg(total_dias) from
(
select 
provider_id, count(distinct encounter_datetime) total_dias
from encounter, encounter_provider, obs
where
encounter.encounter_id = encounter_provider.encounter_id
and encounter.encounter_id = obs.encounter_id
and encounter.encounter_type in (1,2)
and date_format( obs.obs_datetime, '%Y%m%d') between STR_TO_DATE('20160901', '%Y%m%d') and STR_TO_DATE('20160930', '%Y%m%d')
and encounter_provider.provider_id not in (17, 18)
group by provider_id
) dias_x_provider
;



select 
provider_id, count(distinct	obs.person_id) total_pacientes , encounter.encounter_datetime
-- avg (distinct	obs.person_id) total_pacientes 
from encounter, encounter_provider, obs
where
encounter.encounter_id = encounter_provider.encounter_id
and encounter.encounter_id = obs.encounter_id
and encounter.encounter_type in (1,2)
and date_format( obs.obs_datetime, '%Y%m%d') between STR_TO_DATE('20160901', '%Y%m%d') and STR_TO_DATE('20160930', '%Y%m%d')
-- and encounter_provider.provider_id  =  15 --  not in (17, 18)
group by provider_id, encounter.encounter_datetime;

select 
provider_id, count(distinct encounter_datetime) total_dias
from encounter, encounter_provider, obs
where
encounter.encounter_id = encounter_provider.encounter_id
and encounter.encounter_id = obs.encounter_id
and encounter.encounter_type in (1,2)
and date_format( obs.obs_datetime, '%Y%m%d') between STR_TO_DATE('20160901', '%Y%m%d') and STR_TO_DATE('20160930', '%Y%m%d')
and encounter_provider.provider_id not in (17, 18)
group by provider_id;