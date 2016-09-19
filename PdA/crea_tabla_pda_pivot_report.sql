/*TABLA PIVOTE PARA INFORME PDA
Propiedad de Wuqu' Kawoq 
Autor: Neftali Sacuj
Fecha de Creación: 20160902
Version 1.
*/
drop index patient_mes_index  on pda_pivot_report  ;
drop index patien_id_index on pda_pivot_report;
drop table pda_pivot_report;


create table pda_pivot_report
(
patient_id  int (11) ,
numero_open  char (50),
encounter_id int (11),
encounter_datetime  date,
location_id  int (11),
location_name   varchar (255),

ciclo_prestamo  int (11) ,
agencia  int (5),
elegible  int (5) ,
tipo_consulta  int (5) ,

pap_inicial  int (11),
-- tip_consul_pap int (3),
cant_pap_inicial int(5),


pelvico  int (11),
-- tip_consul_pelvico int (3),
cant_pelvico int (3),

eip  int (11),
-- tip_consul_eip int (3),
cant_eip int (3),
eip_tratamiento  int (3),
eip_pareja_tatamiento int (3),

glucosa_ayunas  int (11),
-- tip_consul_glucosa_ayunas  int (3),
cant_glucosa_ayunas  int (3),

glucosa_azar  int (11),
-- tip_consul_glucosa_azar  int (3),
cant_glucosa_azar  int (3),

glucosa_elevada  int (3),

presion_sistolica  int (11),
-- tip_consul_sistolica  int (3),
cant_sistolica  int (3),

presio_diastolica  int (11),
-- tip_consul_diastolica  int (3),
cant_diastolica  int (3),

presion_art_elevada  int (3),

prueba_embarazo  int (11),
-- tip_consul_embarazo  int (3),
cant_prueba_embarazo  int (3),

embarazada  int (3),

ets  int (11),
vih  int (11),
sifilis  int (11),
hepatitis_b  int (3),
ets_positivo  int (11) ,

seno_examen  int (11),
-- tip_consul_seno  int (3),
cant_examen_seno  int (3),
resultado_examen_seno  int (3),

planificacion_familiar  int (11),
implante  int (3),
depo  int (3),
pastillas  int (3),

form_id int (11),
provider_id int (11),
provider_name varchar(250)

);

create index patien_id_index on pda_pivot_report (patient_id);

create index patient_mes_index on pda_pivot_report (patient_id, mes);


create table error_log_pda_repo
(
patient_id  int (11) ,
numero_open  char (50),
fecha_hora date,
error_msg varchar(80)
);
