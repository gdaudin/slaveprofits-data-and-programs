clear

* IMPORT CASH FLOW-DATABASES
* STANDARDIZING STRING FIELDS, IN CASE SOME DATASETS HAVE MISSING VARIABLES FOR ALL OBS
* STANDARDIZING THE NUMERIC VARIABLES SO THAT COMMAS ARE REPLACED BY DOTS AS DECIMAL-SEPARATOR IN THE VALUE-FIELD
* STANDARDIZING THE VARIABLES SO THAT THE FIELD WITH VALUES REALLY ARE NUMERIC, EVEN IF DATA IS MISSING IN SOME CASES
* ROUTINE THE REPEATED FOR EACH DATASET

import delimited "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\GIT\slaveprofits\Cash flow database DR.csv" , encoding(utf8) 
capture tostring meansofpaymentreturn, replace
capture tostring dateoftransaction, replace
capture replace value=subinstr(value, ",", ".",.)
capture destring value, force replace
capture destring estimate, replace
save "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\Cash flow DR.dta", replace

import delimited "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\GIT\slaveprofits\Cash flow database GD.csv", encoding(utf8) clear 
capture tostring meansofpaymentreturn, replace
capture tostring dateoftransaction, replace
capture replace value=subinstr(value, ",", ".",.)
capture destring value, force replace
capture destring estimate, replace
save "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\Cash flow GD.dta", replace

import delimited "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\GIT\slaveprofits\Cash flow database GK.csv", encoding(utf8) clear 
capture tostring meansofpaymentreturn, replace
capture tostring dateoftransaction, replace
capture replace value=subinstr(value, ",", ".",.)
capture destring value, force replace
capture destring estimate, replace
save "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\Cash flow GK.dta", replace

import delimited "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\GIT\slaveprofits\Cash flow database KR - new.csv", encoding(utf8) clear 
capture tostring meansofpaymentreturn, replace
capture tostring dateoftransaction, replace
capture replace value=subinstr(value, ",", ".",.)
capture destring value, force replace
capture destring estimate, replace
save "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\Cash flow KR.dta", replace

import delimited "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\GIT\slaveprofits\Cash flow database MR- new.csv", encoding(utf8) clear
capture tostring meansofpaymentreturn, replace
capture tostring dateoftransaction, replace
capture replace value=subinstr(value, ",", ".",.)
capture destring value, force replace
capture destring estimate, replace
save "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\Cash flow MR.dta", replace


use "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\Cash flow DR.dta", clear

* ALL CASH FLOW DATASETS MERGED INTO ONE FILE, AND SAVED IN NEW FILE

append using "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\Cash flow GD.dta"
append using "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\Cash flow GK.dta"
append using "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\Cash flow KR.dta"
*append using "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\Cash flow MR.dta"

save "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\Cash flow all.dta", replace

* IMPORT VENTURE DATABASES
* STANDARDIZING STRING FIELDS, IN CASE SOME DATASETS HAVE MISSING VARIABLES FOR ALL OBS
* STANDARDIZING NUMERIC FIELDS, IN CASE THEY FOR SOME REASON CONTAIN STRINGS. THIS IS CURRENTLY FORCED, SO STRING VALUES ARE LOST.
* ROUTINE THE REPEATED FOR EACH DATASET

import delimited "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\GIT\slaveprofits\Venture database DR.csv", encoding(utf8) clear 
capture tostring dateofprimarysource, replace
capture tostring voyageidintstd, replace
capture tostring internalcrossref, replace
capture tostring placeofpurchase, replace
capture tostring placeofdisembarkation, replace
capture tostring placeofoutfitting, replace
capture tostring dateofdeparturefromportofoutfit, replace
capture tostring datetradebeganinafrica, replace
capture tostring dateofdeparturefromafrica, replace
capture tostring datevesselarrivedwithslaves, replace
capture tostring datetradebeganinafrica, replace
capture tostring nameofthecaptain, replace
capture tostring dateofreturntoportofoutfitting, replace
capture destring profitsreportedinsource, force replace
capture destring shareoftheship, force replace
capture destring numberofslavespurchased, force replace
capture destring numberofslavessold, force replace
save "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\Venture DR.dta", replace

