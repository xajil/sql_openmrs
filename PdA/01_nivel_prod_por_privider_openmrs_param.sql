##########################################################################
-- Name             : Informe de Produccion Mensual PdA Por Agencias
-- Date             : 20160929
-- Author           : Neftali Sacuj
-- Organization     : Wuqu' Kawoq
-- Purpose          : Conteos Nivel de Producción PdA Por Proveedor
-- Usage        	: sqlplus
-- Impact   		: N/A
-- Required grants  : SELECT
-- Called by        : OpenMRS Sql Data Set
##########################################################################
-- ver  user      date        change  
-- 1.0  @nefsacuj     20160924    initial
##########################################################################

SELECT
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
sum(candidiasis) 'Tratamiento Candidiasis Vaginal',
sum(glucosa_elegible) 'Glucosa Pacientes Elegibles', 
sum(pap_elegible) 'Pap Pacientes Elegibles',
sum(embarazo_test_elegibles) 'Teste Embarazo Elegibles', 
sum(examen_ets_elegibles) 'Examen ETS Elegibles', 
sum(depo_elegibles) 'Depo en Pacientes Elegibles', 
sum(implantes_elegibles) 'Implantes en Pacientes Elegibles'
from
(
select *
from
(		select  provider_id, provider_name, date_format(encounter_datetime, '%Y%m') anio_mes,  count(distinct patient_id) tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis, 0 glucosa_elegible, 0 pap_elegible, 0 embarazo_test_elegibles, 0 examen_ets_elegibles, 0 depo_elegibles, 0 implantes_elegibles     
		from
		pda_pivot_report
        where tipo_consulta in (1,2)
		and date_format(pda_pivot_report.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
        group by provider_id
) pacientes
union       
select *
from 
(		select  provider_id, provider_name,date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes , count(distinct patient_id)  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis, 0 glucosa_elegible, 0 pap_elegible, 0 embarazo_test_elegibles, 0 examen_ets_elegibles, 0 depo_elegibles, 0 implantes_elegibles          
		from
		pda_pivot_report
		where  embarazada = 1
		and date_format(pda_pivot_report.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
        group by provider_id
) embarazadas
union
select * from (
		select provider_id, provider_name,date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, count(encounter_id) consultas_iniciales, 0 reconsultas, 0 glucosa , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis, 0 glucosa_elegible, 0 pap_elegible, 0 embarazo_test_elegibles, 0 examen_ets_elegibles, 0 depo_elegibles, 0 implantes_elegibles                   
        from
		pda_pivot_report
		where tipo_consulta = 1
		and date_format(pda_pivot_report.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')		
		group by provider_id 
) consultas_iniciales
union 
select * from (
		select provider_id, provider_name, date_format(encounter_datetime, '%Y%m') anio_mes, 0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, count(distinct patient_id), 0 glucosa, 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis , 0 glucosa_elegible, 0 pap_elegible, 0 embarazo_test_elegibles, 0 examen_ets_elegibles, 0 depo_elegibles, 0 implantes_elegibles         
        from
        pda_pivot_report
		where tipo_consulta = 2 
		and date_format(pda_pivot_report.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
		group by provider_id
) reconsultas
union 
select * from (
		select  provider_id, provider_name, date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, count(distinct patient_id) glucosa, 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis, 0 glucosa_elegible, 0 pap_elegible, 0 embarazo_test_elegibles, 0 examen_ets_elegibles, 0 depo_elegibles, 0 implantes_elegibles        
			from (
			select   patient_id, glucosa_azar glucosa, encounter_datetime, provider_id, provider_name  from
			pda_pivot_report
			where glucosa_azar <> -1
			and date_format(pda_pivot_report.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
			union 
			select   patient_id, glucosa_ayunas glucosa, encounter_datetime, provider_id, provider_name  from
			pda_pivot_report
			where glucosa_ayunas <> -1
			and date_format(pda_pivot_report.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
			group by encounter_datetime, patient_id
		 ) a
		group by provider_id

) glucosas
union 
select * from
(
		select  provider_id, provider_name,date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , count(distinct PATIENT_ID) pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis, 0 glucosa_elegible, 0 pap_elegible, 0 embarazo_test_elegibles, 0 examen_ets_elegibles, 0 depo_elegibles, 0 implantes_elegibles        
		from pda_pivot_report
		where pap = 1267 
		and tipo_consulta = 1
		and date_format(pda_pivot_report.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
		group by provider_id
)  pap_en_primera_visita
union 
select * from 
(
		select  provider_id, provider_name,date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, count(distinct PATIENT_ID) pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis, 0 glucosa_elegible, 0 pap_elegible, 0 embarazo_test_elegibles, 0 examen_ets_elegibles, 0 depo_elegibles, 0 implantes_elegibles       
        from pda_pivot_report
		where pap = 1267 
		and tipo_consulta = 2
		and date_format(pda_pivot_report.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
		group by provider_id 
) pap_reconsulta
union 
select * from 
(
		select   provider_id, provider_name,date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, count(distinct patient_id) examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis, 0 glucosa_elegible, 0 pap_elegible, 0 embarazo_test_elegibles, 0 examen_ets_elegibles, 0 depo_elegibles, 0 implantes_elegibles         
        from pda_pivot_report
		where ets <> -1
		and date_format(pda_pivot_report.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
		group by provider_id
) ets
union 
select * from (
		select  provider_id, provider_name,date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, count(distinct patient_id) embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis, 0 glucosa_elegible, 0 pap_elegible, 0 embarazo_test_elegibles, 0 examen_ets_elegibles, 0 depo_elegibles, 0 implantes_elegibles       
		from pda_pivot_report
		where prueba_embarazo <> -1
		and date_format(pda_pivot_report.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
		group by provider_id
) test_embarazo
union
select * from  (
		select provider_id, provider_name, date_format(encounter_datetime, '%Y%m') anio_mes, 0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, count(distinct patient_id) test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis, 0 glucosa_elegible, 0 pap_elegible, 0 embarazo_test_elegibles, 0 examen_ets_elegibles, 0 depo_elegibles, 0 implantes_elegibles       
		from
		pda_pivot_report
		where hepatitis_b <> -1
		and date_format(pda_pivot_report.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
		group by provider_id
) tbl_hepatitis
union 
select * from (
	select provider_id, provider_name, date_format(encounter_datetime, '%Y%m') anio_mes, 0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, count(distinct patient_id) test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis, 0 glucosa_elegible, 0 pap_elegible, 0 embarazo_test_elegibles, 0 examen_ets_elegibles, 0 depo_elegibles, 0 implantes_elegibles     
    from
	pda_pivot_report
    where sifilis <> -1
	and date_format(pda_pivot_report.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
	group by provider_id
    ) tbl_sifilis
union 
select * from 
(	select provider_id, provider_name,date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, count(distinct patient_id) test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis, 0 glucosa_elegible, 0 pap_elegible, 0 embarazo_test_elegibles, 0 examen_ets_elegibles, 0 depo_elegibles, 0 implantes_elegibles       
    from pda_pivot_report
    where vih <> -1
	and date_format(pda_pivot_report.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
	group by provider_id
) tbl_vih
union 
select * from 
(	select  provider_id, provider_name,date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih  , count(distinct patient_id)  depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis, 0 glucosa_elegible, 0 pap_elegible, 0 embarazo_test_elegibles, 0 examen_ets_elegibles, 0 depo_elegibles, 0 implantes_elegibles     
	from pda_pivot_report
    where depo <> -1
	and date_format(pda_pivot_report.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
    and depo = 1	
	group by provider_id
) tbl_depo
union 
select * from 
(	select provider_id, provider_name,date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih  ,  0 depo, count(distinct patient_id) implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis, 0 glucosa_elegible, 0 pap_elegible, 0 embarazo_test_elegibles, 0 examen_ets_elegibles, 0 depo_elegibles, 0 implantes_elegibles     	
	from
	pda_pivot_report
    where implante <> -1
    and implante = 1
    and date_format(pda_pivot_report.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')     
	group by provider_id
) tbl_implantes
union 
select * from 
(	select provider_id, provider_name,date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih  ,  0 depo, 0 implantes, count(distinct patient_id) pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis	, 0 glucosa_elegible, 0 pap_elegible, 0 embarazo_test_elegibles, 0 examen_ets_elegibles, 0 depo_elegibles, 0 implantes_elegibles     
	from pda_pivot_report
    where pastillas <> -1
    and pastillas = 1
	and date_format(pda_pivot_report.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
	group by provider_id
) tbl_pastillas
union 
select * from 
(	select provider_id, provider_name,date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih  ,  0 depo, 0 implantes, 0 pastillas, count(distinct patient_id) eip, 0 infla_severa,0 vaginosis,0 candidiasis, 0 glucosa_elegible, 0 pap_elegible, 0 embarazo_test_elegibles, 0 examen_ets_elegibles, 0 depo_elegibles, 0 implantes_elegibles     	
    from pda_pivot_report
    where eip_tratamiento = 1
	and date_format(pda_pivot_report.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
    group by provider_id
) tbl_eip
union
select * from 
(	select provider_id, provider_name,date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih  ,  0 depo, 0 implantes, 0 pastillas, 0 eip, count(distinct patient_id) infla_severa,0 vaginosis,0 candidiasis, 0 glucosa_elegible, 0 pap_elegible, 0 embarazo_test_elegibles, 0 examen_ets_elegibles, 0 depo_elegibles, 0 implantes_elegibles     	
    from pda_pivot_report
    where trat_inflam_severa = 1 
    and date_format(pda_pivot_report.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
	group by provider_id
) tbl_is
union
select * from 
(	select  provider_id, provider_name, date_format(encounter_datetime, '%Y%m') anio_mes, 0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih  ,  0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa, count(distinct patient_id) vaginosis, 0 candidiasis, 0 glucosa_elegible, 0 pap_elegible, 0 embarazo_test_elegibles, 0 examen_ets_elegibles, 0 depo_elegibles, 0 implantes_elegibles     	
    from pda_pivot_report
    where trat_vaginosis_bac = 1 
    and date_format(pda_pivot_report.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
	group by provider_id
) tbl_vaginosis
union 
select * from
(	select  provider_id, provider_name,date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih  ,  0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa, 0 vaginosis, count(distinct patient_id) candidiasis, 0 glucosa_elegible, 0 pap_elegible, 0 embarazo_test_elegibles, 0 examen_ets_elegibles, 0 depo_elegibles, 0 implantes_elegibles     	
    from pda_pivot_report
    where trat_candidiasis_vag = 1 
    and date_format(pda_pivot_report.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
	group by provider_id
) tbl_candidiasis
union
select * from 
			(select  provider_id, provider_name, date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis,  count(distinct patient_id) glucosa_elegible, 0 pap_elegible, 0 embarazo_test_elegibles, 0 examen_ets_elegibles, 0 depo_elegibles, 0 implantes_elegibles
			from (
			select   patient_id, glucosa_azar glucosa, encounter_datetime, provider_id, provider_name  from
			pda_pivot_report
			where glucosa_azar <> -1
            and agencia = 1
            and elegible = 1
			and date_format(pda_pivot_report.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
			union 
			select   patient_id, glucosa_ayunas glucosa, encounter_datetime, provider_id, provider_name  from
			pda_pivot_report
			where glucosa_ayunas <> -1
			and agencia = 1
            and elegible = 1
			and date_format(pda_pivot_report.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
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
		and date_format(pda_pivot_report.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
		group by provider_id
        ) pap_elegible
        
union
select * from (
		select provider_id, provider_name, date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis,  0 glucosa_elegible, 0 pap_elegible, count(distinct patient_id) embarazo_test_elegibles , 0 examen_ets_elegibles, 0 depo_elegibles, 0 implantes_elegibles
        from pda_pivot_report
		where prueba_embarazo <> -1
		and agencia = 1
        and elegible = 1
		and date_format(pda_pivot_report.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
		group by provider_id
) test_embarazo_elegible
union
select * from 
(
		select  provider_id, provider_name, date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis,  0 glucosa_elegible, 0 pap_elegible, 0 embarazo_test_elegibles, count(distinct patient_id) examen_ets_elegibles, 0 depo_elegibles, 0 implantes_elegibles
        from pda_pivot_report
		where ets <> -1
		and agencia = 1
        and elegible = 1
		and date_format(pda_pivot_report.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
		group by provider_id
) ets_elegible
union
select * from 
(	select provider_id, provider_name, date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis,  0 glucosa_elegible, 0 pap_elegible, 0 embarazo_test_elegibles, 0 examen_ets_elegibles, count(distinct patient_id) depo_elegibles, 0 implantes_elegibles
	from pda_pivot_report
    where depo <> -1
    and depo = 1	
		and agencia = 1
        and elegible = 1
	and date_format(pda_pivot_report.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
	group by provider_id
) tbl_depo_elegibles
union
select * from 
(	select provider_id, provider_name, date_format(encounter_datetime, '%Y%m') anio_mes,  0 tot_pacientes, 0  tot_embarazadas, 0 consultas_iniciales, 0 reconsultas, 0 glucosa  , 0 pap_primera_visita, 0 pap_reconsulta, 0 examen_ets, 0 embarazo_test, 0 test_hepatitis, 0 test_sifilis, 0 test_vih, 0 depo, 0 implantes, 0 pastillas, 0 eip, 0 infla_severa,0 vaginosis,0 candidiasis,  0 glucosa_elegible, 0 pap_elegible, 0 embarazo_test_elegibles, 0 examen_ets_elegibles, 0 depo_elegibles, count(distinct patient_id) implantes_elegibles
	from
	pda_pivot_report
    where implante <> -1
    and implante = 1   
		and agencia = 1
        and elegible = 1
	and date_format(pda_pivot_report.encounter_datetime, '%Y%m%d')  between date_format(:startDate, '%Y%m%d') and date_format( :endDate, '%Y%m%d')
	group by provider_id
) tbl_implantes_elegibles
) tbl_fin
group by provider_id, provider_name;