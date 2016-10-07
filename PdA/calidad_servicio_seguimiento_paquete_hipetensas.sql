-- NUMERADOR
select 
patient_identifier.*
 from patient_identifier, patient, patient_program
where patient_identifier.patient_id = patient.patient_id
and patient.patient_id = patient_program.patient_id
and patient_program.program_id = 14
and date_completed is null
and patient_program.voided = 0
and patient_identifier.voided = 0
;


-- DENOMINADOR
select 
patient_identifier.*
 from patient_identifier, patient, patient_program
where patient_identifier.patient_id = patient.patient_id
and patient.patient_id = patient_program.patient_id
and patient_program.program_id = 2
and date_completed is null
and patient_program.voided = 0
and patient_identifier.voided = 0
;