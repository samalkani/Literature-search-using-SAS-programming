/* Generated Code (IMPORT) */
/* Source File: Literature search - reference drill down - future research.xlsx */
/* Source Path: /home/ajay_malkani0/Literature Search */
/* Code generated on: 19/02/2024 23:39 */

%let lit=/home/ajay_malkani0/Literature Search/Literature search - reference drill down - future research.xlsx;

libname ref xport "&lit";



FILENAME REFFILE '&lit';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=ref.IMPORT;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=ref.IMPORT; RUN;


%web_drop_table(WORK.IMPORT1);


FILENAME REFFILE '/home/ajay_malkani0/Literature Search/Literature search - reference drill down - future research.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.IMPORT1;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT1; RUN;


%web_open_table(WORK.IMPORT1);

proc print data=work.import1 (obs=10) label;
		var  _NUMERIC_  _CHAR_;	
run;

