/* En otros sets de datos (especialmente en Puente - Primera Visita, Papanicolaou, Embarazo...) 
tenemos un informe empezado, pero solo sale un dato para cada persona, en vez de todos los datos. 
Eso yo puedo explicar mejor tal vez por telefono si es necesario, pero puede ver un ejemplo aca:
https://openmrs.wuqukawoq.org/puente/module/reporting/datasets/sqlDataSetEditor.form?type=org.openmrs.module.reporting.dataset.definition.SqlDataSetDefinition&uuid=60821655-fbe3-47fc-9095-0e6c8dd463bd
*/

/*
cuantas tuvieron primera visita 
y cuanta alguna obs para cada mes

*/

select 
obs.person_id as id_sistema, 
patient_identifier.identifier as numero, 
person_name.given_name as nombre, 
person_name.middle_name as segundo_nombre, 
person_name.family_name as apellido, 
	case when obs.concept_id=163138 then obs.value_numeric end as ciclo_de_prestamo,
	case when obs.concept_id=162972 then concept_name.name end as pap_inicial,
	case when obs.concept_id=163138 then location.name end as locacion, 
	case when obs.concept_id=162991 then concept_name.name end as examen_pelvico,
	case when obs.concept_id=162969 then concept_name.name end as resultado_pelvico,
	case when obs.concept_id=5085 then obs.value_numeric end as presion_sistolica,
	case when obs.concept_id=5086 then obs.value_numeric end as presion_diastolica,
	case when obs.concept_id=163130 then concept_name.name end as glucosa,
	case when obs.concept_id=162989 then concept_name.name end as historia_medica,
	case when obs.concept_id=162990 then concept_name.name end as examen_seno,
	case when obs.concept_id=159780 then concept_name.name end as resultado_seno
from obs
left join patient_identifier
on obs.person_id = patient_identifier.patient_id  and patient_identifier.identifier_type=2
left join person_name
on obs.person_id = person_name.person_id
left join concept_name
on obs.value_coded = concept_name.concept_id and concept_name.locale='es'
left join location
on obs.location_id = location.location_id
where  date_FORMAT(obs_datetime,'%Y-%m-%d') >= '2016-04-01' ;--  and obs.obs_datetime <= date_FORMAT(obs_datetime,'%Y-%m-%d') 
-- and obs.person_id = 761;

select date_FORMAT(obs_datetime,'%Y-%M-%D') as date_fomated , obs.*  from obs order by obs_datetime desc;
select date_FORMAT(obs_datetime,'%Y-%m-%d') as date_fomated , obs.*  from obs order by obs_datetime desc;

select  date_FORMAT(obs_datetime,'%Y-%m-%d'), obs.*  from obs  where date_FORMAT(obs_datetime,'%Y-%m-%d') >= '2016-04-01'order by obs_datetime asc ;

select  date_FORMAT(obs_datetime,'%Y-%M-%D'), obs.*  from obs  where obs_datetime >= datediff(sysdate(),40);