import delimited "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\GIT\slaveprofits\Venture database GD.csv", encoding(utf8) clear 
capture tostring dateofprimarysource, replace
capture tostring voyageidintstd, replace
capture tostring internalcrossref, replace
capture tostring placeofpurchase, replace
capture tostring placeofdisembarkation, replace
capture tostring placeofoutfitting, replace
capture tostring dateofdeparturefromportofoutfit, replace
capture tostring datetradebeganinafrica, replace
capture tostring dateofdeparturefromafrica, replace
capture tostring datevesselarrivedwithslaves, replace
capture tostring datetradebeganinafrica, replace
capture tostring nameofthecaptain, replace
capture tostring dateofreturntoportofoutfitting, replace
capture destring profitsreportedinsource, force replace
capture destring shareoftheship, force replace
capture destring numberofslavespurchased, force replace
capture destring numberofslavessold, force replace
save "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\Venture GD.dta", replace

import delimited "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\GIT\slaveprofits\Venture database GK.csv", encoding(utf8) clear 
capture tostring dateofprimarysource, replace
capture tostring voyageidintstd, replace
capture tostring internalcrossref, replace
capture tostring placeofpurchase, replace
capture tostring placeofdisembarkation, replace
capture tostring placeofoutfitting, replace
capture tostring dateofdeparturefromportofoutfit, replace
capture tostring datetradebeganinafrica, replace
capture tostring dateofdeparturefromafrica, replace
capture tostring datevesselarrivedwithslaves, replace
capture tostring datetradebeganinafrica, replace
capture tostring nameofthecaptain, replace
capture tostring dateofreturntoportofoutfitting, replace
capture destring profitsreportedinsource, force replace
capture destring shareoftheship, force replace
capture destring numberofslavespurchased, force replace
capture destring numberofslavessold, force replace
save "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\Venture GK.dta", replace

import delimited "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\GIT\slaveprofits\Venture database KR - new.csv", encoding(utf8) clear 
capture tostring dateofprimarysource, replace
capture tostring voyageidintstd, replace
capture tostring internalcrossref, replace
capture tostring placeofpurchase, replace
capture tostring placeofdisembarkation, replace
capture tostring placeofoutfitting, replace
capture tostring dateofdeparturefromportofoutfit, replace
capture tostring datetradebeganinafrica, replace
capture tostring dateofdeparturefromafrica, replace
capture tostring datevesselarrivedwithslaves, replace
capture tostring datetradebeganinafrica, replace
capture tostring nameofthecaptain, replace
capture tostring dateofreturntoportofoutfitting, replace
capture destring profitsreportedinsource, force replace
capture destring shareoftheship, force replace
capture destring numberofslavespurchased, force replace
capture destring numberofslavessold, force replace
save "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\Venture KR.dta", replace

import delimited "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\GIT\slaveprofits\Venture database MR.csv", encoding(utf8) clear
capture tostring dateofprimarysource, replace
capture tostring voyageidintstd, replace
capture tostring internalcrossref, replace
capture tostring placeofpurchase, replace
capture tostring placeofdisembarkation, replace
capture tostring placeofoutfitting, replace
capture tostring dateofdeparturefromportofoutfit, replace
capture tostring datetradebeganinafrica, replace
capture tostring dateofdeparturefromafrica, replace
capture tostring datevesselarrivedwithslaves, replace
capture tostring datetradebeganinafrica, replace
capture tostring nameofthecaptain, replace
capture tostring dateofreturntoportofoutfitting, replace
capture destring profitsreportedinsource, force replace
capture destring shareoftheship, force replace
capture destring numberofslavespurchased, force replace
capture destring numberofslavessold, force replace
save "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\Venture MR.dta", replace

