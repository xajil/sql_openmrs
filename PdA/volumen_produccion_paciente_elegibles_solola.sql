select * from 
			(select  provider_id, provider_name, date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis,  count(distinct patient_id) glucosa_elegible, 0 pap_elegible, 0 embarazo_test_elegibles, 0 examen_ets_elegibles, 0 depo_elegibles, 0 implantes_elegibles
        -- 0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, count(distinct patient_id) glucosa_elegible, 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis   
			from (
			select   patient_id, glucosa_azar glucosa, encounter_datetime, provider_id, provider_name  from
			pda_pivot_report
			where glucosa_azar <> -1
            and agencia = 1
            and elegible = 1
			-- and provider_id = 20
			union 
			select   patient_id, glucosa_ayunas glucosa, encounter_datetime, provider_id, provider_name  from
			pda_pivot_report
			where glucosa_ayunas <> -1
			and agencia = 1
            and elegible = 1
            -- and provider_id = 20
			group by encounter_datetime, patient_id
		 ) a
		group by provider_id) glucosa_elegible
        
union        
select * from        
		(select provider_id, provider_name, date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis, 0 glucosa_elegible, count(distinct PATIENT_ID) pap_elegible,   0 embarazo_test_elegibles, 0 examen_ets_elegibles, 0 depo_elegibles, 0 implantes_elegibles
		from pda_pivot_report
		where pap = 1267 
		and tipo_consulta in(1,2)
		and agencia = 1
        and elegible = 1
		group by provider_id
        ) pap_elegible
        
union
select * from (
		select provider_id, provider_name, date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis,  0 glucosa_elegible, 0 pap_elegible, count(distinct patient_id) embarazo_test_elegibles , 0 examen_ets_elegibles, 0 depo_elegibles, 0 implantes_elegibles
        -- provider_id, provider_name,date_format(encounter_datetime, '%Y%m') anio_mes, count(distinct patient_id) embarazo_test_elegibles
		from pda_pivot_report
		where prueba_embarazo <> -1
		and agencia = 1
        and elegible = 1
		group by provider_id
) test_embarazo_elegible
union
select * from 
(
		select  provider_id, provider_name, date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis,  0 glucosa_elegible, 0 pap_elegible, 0 embarazo_test_elegibles, count(distinct patient_id) examen_ets_elegibles, 0 depo_elegibles, 0 implantes_elegibles
        -- provider_id, provider_name,date_format(encounter_datetime, '%Y%m') anio_mes,  count(distinct patient_id) examen_ets_elegibles
        from pda_pivot_report
		where ets <> -1
		and agencia = 1
        and elegible = 1
		group by provider_id
) ets_elegible
union
select * from 
(	select provider_id, provider_name, date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis,  0 glucosa_elegible, 0 pap_elegible, 0 embarazo_test_elegibles, 0 examen_ets_elegibles, count(distinct patient_id) depo_elegibles, 0 implantes_elegibles
	-- provider_id, provider_name,date_format(encounter_datetime, '%Y%m') anio_mes, count(distinct patient_id)  depo_elegibles
	from pda_pivot_report
    where depo <> -1
    and depo = 1	
		and agencia = 1
        and elegible = 1    
	group by provider_id
) tbl_depo_elegibles
union
select * from 
(	select provider_id, provider_name, date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis,  0 glucosa_elegible, 0 pap_elegible, 0 embarazo_test_elegibles, 0 examen_ets_elegibles, 0 depo_elegibles, count(distinct patient_id) implantes_elegibles
	-- provider_id, provider_name,date_format(encounter_datetime, '%Y%m') anio_mes, count(distinct patient_id) implantes_elegibles
	from
	pda_pivot_report
    where implante <> -1
    and implante = 1   
		and agencia = 1
        and elegible = 1    
	group by provider_id
) tbl_implantes_elegibles
;
        
/*
Pap
Glucosa
Prueba de embarazo
Pruebas de ETS
Implante
Depo
*/
-- provider_id, provider_name, date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis,