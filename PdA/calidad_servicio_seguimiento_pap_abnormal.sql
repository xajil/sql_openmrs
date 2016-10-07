SELECT * FROM obs, encounter
where 
obs.encounter_id = encounter.encounter_id
and concept_id = 162978
and value_coded = 1267
and obs.voided = 0
and exists (
SELECT obs_int.person_id FROM obs obs_int, encounter
where 
obs_int.encounter_id = encounter.encounter_id
and obs_int.concept_id = 885
and obs_int.value_coded = 162974
and obs_int.voided = 0
and encounter.voided = 0
and date_format( obs_int.obs_datetime, '%Y%m%d') between 
    date_format ( (adddate( STR_TO_DATE('20160901', '%Y%m%d'), interval - 7 month)),  '%Y%m%d') 
and date_format ( (adddate( STR_TO_DATE('20160930', '%Y%m%d'), interval - 7 month)),  '%Y%m%d')
and obs_int.person_id = obs.person_id
and obs.obs_datetime >= obs_int.obs_datetime
);


SELECT * FROM obs, encounter
where 
obs.encounter_id = encounter.encounter_id
and concept_id = 885
and value_coded = 162974
and obs.voided = 0
and encounter.voided = 0
and date_format( obs.obs_datetime, '%Y%m%d') between 
    date_format ( (adddate( STR_TO_DATE('20160901', '%Y%m%d'), interval - 7 month)),  '%Y%m%d') 
and date_format ( (adddate( STR_TO_DATE('20160930', '%Y%m%d'), interval - 7 month)),  '%Y%m%d')
;







select adddate( STR_TO_DATE('09/30/2016', '%m/%d/%Y'), interval - 210 day);
-- 2016-03-04 

select adddate( STR_TO_DATE('09/30/2016', '%m/%d/%Y'), interval - 7 Month);
-- 2016-02-29

select adddate( STR_TO_DATE('08/30/2016', '%m/%d/%Y'), interval - 210 day);
-- 2016-02-02 

select adddate( STR_TO_DATE('08/30/2016', '%m/%d/%Y'), interval - 7 Month);
-- 2016-01-30

select diff(
(adddate( STR_TO_DATE('08/30/2016', '%m/%d/%Y'), interval - 2 week)),
(adddate( STR_TO_DATE('08/30/2016', '%m/%d/%Y'), interval - 3 week))
);