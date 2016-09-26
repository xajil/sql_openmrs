##########################################################################
-- Name             : Informe de Produccion Mensual PdA
-- Date             : 20160913
-- Author           : Neftali Sacuj
-- Organization     : Wuqu' Kawoq
-- Purpose          : Generar el informe mensual de producción clínica por cada enfermera.
-- Usage        	: sqlplus
-- Impact   		: N/A
-- Required grants  : SELECT
-- Called by        : OpenMRS Sql Data Set
##########################################################################
-- ver  user      date        change  
-- 1.0  @nefsacuj     20160913    initial
##########################################################################

-- truncate table produccion_mensual_provider;
-- select * from produccion_mensual_provider;
-- create table produccion_mensual_provider  as
-- insert into produccion_mensual_provider
select 
provider_id 'Id Proveedor', 
provider_name 'Nombre Proveedor', 
anio_mes, 
sum(tot_pacientes) Pacientes , 
sum(tot_embarazadas) 'Pacientes Embarazadas', 
sum(consultas_iniciales) 'Consultas Iniciales', 
sum(reconsultas) Reconsultas,
sum(glucosa) Glucosa,  
sum(pap_primera_visita) 'Pap en Primera Visita', 
sum(pap_reconsulta) 'Pap Reconsulta',
sum(examen_ets) 'Examen ETS',
sum(embarazo_test) 'Pruebas Embarazo',
sum(test_hepatitis) 'Pruebas Hepatitis',
sum(test_sifilis  ) 'Pruebas Sifilis',
sum(test_vih) 'Pruebas VIH',
sum(depo) 'Depro-Provera',
sum(implantes) Implantes, 
sum(pastillas) Pastillas, 
sum(eip) 'Tratamiento EIP',
sum(infla_severa) 'Tratamiento Inflamacion Severa',
sum(vaginosis) 'Tratamiento Vaginosis Bacteriana',
sum(candidiasis) 'Tratamiento Candidiasis Vaginal'
from
(
select *
from
(		select  provider_id, provider_name, date_format(encounter_datetime, '%Y%m') anio_mes,  count(distinct patient_id) tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis     
		from
		pda_pivot_report
		where provider_id not in (18, 17)
        group by provider_id
) pacientes
union       
select *
from 
(		select  provider_id, provider_name,date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes , count(distinct patient_id)  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis     
		from
		pda_pivot_report
		where  embarazada = 1
        and provider_id not in (18, 17)
        group by provider_id
) embarazadas
union
select * from (
		select provider_id, provider_name,date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, count(encounter_id) consultas_iniciales, 0 reconsultas, 0 glucosa , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis              
        from
		pda_pivot_report
		where tipo_consulta = 1  --  1 CONSULTAS INICIALES
        and provider_id not in (18, 17)
		group by provider_id 
) consultas_iniciales
union 
select * from (
		select provider_id, provider_name, date_format(encounter_datetime, '%Y%m') anio_mes, 0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, count(distinct patient_id), 0 glucosa, 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis     
        from
        pda_pivot_report
		where tipo_consulta = 2  --  2 RECONSULTAS
        and provider_id not in (18, 17)
		group by provider_id
) reconsultas
union 
select * from (
		select  provider_id, provider_name, date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, count(distinct patient_id) glucosa, 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis   
			from (
			select   patient_id, glucosa_azar glucosa, encounter_datetime, provider_id, provider_name  from
			pda_pivot_report
			where glucosa_azar <> -1
			-- and provider_id = 20
			union 
			select   patient_id, glucosa_ayunas glucosa, encounter_datetime, provider_id, provider_name  from
			pda_pivot_report
			where glucosa_ayunas <> -1
			-- and provider_id = 20
			group by encounter_datetime, patient_id
		 ) a
		where provider_id not in (18, 17)
		group by provider_id

) glucosas
union 
select * from
(
		select  provider_id, provider_name,date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , count(distinct PATIENT_ID) pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis   
		from pda_pivot_report
		where pap = 1267 
		and tipo_consulta = 1  
		group by provider_id

)  pap_en_primera_visita
union 
select * from 
(
		select  provider_id, provider_name,date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, count(distinct PATIENT_ID) pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis  
        from pda_pivot_report
		where pap = 1267 
		and tipo_consulta = 2
		group by provider_id 
) pap_reconsulta
union 
select * from 
(
		select   provider_id, provider_name,date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, count(distinct patient_id) examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis    
        from pda_pivot_report
		where ets <> -1
		group by provider_id
) ets
union 
select * from (
		select  provider_id, provider_name,date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, count(distinct patient_id) embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis  
		from pda_pivot_report
		where prueba_embarazo <> -1
		group by provider_id
) test_embarazo
union
select * from  (
		select provider_id, provider_name, date_format(encounter_datetime, '%Y%m') anio_mes, 0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, count(distinct patient_id) test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis  
		from
		pda_pivot_report
		where hepatitis_b <> -1
		and provider_id not in (18, 17)
		group by provider_id
) tbl_hepatitis
union 
select * from (
	select provider_id, provider_name, date_format(encounter_datetime, '%Y%m') anio_mes, 0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, count(distinct patient_id) test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis
    from
	pda_pivot_report
    where sifilis <> -1
	and provider_id not in (18, 17)
	group by provider_id
    ) tbl_sifilis
union 
select * from 
(	select provider_id, provider_name,date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, count(distinct patient_id) test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis  
    from pda_pivot_report
    where vih <> -1
	and provider_id not in (18, 17)
	group by provider_id
) tbl_vih
union 
select * from 
(	select  provider_id, provider_name,date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih  , count(distinct patient_id)  depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis
	from pda_pivot_report
    where depo <> -1
    and depo = 1
	and provider_id not in (18, 17)
	group by provider_id
) tbl_depo
union 
select * from 
(	select provider_id, provider_name,date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih  ,  0 depo, count(distinct patient_id) implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis	
	from
	pda_pivot_report
    where implante <> -1
    and implante = 1
    and provider_id not in (18, 17)
	group by provider_id
) tbl_implantes
union 
select * from 
(	select provider_id, provider_name,date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih  ,  0 depo, 0 implantes, count(distinct patient_id) pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis	
	from pda_pivot_report
    where pastillas <> -1
    and pastillas = 1
	and provider_id not in (18, 17)
	group by provider_id
) tbl_pastillas
union 
select * from 
(	select provider_id, provider_name,date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih  ,  0 depo, 0 implantes, 0 pastillas, count(distinct patient_id) eip, 0 infla_severa,0 vaginosis,0 candidiasis	
    from pda_pivot_report
    where eip_tratamiento = 1 
    and provider_id not in (18, 17)
    group by provider_id
) tbl_eip
union
select * from 
(	select provider_id, provider_name,date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih  ,  0 depo, 0 implantes, 0 pastillas, 0 eip, count(distinct patient_id) infla_severa,0 vaginosis,0 candidiasis	
    from pda_pivot_report
    where trat_inflam_severa = 1 
    and provider_id not in (18, 17)
    group by provider_id
) tbl_is
union
select * from 
(	select  provider_id, provider_name, date_format(encounter_datetime, '%Y%m') anio_mes, 0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih  ,  0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa, count(distinct patient_id) vaginosis, 0 candidiasis	
    from pda_pivot_report
    where trat_vaginosis_bac = 1 
    and provider_id not in (18, 17)
    group by provider_id
) tbl_vaginosis
union 
select * from
(	select  provider_id, provider_name,date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih  ,  0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa, 0 vaginosis, count(distinct patient_id) candidiasis	
    from pda_pivot_report
    where trat_candidiasis_vag = 1 
    and provider_id not in (18, 17)
    group by provider_id
) tbl_candidiasis
) tbl_fin
group by provider_id, provider_name 
;

-- , 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis 