/*************************
* This do-file cleans up the data
* and creates important variables
* for analysis dataset
**************************/

capture log close
log using $output/makevars.log, replace

use "$tempdata/tastdb_clean", clear

count

* Keep just the useful variables
*keep year* slad* captain* owner* adult* male* female* boy* girl* child* slad* year* voy* sla* jam price *sla* vymr* resistance

/******************************
* Voyage owners: How many? 
* Who are they? Company or independent?
* Is the captain a recorded owner?
******************************/


gen owner_count=0
local i=1
foreach let in a b c d e f g h i j k l m n o p {
	replace owner`let'="" if owner`let'=="."
	replace owner_count=`i' if owner`let'~=""
	local j=`i'+1
	local i=`j'
}
la var owner_count "Number of recorded owners"

/* Is one of the owners a major national slaving monopolist joint-stock firm? */

gen company=0
foreach name in Company Adventurers Companhia Compagnie {
	foreach let in a b c d e f g h i j k l m n o p {
		replace company=1 if strmatch(owner`let', "*`name'*")==1 
	}
}
replace company=. if ownera==""
la var company "Joint-Stock Company 0/1"


gen rac=0 if ownera~=""
la var rac "Royal African Company 0/1"
gen radv=0 if ownera~=""
la var radv "Royal Adventurers 0/1"
gen wic=0 if ownera~=""
gen mcc=0 if ownera~=""
gen ssc=0 if ownera~=""
la var ssc "South Sea Company 0/1"
gen cggp=0 if ownera~=""
gen cgp=0 if ownera~=""
gen cdi=0 if ownera~=""
la var cdi "Companie des Indes 0/1"
foreach let in a b c d e f g h i j k l m n o p {
	replace rac=1 if strmatch(owner`let', "*Royal African Company*")==1
	replace radv=1 if strmatch(owner`let', "*Royal Adventurers*")==1
	replace wic=1 if strmatch(owner`let',"*West*")*strmatch(owner`let',"*Indisch*")==1
	replace mcc=1 if strmatch(owner`let',"*Middelburgsche Commercie*")==1
	replace ssc=1 if strmatch(owner`let',"*South Sea*")==1
	replace cggp=1 if strmatch(owner`let',"*Maranh*")==1
	replace cgp=1 if strmatch(owner`let',"*Pernambuco e Para*")==1
	replace cdi=1 if strmatch(owner`let',"*Compagnie des Indes*")==1
}
gen other_comp=max(0, company-rac-radv-wic-mcc-ssc-cggp-cgp-cdi)
la var other_comp "Other Company 0/1"


*Is captain one of the listed owners?

gen capown=0
foreach own in a b c d e f g h i j k l m n o p {
	foreach cap in a b c {
		replace capown=1 if (strmatch(owner`own',captain`cap')==1 & owner`own'~="" & captain`cap'~="")
	}
}
replace capown=. if ownera=="" | captaina==""
la var capown "Captain-Owner 0/1"

save "$tempdata/temp1", replace

* Some nonlinearities:

gen rac_only=rac*cond(owner_count==1,1,0)
gen rac_split=rac*cond((owner_count>1 & owner_count~=.),1,0)

gen rac_voy2=rac*voyage
la var rac_voy2 "RAC*VOYTIME*"

gen company_only=company*cond(owner_count==1,1,0)
gen company_split=company*cond((owner_count>1 & owner_count~=.),1,0)

gen com_voy2=company*voyage
la var com_voy2 "COMPANY*MPTIME*"

gen voy2_sq=voyage^2
la var voy2_sq "VOYTIME$^2$"
gen voy2_cb=voyage^3
la var voy2_cb "VOYTIME$^3$"

gen com_voy2_sq=com_voy2^2
gen com_voy2_cb=com_voy2^3




/*****************************
* Captains: how many were there?
* First recorded voyage or veterans?
* Have they changed employment status?
*****************************/

/* Count the number of captains recorded on a vessel */
gen captain_count=cond(captaina=="",0,1) +cond(captainb=="",0,1) +cond(captainc=="",0,1)

save "$tempdata/cap_master", replace

do "$do_datawork/cap_order"		/* Create variables for number and order	*/
								/* of a voyage for that captain				*/

use "$tempdata/cap_master", clear

sort voyageid
merge voyageid using "$tempdata/captain_order"
assert _merge==3 | captain_count==0
drop _merge

*Repeat for individual ships
save "$tempdata/ship_master", replace

do "$do_datawork/ship_order"		/* Create variables for number and order	*/
								/* of a voyage for that captain				*/

use "$tempdata/ship_master", clear

sort voyageid
merge voyageid using "$tempdata/ship_order"
assert _merge==3 | shipname=="" | tonnage==.
drop _merge

/*****************************
* Slave mortality rate
*****************************/


/* tslavesp = total slaves purchased
	tslavesd = total slaves on board at last
	slaving port (before transatlantic leg)
	slaarriv = total slaves arrive first port of disembarkation
	This are the recorded NOT imputed variables
	compare to variables sladvoy and vymrtimp
	*/
gen mort_a=(tslavesp-slaarriv)
replace mort_a=tslavesd-slaarriv if tslavesp==.
* assert mort_a >= 0 /* about 1% of obs are negative. why? */
replace mort_a=. if mort_a<0
*replace mort_a=. if mort_a-sladvoy>20 & sladvoy~=.
*replace mort_a=. if mort_a-sladvoy<-20
la var mort_a "imputed mortality count from recorded data"

gen mrate_a=mort_a/tslavesp
replace mrate_a=mort_a/tslavesd if tslavesp==.
la var mrate_a "constructed mortality rate from recorded data"
assert (mrate_a >=0 & mrate_a <=1) | mrate_a==.

gen mrate_b=sladvoy/tslavesd
/* constructed from recorded middle passage and slaves at dept*/
la var mrate_b "constructed middle passage mortality"
replace mrate_b=(tslavesd-slaarriv)/tslavesd if sladvoy==.
replace mrate_b=. if mrate_b<0 | mrate_b>1
gen mrate_pct=mrate_b*100
la var mrate_pct "Mortality Rate (%)"

gen mrate_c=mrate_b
/* try to add some using slaves purchased */
reg tslavesd tslavesp, nocons
predict tslavesd_hat
replace mrate_c=sladvoy/tslavesd_hat if mrate_c==.
replace mrate_c=(tslavesd_hat-slaarriv)/tslavesd_hat if mrate_c==.

gen mrate_af=sladafri/tslavesp
la var mrate_af "african embarkment mortality"

/*********************************
* Time: dates, trends and voyage lengths
*********************************/
gen t=yeardep-1514 /* 1514 minimum year observed */
la var t "Trend"

gen t2=t^2
gen t3=t^3
gen t4=t^4

gen com_t=company*t
la var com_t "Company * Trend"
gen capown_t = capown*t
la var capown_t "Cap Own * Trend"

gen voy1_2=voy1imp^2
la var voy1_2 "Voyage length ^2"

gen month_dep=month(date_dep)
la var month_dep "Month of departure from Europe"
gen month_leftafr=month(date_leftafr)
la var month_leftafr "Month of departure from Africa"
gen time_coast=date_leftafr-date_buy
la var time_coast "Days between first purchase and dep. from Africa"

save "$tempdata/temp3", replace

/*********************************
* Where ships went
*********************************/

* Generate dummies for (1) nationality, (2) african coast region, (3) destination region

tab national, gen(nat)			/* Nation of origin effects */
gen national_x=cond(national==.,0,national)
la var national_x "Nation (incl. missing)"

forval i=1(1)9 {				/* Embarkation in Africa effects */
	gen embk`i'=cond(regem1==60000+`i'*100,1,0,.)
	replace embk`i'=1 if regem2==60000+`i'*100
	replace embk`i'=1 if regem3==60000+`i'*100
	replace embk`i'=. if regem1==.
}

gen region=cond(regem3==.,cond(regem2==. ,cond(regem1==.,.,regem1),regem2),regem3)

#delimit ;

gen dest_reg=.;
replace dest_reg=1 if majselrg>=10000 & majselrg<20000;
replace dest_reg=2 if (majselrg>=20100 & majselrg<21000) |
	(majselpt >21900 & majselpt<=21903) |
	majselrg==21700;
replace dest_reg=3 if (majselrg>=21000 & majselrg<21200);
replace dest_reg=4 if (majselrg>=21200 & majselrg<21600) |
	majselpt==21904;
replace dest_reg=5 if (majselrg>= 32100 & majselrg<32200) |
	(majselrg >=36100 & majselrg <39000) |
	(majselrg >= 32300 & majselrg<35100) ;
replace dest_reg=5 if (majselrg>=31100 & majselrg< 31300) 
	;
replace dest_reg=7 if (majselrg >=31300 & majselrg<31400) |
	(majselrg>=35100 & majselrg<35300) |
	(majselrg>=35500 & majselrg<36000) ;
replace dest_reg=8 if (majselrg >=32200 & majselrg<32300) |
	(majselrg >=35300 & majselrg<35400) |
	(majselrg >=36300 & majselrg<36400);
replace dest_reg=9 if (majselrg>=50000 & majselrg<60000);
/* other regions omitted */; 

label define destinations
	1 "Europe"
	2 "N Atlantic Coast NA"
	3 "C Atlantic Coast NA"
	4 "S Atlantic Coast NA"
	5 "SE Caribbean"
	/*6 "C Caribbean"*/
	7 "NW Caribbean"
	8 "Guyana"
	9 "Brazil"
	;
/* central america = (majselrg>=42100 & majselrg<42000) |
	majselrg==35400;
	NOT MANY OBS */

la var dest_reg "DESTINATION REG";
la values dest_reg destinations;

sort dest_reg region;
egen I_route=group(dest_reg region);

forval i=0/100 {;
	count if I_route==`i';
	if `r(N)'>0{;
		gen I_rt_ton_`i'=cond(I_route==`i',1,0)*tonmod;
	};
};
forval i=1/40 {;
	gen ton_10_`i'=cond(year10==`i',1,0)*tonmod;
};
forval i=1/15 {;
	gen ton_25_`i'=cond(year25==`i',1,0)*tonmod;
};

sort I_route;
by I_route: egen Isd_voytime=sd(voyage);
by I_route: egen Iav_voytime=mean(voyage);
by I_route: egen I50_voytime=median(voyage);


* Dummies by nationality-region fort infrastructure;

/* James Fort, Senegal River */
gen fort_english=cond(region==60100 & national==7,1,0);
replace fort_english=1 if region==60400 & national==7;		/* Cape Coast and others, Gold Coast */

gen fort_portuguese=cond(region==60400 & national==4 & yeardep<1637,1,0);	
	/* Elmina; lost to Dutch 1637 */;
replace fort_portuguese=1 if national==4 & region==60500;	/* Wydah or Oidah */;
replace fort_portuguese=1 if national==4 & region==60600;	/* Sao Tome	*/;

gen fort_dutch = cond(region==60400 & national==8,1,0);

gen fort_voyage=fort_english+fort_portuguese+fort_dutch;


#delimit cr

/***********************************
* crowding
************************************/

gen crowd_mod=tslavesp/tonmod 
replace crowd_mod=tslavesd/tonmod if tslavesp==.

gen slave_af=cond(tslavesp==.,tslavesd,tslavesp)
la var slave_af "Slaves on Middle Passage"

/***********************************
* Crew mortality
************************************/

gen mrate_crew=crewdied/crew1
gen mrate_crew_pct=mrate_crew*100
la var mrate_crew "Crew mortality rate over entire voyage (may >100pct)"
la var mrate_crew_pct "Crew mortality rate over entire voyage (may >100pct) (%)"



/*********************************
* Missing data dummies to test for
* composition bias
*********************************/

gen comp_bias=1
foreach var in mrate_b time_coast vymrtrat voyage fate national rig region tonmod tonnage tontype crewdied tslavesp tslavesd slaarriv sladvoy yeardep dest_reg crowd_mod {
	display "`var'"
	replace comp_bias=0 if `var'==.
	count if comp_bias==1
	gen m_`var'=cond(`var'==.,1,0)
}

la var m_vymrtrat "Imputed Mortality rate missing 0/1"
la var m_mrate_b "Mortality rate missing 0/1"
la var m_voyage "Middle passage duration missing 0/1"
la var m_fate "Voyage Fate missing 0/1"
la var m_rig "Rig type missing 0/1"
la var m_region "Embarkment region missing 0/1"
la var m_tonnage "Tonnage value missing 0/1"
la var m_tontype "Tonnage unit missing 0/1"
la var m_crewdied "Crew death missing 0/1"
la var m_tslavesd "Slaves at departure missing 0/1"
la var m_sladvoy "Deaths on middle passage missing 0/1"
la var m_slaarriv "Slaves at arrival missing 0/1"
la var m_tonmod "Standardized tonnage missing 0/1"
la var m_yeardep "Departure year missing 0/1"
la var m_dest_reg "Disembarkment region missing 0/1"
la var m_crowd_mod "Crowding missing 0/1"
la var m_time_coast "Time On African Coast missing 0/1"

gen m_owner=cond(owner_count==0,1,0)
la var m_owner "No ownership records 0/1"
/*
#delimit ;
gen m_slaximp=cond(adult1==. & child1==. & male1==. & female1==. 
	&men1==. & women1==. & boy1==. & girl1==. & infant1==.,
	1,0);
la var m_slaximp "Slaves embarked completely missing 0/1";

#delimit cr
*/
*replace comp_bias=0 if m_owner==1

/****************************
* Physical characteristics of ship
****************************/

* tonnage has variable units!
* stopgap: split into unit-tonnage interactions
tab tontype,gen(tonunit)		/* dummies for the units of tonnage measure */
								/* we don't always know the conversion rate */
/*forval i=1/21 {
	gen ton_`i'=tonnage*tonunit`i'
	count if ton_`i'>0 & ton_`i'~=. & comp_bias==1
	if r(N)>2{
		gen crowd_`i'=slaximp/ton_`i'
		replace crowd_`i'=0 if ton_`i'==0
	} 
	else {
		drop ton_`i'
	}
}
*/




gen ship_age=yeardep-yrcons
la var ship_age "age of ship at departure"
* 4 obs<0. new ship en route?

/* Dummies, most common types of rigging */
gen rig_oth=cond(rig==.,.,1)
* dropped types:  
foreach i in  1 2 3 4 8 13 25 27 30 35 36 40{
	gen rig_`i'=cond(rig==`i',1,0)
	replace rig_oth=0 if rig_`i'==1
}

gen rig_x=cond(rig==.,0,rig)
la var rig_x "Rigging (incl. missing)"


save "$tempdata/temp5", replace

/*********************************
* Shipboard events
*********************************/

gen crowd=tslavesd/tonnage		/* this variable was wrong in first draft */
la var crowd "slaves/tonnage"	/* is tonnage reliable? */

gen crewdum=cond(crewdied==0,0,1) if crewdied~=.
la var crewdum "indicator crew deaths >0"

gen cs_ratio=sladvoy/crewdied
la var cs_ratio "ratio of slave deaths to crew deaths"

* Recorded slave resistance
gen resist1=cond((resistance>=1 & resistance ~=.),1,0)
la var resist1 "Slave Resistance 0/1"

/* Voyage outcomes */
gen voy_complete=cond(fate==1,1,0)
la var voy_complete "Voyage completed 0/1"

gen voy_preembark=0
foreach i in 2 6 10 14 18 22 27 31 45 50 90 93 96 160 67 {
	replace voy_preembark=1 if fate==`i'
}
la var voy_preembark "Voyage failed before Embarking slaves 0/1"

gen voy_middle=0
foreach i in 69 75 189 201 204 159 99 59 186 187 204 3 7 11 15 19 23 28 46 48 51 56 66 71 72 73 74 76 77 80 81 82 87 89 91 98 99 161 205 {
	replace voy_middle=1 if fate==`i'
}
la var voy_middle "Voyage failed middle passage 0/1"

gen voy_disembark=0
foreach i in 4 8 12 16 20 24 29 47  52 54 185 199 68 85 86 88 92 162 185 196 206 207 49 79 157 {
	replace voy_disembark=1 if fate==`i'
}
la var voy_disembark "Voyage failed after disembarking slaves 0/1"

gen voy_court=0
replace voy_court=1 if fate>=102 & fate<=156
replace voy_court=1 if fate>=164 & fate<=184
la var voy_court "Voyage court 0/1"

gen voy_oth=1-voy_complete-voy_preembark-voy_middle-voy_disembark-voy_court
la var voy_oth "Voyage outcome other 0/1"



/******************
* Merge in annual price data
******************/

sort yeardep
merge yeardep using "$tempdata/slaprice_davies", _merge(_hasannp)
rename db_price db0_price
rename dj_price dj0_price
tab _hasannp
drop year_L*
save "$tempdata/daviesmerge", replace

forval i=1/5{
	use "$tempdata/slaprice_davies"
	keep year_L`i' *price
	sort year_L`i'
	save "$tempdata/d`i'", replace
	
	use "$tempdata/daviesmerge"
	gen year_L`i'=yeardep
	sort year_L`i'
	merge year_L`i' using "$tempdata/d`i'"
	assert _merge !=2
	drop _merge
	
	rename db_price db`i'_price
	rename dj_price dj`i'_price
	save "$tempdata/daviesmerge", replace
}


/*
sort voyageid
merge voyageid using "$tempdata/slaprice_eltis10", _merge(_eltisp)
tab _eltisp
gen shiptest=cond(shipname==shipname_eltis,1,0) if _eltisp==3
* Ship matching seems correct, so why do 92 voyage ids not map correctly?

gen comp_p=company*price_eltis
gen cap_p=capown*price_eltis
*/


sort yeardep
merge yeardep using "$tempdata/slaprice_galenson"
drop _merge
sort yeardep

save "$tempdata/temp7", replace


merge yeardep using "$tempdata/sugar_price"
drop _merge
sort yeardep



*********************
* Imputed ship data

gen gap = yrcons-yrreg /*???*/
sum gap, det
* why negative?




/*************************
* Legal regime changes
*************************/

/* after British banned trade there were reports of slaves being thrown */
/* overboard to avoid punishment. Also british treated slavers as pirates */
gen sta1807=cond(yeardep>=1807, 1, 0)
la var sta1807 "Slave Trade Act 1807 0/1"

/* Royal African Company lost its monopoly in 1698 */
gen rac_mply=rac*cond(yeardep<=1698,1,0)
la var rac_mply "RAC Monopoly Right 0/1"

/*************************
* Network analysis of ship owners
*************************/

/* blank */


/*************************
*  Lags of mortality rate
************************/

/* blank */

/************************
* create age-sex variables
* from raw counts
*************************/

#delimit;
gen adults_dis = .;
replace adults_dis=
	cond(men3==.,0,men3)+
	cond(women3==.,0,women3)+
	cond(adult3==.,0,adult3)
	if 
	(men3~=. | women3~=. | adult3 ~=.);
la var adults_dis "Adults disembarked";

gen male_dis = .;
replace male_dis=
	cond(men3==.,0,men3)+
	cond(boy3==.,0,boy3)
	if 
	(men3~=. | boy3~=.);
la var male_dis "Males disembarked";

gen children_dis = .;
replace children_dis=
	cond(boy3==.,0,boy3)+
	cond(girl3==.,0,girl3)+
	cond(infant3==.,0,infant3)+
	cond(child3==.,0,child3)
	if 
	(men3~=. | women3~=. | adult3 ~=. | infant3~=.);
la var children_dis "Children disembarked";

gen female_dis = .;
replace female_dis=
	cond(women3==.,0,women3)+
	cond(girl3==.,0,girl3)
	if 
	(women3~=. | girl3~=.);
la var female_dis "Females disembarked";

#delimit cr


save "$tempdata/temp9", replace

/*************************
* Create decadal mortality rates
* to control for mortality environment
*************************/

compress
save "$tempdata/tempX", replace								
keep vymrtrat year10
collapse (mean) mean_drate=vymrtrat, by(year10)
la var mean_drate "mean mortality rate by decade"

tsset year10
gen L_mean_drate=L.mean_drate
la var L_mean_drate "previous decade's mean mort rate"

sort year10
save "$tempdata/meanrates", replace

use "$tempdata/tempX"
sort year10
merge year10 using "$tempdata/meanrates"
assert _merge==3
drop _merge

/****************************
* Add data from NOA of Atlantic wind patterns
****************************/

save "$tempdata/tempY", replace

insheet using "$data/NOA_L_F.txt", clear
rename year yeardep
sort yeardep
save "$tempdata/noa", replace

insheet using "$data/noa_monthly.txt", clear
/*
*destring year nao, force replace
forval y=1/3 {
	rename l`y'_noa l`y'_nao
	*destring l`y'_nao, force replace
}
forval y=1/6 {
	rename f`y'_noa f`y'_nao
	*destring f`y'_nao, force replace
}
*/
rename year yearaf
drop mon
sort yearaf month_leftafr
save "$tempdata/noa_month", replace

use "$tempdata/tempY", clear
sort yeardep
merge yeardep using "$tempdata/noa"
drop if _merge==2
drop _merge

sort yearaf month_leftafr
merge yearaf month_leftafr using "$tempdata/noa_month"
drop if _merge==2
drop _merge


/**************************
* Create manual fixed effects
* for nonlinear work
**************************/

tabulate region, gen(rem)

/**************************
* Create indicators for outlier values
**************************/

sum crowd_mod, det
gen outlier_cr=cond(crowd_mod==.,.,0)
replace outlier_cr=1 if crowd_mod<`r(p1)'
replace outlier_cr=1 if crowd_mod>`r(p99)' & crowd_mod!=.

sum tonmod, det
gen outlier_ton=cond(tonmod==.,.,0)
replace outlier_ton=1 if tonmod<`r(p1)'
replace outlier_ton=1 if tonmod>`r(p99)' & tonmod!=.


/**************************
* Clean up outreg labels
**************************/

la var voyage "VOYTIME"
la var company "COMPANY"
la var com_t "COMPANY*TREND"
la var t "TREND"
la var sta1807 "STA1807"
la var tonmod "TONNAGE"
la var crowd_mod "CROWD"



/**************************
* Save data
**************************/

compress
save "$data/extravars", replace					/* main data set */
log close
