/* TABLA PIVOTE */

truncate table pda_pivot_report;         
-- call proc_pivot_report_fill;     
-- call proc_fill_from_encounter;

call proc_fill_from_encounter(
STR_TO_DATE('08/01/2016', '%m/%d/%Y'), 
STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
);

call proc_fill_from_encounter(
STR_TO_DATE('09/01/2016', '%m/%d/%Y'), 
STR_TO_DATE('09/30/2016', '%m/%d/%Y') 
);

<<<<<<< HEAD


-- 4570 
-- total de 730 encuentros.
-- total de 738 encuentro 
-- total de 739 encuentros 
-- total de 741 encuentros 20160921 
-- TOTAL DE 740 encuentros 
-- total de 746 encuentros 20160924
-- total de 749 encuentros 20161003



select pda_pivot_report.* from pda_pivot_report;


TRUNCATE TABLE error_log_pda_repo;

select * from error_log_pda_repo;


--  TOTAL DE VISITAS A CADA PACIENTES
-- EXCLUYENDO LOS LABORATORIOS, CORRESPONDENCIAS 
-- pendiente los form_id 15 que provengan de provider_id 18.


--  TOTAL DE PACIENTES VISTOS CON ALGÚN SERVICIO EN EL MES
--  596
select count(distinct( encounter_datetime ) ), patient_id, numero_open from pda_pivot_report
-- where patient_id = 1926
-- WHERE form_id NOT IN ( 12, 14) 
-- and provider_id <> 18
group by patient_id, numero_open
-- having count(mes) > 2
;


-- 557 
--  TOTAL DE PACIENTES VISTOS CON VISITAS DE ENFERMERAS O DR.
select count(distinct( encounter_datetime ) ), patient_id, numero_open from pda_pivot_report
-- where patient_id = 1926
WHERE form_id NOT IN ( 12, 14) 
and provider_id <> 18
group by patient_id, numero_open
-- having count(mes) > 2
;

--  TOTAL DE ENCUENTROS O VISITAS EN EL MES 
select distinct( encounter_datetime ), patient_id, numero_open from pda_pivot_report
WHERE form_id NOT IN ( 12, 14)
and provider_id <> 18
group by patient_id, pda_pivot_report.encounter_datetime
;


--  TOTAL DE ENCUENTROS O VISITAS EN EL MES 
-- que fueron reconsultas
select distinct( encounter_datetime ), patient_id, numero_open from pda_pivot_report
WHERE form_id NOT IN ( 12, 14)
and provider_id <> 18
and pda_pivot_report.tipo_consulta = 2
group by patient_id, pda_pivot_report.encounter_datetime
;

--  TOTAL DE ENCUENTROS O VISITAS EN EL MES 
-- que fueron primera_visita
select distinct( encounter_datetime ), patient_id, numero_open from pda_pivot_report
WHERE form_id NOT IN ( 12, 14)
and provider_id <> 18
and pda_pivot_report.tipo_consulta = 1
group by patient_id, pda_pivot_report.encounter_datetime
;

select value_coded, obs.*
 from obs
where concept_id = 1619 -- EXAMENES DE ETS EN MUJERES EMBARAZADA
and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y')
and  voided=0
-- and value_coded = 1267
-- group by value_coded
;


select value_coded 
-- into var_sifilis 
from obs, encounter
where encounter.encounter_id = obs.encounter_id
and obs.encounter_id = encounter.encounter_id
-- and obs.person_id = var_patient_id
and concept_id = 1619 -- EXAMENES DE Sífilis
and obs.obs_datetime between  STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') 
and obs.voided = 0;
=======
>>>>>>> refs/remotes/origin/master

call proc_fill_from_encounter(
STR_TO_DATE('10/01/2016', '%m/%d/%Y'), 
STR_TO_DATE('10/31/2016', '%m/%d/%Y') 
);


call proc_fill_from_encounter(
STR_TO_DATE('11/01/2016', '%m/%d/%Y'), 
STR_TO_DATE('11/30/2016', '%m/%d/%Y') 
);


call proc_fill_from_encounter(
STR_TO_DATE('12/01/2016', '%m/%d/%Y'), 
STR_TO_DATE('12/30/2016', '%m/%d/%Y') 
);


call proc_fill_from_encounter(
STR_TO_DATE('01/01/2017', '%m/%d/%Y'), 
STR_TO_DATE('01/31/2017', '%m/%d/%Y') 
);

/* 
delete from  pda_pivot_report 
where encounter_datetime between 
	STR_TO_DATE('11/01/2016', '%m/%d/%Y') AND 
	STR_TO_DATE('11/30/2016', '%m/%d/%Y'); 
commit;

delete from  pda_pivot_report where encounter_datetime between 
	STR_TO_DATE('10/01/2016', '%m/%d/%Y') AND 
	STR_TO_DATE('10/31/2016', '%m/%d/%Y'); 

commit;
*/

delete from  pda_pivot_report where encounter_datetime between 
	STR_TO_DATE('01/01/2017', '%m/%d/%Y') AND 
	STR_TO_DATE('01/31/2017', '%m/%d/%Y'); 
commit;


select * from pda_pivot_report where encounter_datetime between 
	STR_TO_DATE('01/01/2017', '%m/%d/%Y') AND 
	STR_TO_DATE('01/31/2017', '%m/%d/%Y')
	order by patient_id asc ; -- 7652
