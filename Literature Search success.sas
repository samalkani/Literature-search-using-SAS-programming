%let lit=/home/ajay_malkani0/Literature Search/Literature search - reference drill down - future research.xlsx;

libname ref xport "&lit";

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
		var  PMID Title Authors Journal_Book Publication_Year Create_Date Future_Research;	
run;

proc export data=work.import1
    outfile="/home/ajay_malkani0/Literature Search/literature export.xlsx"
    dbms=xlsx
    replace;
run;


