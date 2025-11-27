/* Importing excel file into SAS data set */

options yearcutoff=1960;

%web_drop_table(WORK.IMPORT1);


FILENAME REFFILE '/home/ajay_malkani0/Literature Search/Literature search - complete set.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.IMPORT1;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT1; RUN;


%web_open_table(WORK.IMPORT1);

/* Displaying first 10 observations of imported excel file in a SAS data set */

proc print data=work.import1 (obs=10) label;
		var  PMID Title Authors Journal_Book Publication_Year Create_Date Future_Research;	
run;

/* Creating SAS libname */

%let lit=/home/ajay_malkani0/Literature Search/smaller sets;

libname ref "&lit";

/* Creating a smaller SAS data set */



data ref.smaller_set;
	retain ref_no 0;
	ref_no=ref_no + 1;	
	set work.import1 (keep=PMID Title Authors Keywords Review_No Journal_Book Publication_Year Create_Date Future_Research);
run;

PROC CONTENTS DATA=ref.smaller_set; RUN;


/* Displaying first 10 observations of smaller SAS data set */

title 'Smaller data set';

proc print data=ref.smaller_set (obs=2) label;
			
run;

/* Exported excel file from the smaller SAS data set for splitting the future research column */
/* into 4 new columns; main findings, strengths, weaknesses and research gaps - these three columns */
/* are added manually into the excel spreadsheet */

proc export data=ref.smaller_set
    outfile="/home/ajay_malkani0/Literature Search/smaller complete set.xlsx"
    dbms=xlsx
    replace;
run;

/* Importing smaller complete set modified excel file into SAS data set */

options yearcutoff=1960;

%web_drop_table(WORK.IMPORT2);


FILENAME REFFILE '/home/ajay_malkani0/Literature Search/smaller complete set modified.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.IMPORT2;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT2; RUN;


%web_open_table(WORK.IMPORT2);

data ref.smaller_set(rename=(Research_Gaps=Future_Research));
	retain ref_no 0;
	ref_no=ref_no + 1;	
	set work.import2 (keep=PMID Title Authors Keywords Review_No Journal_Book 
						Publication_Year Create_Date Main_Findings Strengths 
						Weaknesses Research_Gaps);
run;

/* Displaying modified smaller data set after addition of 4 extra columns dropping future research column 
		and renaming research gaps column and future research column */

title 'Modified Smaller data set';

proc print data=ref.smaller_set (obs=5) label;
			
run;


/* Splitting the smaller data set into potential research topics */

/* Displaying research topic SAS data set */

/* setting word document options */

options orientation=landscape topmargin=1in bottommargin=1in 
		leftmargin=0.5in rightmargin=0.5in;

/* Amino acids */


data ref.amino_acids ref.other;
	set ref.smaller_set;
	if find(Keywords, 'amino acids', 'I')>0 then output ref.amino_acids;
	else output ref.other;
run;

proc sort data=ref.amino_acids	
	out=ref.amino_acids_sorted;
	by descending Create_Date;	
run;

data ref.amino_acids_sorted_1 (keep=sub_ref_no ref_no PMID Authors Journal_Book Create_Date) 
		ref.amino_acids_sorted_2 (keep=sub_ref_no Title Main_Findings)
		ref.amino_acids_sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research)
		ref.amino_acids_sorted_4 (keep=sub_ref_no ref_no PMID Authors Journal_Book Create_Date 
										Title Main_Findings Strengths Weaknesses Future_Research Research_Gaps);
	    retain sub_ref_no 0;		
		sub_ref_no=sub_ref_no + 1;		
		set ref.amino_acids_sorted (keep=ref_no PMID Title Authors Journal_Book Create_Date Main_Findings Strengths 
						              Weaknesses Future_Research);
		Research_Gaps="";
run;

ods html5 file="&lit/Amino_acids_1_.html" style=SasWeb;
title 'Amino acids data set 1';
proc print data=ref.amino_acids_sorted_1 noobs;			
run;
ods html5 close;

ods html5 file="&lit/Amino_acids_2_.html" style=SasWeb;
title 'Amino acids data set 2';
proc print data=ref.amino_acids_sorted_2 noobs;			
run;
ods html5 close;

ods html5 file="&lit/Amino_acids_3_.html" style=SasWeb;
title 'Amino acids data set 3';
proc print data=ref.amino_acids_sorted_3 noobs;			
run;
ods html5 close;

/* Exported excel file from sorted research topics SAS data set  */

proc export data=ref.amino_acids_sorted_4
    outfile="/home/ajay_malkani0/Literature Search/smaller sets/amino_acids_sorted_4.xlsx"
    dbms=xlsx
    replace;
run;

/* Lipids */

data ref.lipids ref.other;
	set ref.smaller_set;
	if find(Keywords, 'lipids', 'I')>0 then output ref.lipids;	
	else output ref.other;
run;


proc sort data=ref.lipids	
	out=ref.lipids_sorted;
	by descending Create_Date;	
run;

data ref.lipids_sorted_1 (keep=sub_ref_no ref_no PMID Authors Journal_Book Create_Date) 
		ref.lipids_sorted_2 (keep=sub_ref_no Title Main_Findings)
		ref.lipids_sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research)
		ref.lipids_sorted_4 (keep=sub_ref_no ref_no PMID Authors Journal_Book Create_Date 
										Title Main_Findings Strengths Weaknesses Future_Research Research_Gaps);
	retain sub_ref_no 0;
	sub_ref_no=sub_ref_no + 1;		
	set ref.lipids_sorted (keep=ref_no PMID Title Authors Journal_Book Create_Date Main_Findings Strengths 
						         Weaknesses Future_Research);
	Research_Gaps="";
run;

ods html5 file="&lit/Lipids_1_.html" style=SasWeb;
title 'Lipids data set 1';
proc print data=ref.lipids_sorted_1 noobs;			
run;
ods html5 close;

ods html5 file="&lit/Lipids_2_.html" style=SasWeb;
title 'Lipids data set 2';
proc print data=ref.lipids_sorted_2 noobs;			
run;
ods html5 close;

ods html5 file="&lit/Lipids_3_.html" style=SasWeb;
title 'Lipids data set 3';
proc print data=ref.lipids_sorted_3 noobs;			
run;
ods html5 close;

/* Exported excel file from sorted research topics SAS data set  */

proc export data=ref.lipids_sorted_4
    outfile="/home/ajay_malkani0/Literature Search/smaller sets/lipids_sorted_4.xlsx"
    dbms=xlsx
    replace;
run;


/* Energy Metabolism */

data ref.energy_metabolism ref.other;
	set ref.smaller_set;
	if find(Keywords, 'energy metabolism', 'I')>0 then output ref.energy_metabolism;
	else output ref.other;
run;

proc sort data=ref.energy_metabolism	
	out=ref.energy_metabolism_sorted;
	by descending Create_Date;	
run;

data ref.energy_metabolism_sorted_1 (keep=sub_ref_no ref_no PMID Authors Journal_Book Create_Date) 
		ref.energy_metabolism_sorted_2 (keep=sub_ref_no Title Main_Findings)
		ref.energy_metabolism_sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research) 
		ref.energy_metabolism_sorted_4 (keep=sub_ref_no ref_no PMID Authors Journal_Book Create_Date 
										Title Main_Findings Strengths Weaknesses Future_Research Research_Gaps);
	retain sub_ref_no 0;
	sub_ref_no=sub_ref_no + 1;		
	set ref.energy_metabolism_sorted (keep=ref_no PMID Title Authors Journal_Book Create_Date Main_Findings Strengths 
						                    Weaknesses Future_Research);
	Research_Gaps="";
run;

ods html5 file="&lit/Energy_Metabolism_1_.html" style=SasWeb;
title 'Energy metabolism data set 1';
proc print data=ref.energy_metabolism_sorted_1 noobs;			
run;
ods html5 close;

ods html5 file="&lit/Energy_Metabolism_2_.html" style=SasWeb;
title 'Energy metabolism data set 2';
proc print data=ref.energy_metabolism_sorted_2 noobs;			
run;
ods html5 close;

ods html5 file="&lit/Energy_Metabolism_3_.html" style=SasWeb;
title 'Energy metabolism data set 3';
proc print data=ref.energy_metabolism_sorted_3 noobs;			
run;
ods html5 close;

/* Exported excel file from sorted research topics SAS data set  */

proc export data=ref.energy_metabolism_sorted_4
    outfile="/home/ajay_malkani0/Literature Search/smaller sets/energy_metabolism_sorted_4.xlsx"
    dbms=xlsx
    replace;
run;

/* Micro RNA */

data ref.micro_RNA ref.other;
	set ref.smaller_set;
	if find(Keywords, 'micro RNA', 'I')>0 then output ref.micro_RNA;
	else output ref.other;
run;

proc sort data=ref.micro_RNA	
	out=ref.micro_RNA_sorted;
	by descending Create_Date;	
run;

data ref.micro_RNA_sorted_1 (keep=sub_ref_no ref_no PMID Authors Journal_Book Create_Date) 
		ref.micro_RNA_sorted_2 (keep=sub_ref_no Title Main_Findings)
		ref.micro_RNA_sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research)
		ref.micro_RNA_sorted_4 (keep=sub_ref_no ref_no PMID Authors Journal_Book Create_Date 
										Title Main_Findings Strengths Weaknesses Future_Research Research_Gaps);
	retain sub_ref_no 0;
	sub_ref_no=sub_ref_no + 1;		
	set ref.micro_RNA_sorted (keep=ref_no PMID Title Authors Journal_Book Create_Date Main_Findings Strengths 
						            Weaknesses Future_Research);
	Research_Gaps="";
run;

ods html5 file="&lit/Micro_RNA_1_.html" style=SasWeb ;
title 'Micro RNA data set 1';
proc print data=ref.micro_RNA_sorted_1 noobs;			
run;
ods html5 close;

ods html5 file="&lit/Micro_RNA_2_.html" style=SasWeb ;
title 'Micro RNA data set 2';
proc print data=ref.micro_RNA_sorted_2 noobs;			
run;
ods html5 close;

ods html5 file="&lit/Micro_RNA_3_.html" style=SasWeb ;
title 'Micro RNA data set 3';
proc print data=ref.micro_RNA_sorted_3 noobs;			
run;
ods html5 close;

/* Exported excel file from sorted research topics SAS data set  */

proc export data=ref.micro_RNA_sorted_4
    outfile="/home/ajay_malkani0/Literature Search/smaller sets/micro_RNA_sorted_4.xlsx"
    dbms=xlsx
    replace;
run;


/* CVD */

data ref.CVD ref.other;
	set ref.smaller_set;
	if find(Keywords, 'CVD', 'I')>0 then output ref.CVD;
	else output ref.other;
run;

proc sort data=ref.CVD	
	out=ref.CVD_sorted;
	by descending Create_Date;	
run;

data ref.CVD_sorted_1 (keep=sub_ref_no ref_no PMID Authors Journal_Book Create_Date)
		ref.CVD_sorted_2 (keep=sub_ref_no Title Main_Findings)
		ref.CVD_sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research)
		ref.CVD_sorted_4 (keep=sub_ref_no ref_no PMID Authors Journal_Book Create_Date 
										Title Main_Findings Strengths Weaknesses Future_Research Research_Gaps);
	retain sub_ref_no 0;
	sub_ref_no=sub_ref_no + 1;		
	set ref.CVD_sorted (keep=ref_no PMID Title Authors Journal_Book Create_Date Main_Findings Strengths 
						      Weaknesses Future_Research);
	Research_Gaps="";
run;

ods html5 file="&lit/CVD_1_.html" style=SasWeb;
title 'CVD data set 1';
proc print data=ref.CVD_sorted_1 noobs;			
run;
ods html5 close;

ods html5 file="&lit/CVD_2_.html" style=SasWeb;
title 'CVD data set 2';
proc print data=ref.CVD_sorted_2 noobs;			
run;
ods html5 close;

ods html5 file="&lit/CVD_3_.html" style=SasWeb;
title 'CVD data set 3';
proc print data=ref.CVD_sorted_3 noobs;			
run;
ods html5 close;

/* Exported excel file from sorted research topics SAS data set  */

proc export data=ref.CVD_sorted_4
    outfile="/home/ajay_malkani0/Literature Search/smaller sets/CVD_sorted_4.xlsx"
    dbms=xlsx
    replace;
run;



/* Mendelian Randomization */

data ref.MR ref.other;
	set ref.smaller_set;
	if find(Keywords, 'mendelian randomisation', 'I')>0 then output ref.MR;
	else if find(Keywords, 'mendelian randomization', 'I')>0 then output ref.MR;
	else output ref.other;
run;

proc sort data=ref.MR	
	out=ref.MR_sorted;
	by descending Create_Date;	
run;

data ref.MR_sorted_1 (keep=sub_ref_no ref_no PMID Authors Journal_Book Create_Date) 
		ref.MR_sorted_2 (keep=sub_ref_no Title Main_Findings)
		ref.MR_sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research)
		ref.MR_sorted_4 (keep=sub_ref_no ref_no PMID Authors Journal_Book Create_Date 
										Title Main_Findings Strengths Weaknesses Future_Research Research_Gaps);
	retain sub_ref_no 0;
	sub_ref_no=sub_ref_no + 1;		
	set ref.MR_sorted (keep=ref_no PMID Title Authors Journal_Book Create_Date Main_Findings Strengths 
						       Weaknesses Future_Research);
	Research_Gaps="";
run;

ods html5 file="&lit/MR_1_.html" style=SasWeb;
title 'MR data set 1';
proc print data=ref.MR_sorted_1 noobs;			
run;
ods html5 close;

