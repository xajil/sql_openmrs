-- NUMERADOR
select  
distinct orders.patient_id
from drug_order, drug, orders
where drug_order.drug_inventory_id = drug.drug_id
and drug_order.order_id = orders.order_id
and orders.discontinued <> 1
and orders.concept_id IN ( 1873, 907, 104625)
-- and orders.start_date  between STR_TO_DATE('20160901', '%Y%m%d') and STR_TO_DATE('20160930', '%Y%m%d')
and orders.patient_id in (
SELECT 
person.person_id
FROM obs, encounter, person
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.person_id = person.person_id
and obs.concept_id = 160653
and obs.value_coded in (160652, 162986) 
and encounter.encounter_type = 1
and obs.voided = 0
and encounter.voided = 0
and date_format( obs.obs_datetime, '%Y%m%d') between STR_TO_DATE('20160901', '%Y%m%d') and STR_TO_DATE('20160930', '%Y%m%d')
and person.dead = 0 
and person.voided = 0
and (YEAR(STR_TO_DATE('20160930', '%Y%m%d') ) - YEAR(birthdate) - (DATE_FORMAT(sysdate(), '%m%d') < DATE_FORMAT(birthdate, '%m%d'))) between 18 and 50

);



-- DENOMINADOR
-- mujeres que empezaron un método
SELECT 
*
FROM obs, encounter, person
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.person_id = person.person_id
and obs.concept_id = 160653
and obs.value_coded in (160652, 162986) 
and encounter.encounter_type = 1
and obs.voided = 0
and encounter.voided = 0
and date_format( obs.obs_datetime, '%Y%m%d') between STR_TO_DATE('20160901', '%Y%m%d') and STR_TO_DATE('20160930', '%Y%m%d')
and person.dead = 0 
and person.voided = 0
and (YEAR(STR_TO_DATE('20160930', '%Y%m%d') ) - YEAR(birthdate) - (DATE_FORMAT(sysdate(), '%m%d') < DATE_FORMAT(birthdate, '%m%d'))) between 18 and 50
;

select * from patient_identifier
where patient_identifier.patient_id in (
select  
distinct orders.patient_id
from drug_order, drug, orders
where drug_order.drug_inventory_id = drug.drug_id
and drug_order.order_id = orders.order_id
and orders.discontinued <> 1
and orders.concept_id IN ( 1873, 907, 104625)
-- and orders.start_date  between STR_TO_DATE('20160901', '%Y%m%d') and STR_TO_DATE('20160930', '%Y%m%d')
and orders.patient_id in (
SELECT 
person.person_id
FROM obs, encounter, person
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.person_id = person.person_id
and obs.concept_id = 160653
and obs.value_coded in (160652, 162986) 
and encounter.encounter_type = 1
and obs.voided = 0
and encounter.voided = 0
and date_format( obs.obs_datetime, '%Y%m%d') between STR_TO_DATE('20160901', '%Y%m%d') and STR_TO_DATE('20160930', '%Y%m%d')
and person.dead = 0 
and person.voided = 0
and (YEAR(STR_TO_DATE('20160930', '%Y%m%d') ) - YEAR(birthdate) - (DATE_FORMAT(sysdate(), '%m%d') < DATE_FORMAT(birthdate, '%m%d'))) between 18 and 50

)
)
;