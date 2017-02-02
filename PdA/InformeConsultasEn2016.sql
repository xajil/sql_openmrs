-- al menos una consulta: 20160101 y 20160939
-- al menos una consulta: 20160701 y 20160939

-- and encounter.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
-- and encounter.location_id in (26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50) -- CHIMALTENANGO

select count(*) from (
select encounter.patient_id, encounter.encounter_id from encounter
where encounter.encounter_type in (1,2)
and date_format(encounter.encounter_datetime, '%Y%m%d') between STR_TO_DATE('20160701', '%Y%m%d') and STR_TO_DATE('20160930', '%Y%m%d')
and encounter.voided = 0
and encounter.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
-- and encounter.location_id in (26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50) -- CHIMALTENANGO
group by encounter.encounter_datetime, encounter.patient_id
) encuentros_pacientes;

select count(distinct encounter.patient_id) from encounter
where encounter.encounter_type in (1,2)
and date_format(encounter.encounter_datetime, '%Y%m%d') between STR_TO_DATE('20160701', '%Y%m%d') and STR_TO_DATE('20160930', '%Y%m%d')
and encounter.voided = 0
and encounter.location_id in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23) -- SOLOLA
-- and encounter.location_id in (26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50) -- CHIMALTENANGO
;






/*
select * from encounter, obs
where encounter.encounter_id = obs.encounter_id
and obs.person_id = 2264
and encounter.encounter_type in (1,2)
and obs.obs_datetime between adddate(sysdate(), interval -5 day) and sysdate()
group by obs_datetime;

select * from encounter
where encounter.encounter_type in (1,2)
and encounter.encounter_datetime between adddate(sysdate(), interval -5 day) and sysdate()
and encounter.patient_id = 2264
group by encounter.encounter_datetime, patient_id
;
*/