ods html5 file="&lit/MR_2_.html" style=SasWeb;
title 'MR data set 2';
proc print data=ref.MR_sorted_2 noobs;			
run;
ods html5 close;

ods html5 file="&lit/MR_3_.html" style=SasWeb;
title 'MR data set 3';
proc print data=ref.MR_sorted_3 noobs;			
run;
ods html5 close;

/* Exported excel file from sorted research topics SAS data set  */

proc export data=ref.MR_sorted_4
    outfile="/home/ajay_malkani0/Literature Search/smaller sets/MR_sorted_4.xlsx"
    dbms=xlsx
    replace;
run;



/* GWAS - genome wide association studies */

data ref.gwas ref.other;
	set ref.smaller_set;
	if find(Keywords, 'GWAS', 'I')>0 then output ref.gwas;
	else output ref.other;
run;

proc sort data=ref.gwas	
	out=ref.gwas_sorted;
	by descending Create_Date;	
run;

data ref.gwas_sorted_1 (keep=sub_ref_no ref_no PMID Authors Journal_Book Create_Date) 
		ref.gwas_sorted_2 (keep=sub_ref_no Title Main_Findings)
		ref.gwas_sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research)
		ref.gwas_sorted_4 (keep=sub_ref_no ref_no PMID Authors Journal_Book Create_Date 
										Title Main_Findings Strengths Weaknesses Future_Research Research_Gaps);
	retain sub_ref_no 0;
	sub_ref_no=sub_ref_no + 1;		
	set ref.gwas_sorted (keep=ref_no PMID Title Authors Journal_Book Create_Date Main_Findings Strengths 
						       Weaknesses Future_Research);
	Research_Gaps="";
run;

ods html5 file="&lit/GWAS_1_.html" style=SasWeb;
title 'GWAS - (genome wide association studies) data set 1';
proc print data=ref.gwas_sorted_1 noobs;			
run;
ods html5 close;

ods html5 file="&lit/GWAS_2_.html" style=SasWeb;
title 'GWAS - (genome wide association studies) data set 2';
proc print data=ref.gwas_sorted_2 noobs;			
run;
ods html5 close;

ods html5 file="&lit/GWAS_3_.html" style=SasWeb;
title 'GWAS - (genome wide association studies) data set 3';
proc print data=ref.gwas_sorted_3 noobs;			
run;
ods html5 close;

/* Exported excel file from sorted research topics SAS data set  */

proc export data=ref.GWAS_sorted_4
    outfile="/home/ajay_malkani0/Literature Search/smaller sets/GWAS_sorted_4.xlsx"
    dbms=xlsx
    replace;
run;


/* Methodology */

data ref.methodology ref.other;
	set ref.smaller_set;
	if find(Keywords, 'methodology', 'I')>0 then output ref.methodology;
	else output ref.other;
run;

proc sort data=ref.methodology	
	out=ref.methodology_sorted;
	by descending Create_Date;	
run;

data ref.methodology_sorted_1 (keep=sub_ref_no ref_no  PMID Authors Journal_Book Create_Date)
		ref.methodology_sorted_2 (keep=sub_ref_no Title Main_Findings)
		ref.methodology_sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research)
		ref.methodology_sorted_4 (keep=sub_ref_no ref_no PMID Authors Journal_Book Create_Date 
										Title Main_Findings Strengths Weaknesses Future_Research Research_Gaps);
	retain sub_ref_no 0;
	sub_ref_no=sub_ref_no + 1;		
	set ref.methodology_sorted (keep=ref_no PMID Title Authors Journal_Book Create_Date Main_Findings Strengths 
						              Weaknesses Future_Research);
	Research_Gaps="";
run;

ods html5 file="&lit/methodology_1_.html" style=SasWeb;
title 'Methodology data set 1';
proc print data=ref.methodology_sorted_1 noobs;			
run;
ods html5 close;

ods html5 file="&lit/methodology_2_.html" style=SasWeb;
title 'Methodology data set 2';
proc print data=ref.methodology_sorted_2 noobs;			
run;
ods html5 close;

ods html5 file="&lit/methodology_3_.html" style=SasWeb;
title 'Methodology data set 3';
proc print data=ref.methodology_sorted_3 noobs;			
run;
ods html5 close;

/* Exported excel file from sorted research topics SAS data set  */

proc export data=ref.methodology_sorted_4
    outfile="/home/ajay_malkani0/Literature Search/smaller sets/methodology_sorted_4.xlsx"
    dbms=xlsx
    replace;
run;

/* Ethnicity */

data ref.ethnicity ref.other;
	set ref.smaller_set;
	if find(Keywords, 'ethnicity', 'I')>0 then output ref.ethnicity;
	else output ref.other;
run;

proc sort data=ref.ethnicity	
	out=ref.ethnicity_sorted;
	by descending Create_Date;	
run;

data ref.ethnicity_sorted_1 (keep=sub_ref_no ref_no  PMID Authors Journal_Book Create_Date)
		ref.ethnicity_sorted_2 (keep=sub_ref_no Title Main_Findings)
		ref.ethnicity_sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research)
		ref.ethnicity_sorted_4 (keep=sub_ref_no ref_no PMID Authors Journal_Book Create_Date 
										Title Main_Findings Strengths Weaknesses Future_Research Research_Gaps);
	retain sub_ref_no 0;
	sub_ref_no=sub_ref_no + 1;		
	set ref.ethnicity_sorted (keep=ref_no PMID Title Authors Journal_Book Create_Date Main_Findings Strengths 
						             Weaknesses Future_Research);
	Research_Gaps="";
run;

ods html5 file="&lit/ethnicity_1_.html" style=SasWeb;
title 'Ethnicity data set 1';
proc print data=ref.ethnicity_sorted_1 noobs;			
run;
ods html5 close;

ods html5 file="&lit/ethnicity_2_.html" style=SasWeb;
title 'Ethnicity data set 2';
proc print data=ref.ethnicity_sorted_2 noobs;			
run;
ods html5 close;

ods html5 file="&lit/ethnicity_3_.html" style=SasWeb;
title 'Ethnicity data set 3';
proc print data=ref.ethnicity_sorted_3 noobs;			
run;
ods html5 close;

/* Exported excel file from sorted research topics SAS data set  */

proc export data=ref.ethnicity_sorted_4
    outfile="/home/ajay_malkani0/Literature Search/smaller sets/ethnicity_sorted_4.xlsx"
    dbms=xlsx
    replace;
run;


/* Diet */

data ref.diet ref.other;
	set ref.smaller_set;
	if find(Keywords, 'diet', 'I')>0 then output ref.diet;
	else output ref.other;
run;

proc sort data=ref.diet	
	out=ref.diet_sorted;
	by descending Create_Date;	
run;

data ref.diet_sorted_1 (keep=sub_ref_no ref_no  PMID Authors Journal_Book Create_Date)
		ref.diet_sorted_2 (keep=sub_ref_no Title Main_Findings)
		ref.diet_sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research)
		ref.diet_sorted_4 (keep=sub_ref_no ref_no PMID Authors Journal_Book Create_Date 
										Title Main_Findings Strengths Weaknesses Future_Research Research_Gaps);
	retain sub_ref_no 0;
	sub_ref_no=sub_ref_no + 1;		
	set ref.diet_sorted (keep=ref_no PMID Title Authors Journal_Book Create_Date Main_Findings Strengths 
						        Weaknesses Future_Research);
	Research_Gaps="";
run;

ods html5 file="&lit/diet_1_.html" style=SasWeb;
title 'Diet data set 1';
proc print data=ref.diet_sorted_1 noobs;			
run;
ods html5 close;

ods html5 file="&lit/diet_2_.html" style=SasWeb;
title 'Diet data set 2';
proc print data=ref.diet_sorted_2 noobs;			
run;
ods html5 close;

ods html5 file="&lit/diet_3_.html" style=SasWeb;
title 'Diet data set 3';
proc print data=ref.diet_sorted_3 noobs;			
run;
ods html5 close;

/* Exported excel file from sorted research topics SAS data set  */

proc export data=ref.diet_sorted_4
    outfile="/home/ajay_malkani0/Literature Search/smaller sets/diet_sorted_4.xlsx"
    dbms=xlsx
    replace;
run;


/* Microbiota */

data ref.microbiota ref.other;
	set ref.smaller_set;
	if find(Keywords, 'microbiota', 'I')>0 then output ref.microbiota;
	else output ref.other;
run;

proc sort data=ref.microbiota	
	out=ref.microbiota_sorted;
	by descending Create_Date;	
run;

data ref.microbiota_sorted_1 (keep=sub_ref_no ref_no  PMID Authors Journal_Book Create_Date)
		ref.microbiota_sorted_2 (keep=sub_ref_no Title Main_Findings)
		ref.microbiota_sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research)
		ref.microbiota_sorted_4 (keep=sub_ref_no ref_no PMID Authors Journal_Book Create_Date 
										Title Main_Findings Strengths Weaknesses Future_Research Research_Gaps);
	retain sub_ref_no 0;
	sub_ref_no=sub_ref_no + 1;		
	set ref.microbiota_sorted (keep=ref_no PMID Title Authors Journal_Book Create_Date Main_Findings Strengths 
						             Weaknesses Future_Research);
	Research_Gaps="";
run;

ods html5 file="&lit/microbiota_1_.html" style=SasWeb;
title 'Microbiota data set 1';
proc print data=ref.microbiota_sorted_1 noobs;			
run;
ods html5 close;

ods html5 file="&lit/microbiota_2_.html" style=SasWeb;
title 'Microbiota data set 2';
proc print data=ref.microbiota_sorted_2 noobs;			
run;
ods html5 close;

ods html5 file="&lit/microbiota_3_.html" style=SasWeb;
title 'Microbiota data set 3';
proc print data=ref.microbiota_sorted_3 noobs;			
run;
ods html5 close;

/* Exported excel file from sorted research topics SAS data set  */

proc export data=ref.microbiota_sorted_4
    outfile="/home/ajay_malkani0/Literature Search/smaller sets/microbiota_sorted_4.xlsx"
    dbms=xlsx
    replace;
run;

/* Iron/Ferritin */

data ref.ferritin ref.other;
	set ref.smaller_set;
	if find(Keywords, 'ferritin', 'I')>0 then output ref.ferritin;
	else if find(Keywords, 'iron', 'I')>0 then output ref.ferritin;
	else output ref.other;
run;

proc sort data=ref.ferritin	
	out=ref.ferritin_sorted;
	by descending Create_Date;	
run;

data ref.ferritin_sorted_1 (keep=sub_ref_no ref_no  PMID Authors Journal_Book Create_Date)
		ref.ferritin_sorted_2 (keep=sub_ref_no Title Main_Findings)
		ref.ferritin_sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research)
		ref.ferritin_sorted_4 (keep=sub_ref_no ref_no PMID Authors Journal_Book Create_Date 
										Title Main_Findings Strengths Weaknesses Future_Research Research_Gaps);
	retain sub_ref_no 0;
	sub_ref_no=sub_ref_no + 1;		
	set ref.ferritin_sorted (keep=ref_no PMID Title Authors Journal_Book Create_Date Main_Findings Strengths 
						             Weaknesses Future_Research);
	Research_Gaps="";
run;

ods html5 file="&lit/ferritin_1_.html" style=SasWeb;
title 'Ferritin data set 1';
proc print data=ref.ferritin_sorted_1 noobs;			
run;
ods html5 close;

ods html5 file="&lit/ferritin_2_.html" style=SasWeb;
title 'Ferritin data set 2';
proc print data=ref.ferritin_sorted_2 noobs;			
run;
ods html5 close;

ods html5 file="&lit/ferritin_3_.html" style=SasWeb;
title 'Ferritin data set 3';
proc print data=ref.ferritin_sorted_3 noobs;			
run;
ods html5 close;

/* Exported excel file from sorted research topics SAS data set  */

proc export data=ref.ferritin_sorted_4
    outfile="/home/ajay_malkani0/Literature Search/smaller sets/ferritin_sorted_4.xlsx"
    dbms=xlsx
    replace;
run;

/* Biomarkers */

data ref.biomarkers ref.other;
	set ref.smaller_set;
	if find(Keywords, 'biomarkers', 'I')>0 then output ref.biomarkers;
	else output ref.other;
run;

proc sort data=ref.biomarkers	
	out=ref.biomarkers_sorted;
	by descending Create_Date;	
run;

data ref.biomarkers_sorted_1 (keep=sub_ref_no ref_no  PMID Authors Journal_Book Create_Date)
		ref.biomarkers_sorted_2 (keep=sub_ref_no Title Main_Findings)
		ref.biomarkers_sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research)
		ref.biomarkers_sorted_4 (keep=sub_ref_no ref_no PMID Authors Journal_Book Create_Date 
										Title Main_Findings Strengths Weaknesses Future_Research Research_Gaps);
	retain sub_ref_no 0;
	sub_ref_no=sub_ref_no + 1;		
	set ref.biomarkers_sorted (keep=ref_no PMID Title Authors Journal_Book Create_Date Main_Findings Strengths 
						             Weaknesses Future_Research);
	Research_Gaps="";
run;

ods html5 file="&lit/biomarkers_1_.html" style=SasWeb;
title 'Biomarkers data set 1';
proc print data=ref.biomarkers_sorted_1 noobs;			
run;
ods html5 close;

ods html5 file="&lit/biomarkers_2_.html" style=SasWeb;
title 'Biomarkers data set 2';
proc print data=ref.biomarkers_sorted_2 noobs;			
run;
ods html5 close;

ods html5 file="&lit/biomarkers_3_.html" style=SasWeb;
title 'Biomarkers data set 3';
proc print data=ref.biomarkers_sorted_3 noobs;			
run;
ods html5 close;

/* Exported excel file from sorted research topics SAS data set  */

