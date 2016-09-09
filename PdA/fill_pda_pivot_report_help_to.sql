/* TABLA PIVOTE */

truncate table pda_pivot_report;         
-- call proc_pivot_report_fill;     
call proc_fill_from_encounter;
-- 4570 

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

