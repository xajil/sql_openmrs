CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_pivot_report_fill`()
BEGIN

declare var_patient_id int (11) ;
declare var_numero_open char (50);
declare var_mes date;
declare var_ciclo_prestamo int (11) ;
declare var_agencia int (5);
declare var_elegible int (5) ;
declare var_tipo_consulta int (5) ;
declare var_papanicolaou int (3);
declare var_pelvico int (3);
declare var_EIP int (3);
declare var_EIP_tratamiento int (3);
declare var_glucosa int (3);
declare var_glucosa_elevada int (3);
declare var_presion_art int (3);
declare var_presion_art_elevada int (3);
declare var_prueba_embarazo int (3);
declare var_embarazo_positivo int (3);
declare var_ETS int (3);
declare var_ETS_positivo int (11) ;
declare var_seno_examen int (3);
declare var_resultado_examen_seno int (11) ;
declare var_implante int (3);
declare var_DEPO int (3);
declare var_pastillas int (3);

declare concept_id_ciclo_prestamo int default 163138;
declare valor_elegible int default 3;

DECLARE fin int default 0;


-- en wk identifier_type = 2  para asegura que es numero_open
-- filtrar pacientes que no tuvieron una observación en ese mes 
declare cur_patients cursor for 
select patient_identifier.identifier as num_open, patient_id
	from patient_identifier
		where voided = 0
        and patient_identifier.patient_id = 139 ; 

declare cur_obs cursor for select concept_id from obs where patient_id = var_patient_id;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 1;

open cur_patients;

	loop_patients: loop
		fetch cur_patients into var_numero_open, var_patient_id;
		
		if fin=1 then
			leave loop_patients;
		end if;
        
        set var_mes = date_format(sysdate(), '%Y%m%d');
        
        -- definir cuando no existe obs de ese paciente en esa fecha         
        set var_ciclo_prestamo=
        (select value_numeric from obs
		where concept_id = concept_id_ciclo_prestamo 
		and person_id = var_patient_id
		and obs.obs_datetime between STR_TO_DATE('08/01/2016', '%m/%d/%Y') and STR_TO_DATE('08/31/2016', '%m/%d/%Y') );
        
        if ( var_ciclo_prestamo is not null and var_ciclo_prestamo >= valor_elegible) then
			set var_elegible = 1;
			else 
			set var_elegible =0;
        end if;
        
        insert into  pda_pivot_report 
        (
        patient_id, numero_open, mes, ciclo_prestamo, agencia,elegible,tipo_consulta,papanicolaou,pelvico,EIP,EIP_tratamiento,glucosa,glucosa_elevada,presion_art,presion_art_elevada,prueba_embarazo,embarazo_positivo,ETS,ETS_positivo,seno_examen,resultado_examen_seno,implante,DEPO,pastillas
        ) values (
var_patient_id,
var_numero_open,
var_mes,
var_ciclo_prestamo,
var_agencia,
var_elegible,
var_tipo_consulta,
var_papanicolaou,
var_pelvico,
var_EIP,
var_EIP_tratamiento,
var_glucosa,
var_glucosa_elevada,
var_presion_art,
var_presion_art_elevada,
var_prueba_embarazo,
var_embarazo_positivo,
var_ETS,
var_ETS_positivo,
var_seno_examen,
var_resultado_examen_seno,
var_implante,
var_DEPO,
var_pastillas
        );
        commit;

	end loop loop_patients;
    
close cur_patients;

END