proc export data=ref.biomarkers_sorted_4
    outfile="/home/ajay_malkani0/Literature Search/smaller sets/biomarkers_sorted_4.xlsx"
    dbms=xlsx
    replace;
run;

/* Finding common observations in Amino acids + lipids + energy metabolism + micro rna + 
CVD + Ethnicity + Diet + Microbiota + Ferritin data sets */

proc sort data=ref.amino_acids_sorted_1	
	out=ref.amino_acids_sorted_alt;
	by ref_no;	
run;

proc sort data=ref.lipids_sorted_1	
	out=ref.lipids_sorted_alt;
	by ref_no;	
run;

proc sort data=ref.energy_metabolism_sorted_1	
	out=ref.energy_metabolism_sorted_alt;
	by ref_no;	
run;

proc sort data=ref.micro_rna_sorted_1	
	out=ref.micro_rna_sorted_alt;
	by ref_no;	
run;

proc sort data=ref.CVD_sorted_1	
	out=ref.CVD_sorted_alt;
	by ref_no;	
run;

proc sort data=ref.ethnicity_sorted_1	
	out=ref.ethnicity_sorted_alt;
	by ref_no;	
run;

proc sort data=ref.diet_sorted_1	
	out=ref.diet_sorted_alt;
	by ref_no;	
run;

proc sort data=ref.microbiota_sorted_1	
	out=ref.microbiota_sorted_alt;
	by ref_no;	
run;

proc sort data=ref.ferritin_sorted_1	
	out=ref.ferritin_sorted_alt;
	by ref_no;	
run;

proc sort data=ref.MR_sorted_1	
	out=ref.MR_sorted_alt;
	by ref_no;	
run;

proc sort data=ref.GWAS_sorted_1	
	out=ref.GWAS_sorted_alt;
	by ref_no;	
run;

proc sort data=ref.biomarkers_sorted_1	
	out=ref.biomarkers_sorted_alt;
	by ref_no;	
run;

proc sort data=ref.methodology_sorted_1	
	out=ref.methodology_sorted_alt;
	by ref_no;	
run;

data ref.combined (keep=ref_no Authors);
			merge ref.amino_acids_sorted_alt(in=amino)
				  ref.lipids_sorted_alt(in=lipid)
				  ref.energy_metabolism_sorted_alt(in=energy)
				  ref.micro_rna_sorted_alt(in=micro)
				  ref.CVD_sorted_alt(in=CVD)
				  ref.ethnicity_sorted_alt(in=ethnic)
				  ref.diet_sorted_alt(in=diet)
				  ref.microbiota_sorted_alt(in=microb)
				  ref.ferritin_sorted_alt(in=ferritin)
				  ref.MR_sorted_alt(in=MR)
				  ref.GWAS_sorted_alt(in=GWAS)
				  ref.biomarkers_sorted_alt(in=bio);
			by ref_no;
			if amino=1 or lipid=1 or energy=1 or micro=1 or CVD=1 or ethnic=1 or diet=1 or microb=1 or ferritin=1 or MR=1 or GWAS=1 or bio=1;
run;

proc print data=ref.combined;
run;

data ref.combined_1 (keep=ref_no Authors);
			merge ref.combined(in=combo)
				  ref.methodology_sorted_alt(in=method);
			by ref_no;
			if combo=1 and method=1;
run;

proc print data=ref.combined_1;
run;

/* Importing modified excel files with revised main findings (as notes) and research gaps */

FILENAME amino '/home/ajay_malkani0/Literature Search/sorted sets/amino_acids_sorted_4_modified.xlsx';

PROC IMPORT DATAFILE=amino
	DBMS=XLSX
	REPLACE
	OUT=WORK.amino_acids_sorted_4_modified;
	GETNAMES=YES;
	
RUN;

PROC CONTENTS DATA=WORK.amino_acids_sorted_4_modified; RUN;

FILENAME lipids '/home/ajay_malkani0/Literature Search/sorted sets/lipids_sorted_4_modified.xlsx';

PROC IMPORT DATAFILE=lipids
	DBMS=XLSX
	REPLACE
	OUT=WORK.lipids_sorted_4_modified;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.lipids_sorted_4_modified; RUN;

FILENAME energy '/home/ajay_malkani0/Literature Search/sorted sets/energy_metabolism_sorted_4_modified.xlsx';

PROC IMPORT DATAFILE=energy
	DBMS=XLSX
	REPLACE
	OUT=WORK.energy_sorted_4_modified;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.energy_sorted_4_modified; RUN;

FILENAME micro '/home/ajay_malkani0/Literature Search/sorted sets/micro_RNA_sorted_4.xlsx';

PROC IMPORT DATAFILE=micro
	DBMS=XLSX
	REPLACE
	OUT=WORK.micro_RNA_sorted_4_modified;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.micro_RNA_sorted_4_modified; RUN;

FILENAME CVD '/home/ajay_malkani0/Literature Search/sorted sets/CVD_sorted_4.xlsx';

PROC IMPORT DATAFILE=CVD
	DBMS=XLSX
	REPLACE
	OUT=WORK.CVD_sorted_4_modified;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.CVD_sorted_4_modified; RUN;

FILENAME ethnic '/home/ajay_malkani0/Literature Search/sorted sets/ethnicity_sorted_4.xlsx';

PROC IMPORT DATAFILE=ethnic
	DBMS=XLSX
	REPLACE
	OUT=WORK.ethnicity_sorted_4_modified;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.ethnicity_sorted_4_modified; RUN;

FILENAME diet '/home/ajay_malkani0/Literature Search/sorted sets/diet_sorted_4.xlsx';

PROC IMPORT DATAFILE=diet
	DBMS=XLSX
	REPLACE
	OUT=WORK.diet_sorted_4_modified;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.diet_sorted_4_modified; RUN;

FILENAME micro '/home/ajay_malkani0/Literature Search/sorted sets/microbiota_sorted_4.xlsx';

PROC IMPORT DATAFILE=micro
	DBMS=XLSX
	REPLACE
	OUT=WORK.microbiota_sorted_4_modified;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.microbiota_sorted_4_modified; RUN;

FILENAME ferritin '/home/ajay_malkani0/Literature Search/sorted sets/ferritin_sorted_4.xlsx';

PROC IMPORT DATAFILE=ferritin
	DBMS=XLSX
	REPLACE
	OUT=WORK.ferritin_sorted_4_modified;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.ferritin_sorted_4_modified; RUN;

FILENAME MR '/home/ajay_malkani0/Literature Search/sorted sets/MR_sorted_4.xlsx';

PROC IMPORT DATAFILE=MR
	DBMS=XLSX
	REPLACE
	OUT=WORK.MR_sorted_4_modified;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.MR_sorted_4_modified; RUN;

FILENAME GWAS '/home/ajay_malkani0/Literature Search/sorted sets/GWAS_sorted_4.xlsx';

PROC IMPORT DATAFILE=GWAS
	DBMS=XLSX
	REPLACE
	OUT=WORK.GWAS_sorted_4_modified;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.GWAS_sorted_4_modified; RUN;

FILENAME biomark '/home/ajay_malkani0/Literature Search/sorted sets/biomarkers_sorted_4.xlsx';

PROC IMPORT DATAFILE=biomark
	DBMS=XLSX
	REPLACE
	OUT=WORK.biomarkers_sorted_4_modified;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.biomarkers_sorted_4_modified; RUN;


/* Modifying lengths of character variables to standard variable lengths */

proc sql;
    alter table WORK.amino_acids_sorted_4_modified
    modify Title char(240),
           Authors char(1153),
           Journal_Book char(101),
           Main_Findings char(22429),
           Strengths char(2505),
           Weaknesses char(8832),
           Future_Research char(6260),
           Revised_Main_Findings char(18862),
           Research_Gaps char(18862);
    
quit;

PROC CONTENTS DATA=WORK.amino_acids_sorted_4_modified; RUN;

proc sql;
    alter table WORK.lipids_sorted_4_modified
    modify Title char(240),
           Authors char(1153),
           Journal_Book char(101),
           Main_Findings char(22429),
           Strengths char(2505),
           Weaknesses char(8832),
           Future_Research char(6260),
           Revised_Main_Findings char(18862),
           Research_Gaps char(18862);

quit;

PROC CONTENTS DATA=WORK.lipids_sorted_4_modified; RUN;

proc sql;
    alter table WORK.energy_sorted_4_modified
    modify Title char(240),
           Authors char(1153),
           Journal_Book char(101),
           Main_Findings char(22429),
           Strengths char(2505),
           Weaknesses char(8832),
           Future_Research char(6260),
           Revised_Main_Findings char(18862),
           Research_Gaps char(18862);

quit;

PROC CONTENTS DATA=WORK.energy_sorted_4_modified; RUN;

proc sql;
    alter table WORK.micro_RNA_sorted_4_modified
    modify Title char(240),
           Authors char(1153),
           Journal_Book char(101),
           Main_Findings char(22429),
           Strengths char(2505),
           Weaknesses char(8832),
           Future_Research char(6260),
           Revised_Main_Findings char(18862),
           Research_Gaps char(18862);

quit;

PROC CONTENTS DATA=WORK.micro_RNA_sorted_4_modified; RUN;

proc sql;
    alter table WORK.CVD_sorted_4_modified
    modify Title char(240),
           Authors char(1153),
           Journal_Book char(101),
           Main_Findings char(22429),
           Strengths char(2505),
           Weaknesses char(8832),
           Future_Research char(6260),
           Revised_Main_Findings char(18862),
           Research_Gaps char(18862);

quit;

PROC CONTENTS DATA=WORK.CVD_sorted_4_modified; RUN;

proc sql;
    alter table WORK.ethnicity_sorted_4_modified
    modify Title char(240),
           Authors char(1153),
           Journal_Book char(101),
           Main_Findings char(22429),
           Strengths char(2505),
           Weaknesses char(8832),
           Future_Research char(6260),
           Revised_Main_Findings char(18862),
           Research_Gaps char(18862);

quit;

PROC CONTENTS DATA=WORK.ethnicity_sorted_4_modified; RUN;

proc sql;
    alter table WORK.diet_sorted_4_modified
    modify Title char(240),
           Authors char(1153),
           Journal_Book char(101),
           Main_Findings char(22429),
           Strengths char(2505),
           Weaknesses char(8832),
           Future_Research char(6260),
           Revised_Main_Findings char(18862),
           Research_Gaps char(18862);

quit;

PROC CONTENTS DATA=WORK.diet_sorted_4_modified; RUN;

proc sql;
    alter table WORK.microbiota_sorted_4_modified
    modify Title char(240),
           Authors char(1153),
           Journal_Book char(101),
           Main_Findings char(22429),
           Strengths char(2505),
           Weaknesses char(8832),
           Future_Research char(6260),
           Revised_Main_Findings char(18862),
           Research_Gaps char(18862);

quit;

PROC CONTENTS DATA=WORK.microbiota_sorted_4_modified; RUN;

proc sql;
    alter table WORK.ferritin_sorted_4_modified
    modify Title char(240),
           Authors char(1153),
           Journal_Book char(101),
           Main_Findings char(22429),
           Strengths char(2505),
           Weaknesses char(8832),
           Future_Research char(6260),
           Revised_Main_Findings char(18862),
           Research_Gaps char(18862);

quit;

PROC CONTENTS DATA=WORK.ferritin_sorted_4_modified; RUN;

proc sql;
    alter table WORK.MR_sorted_4_modified
    modify Title char(240),
           Authors char(1153),
           Journal_Book char(101),
           Main_Findings char(22429),
           Strengths char(2505),
           Weaknesses char(8832),
           Future_Research char(6260),
           Revised_Main_Findings char(18862),
           Research_Gaps char(18862);

quit;

PROC CONTENTS DATA=WORK.MR_sorted_4_modified; RUN;

proc sql;
    alter table WORK.GWAS_sorted_4_modified
    modify Title char(240),
           Authors char(1153),
           Journal_Book char(101),
           Main_Findings char(22429),
           Strengths char(2505),
           Weaknesses char(8832),
           Future_Research char(6260),
           Revised_Main_Findings char(18862),
           Research_Gaps char(18862);

quit;

PROC CONTENTS DATA=WORK.GWAS_sorted_4_modified; RUN;

proc sql;
    alter table WORK.biomarkers_sorted_4_modified
    modify Title char(240),
           Authors char(1153),
           Journal_Book char(101),
           Main_Findings char(22429),
           Strengths char(2505),
           Weaknesses char(8832),
           Future_Research char(6260),
           Revised_Main_Findings char(18862),
           Research_Gaps char(18862);

quit;

PROC CONTENTS DATA=WORK.biomarkers_sorted_4_modified; RUN;


/* Creating SAS libname */

%let lit1=/home/ajay_malkani0/Literature Search/modified sets;

libname ref1 "&lit1";


/* Conversion from work library SAS datasets to ref1 library SAS data sets */

data ref1.amino_acids_sorted_4_modified;
	set work.amino_acids_sorted_4_modified;
run;

data ref1.lipids_sorted_4_modified;
	set work.lipids_sorted_4_modified;
run;

data ref1.energy_sorted_4_modified;
	set work.energy_sorted_4_modified;
run;

data ref1.micro_RNA_sorted_4_modified;
	set work.micro_RNA_sorted_4_modified;
run;

data ref1.CVD_sorted_4_modified;
	set WORK.CVD_sorted_4_modified;
run;

data ref1.ethnicity_sorted_4_modified;
	set WORK.ethnicity_sorted_4_modified;
run;

data ref1.diet_sorted_4_modified;
	set WORK.diet_sorted_4_modified;
run;

data ref1.microbiota_sorted_4_modified;
	set WORK.microbiota_sorted_4_modified;