clear

* ALL VENTURE DATASETS MERGED INTO ONE FILE, AND SAVED IN NEW FILE

use "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\Venture DR.dta"
append using "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\Venture GD.dta"
append using "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\Venture GK.dta"
append using "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\Venture KR.dta"
*append using "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\Venture MR.dta"

save "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\Venture all.dta", replace

* A SET OF DATES IN STATA-READABLE FORMAT ARE DERIVED FROM DATE IN STRING FORMAT, BASED ON POSITION OF CHARACTERS IN THE STRING (DATES ARE TO BE FORMATTED AS: YYYY-MM-DD)
* IF MONTH & DAY IS MISSING IN THE OBSERVATION, BUT WE HAVE AN OBSERVATION FOR YEAR, MONTH AND DATE IS CURRENTLY ASSUMED TO BE 1st OF JULY, IN ORDER TO CREATE A STATA-READABLE DATE-VAR.
* ROUTINE IS THEN REPEATED FOR ALL DIFFERENT DATES IN THE DATASETS

gen year1=substr( dateofdeparturefromportofoutfitt,1,4)
gen month1=substr( dateofdeparturefromportofoutfitt,6,2)
gen day1=substr( dateofdeparturefromportofoutfitt,9,2)
destring year1, replace
destring month1, replace
destring day1, replace
gen monthdeparturefromportofoutfit = month1
replace month1=7 if missing(month1) & year1<.
replace day1=1 if missing(day1) & year1<.
gen date1=mdy(month1, day1, year1)
format date1 %d
drop year1 month1 day1 
ren dateofdeparturefromportofoutfitt datedepartureportofoutfitt_str
ren date1 dateofdeparturefromportofoutfit

gen year1=substr( dateofprimarysource,1,4)
gen month1=substr( dateofprimarysource,6,2)
gen day1=substr( dateofprimarysource,9,2)
destring year1, replace
destring month1, replace
destring day1, replace
gen monthofprimarysource=month1
replace month1=7 if missing(month1) & year1<.
replace day1=1 if missing(day1) & year1<.
gen date1=mdy(month1, day1, year1)
format date1 %d
drop year1 month1 day1 
ren dateofprimarysource dateofprimarysource_str
ren date1 dateofprimarysource

gen year1=substr( datetradebeganinafrica,1,4)
gen month1=substr( datetradebeganinafrica,6,2)
gen day1=substr( datetradebeganinafrica,9,2)
destring year1, replace
destring month1, replace
destring day1, replace
gen monthtradebeganinafrica=month1
replace month1=7 if missing(month1) & year1<.
replace day1=1 if missing(day1) & year1<.
gen date1=mdy(month1, day1, year1)
format date1 %d
drop year1 month1 day1 
ren datetradebeganinafrica datetradebeganinafrica_str
ren date1 datetradebeganinafrica

gen year1=substr( dateofdeparturefromafrica,1,4)
gen month1=substr( dateofdeparturefromafrica,6,2)
gen day1=substr( dateofdeparturefromafrica,9,2)
destring year1, force replace
destring month1, force replace
destring day1, force replace
gen monthofdeparturefromafrica=month1
replace month1=7 if missing(month1) & year1<.
replace day1=1 if missing(day1) & year1<.
gen date1=mdy(month1, day1, year1)
format date1 %d
drop year1 month1 day1 
ren dateofdeparturefromafrica dateofdeparturefromafrica_str
ren date1 dateofdeparturefromafrica

gen year1=substr( datevesselarrivedwithslaves,1,4)
gen month1=substr( datevesselarrivedwithslaves,6,2)
gen day1=substr( datevesselarrivedwithslaves,9,2)
destring year1, replace
destring month1, replace
destring day1, replace
gen monthvesselarrivedwithslaves=month1
replace month1=7 if missing(month1) & year1<.
replace day1=1 if missing(day1) & year1<.
gen date1=mdy(month1, day1, year1)
format date1 %d
drop year1 month1 day1 
ren datevesselarrivedwithslaves datevesselarrivedwithslaves_str
ren date1 datevesselarrivedwithslaves

