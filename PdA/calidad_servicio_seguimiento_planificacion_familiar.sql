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
obs.person_id
FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.concept_id = 162971
and obs.value_coded in (1873, 907, 104625) 
and date_format( obs.obs_datetime, '%Y%m%d') between date_format ( (adddate( STR_TO_DATE('20160901', '%Y%m%d'), interval - 1 year)),  '%Y%m%d') and date_format ( (adddate( STR_TO_DATE('20160930', '%Y%m%d'), interval - 1 year)),  '%Y%m%d')
);



-- DENOMINADOR
-- mujeres que empezaron un método
SELECT 
*
FROM obs, encounter
WHERE 
obs.encounter_id = encounter.encounter_id
and obs.concept_id = 162971
and obs.voided = 0
and encounter.voided = 0
and obs.value_coded in (1873, 907, 104625) 
and date_format( obs.obs_datetime, '%Y%m%d') between date_format ( (adddate( STR_TO_DATE('20160901', '%Y%m%d'), interval - 1 year)),  '%Y%m%d') and date_format ( (adddate( STR_TO_DATE('20160930', '%Y%m%d'), interval - 1 year)),  '%Y%m%d')
;    

select 
date_format ( (adddate( STR_TO_DATE('20160901', '%Y%m%d'), interval - 1 year)),  '%Y%m%d') , 
date_format ( (adddate( STR_TO_DATE('20160930', '%Y%m%d'), interval - 1 year)),  '%Y%m%d');