run;

data ref1.ferritin_sorted_4_modified;
	set WORK.ferritin_sorted_4_modified;
run;

data ref1.MR_sorted_4_modified;
	set WORK.MR_sorted_4_modified;
run;

data ref1.GWAS_sorted_4_modified;
	set WORK.GWAS_sorted_4_modified;
run;

data ref1.biomarkers_sorted_4_modified;
	set WORK.biomarkers_sorted_4_modified;
run;


/* Finding common observations in Amino acids + lipids + energy + microRNA + 
CVD + ethnicity + diet + microbiota modified data sets */

proc sort data=ref1.amino_acids_sorted_4_modified	
	out=ref1.amino_acids_sorted_alt;
	by ref_no;	
run;

proc print data=ref1.amino_acids_sorted_alt;
run;

proc sort data=ref1.lipids_sorted_4_modified	
	out=ref1.lipids_sorted_alt;
	by ref_no;	
run;

proc print data=ref1.lipids_sorted_alt;
run;

proc sort data=ref1.energy_sorted_4_modified	
	out=ref1.energy_metabolism_sorted_alt;
	by ref_no;	
run;

proc print data=ref1.energy_metabolism_sorted_alt;
run;

proc sort data=ref1.micro_RNA_sorted_4_modified	
	out=ref1.micro_RNA_sorted_alt;
	by ref_no;	
run;

proc print data=ref1.micro_RNA_sorted_alt;
run;

proc sort data=ref1.CVD_sorted_4_modified	
	out=ref1.CVD_sorted_alt;
	by ref_no;	
run;

proc print data=ref1.CVD_sorted_alt;
run;

proc sort data=ref1.ethnicity_sorted_4_modified	
	out=ref1.ethnicity_sorted_alt;
	by ref_no;	
run;

proc print data=ref1.ethnicity_sorted_alt;
run;

proc sort data=ref1.diet_sorted_4_modified	
	out=ref1.diet_sorted_alt;
	by ref_no;	
run;

proc print data=ref1.diet_sorted_alt;
run;

proc sort data=ref1.microbiota_sorted_4_modified	
	out=ref1.microbiota_sorted_alt;
	by ref_no;	
run;

proc print data=ref1.microbiota_sorted_alt;
run;

proc sort data=ref1.ferritin_sorted_4_modified	
	out=ref1.ferritin_sorted_alt;
	by ref_no;	
run;

proc print data=ref1.ferritin_sorted_alt;
run;

proc sort data=ref1.MR_sorted_4_modified	
	out=ref1.MR_sorted_alt;
	by ref_no;	
run;

proc print data=ref1.MR_sorted_alt;
run;

proc sort data=ref1.GWAS_sorted_4_modified	
	out=ref1.GWAS_sorted_alt;
	by ref_no;	
run;

proc print data=ref1.GWAS_sorted_alt;
run;

proc sort data=ref1.biomarkers_sorted_4_modified	
	out=ref1.biomarkers_sorted_alt;
	by ref_no;	
run;

proc print data=ref1.biomarkers_sorted_alt;
run;


data ref1.combined;
			merge ref1.amino_acids_sorted_alt(in=amino)
				  ref1.lipids_sorted_alt(in=lipid)
				  ref1.energy_metabolism_sorted_alt(in=energy)
				  ref1.micro_RNA_sorted_alt(in=micro)
				  ref1.CVD_sorted_alt(in=CVD)
				  ref1.ethnicity_sorted_alt(in=ethnic)
				  ref1.diet_sorted_alt(in=diet)
				  ref1.microbiota_sorted_alt(in=microb)
				  ref1.ferritin_sorted_alt(in=ferritin)
				  ref1.MR_sorted_alt(in=MR)
				  ref1.GWAS_sorted_alt(in=GWAS);
			by ref_no;
			if amino=1 or lipid=1 or energy=1 or micro=1 or CVD=1 or ethnic=1 or diet=1 or microb=1 or ferritin=1 or MR=1 or GWAS=1;
run;

proc print data=ref1.combined;
run;

data ref1.combined_1;
			merge ref1.biomarkers_sorted_alt(in=biomarkers)
				  ref1.combined(in=combo);
			by ref_no;
			if combo=1 and biomarkers=1;
run;

proc print data=ref1.combined_1;
run;

/* Finding observations just from the biomarkers data set */

data ref1.combined_2;
			merge ref1.biomarkers_sorted_alt(in=biomarkers)
				  ref1.combined(in=combo);
			by ref_no;
			if combo=0 and biomarkers=1;
run;

proc print data=ref1.combined_2;
run;

/* Concatenate observations from the combined 
amino acids / lipids / energy data set with the observations 
from just the energy data set */

data ref1.combined_3;
		set ref1.combined_1
			ref1.combined_2;
run;

proc print data=ref1.combined_3;
run;

/* Sort the combined data set for sub_ref_no */

proc sort data=ref1.combined_3	
	out=ref1.biomarkers_modified_sorted;
	by sub_ref_no;	
run;

proc print data=ref1.biomarkers_modified_sorted;
run;



proc export data=ref1.biomarkers_modified_sorted
    outfile="/home/ajay_malkani0/Literature Search/modified sets/biomarkers_modified_sorted_4.xlsx"
    dbms=xlsx
    replace;
run;

/* Combined modified data set */

/* Creating SAS libname */

%let lit2=/home/ajay_malkani0/Literature Search/topic sets;

libname ref2 "&lit2";

/* Importing completed modified excel files with revised main findings (as notes) and research gaps */

FILENAME amino '/home/ajay_malkani0/Literature Search/topic sets/amino_acids_sorted_4_modified.xlsx';

PROC IMPORT DATAFILE=amino
	DBMS=XLSX
	REPLACE
	OUT=WORK.amino_acids_sorted_4_modified;
	GETNAMES=YES;
	
RUN;

PROC CONTENTS DATA=WORK.amino_acids_sorted_4_modified; RUN;

FILENAME lipids '/home/ajay_malkani0/Literature Search/topic sets/lipids_sorted_4_modified.xlsx';

PROC IMPORT DATAFILE=lipids
	DBMS=XLSX
	REPLACE
	OUT=WORK.lipids_sorted_4_modified;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.lipids_sorted_4_modified; RUN;

FILENAME energy '/home/ajay_malkani0/Literature Search/topic sets/energy_modified_sorted_4.xlsx';

PROC IMPORT DATAFILE=energy
	DBMS=XLSX
	REPLACE
	OUT=WORK.energy_sorted_4_modified;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.energy_sorted_4_modified; RUN;

FILENAME micro '/home/ajay_malkani0/Literature Search/topic sets/micro_RNA_modified_sorted_4.xlsx';

PROC IMPORT DATAFILE=micro
	DBMS=XLSX
	REPLACE
	OUT=WORK.micro_RNA_sorted_4_modified;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.micro_RNA_sorted_4_modified; RUN;

FILENAME CVD '/home/ajay_malkani0/Literature Search/topic sets/CVD_modified_sorted_4.xlsx';

PROC IMPORT DATAFILE=CVD
	DBMS=XLSX
	REPLACE
	OUT=WORK.CVD_sorted_4_modified;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.CVD_sorted_4_modified; RUN;

FILENAME ethnic '/home/ajay_malkani0/Literature Search/topic sets/ethnicity_modified_sorted_4.xlsx';

PROC IMPORT DATAFILE=ethnic
	DBMS=XLSX
	REPLACE
	OUT=WORK.ethnicity_sorted_4_modified;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.ethnicity_sorted_4_modified; RUN;

FILENAME diet '/home/ajay_malkani0/Literature Search/topic sets/diet_modified_sorted_4.xlsx';

PROC IMPORT DATAFILE=diet
	DBMS=XLSX
	REPLACE
	OUT=WORK.diet_sorted_4_modified;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.diet_sorted_4_modified; RUN;

FILENAME micro '/home/ajay_malkani0/Literature Search/topic sets/microbiota_modified_sorted_4.xlsx';

PROC IMPORT DATAFILE=micro
	DBMS=XLSX
	REPLACE
	OUT=WORK.microbiota_sorted_4_modified;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.microbiota_sorted_4_modified; RUN;

FILENAME ferritin '/home/ajay_malkani0/Literature Search/topic sets/ferritin_sorted_4.xlsx';

PROC IMPORT DATAFILE=ferritin
	DBMS=XLSX
	REPLACE
	OUT=WORK.ferritin_sorted_4_modified;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.ferritin_sorted_4_modified; RUN;

FILENAME MR '/home/ajay_malkani0/Literature Search/topic sets/MR_modified_sorted_4.xlsx';

PROC IMPORT DATAFILE=MR
	DBMS=XLSX
	REPLACE
	OUT=WORK.MR_sorted_4_modified;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.MR_sorted_4_modified; RUN;

FILENAME GWAS '/home/ajay_malkani0/Literature Search/topic sets/GWAS_modified_sorted_4.xlsx';

PROC IMPORT DATAFILE=GWAS
	DBMS=XLSX
	REPLACE
	OUT=WORK.GWAS_sorted_4_modified;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.GWAS_sorted_4_modified; RUN;

FILENAME biomark '/home/ajay_malkani0/Literature Search/topic sets/biomarkers_modified_sorted_4.xlsx';

PROC IMPORT DATAFILE=biomark
	DBMS=XLSX
	REPLACE
	OUT=WORK.biomarkers_sorted_4_modified;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.biomarkers_sorted_4_modified; RUN;

/* Modifying lengths of character variables to standard variable lengths */

proc sql;
    alter table WORK.amino_acids_sorted_4_modified
    modify Title char(240),
           Authors char(1153),
           Journal_Book char(101),
           Main_Findings char(22429),
           Strengths char(2505),
           Weaknesses char(8832),
           Future_Research char(6260),
           Revised_Main_Findings char(18862),
           Research_Gaps char(18862);
    
quit;

PROC CONTENTS DATA=WORK.amino_acids_sorted_4_modified; RUN;

proc sql;
    alter table WORK.lipids_sorted_4_modified
    modify Title char(240),
           Authors char(1153),
           Journal_Book char(101),
           Main_Findings char(22429),
           Strengths char(2505),
           Weaknesses char(8832),
           Future_Research char(6260),
           Revised_Main_Findings char(18862),
           Research_Gaps char(18862);

quit;

PROC CONTENTS DATA=WORK.lipids_sorted_4_modified; RUN;

proc sql;
    alter table WORK.energy_sorted_4_modified
    modify Title char(240),
           Authors char(1153),
           Journal_Book char(101),
           Main_Findings char(22429),
           Strengths char(2505),
           Weaknesses char(8832),
           Future_Research char(6260),
           Revised_Main_Findings char(18862),
           Research_Gaps char(18862);

quit;

PROC CONTENTS DATA=WORK.energy_sorted_4_modified; RUN;

proc sql;
    alter table WORK.micro_RNA_sorted_4_modified
    modify Title char(240),
           Authors char(1153),
           Journal_Book char(101),
           Main_Findings char(22429),
           Strengths char(2505),
           Weaknesses char(8832),
           Future_Research char(6260),
           Revised_Main_Findings char(18862),
           Research_Gaps char(18862);

quit;

PROC CONTENTS DATA=WORK.micro_RNA_sorted_4_modified; RUN;

proc sql;
    alter table WORK.CVD_sorted_4_modified
    modify Title char(240),
           Authors char(1153),
           Journal_Book char(101),
           Main_Findings char(22429),
           Strengths char(2505),
           Weaknesses char(8832),
           Future_Research char(6260),
           Revised_Main_Findings char(18862),
           Research_Gaps char(18862);

quit;

PROC CONTENTS DATA=WORK.CVD_sorted_4_modified; RUN;

proc sql;
    alter table WORK.ethnicity_sorted_4_modified
    modify Title char(240),
           Authors char(1153),
           Journal_Book char(101),
           Main_Findings char(22429),
           Strengths char(2505),
           Weaknesses char(8832),
           Future_Research char(6260),
           Revised_Main_Findings char(18862),
           Research_Gaps char(18862);

quit;

PROC CONTENTS DATA=WORK.ethnicity_sorted_4_modified; RUN;

proc sql;
    alter table WORK.diet_sorted_4_modified
    modify Title char(240),
           Authors char(1153),
           Journal_Book char(101),
           Main_Findings char(22429),
           Strengths char(2505),
           Weaknesses char(8832),
           Future_Research char(6260),
           Revised_Main_Findings char(18862),
           Research_Gaps char(18862);

quit;

PROC CONTENTS DATA=WORK.diet_sorted_4_modified; RUN;

proc sql;
    alter table WORK.microbiota_sorted_4_modified
    modify Title char(240),
           Authors char(1153),
           Journal_Book char(101),
           Main_Findings char(22429),
           Strengths char(2505),
           Weaknesses char(8832),
           Future_Research char(6260),
           Revised_Main_Findings char(18862),
           Research_Gaps char(18862);

quit;

PROC CONTENTS DATA=WORK.microbiota_sorted_4_modified; RUN;

proc sql;
    alter table WORK.ferritin_sorted_4_modified
    modify Title char(240),
           Authors char(1153),
           Journal_Book char(101),
           Main_Findings char(22429),
           Strengths char(2505),
           Weaknesses char(8832),
           Future_Research char(6260),
           Revised_Main_Findings char(18862),
           Research_Gaps char(18862);

quit;

PROC CONTENTS DATA=WORK.ferritin_sorted_4_modified; RUN;

proc sql;
    alter table WORK.MR_sorted_4_modified
    modify Title char(240),
           Authors char(1153),
           Journal_Book char(101),
           Main_Findings char(22429),
           Strengths char(2505),
           Weaknesses char(8832),
           Future_Research char(6260),
           Revised_Main_Findings char(18862),
           Research_Gaps char(18862);