gen year1=substr( dateofreturntoportofoutfitting,1,4)
gen month1=substr( dateofreturntoportofoutfitting,6,2)
gen day1=substr( dateofreturntoportofoutfitting,9,2)
destring year1, replace
destring month1, replace
destring day1, replace
gen monthofreturnoutfitting=month1
replace month1=7 if missing(month1) & year1<.
replace day1=1 if missing(day1) & year1<.
gen date1=mdy(month1, day1, year1)
format date1 %d
drop year1 month1 day1 
ren dateofreturntoportofoutfitting datereturnportofoutfitting_str
ren date1 dateofreturntoportofoutfitting

* VARIABLES ONLY INCLUDING THE YEARS OF THE VARIOUS CHRONOLOGICAL VARS ARE DERIVED FROM THE RESPECTIVE DATE-VARS

gen yearofdeparturefromportofoutfit=year(dateofdeparturefromportofoutfit)
gen yearofprimarysource=year(dateofprimarysource)
gen yeartradebeganinafrica=year(datetradebeganinafrica)
gen yearofdeparturefromafrica=year(dateofdeparturefromafrica)
gen yearvesselarrivedwithslaves=year(datevesselarrivedwithslaves)
gen yearofreturntoportofoutfitting=year(dateofreturntoportofoutfitting)

* GENERAL YEAR-VARIABLE, THE LOWEST COMMON DENOMINATOR, IN ORDER TO BE ABLE TO ORDER THE VENTURES ROUGHLY CHRONOLOGICALLY

gen yearmin= yearofdeparturefromportofoutfit
replace yearmin= yeartradebeganinafrica if yearmin==.
replace yearmin= yearofdeparturefromafrica if yearmin==.
replace yearmin= yearvesselarrivedwithslaves if yearmin==.
replace yearmin= yearofreturntoportofoutfitting if yearmin==.

* CREATE A NUMERIC VARIABLE OUT OF THE VAR FOR ID IN THE TRANSATLANTIC SLAVE TRADE DATABASE, FOR LINKING THE DATASETS
* THEN THE DATASETS ARE MERGED, AND UNNECESSARY OBSERVATIONS FROM THE TSTD (I.E. THOSE THAT ARE NOT PRESENT IN OUR DATASETS) ARE DROPPED
* NB: CURRENT ROUTINE ONLY MANAGES TO DO THIS FOR OBS OF ONE SINGLE VOYAGE; VENTURES INCORPORATING MULTIPLE VOYAGES CANNOT BE CAPTURED IN THIS WAY. HAVE NOT YET FIGURED OUT A GOOD WAY TO LINK WHEN THERE ARE MULTIPLE VOYAGES

gen VOYAGEID= voyageidintstd
destring VOYAGEID, force replace
merge m:1 VOYAGEID using "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\tastdb-exp-2020.dta"
drop if _merge==2
drop _merge

* REPLACE THE TSTD-VAR YEARAF IF DATA FOR THIS VAR IS MISSING, BUT WE HAVE SOME DATA ON THE TIMING IN OUR DATASETS
* NB: OME ASSUMPTIONS ARE MADE AS TO THE TIMING, IF WE ONLY HAVE DATE FROM DEPARTURE FROM OR RETURN TO EUROPE.

replace YEARAF=yeartradebeganinafrica if missing(YEARAF)
replace YEARAF= yearofdeparturefromafrica if missing(YEARAF)
replace YEARAF= yearvesselarrivedwithslaves if missing(YEARAF)
replace YEARAF= yearofdeparturefromportofoutfit+1 if missing(YEARAF)
replace YEARAF= yearofreturntoportofoutfitting-1 if missing(YEARAF)

save "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\Venture all.dta", replace
