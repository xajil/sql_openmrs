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
mes  date,
ciclo_prestamo  int (11) ,
agencia  int (5),
elegible  int (5) ,
tipo_consulta  int (5) ,
pap_inicial  int (11),
cant_pap_inicial int(5),
pelvico  int (11),
tip_consul_pelvico int (3),
cant_pelvico int (3),
EIP  int (3),
EIP_tratamiento  int (3),
glucosa  int (3),
glucosa_elevada  int (3),
presion_art  int (3),
presion_art_elevada  int (3),
prueba_embarazo  int (3),
embarazo_positivo  int (3),
ETS  int (3),
ETS_positivo  int (11) ,
seno_examen  int (3),
resultado_examen_seno  int (11) ,
implante  int (3),
DEPO  int (3),
pastillas  int (3)
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