quit;

PROC CONTENTS DATA=WORK.MR_sorted_4_modified; RUN;

proc sql;
    alter table WORK.GWAS_sorted_4_modified
    modify Title char(240),
           Authors char(1153),
           Journal_Book char(101),
           Main_Findings char(22429),
           Strengths char(2505),
           Weaknesses char(8832),
           Future_Research char(6260),
           Revised_Main_Findings char(18862),
           Research_Gaps char(18862);

quit;

PROC CONTENTS DATA=WORK.GWAS_sorted_4_modified; RUN;

proc sql;
    alter table WORK.biomarkers_sorted_4_modified
    modify Title char(240),
           Authors char(1153),
           Journal_Book char(101),
           Main_Findings char(22429),
           Strengths char(2505),
           Weaknesses char(8832),
           Future_Research char(6260),
           Revised_Main_Findings char(18862),
           Research_Gaps char(18862);

quit;

PROC CONTENTS DATA=WORK.biomarkers_sorted_4_modified; RUN;

/* Conversion from work library SAS datasets to ref2 library SAS data sets */

data ref2.amino_acids_sorted_4_modified;
	set work.amino_acids_sorted_4_modified;
run;

data ref2.lipids_sorted_4_modified;
	set work.lipids_sorted_4_modified;
run;

data ref2.energy_sorted_4_modified;
	set work.energy_sorted_4_modified;
run;

data ref2.micro_RNA_sorted_4_modified;
	set work.micro_RNA_sorted_4_modified;
run;

data ref2.CVD_sorted_4_modified;
	set WORK.CVD_sorted_4_modified;
run;

data ref2.ethnicity_sorted_4_modified;
	set WORK.ethnicity_sorted_4_modified;
run;

data ref2.diet_sorted_4_modified;
	set WORK.diet_sorted_4_modified;
run;

data ref2.microbiota_sorted_4_modified;
	set WORK.microbiota_sorted_4_modified;
run;

data ref2.ferritin_sorted_4_modified;
	set WORK.ferritin_sorted_4_modified;
run;

data ref2.MR_sorted_4_modified;
	set WORK.MR_sorted_4_modified;
run;

data ref2.GWAS_sorted_4_modified;
	set WORK.GWAS_sorted_4_modified;
run;

data ref2.biomarkers_sorted_4_modified;
	set WORK.biomarkers_sorted_4_modified;
run;

/* Finding common observations in topic modified data sets */

proc sort data=ref2.amino_acids_sorted_4_modified	
	out=ref2.amino_acids_sorted_alt;
	by ref_no;	
run;

proc print data=ref2.amino_acids_sorted_alt;
run;

proc sort data=ref2.lipids_sorted_4_modified	
	out=ref2.lipids_sorted_alt;
	by ref_no;	
run;

proc print data=ref2.lipids_sorted_alt;
run;

proc sort data=ref2.energy_sorted_4_modified	
	out=ref2.energy_metabolism_sorted_alt;
	by ref_no;	
run;

proc print data=ref2.energy_metabolism_sorted_alt;
run;

proc sort data=ref2.micro_RNA_sorted_4_modified	
	out=ref2.micro_RNA_sorted_alt;
	by ref_no;	
run;

proc print data=ref2.micro_RNA_sorted_alt;
run;

proc sort data=ref2.CVD_sorted_4_modified	
	out=ref2.CVD_sorted_alt;
	by ref_no;	
run;

proc print data=ref2.CVD_sorted_alt;
run;

proc sort data=ref2.ethnicity_sorted_4_modified	
	out=ref2.ethnicity_sorted_alt;
	by ref_no;	
run;

proc print data=ref2.ethnicity_sorted_alt;
run;

proc sort data=ref2.diet_sorted_4_modified	
	out=ref2.diet_sorted_alt;
	by ref_no;	
run;

proc print data=ref2.diet_sorted_alt;
run;

proc sort data=ref2.microbiota_sorted_4_modified	
	out=ref2.microbiota_sorted_alt;
	by ref_no;	
run;

proc print data=ref2.microbiota_sorted_alt;
run;

proc sort data=ref2.ferritin_sorted_4_modified	
	out=ref2.ferritin_sorted_alt;
	by ref_no;	
run;

proc print data=ref2.ferritin_sorted_alt;
run;

proc sort data=ref2.MR_sorted_4_modified	
	out=ref2.MR_sorted_alt;
	by ref_no;	
run;

proc print data=ref2.MR_sorted_alt;
run;

proc sort data=ref2.GWAS_sorted_4_modified	
	out=ref2.GWAS_sorted_alt;
	by ref_no;	
run;

proc print data=ref2.GWAS_sorted_alt;
run;

proc sort data=ref2.biomarkers_sorted_4_modified	
	out=ref2.biomarkers_sorted_alt;
	by ref_no;	
run;

proc print data=ref2.biomarkers_sorted_alt;
run;


/* Combining modified data sets */


data ref2.combined;
			merge ref2.amino_acids_sorted_alt(in=amino)
				  ref2.lipids_sorted_alt(in=lipid)
				  ref2.energy_metabolism_sorted_alt(in=energy)
				  ref2.micro_RNA_sorted_alt(in=micro)
				  ref2.CVD_sorted_alt(in=CVD)
				  ref2.ethnicity_sorted_alt(in=ethnic)
				  ref2.diet_sorted_alt(in=diet)
				  ref2.microbiota_sorted_alt(in=microb)
				  ref2.ferritin_sorted_alt(in=ferritin)
				  ref2.MR_sorted_alt(in=MR)
				  ref2.GWAS_sorted_alt(in=GWAS)
				  ref2.biomarkers_sorted_alt(in=biomarkers);
			by ref_no;
			if amino=1 or lipid=1 or energy=1 or micro=1 or CVD=1 or ethnic=1 or diet=1 or microb=1 or ferritin=1 or MR=1 or GWAS=1 or biomarkers=1;
run;

proc print data=ref2.combined;
run;

/* Importing Literature search - complete set */

FILENAME lit '/home/ajay_malkani0/Literature Search/Literature search - complete set.xlsx';

PROC IMPORT DATAFILE=lit
	DBMS=XLSX
	REPLACE
	OUT=WORK.lit_search_complete_set;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.lit_search_complete_set; RUN;

/* Converting work data set to ref2 data set */

data ref2.lit_search_complete_set;
	set WORK.lit_search_complete_set;
run;

/* Adding the keywords column to combined data set */



proc sql;
		create table ref2.combined_1 as
		select l.ref_no, c.PMID, l.Keywords, c.title, c.Authors, c.Journal_Book, c.Create_Date,
			   c.Main_Findings, c.Strengths, c.Weaknesses, c.Future_Research, c.Revised_Main_Findings, c.Research_Gaps 
			from ref2.combined as c,
				 ref.smaller_set as l
		where c.ref_no =
			  l.ref_no;
quit;

proc print data=ref2.combined_1 (obs=2) label;
			
run;

/* Finding specific topics */

/* Desaturases */

data ref2.desaturases ref2.other;
	set ref2.combined_1;
	if find(Research_Gaps, 'desaturases', 'I')>0 then output ref2.desaturases; 
	if find(Research_Gaps, 'desaturase', 'I')>0 then output ref2.desaturases;
	else output ref2.other;
run;

title1 'Desaturases';

proc print data=ref2.desaturases;			
run;

/*create dataset with no duplicate rows in ref_no column*/
proc sort data=ref2.desaturases out=ref2.desaturases nodupkey;
    by ref_no;
run;

/*view dataset with no duplicate rows in ref_no column*/
proc print data=ref2.desaturases;

proc sort data=ref2.desaturases	
	out=ref.desaturases_sorted;
	by descending Create_Date;	
run;

data ref2.desaturases_sorted_1 (keep=sub_ref_no ref_no PMID Title Authors Journal_Book Create_Date) 
		ref2.desaturases_sorted_2 (keep=sub_ref_no Title Research_Gaps)
		ref2.desaturases_sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research);
	    retain sub_ref_no 0;		
		sub_ref_no=sub_ref_no + 1;		
		set ref.desaturases_sorted (keep=ref_no PMID Keywords Title Authors Journal_Book Create_Date Main_Findings Strengths 
						              Weaknesses Future_Research Research_Gaps);
run;

ods html file="&lit2/desaturases_1_.html" style=SasWeb;
title 'Desaturases data set 1';
proc print data=ref2.desaturases_sorted_1 noobs;			
run;
ods html close;

ods html file="&lit2/desaturases_2_.html" style=SasWeb;
title 'Desaturases data set 2';
proc print data=ref2.desaturases_sorted_2 noobs;			
run;
ods html close;

ods html file="&lit2/desaturases_3_.html" style=SasWeb;
title 'Desaturases data set 3';
proc print data=ref2.desaturases_sorted_3 noobs;			
run;
ods html close;


/* Ceramides / Sphingolipids */

data ref2.ceramide_sphingo_1 ref2.ceramide_sphingo_2 ref2.ceramide_sphingo_3 ref2.ceramide_sphingo_4 ref2.other;
	set ref2.combined_1;
	if find(Research_Gaps, 'ceramide', 'I')>0 then output ref2.ceramide_sphingo_1; 
	if find(Research_Gaps, 'ceramides', 'I')>0 then output ref2.ceramide_sphingo_2;
	if find(Research_Gaps, 'sphingolipids', 'I')>0 then output ref2.ceramide_sphingo_3;
	if find(Research_Gaps, 'sphingo', 'I')>0 then output ref2.ceramide_sphingo_4;
	else output ref2.other;
run;

proc sort data=ref2.ceramide_sphingo_1	
	out=ref2.ceramide_sphingo_1_sorted;
	by ref_no;	
run;

proc sort data=ref2.ceramide_sphingo_2
	out=ref2.ceramide_sphingo_2_sorted;
	by ref_no;	
run;

proc sort data=ref2.ceramide_sphingo_3
	out=ref2.ceramide_sphingo_3_sorted;
	by ref_no;	
run;

proc sort data=ref2.ceramide_sphingo_4
	out=ref2.ceramide_sphingo_4_sorted;
	by ref_no;	
run;

data ref2.ceramide_sphingo;
			merge ref2.ceramide_sphingo_1_sorted(in=cer1)
				  ref2.ceramide_sphingo_2_sorted(in=cer2)
				  ref2.ceramide_sphingo_3_sorted(in=cer3)
				  ref2.ceramide_sphingo_4_sorted(in=cer4);
			by ref_no;
			if cer1=1 or cer2=1 or cer3=1 or cer4=1;
run;


title1 'Ceramides / Sphingolipids';

proc print data=ref2.ceramide_sphingo;			
run;

proc sort data=ref2.ceramide_sphingo	
	out=ref2.ceramide_sphingo_sorted;
	by descending Create_Date;	
run;

data ref2.ceramide_sphingo_sorted_1 (keep=sub_ref_no ref_no PMID Title Authors Journal_Book Create_Date) 
		ref2.ceramide_sphingo_sorted_2 (keep=sub_ref_no Title Research_Gaps)
		ref2.ceramide_sphingo_sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research);
	    retain sub_ref_no 0;		
		sub_ref_no=sub_ref_no + 1;		
		set ref.ceramide_sphingo_sorted (keep=ref_no PMID Keywords Title Authors Journal_Book Create_Date Main_Findings Strengths 
						              Weaknesses Future_Research Research_Gaps);
run;

ods html file="&lit2/ceramide_sphingo_1_.html" style=SasWeb;
title 'Ceramides / Sphingolipids data set 1';
proc print data=ref2.ceramide_sphingo_sorted_1 noobs;			
run;
ods html close;

ods html file="&lit2/ceramide_sphingo_2_.html" style=SasWeb;
title 'Ceramides / Sphingolipids data set 2';
proc print data=ref2.ceramide_sphingo_sorted_2 noobs;			
run;
ods html close;

ods html file="&lit2/ceramide_sphingo_3_.html" style=SasWeb;
title 'Ceramides / Sphingolipids data set 3';
proc print data=ref2.ceramide_sphingo_sorted_3 noobs;			
run;
ods html close;


/* Gluconeogenesis /Energy / SIRT */

data ref2.gluconeogenesis ref2.energy ref2.SIRT ref2.other;
	set ref2.combined_1;
	if find(Research_Gaps, 'gluconeogenesis', 'I')>0 then output ref2.gluconeogenesis;	
	if find(Research_Gaps, 'energy', 'I')>0 then output ref2.energy;
	if find(Research_Gaps, 'SIRT', 'I')>0 then output ref2.SIRT;
	else output ref2.other;
run;

title1 'Gluconeogenesis';

proc print data=ref2.gluconeogenesis;			
run;

proc sort data=ref2.gluconeogenesis
	out=ref2.gluconeogenesis_sorted;
	by descending Create_Date;	
run;

data ref2.gluconeogenesis_sorted_1 (keep=sub_ref_no ref_no PMID Title Authors Journal_Book Create_Date)
		ref2.gluconeogenesis_sorted_2 (keep=sub_ref_no Title Research_Gaps)
		ref2.gluconeogenesis_sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research);
	    retain sub_ref_no 0;		
		sub_ref_no=sub_ref_no + 1;		
		set ref2.gluconeogenesis_sorted (keep=ref_no PMID Keywords Title Authors Journal_Book Create_Date Main_Findings Strengths 
						              Weaknesses Future_Research Research_Gaps);
run;

ods html file="&lit2/gluconeogenesis_1_.html" style=SasWeb;
title 'Gluconeogenesis data set 1';
proc print data=ref2.gluconeogenesis_sorted_1 noobs;			
run;
ods html close;

