clear

 if lower(c(username)) == "guillaumedaudin" {
	global dir "~/Répertoires GIT/slaveprofits"
	cd "$dir"
	global output "~/Répertoires GIT/slaveprofits/output/"
	global tastdb "$dir/external data/"
}

 if lower(c(username)) == "xronkl" {
	global dir "S:\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\GIT\slaveprofits"
	cd "$dir"
	global output "$dir\output\"
	global tastdb "$dir\external data\"
}



*1. Make VOYAGEID string
use "${tastdb}tastdb-exp-2020.dta", clear
tostring(VOYAGEID), replace
save "${tastdb}tastdb-exp-2020.dta", replace

use "${output}Venture all.dta", clear
keep if strmatch(voyageidintstd,"*/*")==1
keep ventureid voyageidintstd nameofoutfitter nameofthecaptain YEARAF_own numberofvoyages

gen voy1 =word(voyageidintstd,1)
gen voy2=word(voyageidintstd,3)
gen voy3=word(voyageidintstd,5)
gen voy4=word(voyageidintstd,7)
gen voy5=word(voyageidintstd,9)
gen voy6=word(voyageidintstd,11)
gen voy7=word(voyageidintstd,13)

drop voyageidintstd
reshape long voy, i(ventureid) j(voyagenumber)
drop if voy==""
gen VOYAGEID= voy
*destring VOYAGEID, force replace

merge m:1 VOYAGEID using "${tastdb}tastdb-exp-2020.dta"
drop if _merge==2
drop _merge
replace OWNERA= nameofoutfitter if nameofoutfitter!=""
//Here, we assume stdt on captain is correct
replace CAPTAINA= nameofthecaptain if missing(CAPTAINA)
replace YEARAF = YEARAF_own if missing(YEARAF)

sort ventureid VOYAGEID

keep ventureid numberofvoyages VOYAGEID YEARAF MAJBYIMP MJSELIMP SLAXIMP SLAMIMP CAPTAINA OWNERA DATEEND DATEDEP FATE FATE4
sort ventureid DATEDEP

gen voyagerank=.
by ventureid: replace voyagerank=_n

foreach rank of numlist 1(1)7 {
	foreach var of varlist DATEEND DATEDEP {
	capture gen `var'`rank'=.
	replace `var'`rank'=`var' if voyagerank==`rank'
	}
}


*** COLLAPSE FATE-VARIABLE INTO FOUR CATEGORIES, DEPENDING ON WHETHER/WHEN SHIP WAS LOST, THEN GENERATE DUMMY-VARS TO CAPTURE DIFFERENT OUTCOMES
gen FATEcol=1 if FATE==1
replace FATEcol=2 if FATE==2
replace FATEcol=2 if FATE==3
replace FATEcol=3 if FATE==4
replace FATEcol=3 if FATE==29
replace FATEcol=4 if FATE==49
replace FATEcol=3 if FATE==68
replace FATEcol=3 if FATE==95
replace FATEcol=3 if FATE==97
replace FATEcol=3 if FATE==162
replace FATEcol=4 if FATE==208

gen FATEdum1=1 if FATEcol==1
gen FATEdum2=1 if FATEcol==2
gen FATEdum3=1 if FATEcol==3
gen FATEdum4=1 if FATEcol==4

**Compute the length of each voyage (if possible)
gen length_in_days=(DATEEND-DATEDEP)/1000/60/60/24
label var length_in_days "Length of voyage (Europe to Europe) in days"
drop DATEEND DATEDEP



***To get rid of values that cannot be averaged because some other one is missing (if we want to do that)
foreach var of varlist  SLAXIMP SLAMIMP length_in_days /*YEARAF*/ {
	gen test`var'=1 if `var'==.
	replace test`var'=0 if `var'!=.
	egen test1=max(test`var'), by(ventureid)
	replace `var' =. if test1==1
	drop test`var' test1	
}


*HERE I TEST FOR DIFFERENCES IN MAJBYIMP OR MJSELIMP. IF THERE IS ONE, I REPLACE THEM BY MISSING
foreach var of varlist MAJBYIMP MJSELIMP {

	egen test`var'=group(`var'), missing
	egen test`var'1=min(test`var'), by(ventureid)
	egen test`var'2=max(test`var'), by(ventureid)
	egen test`var'3=max(test`var'2-test`var'1), by(ventureid)
	replace `var'=. if test`var'3 !=0 
	drop test*
}
gsort - SLAXIMP
sort ventureid YEARAF, stable
*We take the chronolgically first captain and owner 



collapse (first) CAPTAINA OWNERA (min) YEARAF (mean) SLAXIMP SLAMIMP length_in_days (max) numberofvoyages FATEdum1 FATEdum2 FATEdum3 FATEdum4 DATEDEP* DATEEND* /*
	*/ (first) MAJBYIMP MJSELIMP, by(ventureid)

generate VYMRTRAT=(SLAXIMP-SLAMIMP)/SLAXIMP

sort ventureid YEARAF


*** GENERATE FATEcol from dummy variables after collapsing.
gen FATEcol=1 if FATEdum1==1
replace FATEcol=3 if FATEdum3==1
replace FATEcol=2 if FATEdum2==1
replace FATEcol=4 if FATEdum4==1
drop FATEdum*

label define fate 1 "Voyage completed as intended" 2 "Original goal thwarted before disembarking slaves" 3 "Original goal thwarted after disembarking slaves" 4 "Unspecified/unknown"
label values FATEcol fate


foreach var of varlist CAPTAINA OWNERA YEARAF SLAXIMP SLAMIMP length_in_days MAJBYIMP MJSELIMP VYMRTRAT {
	rename `var' `var'rev
}

export delimited using "$dir/external data/Multiple voyages TSTD variables.csv", replace
save "${output}Multiple voyages.dta", replace





