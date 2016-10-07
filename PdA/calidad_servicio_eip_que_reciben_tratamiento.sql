
-- DENOMINADORR
select  
distinct orders.patient_id
from drug_order, drug, orders
where drug_order.drug_inventory_id = drug.drug_id
and drug_order.order_id = orders.order_id
and orders.discontinued = 1
and orders.concept_id IN( 73041, 79782, 75222) --  juntos siempre
-- and orders.patient_id = var_patient_i
and orders.start_date  between STR_TO_DATE('20160901', '%Y%m%d') and STR_TO_DATE('20160930', '%Y%m%d')
and orders.patient_id in (
SELECT 
obs.person_id FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.concept_id = 162969
and obs.value_coded  = 162968
and obs.voided = 0 
and encounter.voided = 0
and date_format( obs.obs_datetime, '%Y%m%d') between STR_TO_DATE('20160901', '%Y%m%d') and STR_TO_DATE('20160930', '%Y%m%d')
)
group by orders.patient_id
having count(orders.concept_id) = 3
order by orders.patient_id;


-- DENOMINADOR
SELECT 
date_format( obs.obs_datetime, '%Y%m%d') obs_datetime_formated,
obs.* FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.concept_id = 162969
and obs.value_coded  = 162968
and obs.voided = 0 
and encounter.voided = 0
and date_format( obs.obs_datetime, '%Y%m%d') between STR_TO_DATE('20160901', '%Y%m%d') and STR_TO_DATE('20160930', '%Y%m%d')
;




select * from concept where concept_id = 162968;