ods html file="&lit2/gluconeogenesis_2_.html" style=SasWeb;
title 'Gluconeogenesis data set 2';
proc print data=ref2.gluconeogenesis_sorted_2 noobs;			
run;
ods html close;

ods html file="&lit2/gluconeogenesis_3_.html" style=SasWeb;
title 'Gluconeogenesis data set 3';
proc print data=ref2.gluconeogenesis_sorted_3 noobs;			
run;
ods html close;


title1 'Energy';

proc print data=ref2.energy;
run;

proc sort data=ref2.energy
	out=ref2.energy_sorted;
	by descending Create_Date;	
run;

data ref2.energy_sorted_1 (keep=sub_ref_no ref_no PMID Title Authors Journal_Book Create_Date)
		ref2.energy_sorted_2 (keep=sub_ref_no Title Research_Gaps)
		ref2.energy_sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research);
	    retain sub_ref_no 0;		
		sub_ref_no=sub_ref_no + 1;		
		set ref2.energy_sorted (keep=ref_no PMID Keywords Title Authors Journal_Book Create_Date Main_Findings Strengths 
						              Weaknesses Future_Research Research_Gaps);
run;

ods html file="&lit2/energy_1_.html" style=SasWeb;
title 'Energy data set 1';
proc print data=ref2.energy_sorted_1 noobs;			
run;
ods html close;

ods html file="&lit2/energy_2_.html" style=SasWeb;
title 'Energy data set 2';
proc print data=ref2.energy_sorted_2 noobs;			
run;
ods html close;

ods html file="&lit2/energy_3_.html" style=SasWeb;
title 'Energy data set 3';
proc print data=ref2.energy_sorted_3 noobs;			
run;
ods html close;


title1 'SIRT';

proc print data=ref2.SIRT;
run;

/* Gluconeogenesis / energy */

proc sort data=ref2.gluconeogenesis	
	out=ref2.gluconeogenesis_sorted;
	by ref_no;	
run;

proc sort data=ref2.energy	
	out=ref2.energy_sorted;
	by ref_no;	
run;

data ref2.energy_gluconeogenesis;
			merge ref2.gluconeogenesis_sorted(in=gluco)
				  ref2.energy_sorted(in=energy);
			by ref_no;
			if gluco=1 and energy=1;
run;

title1 'Energy / Gluconeogenesis';

proc print data=ref2.Energy_Gluconeogenesis;			
run;

proc sort data=ref2.Energy_Gluconeogenesis
	out=ref2.Energy_Gluco_sorted;
	by descending Create_Date;	
run;

data ref2.Energy_Gluco_Sorted_1 (keep=sub_ref_no ref_no PMID Title Authors Journal_Book Create_Date)
		ref2.Energy_Gluco_Sorted_2 (keep=sub_ref_no Title Research_Gaps)
		ref2.Energy_Gluco_Sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research);
	    retain sub_ref_no 0;		
		sub_ref_no=sub_ref_no + 1;		
		set ref2.Energy_Gluco_sorted (keep=ref_no PMID Keywords Title Authors Journal_Book Create_Date Main_Findings Strengths 
						              Weaknesses Future_Research Research_Gaps);
run;

ods html file="&lit2/Energy_Gluco_1_.html" style=SasWeb;
title 'Energy Gluconeogenesis data set 1';
proc print data=ref2.Energy_Gluco_Sorted_1 noobs;			
run;
ods html close;

ods html file="&lit2/Energy_Gluco_2_.html" style=SasWeb;
title 'Energy Gluconeogenesis data set 2';
proc print data=ref2.Energy_Gluco_sorted_2 noobs;			
run;
ods html close;

ods html file="&lit2/Energy_Gluco_3_.html" style=SasWeb;
title 'Energy Gluconeogenesis data set 3';
proc print data=ref2.Energy_Gluco_sorted_3 noobs;			
run;
ods html close;


/* South Asian / Asian Indian / AI */

data ref2.South_Asian ref2.other;
	set ref2.combined_1;
	if find(Research_Gaps, 'South Asian', 'I')>0 then output ref2.South_Asian;
	if find(Research_Gaps, 'Asian Indian', 'I')>0 then output ref2.South_Asian;	
	else output ref2.other;
run;

title1 'South Asian';

proc print data=ref2.South_Asian;			
run;

proc sort data=ref2.South_Asian
	out=ref2.South_Asian_sorted;
	by descending Create_Date;	
run;

data ref2.South_Asian_Sorted_1 (keep=sub_ref_no ref_no PMID Title Authors Journal_Book Create_Date)
		ref2.South_Asian_Sorted_2 (keep=sub_ref_no Title Research_Gaps)
		ref2.South_Asian_Sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research);
	    retain sub_ref_no 0;		
		sub_ref_no=sub_ref_no + 1;		
		set ref2.South_Asian_sorted (keep=ref_no PMID Keywords Title Authors Journal_Book Create_Date Main_Findings Strengths 
						              Weaknesses Future_Research Research_Gaps);
run;

ods html file="&lit2/South_Asian_1_.html" style=SasWeb;
title 'South Asian data set 1';
proc print data=ref2.South_Asian_Sorted_1 noobs;			
run;
ods html close;

ods html file="&lit2/South_Asian_2_.html" style=SasWeb;
title 'South Asian data set 2';
proc print data=ref2.South_Asian_sorted_2 noobs;			
run;
ods html close;

ods html file="&lit2/South_Asian_3_.html" style=SasWeb;
title 'South Asian data set 3';
proc print data=ref2.South_Asian_sorted_3 noobs;			
run;
ods html close;

/* Gluconeogensis + South Asians */

proc sort data=ref2.gluconeogenesis	
	out=ref2.gluconeogenesis_sorted;
	by ref_no;	
run;

proc sort data=ref2.South_Asian	
	out=ref2.South_Asian_sorted;
	by ref_no;	
run;

data ref2.South_Asian_Gluconeogenesis;
			merge ref2.gluconeogenesis_sorted(in=gluco)
				  ref2.South_Asian_sorted(in=SA);
			by ref_no;
			if gluco=1 and SA=1;
run;

title1 'South Asian Gluconeogenesis';

proc print data=ref2.South_Asian_Gluconeogenesis;			
run;

proc sort data=ref2.South_Asian_Gluconeogenesis
	out=ref2.South_Asian_Gluco_sorted;
	by descending Create_Date;	
run;

data ref2.South_Asian_Gluco_Sorted_1 (keep=sub_ref_no ref_no PMID Title Authors Journal_Book Create_Date)
		ref2.South_Asian_Gluco_Sorted_2 (keep=sub_ref_no Title Research_Gaps)
		ref2.South_Asian_Gluco_Sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research);
	    retain sub_ref_no 0;		
		sub_ref_no=sub_ref_no + 1;		
		set ref2.South_Asian_Gluco_sorted (keep=ref_no PMID Keywords Title Authors Journal_Book Create_Date Main_Findings Strengths 
						              Weaknesses Future_Research Research_Gaps);
run;

ods html file="&lit2/South_Asian_Gluco_1_.html" style=SasWeb;
title 'South Asian Gluconeogenesis data set 1';
proc print data=ref2.South_Asian_Gluco_Sorted_1 noobs;			
run;
ods html close;

ods html file="&lit2/South_Asian_Gluco_2_.html" style=SasWeb;
title 'South Asian Gluconeogenesis data set 2';
proc print data=ref2.South_Asian_Gluco_sorted_2 noobs;			
run;
ods html close;

ods html file="&lit2/South_Asian_Gluco_3_.html" style=SasWeb;
title 'South Asian Gluconeogenesis data set 3';
proc print data=ref2.South_Asian_Gluco_sorted_3 noobs;			
run;
ods html close;



/* Stress / Mitochrondrial Stress / ROS / Inflammation / Interleukin / TNF / Acylcarnitine / Adiponectin / adipokines */

data ref2.Stress ref2.Mito_Stress ref2.ROS ref2.Inflammation ref2.Interleukin 
	 ref2.TNF ref2.Acylcarnitine ref2.Adiponectin ref2.other;
	set ref2.combined_1;
	if find(Research_Gaps, 'Stress', 'I')>0 then output ref2.Stress;
	if find(Research_Gaps, 'Mitochondrial Stress', 'I')>0 then output ref2.Mito_Stress;
	if find(Research_Gaps, 'Reactive oxygen species', 'I')>0 then output ref2.ROS;
	if find(Research_Gaps, 'ROS', 'I')>0 then output ref2.ROS;
	if find(Research_Gaps, 'Inflammation', 'I')>0 then output ref2.Inflammation;
	if find(Research_Gaps, 'Interleukin', 'I')>0 then output ref2.Interleukin;
	if find(Research_Gaps, 'IL-6', 'I')>0 then output ref2.Interleukin;
	if find(Research_Gaps, 'TNF', 'I')>0 then output ref2.TNF;
	if find(Research_Gaps, 'Acylcarnitine', 'I')>0 then output ref2.Acylcarnitine;
	if find(Research_Gaps, 'Adiponectin', 'I')>0 then output ref2.Adiponectin;
	else output ref2.other;
run;

proc sort data=ref2.ROS	
	out=ref2.ROS_sorted;
	by ref_no;	
run;

proc sort data=ref2.Inflammation	
	out=ref2.Inflammation_sorted;
	by ref_no;	
run;

proc sort data=ref2.Interleukin	
	out=ref2.Interleukin_sorted;
	by ref_no;	
run;

proc sort data=ref2.TNF	
	out=ref2.TNF_sorted;
	by ref_no;	
run;

data ref2.Inflam_ROS_IL6_TNF;
			merge ref2.ROS_sorted(in=ROS)
				  ref2.Inflammation_sorted(in=Inflam)
				  ref2.Interleukin_sorted(in=interleukin)
				  ref2.TNF_sorted(in=TNF);
			by ref_no;
			if ROS=1 and (Inflam=1 or Interleukin=1 or TNF=1);
run;

title1 'ROS / Inflammation / Interleukin / TNF';

proc print data=ref2.Inflam_ROS_IL6_TNF;			
run;

/*create dataset with no duplicate rows in ref_no column*/
proc sort data=ref2.Inflam_ROS_IL6_TNF out=ref2.Inflam_ROS_IL6_TNF nodupkey;
    by ref_no;
run;

/*view dataset with no duplicate rows in ref_no column*/
proc print data=ref2.Inflam_ROS_IL6_TNF;


proc sort data=ref2.Inflam_ROS_IL6_TNF
	out=ref2.Inflam_ROS_IL6_TNF_sorted;
	by descending Create_Date;	
run;

data ref2.Inflam_ROS_IL6_TNF_Sorted_1 (keep=sub_ref_no ref_no PMID Title Authors Journal_Book Create_Date)
		ref2.Inflam_ROS_IL6_TNF_Sorted_2 (keep=sub_ref_no Title Research_Gaps)
		ref2.Inflam_ROS_IL6_TNF_Sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research);
	    retain sub_ref_no 0;		
		sub_ref_no=sub_ref_no + 1;		
		set ref2.Inflam_ROS_IL6_TNF_sorted (keep=ref_no PMID Keywords Title Authors Journal_Book Create_Date Main_Findings Strengths 
						              Weaknesses Future_Research Research_Gaps);
run;

ods html file="&lit2/Inflam_ROS_IL6_TNF_1_.html" style=SasWeb;
title 'Inflam_ROS_IL6_TNF data set 1';
proc print data=ref2.Inflam_ROS_IL6_TNF_Sorted_1 noobs;			
run;
ods html close;

ods html file="&lit2/Inflam_ROS_IL6_TNF_2_.html" style=SasWeb;
title 'Inflam_ROS_IL6_TNF data set 2';
proc print data=ref2.Inflam_ROS_IL6_TNF_sorted_2 noobs;			
run;
ods html close;

ods html file="&lit2/Inflam_ROS_IL6_TNF_3_.html" style=SasWeb;
title 'Inflam_ROS_IL6_TNF data set 3';
proc print data=ref2.Inflam_ROS_IL6_TNF_sorted_3 noobs;			
run;
ods html close;


/* Acylcarnitine */

title1 'Acylcarnitines';

proc print data=ref2.Acylcarnitine;			
run;

proc sort data=ref2.Acylcarnitine
	out=ref2.Acylcarnitine_sorted;
	by descending Create_Date;	
run;

data ref2.Acylcarnitine_Sorted_1 (keep=sub_ref_no ref_no PMID Title Authors Journal_Book Create_Date)
		ref2.Acylcarnitine_Sorted_2 (keep=sub_ref_no Title Research_Gaps)
		ref2.Acylcarnitine_Sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research);
	    retain sub_ref_no 0;		
		sub_ref_no=sub_ref_no + 1;		
		set ref2.Acylcarnitine_sorted (keep=ref_no PMID Keywords Title Authors Journal_Book Create_Date Main_Findings Strengths 
						              Weaknesses Future_Research Research_Gaps);
run;

ods html file="&lit2/Acylcarnitine_1_.html" style=SasWeb;
title 'Acylcarnitine data set 1';
proc print data=ref2.Acylcarnitine_Sorted_1 noobs;			
run;
ods html close;

ods html file="&lit2/Acylcarnitine_2_.html" style=SasWeb;
title 'Acylcarnitine data set 2';
proc print data=ref2.Acylcarnitine_sorted_2 noobs;			
run;
ods html close;

ods html file="&lit2/Acylcarnitine_3_.html" style=SasWeb;
title 'Acylcarnitine data set 3';
proc print data=ref2.Acylcarnitine_sorted_3 noobs;			
run;
ods html close;


/* Adiponectin */

title1 'Adiponectin';

proc print data=ref2.Adiponectin;			
run;

