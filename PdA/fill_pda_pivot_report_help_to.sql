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