proc sort data=ref2.Adiponectin
	out=ref2.Adiponectin_sorted;
	by descending Create_Date;	
run;

data ref2.Adiponectin_Sorted_1 (keep=sub_ref_no ref_no PMID Title Authors Journal_Book Create_Date)
		ref2.Adiponectin_Sorted_2 (keep=sub_ref_no Title Research_Gaps)
		ref2.Adiponectin_Sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research);
	    retain sub_ref_no 0;		
		sub_ref_no=sub_ref_no + 1;		
		set ref2.Adiponectin_sorted (keep=ref_no PMID Keywords Title Authors Journal_Book Create_Date Main_Findings Strengths 
						              Weaknesses Future_Research Research_Gaps);
run;

ods html file="&lit2/Adiponectin_1_.html" style=SasWeb;
title 'Adiponectin data set 1';
proc print data=ref2.Adiponectin_Sorted_1 noobs;			
run;
ods html close;

ods html file="&lit2/Adiponectin_2_.html" style=SasWeb;
title 'Adiponectin data set 2';
proc print data=ref2.Adiponectin_sorted_2 noobs;			
run;
ods html close;

ods html file="&lit2/Adiponectin_3_.html" style=SasWeb;
title 'Adiponectin data set 3';
proc print data=ref2.Adiponectin_sorted_3 noobs;			
run;
ods html close;


/* Stress */

proc sort data=ref2.Stress	
	out=ref2.Stress_sorted;
	by ref_no;	
run;

proc sort data=ref2.Mito_Stress	
	out=ref2.Mito_Stress_sorted;
	by ref_no;	
run;

data ref2.Stress_Combined;
			merge ref2.Stress_sorted(in=Stress)
				  ref2.Mito_Stress_sorted(in=Mito_Stress);
			by ref_no;
			if Stress=1 and Mito_Stress=0;
run;

title1 'Stress';

proc print data=ref2.Stress_Combined;			
run;

proc sort data=ref2.Stress_Combined
	out=ref2.Stress_sorted;
	by descending Create_Date;	
run;

data ref2.Stress_Sorted_1 (keep=sub_ref_no ref_no PMID Title Authors Journal_Book Create_Date)
		ref2.Stress_Sorted_2 (keep=sub_ref_no Title Research_Gaps)
		ref2.Stress_Sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research);
	    retain sub_ref_no 0;		
		sub_ref_no=sub_ref_no + 1;		
		set ref2.Stress_sorted (keep=ref_no PMID Keywords Title Authors Journal_Book Create_Date Main_Findings Strengths 
						              Weaknesses Future_Research Research_Gaps);
run;

ods html file="&lit2/Stress_1_.html" style=SasWeb;
title 'Stress data set 1';
proc print data=ref2.Stress_Sorted_1 noobs;			
run;
ods html close;

ods html file="&lit2/Stress_2_.html" style=SasWeb;
title 'Stress data set 2';
proc print data=ref2.Stress_sorted_2 noobs;			
run;
ods html close;

ods html file="&lit2/Stress_3_.html" style=SasWeb;
title 'Stress data set 3';
proc print data=ref2.Stress_sorted_3 noobs;			
run;
ods html close;


/* Cholesterol */

data ref2.cholesterol ref2.cholesterol_CE ref2.cholesterol_LDL ref2.cholesterol_HDL 
	 ref2.cholesterol_IDL ref2.cholesterol_VLDL ref2.other;
	set ref2.combined_1;
	if find(Research_Gaps, 'cholesterol', 'I')>0 then output ref2.cholesterol;
	if find(Research_Gaps, 'cholesterol ester', 'I')>0 then output ref2.cholesterol_CE;
	if find(Research_Gaps, 'CE', 'I')>0 then output ref2.cholesterol_CE;
	if find(Research_Gaps, 'LDL', 'I')>0 then output ref2.cholesterol_LDL;
	if find(Research_Gaps, 'HDL', 'I')>0 then output ref2.cholesterol_HDL;
	if find(Research_Gaps, 'IDL', 'I')>0 then output ref2.cholesterol_IDL;
	if find(Research_Gaps, 'VLDL', 'I')>0 then output ref2.cholesterol_VLDL;
	else output ref2.other;
run;

proc sort data=ref2.cholesterol	
	out=ref2.cholesterol_sorted;
	by ref_no;	
run;

proc sort data=ref2.cholesterol_CE	
	out=ref2.cholesterol_CE_sorted;
	by ref_no;	
run;

proc sort data=ref2.cholesterol_LDL	
	out=ref2.cholesterol_LDL_sorted;
	by ref_no;	
run;

proc sort data=ref2.cholesterol_HDL	
	out=ref2.cholesterol_HDL_sorted;
	by ref_no;	
run;

proc sort data=ref2.cholesterol_IDL	
	out=ref2.cholesterol_IDL_sorted;
	by ref_no;	
run;

proc sort data=ref2.cholesterol_VLDL	
	out=ref2.cholesterol_VLDL_sorted;
	by ref_no;	
run;

/* Cholesterol forward transport */

data ref2.chol_forward;
			merge ref2.cholesterol_sorted(in=chol)
				  ref2.cholesterol_CE_sorted(in=chol_CE)
				  ref2.cholesterol_LDL_sorted(in=chol_LDL)
				  ref2.cholesterol_HDL_sorted(in=chol_HDL)
				  ref2.cholesterol_IDL_sorted(in=chol_IDL)
				  ref2.cholesterol_VLDL_sorted(in=chol_VLDL);
			by ref_no;
			if chol_CE=1 and (chol_LDL=1 or chol_IDL=1 or chol_VLDL=1);
run;

title1 'Cholesterol forward transport (cholesterol ester (CE) + LDL + IDL + VLDL)';
title2 'Liver to Tissues (cholesterol deposition (Pro-Atherogenic))';

proc print data=ref2.chol_forward;
run;

/*create dataset with no duplicate rows in ref_no column*/
proc sort data=ref2.chol_forward out=ref2.chol_forward nodupkey;
    by ref_no;
run;

/*view dataset with no duplicate rows in ref_no column*/
proc print data=ref2.chol_forward;

proc sort data=ref2.chol_forward
	out=ref2.chol_forward_sorted;
	by descending Create_Date;	
run;

data ref2.chol_forward_Sorted_1 (keep=sub_ref_no ref_no PMID Title Authors Journal_Book Create_Date)
		ref2.chol_forward_Sorted_2 (keep=sub_ref_no Title Research_Gaps)
		ref2.chol_forward_Sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research);
	    retain sub_ref_no 0;		
		sub_ref_no=sub_ref_no + 1;		
		set ref2.chol_forward_sorted (keep=ref_no PMID Keywords Title Authors Journal_Book Create_Date Main_Findings Strengths 
						              Weaknesses Future_Research Research_Gaps);
run;

ods html file="&lit2/chol_forward_1_.html" style=SasWeb;
title1 'Cholesterol forward transport (cholesterol ester (CE) + LDL + IDL + VLDL)';
title2 'Liver to Tissues (cholesterol deposition (Pro-Atherogenic))';
title3 'Cholesterol forward transport data set 1';
proc print data=ref2.chol_forward_Sorted_1 noobs;			
run;
ods html close;

ods html file="&lit2/chol_forward_2_.html" style=SasWeb;
title1 'Cholesterol forward transport (cholesterol ester (CE) + LDL + IDL + VLDL)';
title2 'Liver to Tissues (cholesterol deposition (Pro-Atherogenic))';
title3 'Cholesterol forward transport data set 2';
proc print data=ref2.chol_forward_sorted_2 noobs;			
run;
ods html close;

ods html file="&lit2/chol_forward_3_.html" style=SasWeb;
title1 'Cholesterol forward transport (cholesterol ester (CE) + LDL + IDL + VLDL)';
title2 'Liver to Tissues (cholesterol deposition (Pro-Atherogenic))';
title3 'Cholesterol forward transport data set 3';
proc print data=ref2.chol_forward_sorted_3 noobs;			
run;
ods html close;

/* Cholesterol Reverse Transport */


data ref2.chol_reverse;
			merge ref2.cholesterol_CE_sorted(in=chol_CE)
				  ref2.cholesterol_HDL_sorted(in=chol_HDL);
			by ref_no;
			if chol_CE=1 and chol_HDL=1;
run;

title1 'Cholesterol reverse transport (cholesterol ester (CE) + HDL)';
title2 'Tissues to Liver (cholesterol removal (Anti-atherogenic))';

proc print data=ref2.chol_reverse;
run;

/*create dataset with no duplicate rows in ref_no column*/
proc sort data=ref2.chol_reverse out=ref2.chol_reverse nodupkey;
    by ref_no;
run;

/*view dataset with no duplicate rows in ref_no column*/
proc print data=ref2.chol_reverse;

proc sort data=ref2.chol_reverse
	out=ref2.chol_reverse_sorted;
	by descending Create_Date;	
run;

data ref2.chol_reverse_Sorted_1 (keep=sub_ref_no ref_no PMID Title Authors Journal_Book Create_Date)
		ref2.chol_reverse_Sorted_2 (keep=sub_ref_no Title Research_Gaps)
		ref2.chol_reverse_Sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research);
	    retain sub_ref_no 0;		
		sub_ref_no=sub_ref_no + 1;		
		set ref2.chol_reverse_sorted (keep=ref_no PMID Keywords Title Authors Journal_Book Create_Date Main_Findings Strengths 
						              Weaknesses Future_Research Research_Gaps);
run;

ods html file="&lit2/chol_reverse_1_.html" style=SasWeb;
title1 'Cholesterol reverse transport (cholesterol ester (CE) + HDL)';
title2 'Liver to Tissues (cholesterol deposition (Anti-Atherogenic))';
title3 'Cholesterol reverse transport data set 1';
proc print data=ref2.chol_reverse_Sorted_1 noobs;			
run;
ods html close;

ods html file="&lit2/chol_reverse_2_.html" style=SasWeb;
title1 'Cholesterol reverse transport (cholesterol ester (CE) + HDL)';
title2 'Liver to Tissues (cholesterol deposition (Anti-Atherogenic))';
title3 'Cholesterol reverse transport data set 2';
proc print data=ref2.chol_reverse_sorted_2 noobs;			
run;
ods html close;

ods html file="&lit2/chol_reverse_3_.html" style=SasWeb;
title1 'Cholesterol reverse transport (cholesterol ester (CE) + HDL)';
title2 'Liver to Tissues (cholesterol deposition (Anti-Atherogenic))';
title3 'Cholesterol reverse transport data set 3';
proc print data=ref2.chol_reverse_sorted_3 noobs;			
run;
ods html close;

/* diabetes complications */

data ref2.diabetes ref2.complications ref2.kidney ref2.microvascular ref2.macrovascular ref2.other;
	set ref2.combined_1;
	if find(Research_Gaps, 'diabetes', 'I')>0 then output ref2.diabetes;
	if find(Research_Gaps, 'T2D', 'I')>0 then output ref2.diabetes;
	if find(Research_Gaps, 'complications', 'I')>0 then output ref2.complications;
	if find(Research_Gaps, 'kidney', 'I')>0 then output ref2.kidney;
	if find(Research_Gaps, 'renal', 'I')>0 then output ref2.kidney;
	if find(Research_Gaps, 'microvascular', 'I')>0 then output ref2.microvascular;
	if find(Research_Gaps, 'macrovascular', 'I')>0 then output ref2.macrovascular;
	else output ref2.other;
run;

proc sort data=ref2.diabetes	
	out=ref2.diabetes_sorted;
	by ref_no;	
run;

proc sort data=ref2.complications	
	out=ref2.complications_sorted;
	by ref_no;	
run;

proc sort data=ref2.kidney	
	out=ref2.kidney_sorted;
	by ref_no;	
run;

proc sort data=ref2.microvascular	
	out=ref2.microvascular_sorted;
	by ref_no;	
run;

proc sort data=ref2.macrovascular	
	out=ref2.macrovascular_sorted;
	by ref_no;	
run;

/* Renal diabetic complications */

data ref2.diabetes_kidney_comp;
			merge ref2.diabetes_sorted(in=diabetes)
				  ref2.complications_sorted(in=complications)
				  ref2.kidney_sorted(in=kidney);
			by ref_no;
			if diabetes=1 and complications=1 and kidney=1;
run;

title1 'Diabetes kidney complications';

proc print data=ref2.diabetes_kidney_comp;
run;

/*create dataset with no duplicate rows in ref_no column*/
proc sort data=ref2.diabetes_kidney_comp out=ref2.diabetes_kidney_comp nodupkey;
    by ref_no;
run;

/*view dataset with no duplicate rows in ref_no column*/
proc print data=ref2.diabetes_Kidney_comp;

proc sort data=ref2.diabetes_kidney_comp
	out=ref2.diabetes_kidney_comp_sorted;
	by descending Create_Date;	
run;

data ref2.diabetes_kidney_comp_Sorted_1 (keep=sub_ref_no ref_no PMID Title Authors Journal_Book Create_Date)
		ref2.diabetes_kidney_comp_Sorted_2 (keep=sub_ref_no Title Research_Gaps)
		ref2.diabetes_kidney_comp_Sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research);
	    retain sub_ref_no 0;		
		sub_ref_no=sub_ref_no + 1;		
		set ref2.diabetes_kidney_comp_sorted (keep=ref_no PMID Keywords Title Authors Journal_Book Create_Date Main_Findings Strengths 
						              Weaknesses Future_Research Research_Gaps);
run;

ods html file="&lit2/diabetes_kidney_comp_1_.html" style=SasWeb;
title 'Diabetes kidney complications data set 1';
proc print data=ref2.diabetes_kidney_comp_Sorted_1 noobs;			
run;
ods html close;

ods html file="&lit2/diabetes_kidney_comp_2_.html" style=SasWeb;
title 'Diabetes kidney complications data set 2';
proc print data=ref2.diabetes_kidney_comp_sorted_2 noobs;			
run;
ods html close;

ods html file="&lit2/diabetes_kidney_comp_3_.html" style=SasWeb;
title 'Diabetes kidney complications data set 3';
proc print data=ref2.diabetes_kidney_comp_sorted_3 noobs;			
run;
ods html close;

/* Microvascular Diabetic complications */

data ref2.diabetes_micro_comp;
			merge ref2.diabetes_sorted(in=diabetes)
				  ref2.complications_sorted(in=complications)
				  ref2.microvascular_sorted(in=micro);
			by ref_no;
			if diabetes=1 and complications=1 and micro=1;
run;

title1 'Diabetes microvascular complications';

proc print data=ref2.diabetes_micro_comp;
run;

/*create dataset with no duplicate rows in ref_no column*/
proc sort data=ref2.diabetes_micro_comp out=ref2.diabetes_micro_comp nodupkey;
    by ref_no;
run;

/*view dataset with no duplicate rows in ref_no column*/
proc print data=ref2.diabetes_micro_comp;

proc sort data=ref2.diabetes_micro_comp
	out=ref2.diabetes_micro_comp_sorted;
	by descending Create_Date;	
run;

data ref2.diabetes_micro_comp_Sorted_1 (keep=sub_ref_no ref_no PMID Title Authors Journal_Book Create_Date)
		ref2.diabetes_micro_comp_Sorted_2 (keep=sub_ref_no Title Research_Gaps)
		ref2.diabetes_micro_comp_Sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research);
	    retain sub_ref_no 0;		
		sub_ref_no=sub_ref_no + 1;		
		set ref2.diabetes_micro_comp_sorted (keep=ref_no PMID Keywords Title Authors Journal_Book Create_Date Main_Findings Strengths 
						              Weaknesses Future_Research Research_Gaps);
run;

ods html file="&lit2/diabetes_micro_comp_1_.html" style=SasWeb;
title 'Diabetes microvascular complications data set 1';
proc print data=ref2.diabetes_micro_comp_Sorted_1 noobs;			
run;
ods html close;

ods html file="&lit2/diabetes_micro_comp_2_.html" style=SasWeb;
title 'Diabetes microvascular complications data set 2';
proc print data=ref2.diabetes_micro_comp_sorted_2 noobs;			
run;
ods html close;

ods html file="&lit2/diabetes_micro_comp_3_.html" style=SasWeb;
title 'Diabetes microvascular complications data set 3';
proc print data=ref2.diabetes_micro_comp_sorted_3 noobs;			
run;
ods html close;

/* Macrovascular Diabetic complications  */

data ref2.diabetes_macro_comp;
			merge ref2.diabetes_sorted(in=diabetes)
				  ref2.complications_sorted(in=complications)
				  ref2.macrovascular_sorted(in=macro);
			by ref_no;
			if diabetes=1 and complications=1 and macro=1;
run;

title1 'Diabetes macrovascular complications';

proc print data=ref2.diabetes_macro_comp;
run;

/*create dataset with no duplicate rows in ref_no column*/
proc sort data=ref2.diabetes_macro_comp out=ref2.diabetes_macro_comp nodupkey;
    by ref_no;
run;

/*view dataset with no duplicate rows in ref_no column*/
proc print data=ref2.diabetes_macro_comp;

proc sort data=ref2.diabetes_macro_comp
	out=ref2.diabetes_macro_comp_sorted;
	by descending Create_Date;	
run;

data ref2.diabetes_macro_comp_Sorted_1 (keep=sub_ref_no ref_no PMID Title Authors Journal_Book Create_Date)
		ref2.diabetes_macro_comp_Sorted_2 (keep=sub_ref_no Title Research_Gaps)
		ref2.diabetes_macro_comp_Sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research);
	    retain sub_ref_no 0;		
		sub_ref_no=sub_ref_no + 1;		
		set ref2.diabetes_macro_comp_sorted (keep=ref_no PMID Keywords Title Authors Journal_Book Create_Date Main_Findings Strengths 
						              Weaknesses Future_Research Research_Gaps);
run;

ods html file="&lit2/diabetes_macro_comp_1_.html" style=SasWeb;
title 'Diabetes macrovascular complications data set 1';
proc print data=ref2.diabetes_macro_comp_Sorted_1 noobs;			
run;
ods html close;

ods html file="&lit2/diabetes_macro_comp_2_.html" style=SasWeb;
title 'Diabetes macrovascular complications data set 2';
proc print data=ref2.diabetes_macro_comp_sorted_2 noobs;			
run;
ods html close;

ods html file="&lit2/diabetes_macro_comp_3_.html" style=SasWeb;
title 'Diabetes macrovascular complications data set 3';
proc print data=ref2.diabetes_macro_comp_sorted_3 noobs;			
run;
ods html close;

/* Electron Transport Chain (ETC) */

data ref2.etc ref2.ferritin ref2.other;
	set ref2.combined_1;
	if find(Research_Gaps, 'electron transport chain', 'I')>0 then output ref2.etc;
	if find(Research_Gaps, 'ETC', 'I')>0 then output ref2.etc;
	if find(Research_Gaps, 'ferritin', 'I')>0 then output ref2.ferritin;
	if find(Research_Gaps, 'iron', 'I')>0 then output ref2.ferritin;
	else output ref2.other;
run;

/*create dataset with no duplicate rows in ref_no column*/
proc sort data=ref2.etc out=ref2.etc nodupkey;
    by ref_no;
run;

/*view dataset with no duplicate rows in ref_no column*/
proc print data=ref2.etc;


proc sort data=ref2.etc	
	out=ref2.etc_sorted;
	by ref_no;	
run;

proc sort data=ref2.etc
	out=ref2.etc_sorted;
	by descending Create_Date;	
run;

data ref2.etc_Sorted_1 (keep=sub_ref_no ref_no PMID Title Authors Journal_Book Create_Date)
		ref2.etc_Sorted_2 (keep=sub_ref_no Title Research_Gaps)
		ref2.etc_Sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research);
	    retain sub_ref_no 0;		
		sub_ref_no=sub_ref_no + 1;		
		set ref2.etc_sorted (keep=ref_no PMID Keywords Title Authors Journal_Book Create_Date Main_Findings Strengths 
						              Weaknesses Future_Research Research_Gaps);
run;

ods html file="&lit2/etc_1_.html" style=SasWeb;
title 'Electron Transport Chain data set 1';
proc print data=ref2.etc_Sorted_1 noobs;			
run;
ods html close;

ods html file="&lit2/etc_2_.html" style=SasWeb;
title 'Electron Transport Chain data set 2';
proc print data=ref2.etc_sorted_2 noobs;			
run;
ods html close;

ods html file="&lit2/etc_3_.html" style=SasWeb;
title 'Electron Transport Chain data set 3';
proc print data=ref2.etc_sorted_3 noobs;			
run;
ods html close;

/* Ferritin */

/*create dataset with no duplicate rows in ref_no column*/
proc sort data=ref2.ferritin out=ref2.ferritin nodupkey;
    by ref_no;
run;

/*view dataset with no duplicate rows in ref_no column*/
proc print data=ref2.ferritin;
run;

proc sort data=ref2.ferritin	
	out=ref2.ferritin_sorted;
	by ref_no;	
run;

proc sort data=ref2.ferritin
	out=ref2.ferritin_sorted;
	by descending Create_Date;	
run;

data ref2.ferritin_Sorted_1 (keep=sub_ref_no ref_no PMID Title Authors Journal_Book Create_Date)
		ref2.ferritin_Sorted_2 (keep=sub_ref_no Title Research_Gaps)
		ref2.ferritin_Sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research);
	    retain sub_ref_no 0;		
		sub_ref_no=sub_ref_no + 1;		
		set ref2.ferritin_sorted (keep=ref_no PMID Keywords Title Authors Journal_Book Create_Date Main_Findings Strengths 
						              Weaknesses Future_Research Research_Gaps);
run;

ods html file="&lit2/ferritin_1_.html" style=SasWeb;
title 'Ferritin data set 1';
proc print data=ref2.ferritin_Sorted_1 noobs;			
run;
ods html close;

ods html file="&lit2/ferritin_2_.html" style=SasWeb;
title 'Ferritin data set 2';
proc print data=ref2.ferritin_sorted_2 noobs;			
run;
ods html close;

ods html file="&lit2/ferritin_3_.html" style=SasWeb;
title 'Ferritin data set 3';
proc print data=ref2.ferritin_sorted_3 noobs;			
run;
ods html close;

/* Ferritin + ETC */

proc sort data=ref2.etc	
	out=ref2.etc_sorted;
	by ref_no;	
run;

proc sort data=ref2.ferritin	
	out=ref2.ferritin_sorted;
	by ref_no;	
run;


data ref2.etc_ferritin;
			merge ref2.etc_sorted(in=etc)
				  ref2.ferritin_sorted(in=ferritin);
			by ref_no;
			if etc=1 and ferritin=1;
run;

/*create dataset with no duplicate rows in ref_no column*/
proc sort data=ref2.etc_ferritin out=ref2.etc_ferritin nodupkey;
    by ref_no;
run;

/*view dataset with no duplicate rows in ref_no column*/
proc print data=ref2.etc_ferritin;
run;

proc sort data=ref2.etc_ferritin	
	out=ref2.etc_ferritin_sorted;
	by ref_no;	
run;

data ref2.etc_ferritin_Sorted_1 (keep=sub_ref_no ref_no PMID Title Authors Journal_Book Create_Date)
		ref2.etc_ferritin_Sorted_2 (keep=sub_ref_no Title Research_Gaps)
		ref2.etc_ferritin_Sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research);
	    retain sub_ref_no 0;		
		sub_ref_no=sub_ref_no + 1;		
		set ref2.etc_ferritin_sorted (keep=ref_no PMID Keywords Title Authors Journal_Book Create_Date Main_Findings Strengths 
						              Weaknesses Future_Research Research_Gaps);
run;

ods html file="&lit2/etc_ferritin_1_.html" style=SasWeb;
title 'ETC + Ferritin data set 1';
proc print data=ref2.etc_ferritin_Sorted_1 noobs;			
run;
ods html close;

ods html file="&lit2/etc_ferritin_2_.html" style=SasWeb;
title 'ETC Ferritin data set 2';
proc print data=ref2.etc_ferritin_sorted_2 noobs;			
run;
ods html close;

ods html file="&lit2/etc_ferritin_3_.html" style=SasWeb;
title 'ETC Ferritin data set 3';
proc print data=ref2.etc_ferritin_sorted_3 noobs;			
run;
ods html close;

/* Obesity + Insulin Resistance + T2D */

data ref2.other ref2.obesity ref2.IR ref2.T2D;
	set ref2.combined_1;
	if find(Research_Gaps, 'Obesity', 'I')>0 then output ref2.obesity;
	if find(Research_Gaps, 'Insulin Resistance', 'I')>0 then output ref2.IR;
	if find(Research_Gaps, 'IR', 'I')>0 then output ref2.IR;
	if find(Research_Gaps, 'T2D', 'I')>0 then output ref2.T2D;
	if find(Research_Gaps, 'Type 2 Diabetes', 'I')>0 then output ref2.T2D;
	else output ref2.other;
run;

/*create dataset with no duplicate rows in ref_no column*/
proc sort data=ref2.IR out=ref2.IR nodupkey;
    by ref_no;
run;

/*view dataset with no duplicate rows in ref_no column*/
proc print data=ref2.IR;
run;

/*create dataset with no duplicate rows in ref_no column*/
proc sort data=ref2.T2D out=ref2.T2D nodupkey;
    by ref_no;
run;

/*view dataset with no duplicate rows in ref_no column*/
proc print data=ref2.T2D;
run;

proc sort data=ref2.obesity	
	out=ref2.obesity;
	by ref_no;	
run;

data ref2.obesity_IR_T2D;
			merge ref2.obesity(in=obesity)
				  ref2.IR(in=IR)
				  ref2.T2D(in=T2D);
			by ref_no;
			if obesity=1 and IR=1 and T2D=1;
run;

proc sort data=ref2.obesity_IR_T2D	
	out=ref2.obesity_IR_T2D_sorted;
	by descending Create_Date;	
run;

data ref2.obesity_IR_T2D_Sorted_1 (keep=sub_ref_no ref_no PMID Title Authors Journal_Book Create_Date)
		ref2.obesity_IR_T2D_Sorted_2 (keep=sub_ref_no Title Research_Gaps)
		ref2.obesity_IR_T2D_Sorted_3 (keep=sub_ref_no Strengths Weaknesses Future_Research);
	    retain sub_ref_no 0;		
		sub_ref_no=sub_ref_no + 1;		
		set ref2.obesity_IR_T2D_sorted (keep=ref_no PMID Keywords Title Authors Journal_Book Create_Date Main_Findings Strengths 
						              Weaknesses Future_Research Research_Gaps);
run;

ods html file="&lit2/obesity_IR_T2D_1_.html" style=SasWeb;
title 'Obesity + IR + T2D data set 1';
proc print data=ref2.obesity_IR_T2D_Sorted_1 noobs;			
run;
ods html close;

ods html file="&lit2/obesity_IR_T2D_2_.html" style=SasWeb;
title 'Obesity + IR + T2D data set 2';
proc print data=ref2.obesity_IR_T2D_sorted_2 noobs;			
run;
ods html close;

ods html file="&lit2/obesity_IR_T2D_3_.html" style=SasWeb;
title 'Obesity + IR + T2D data set 3';
proc print data=ref2.obesity_IR_T2D_sorted_3 noobs;			
run;
ods html close;











