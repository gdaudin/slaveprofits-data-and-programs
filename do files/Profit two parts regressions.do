
clear
*ssc install estout, replace
*ssc install outreg2, replace


if lower(c(username)) == "guillaumedaudin" {
	global dir "~/Répertoires GIT/slaveprofits"
	cd "$dir"
	global output "~/Répertoires GIT/slaveprofits/output/"
	global tastdb "$dir/script guillaume-claire-judith/"
	global slaves "$dir/script guillaume-claire-judith/slaves/"
	global graphs "$dir/graphs"
}

 if lower(c(username)) == "xronkl" {
	global dir "S:\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\GIT\slaveprofits"
	cd "$dir"
	global output "$dir\output\"
	global tastdb "$dir\external data\"
	global slaves "$dir\do files\script guillaume-claire-judith\slaves\"
	global graphs "$dir\graphs"
}


capture program drop profit_regv2
program define profit_regv2
args OR VSDO VSDR VSDT VSRV VSRT INV INT IMP
*eg profit_analysis 0.5 1 1 0 1 0 1 0 for the baseline
* eg profit_analysis 0.5 1 1 0 1 0 1 0 IMP for the baseline + imputed



use "${output}Ventures&profit_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.dta", clear

*keep if completedataonoutlays=="yes" & completedataonreturns=="yes"
drop if completedataonoutlays=="no" & completedataonreturns=="no"
drop if profit ==.

collect clear

global explaining "nationality_num period war neutral big_port ln_totalnetexp_silver_ship pricemarkup MAJMAJBYIMP_num TONMOD crowd OUTFITTER_experience_d captain_experience_d OUTFITTER_total_career captain_total_career OUTFITTER_regional_experience_d captain_regional_experience_d"
global proxy "investment_per_slave ln_SLAXIMP  MORTALITY ln_length_in_days FATEcol"
estpost summarize profit $explaining $proxy
esttab using "$output/tablesv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.csv", cells("count mean median sd min max") replace csv
*These descriptive statistic tables are superceded by the one computed by nationality in do "Descriptive statistics of explaining variables.do"

global explaining "nationality_num war neutral period"
global explaining =subinstr("$explaining","nationality_num","ib3.nationality_num",.)
global explaining =subinstr("$explaining","period","ib2.period",.)
reg profit $explaining, vce(robust)
outreg2 using "$output/regv2exp_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) replace 

global explaining "$explaining MAJMAJBYIMP_num big_port"
global explaining =subinstr("$explaining","MAJMAJBYIMP_num","i.MAJMAJBYIMP_num",.)
reg profit $explaining, vce(robust)
outreg2 using "$output/regv2exp_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2)

global explaining "$explaining ln_totalnetexp_silver_ship crowd OUTFITTER_experience_d captain_experience_d"
reg profit $explaining, vce(robust)
outreg2 using "$output/regv2exp_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2)

global explaining "nationality_num war neutral period"
global explaining =subinstr("$explaining","nationality_num","ib3.nationality_num",.)
global explaining =subinstr("$explaining","period","ib2.period",.)
global explaining "$explaining MAJMAJBYIMP_num big_port"
global explaining =subinstr("$explaining","MAJMAJBYIMP_num","i.MAJMAJBYIMP_num",.)
global explaining "$explaining TONMOD crowd OUTFITTER_experience_d captain_experience_d"
reg profit $explaining, vce(robust)
outreg2 using "$output/regv2exp_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2)

global explaining "$explaining ln_totalnetexp_silver_ship"
reg profit $explaining, vce(robust)
outreg2 using "$output/regv2exp_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2)

global explaining "$explaining OUTFITTER_total_career captain_total_career OUTFITTER_regional_experience_d captain_regional_experience_d "
reg profit $explaining, vce(robust)
outreg2 using "$output/regv2exp_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2)

test OUTFITTER_experience_d  OUTFITTER_regional_experience_d OUTFITTER_total_career
test captain_experience_d  captain_regional_experience_d captain_total_career
test war neutral
*test YEARAF yearsq

global proxy "ln_SLAXIMP MORTALITY investment_per_slave pricemarkup ln_length_in_days FATEcol"
global proxy =subinstr("$proxy","FATEcol","i.FATEcol",.)
reg profit $proxy, vce(robust) 
outreg2 using "$output/regv2prox_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) replace 


/*

* VARIOUS LIMITED REGRESSIONS; TESTING ONLY SPECIFIC VARIABLES
reg profit ib3.nationality_num 


reg profit ib3.nationality_num YEARAF
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

reg profit ib3.nationality_num YEARAF yearsq
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

reg profit ib3.nationality_num ib2.period
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

reg profit ib3.nationality_num war neutral
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

reg profit ib3.nationality_num pricemarkup
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

reg profit ib3.nationality_num captain_experience_d
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

reg profit ib3.nationality_num captain_experience
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

reg profit ib3.nationality_num captain_total_career
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

reg profit ib3.nationality_num OUTFITTER_experience_d
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

reg profit ib3.nationality_num OUTFITTER_experience
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

reg profit ib3.nationality_num OUTFITTER_total_career
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

reg profit ib3.nationality_num ib2.perspective
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

*gen ln_SLAXIMP = ln(SLAXIMP)
reg profit ib3.nationality_num ln_SLAXIMP
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

*gen MORTALITY=(SLAXIMP-SLAMIMP)/SLAXIMP
*replace MORTALITY=VYMRTRAT if missing(MORTALITY)
reg profit ib3.nationality_num MORTALITY
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

*gen crowd=SLAXIMP/TONMOD
reg profit ib3.nationality_num crowd
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

*gen crowd=SLAXIMP/TONMOD
reg profit ib3.nationality_num crowd
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 


**For ponctual test

reg profit ib3.nationality_num crowd MORTALITY
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

****

*gen ln_totalnetexp_silver_ship = ln(totalnetexp_silver_ship)
reg profit ib3.nationality_num ln_totalnetexp_silver_ship
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

reg profit ib3.nationality_num investment_per_slavekg
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

reg profit ib3.nationality_num b3.MAJBYIMP
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 


*gen ln_numberofslavespurchased = ln(numberofslavespurchased)
*reg profit ib3.nationality_num ln_numberofslavespurchased
*outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

*gen mortality=(numberofslavespurchased-numberofslavessold)/numberofslavespurchased
*reg profit ib3.nationality_num mortality
*outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

*gen ln_mortality=ln(numberofslavespurchased-numberofslavessold)/numberofslavespurchased
*reg profit ib3.nationality_num ln_mortality
*outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

*gen ln_TSLAVESP = ln(TSLAVESP)
*reg profit ib3.nationality_num ln_TSLAVESP
*outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

*gen ln_MORTALITY=ln(MORTALITY)
*reg profit ib3.nationality_num ln_MORTALITY
*outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

*gen ln_VYMRTRAT = ln(VYMRTRAT)
*reg profit ib3.nationality_num ln_VYMRTRAT
*reg profit ib3.nationality_num VYMRTRAT
*outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 



* MULTIVARIATE REGRESSIONS
reg profit ib3.nationality_num YEARAF war neutral
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

reg profit ib3.nationality_num YEARAF war neutral pricemarkup
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

reg profit ib3.nationality_num YEARAF war neutral pricemarkup OUTFITTER_experience
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

reg profit ib3.nationality_num YEARAF war neutral pricemarkup OUTFITTER_experience_d
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

reg profit ib3.nationality_num YEARAF war neutral pricemarkup OUTFITTER_experience captain_experience
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

reg profit ib3.nationality_num YEARAF war neutral pricemarkup OUTFITTER_experience_d captain_experience_d
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

reg profit ib3.nationality_num YEARAF war neutral pricemarkup OUTFITTER_experience_d captain_experience_d
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

reg profit ib3.nationality_num YEARAF war neutral pricemarkup investment_per_slavekg OUTFITTER_experience_d captain_experience_d ln_SLAXIMP
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

reg profit ib3.nationality_num YEARAF war neutral pricemarkup investment_per_slavekg OUTFITTER_experience_d captain_experience_d ln_SLAXIMP MORTALITY
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

reg profit ib3.nationality_num YEARAF war neutral pricemarkup investment_per_slavekg OUTFITTER_experience_d captain_experience_d ln_SLAXIMP MORTALITY crowd
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

reg profit ib3.nationality_num ib2.period war neutral pricemarkup investment_per_slavekg OUTFITTER_experience_d captain_experience_d ln_SLAXIMP MORTALITY crowd
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

reg profit ib3.nationality_num ib2.period war neutral pricemarkup investment_per_slavekg OUTFITTER_experience_d captain_experience_d TONMOD MORTALITY crowd
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

reg profit ib3.nationality_num ib2.period war neutral pricemarkup investment_per_slavekg OUTFITTER_experience_d captain_experience_d ln_totalnetexp_silver_ship MORTALITY crowd
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

reg profit ib3.nationality_num ib2.period war neutral pricemarkup investment_per_slavekg OUTFITTER_experience_d captain_experience_d ln_totalnetexp_silver_ship MORTALITY crowd
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

reg profit ib3.nationality_num ib2.period war neutral pricemarkup investment_per_slavekg OUTFITTER_experience_d captain_experience_d TONMOD ln_SLAXIMP MORTALITY ln_totalnetexp_silver_ship crowd
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 



reg profit ib3.nationality_num ib2.period war neutral OUTFITTER_experience_d captain_experience_d TONMOD ln_totalnetexp_silver_ship totalnetexpperton
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2)




reg profit ib3.nationality_num ib2.period war neutral pricemarkup investment_per_slavekg OUTFITTER_experience_d captain_experience_d ln_totalnetexp_silver_ship MORTALITY crowd, hc3
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 

reg profit ib3.nationality_num ib2.period war neutral pricemarkup investment_per_slavekg OUTFITTER_experience_d captain_experience_d  MORTALITY crowd ln_totalnetexp_silver_ship
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 
if "`hyp'"=="Baseline" outreg2 using "$output/Table6.xls", excel auto(2) label
if "`hyp'"=="Baseline" | "`hyp'"=="Imputed" | "`hyp'"=="Only imputed" outreg2 using "$output/TableBaseline-Imputed.xls", excel auto(2) label


reg profit ib3.nationality_num ib2.period war neutral pricemarkup OUTFITTER_experience_d captain_experience_d  MORTALITY crowd ln_totalnetexp_silver_ship
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 
if "`hyp'"=="Baseline" outreg2 using "$output/Table6.xls", excel auto(2) label


reg profit ib3.nationality_num ib2.period war neutral pricemarkup investment_per_slavekg OUTFITTER_experience_d captain_experience_d  MORTALITY crowd ln_SLAXIMP
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 
if "`hyp'"=="Baseline" outreg2 using "$output/Table6.xls", excel auto(2) label

reg profit ib3.nationality_num ib2.period war neutral pricemarkup investment_per_slavekg OUTFITTER_experience_d captain_experience_d  MORTALITY crowd TONMOD
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 
if "`hyp'"=="Baseline" outreg2 using "$output/Table6.xls", excel auto(2) label



reg profit ib3.nationality_num ib2.period war neutral pricemarkup investment_per_slavekg OUTFITTER_experience_d captain_experience_d  MORTALITY crowd ln_totalnetexp_silver_ship if profit<2
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 
if "`hyp'"=="Baseline" outreg2 using "$output/Table6.xls", excel auto(2) label


reg profit ib3.nationality_num ib2.period war neutral pricemarkup investment_per_slavekg OUTFITTER_experience_d captain_experience_d  MORTALITY crowd ln_totalnetexp_silver_ship, vce(robust)
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 
if "`hyp'"=="Baseline" outreg2 using "$output/Table6.xls", excel auto(2) label

reg profit ib3.nationality_num ib2.period war neutral ln_totalnetexp_silver_ship
outreg2 using "$output/regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.xls", label excel auto(2) 
if "`hyp'"=="Baseline" outreg2 using "$output/Table6.xls", excel auto(2) label




reg profit ib3.nationality_num ib2.period war neutral pricemarkup investment_per_slavekg OUTFITTER_experience_d captain_experience_d  MORTALITY crowd ln_totalnetexp_silver_ship
if "`hyp'"!="Imputed" & "`hyp'"!="Only imputed" /// 
	outreg2 using "$output/Comparison between different assumptions.xls", label excel auto(2) 


cd "$output"
capture erase "regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.csv"
_renamefile "regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.txt" ///
		"regv2_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.csv"


/*

* DECISION WHICH OBSERVATIONS TO INCLUDE IN THE ANALYSIS
* NB: CURRENTLY, I INCLUDE OBSERVATIONS THAT HAVE COMPLETE INFORMATION ON BOTH EXPENDITURES AND RETURNS, AND OBSERVATIONS WHERE THESE ARE COMPLETE BASED ON IMPUTED ESTIMATES. THIS CAN BE CHANGED IN ROBUSTNESS-TESTS
* PROFIT-OBSERVATIONS ARE DROPPED FOR ALL OBS THAT DO NOT MEET THESE CRITERIA

gen keep=1 if completedataonoutlays=="yes" & completedataonreturns=="yes"
replace keep=1 if completedataonoutlays=="with estimates" & completedataonreturns=="yes"
replace keep=1 if completedataonoutlays=="yes" & completedataonreturns=="with estimates"
replace keep=1 if completedataonoutlays=="with estimates" & completedataonreturns=="with estimates"
replace profit=. if keep!=1


* ESTIMATE TOTAL EXPENDITURES BY NATIONALITY OF THE VENTURES, FOR OBS WITH COMPLETE DATA, SO AS TO BE ABLE TO ANALYZE THE SHARE OF EXPENDITURES FOR DIFFERENT PURPOSES

bysort nationality: egen nattotexp=total(value) if typeofcashflow=="Expenditure" & completedataonoutlays=="yes"
bysort nationality specification: egen nattotexpspec=total(value) if typeofcashflow=="Expenditure" & completedataonoutlays=="yes"
bysort nationality specification: gen seq2=_n if completedataonoutlays=="yes"
replace nattotexp=. if seq2>1 & completedataonoutlays=="yes"
replace nattotexpspec=. if seq2>1 & completedataonoutlays=="yes"
gen shareexp= nattotexpspec/nattotexp
bysort nationality: tabstat shareexp, by(specification), if typeofcashflow=="Expenditure"

* ESTIMATE PROFITABILITY BY NATIONALITY WEIGHTED BY SIZE OF INVESTMENTS IN A CORRESPONDING WAY TO WHEN CALCULATED BY VENTURE
bysort nationality: egen totalgrossexp2=total(expenditure)
bysort nationality: egen totaldisc2=total(discount)
bysort nationality: egen totalgrossreturn2=total(return)
bysort nationality: egen totalcostonreturn2=total(costonreturn)

gen totalnetexp2=totalgrossexp2-totaldisc2
gen totalnetreturn2=totalgrossreturn2-totalcostonreturn2
gen profit_nat= totalnetreturn2/totalnetexp2-1
bysort nationality: gen seqnation=_n
replace profit_nat=. if seqnation>1


* ESTIMATE TOTAL RETURN BY NATIONALITY OF THE VENTURES, FOR OBS WITH COMPLETE DATA, SO AS TO BE ABLE TO ANALYZE THE SHARE OF RETURNS FROM DIFFERENT SOURCES

bysort nationality: egen nattotreturn=total(value) if typeofcashflow=="Return" & completedataonreturn=="yes"
bysort nationality specification: egen nattotreturnspec=total(value) if typeofcashflow=="Return" & completedataonreturn=="yes"
bysort nationality specification: gen seq3=_n if completedataonreturn=="yes"
replace nattotreturn=. if seq3>1 & completedataonreturn=="yes"
replace nattotreturnspec=. if seq2>1 & completedataonreturn=="yes"
gen sharereturn= nattotreturnspec/nattotreturn
bysort nationality: tabstat sharereturn, by(specification), if typeofcashflow=="Return"

* ENCODE NATIONALITY AND PERSPECTIVE OF SOURCE, SO AS TO BE ABLE TO USE THESE VARS IN REGRESSIONS

encode nationality, generate(nation)
encode perspectiveofsource , generate(perspec)


* TABULATE PROFIT BY NATIONALITY OF VENTURE, YEAR TRADING IN AFRICA, AND BY MAJOR AREA OF SLAVE PURCHASES

tabstat profit profit_nat, by(nationality) stat (mean n sd min max) missing
*tabstat profit, by(YEARAF) stat (mean n sd min max) missing
*tabstat profit, by(MAJBYIMP) stat (mean n sd min max) missing

* TABULATE PROFITS BY VENTURE, SO AS TO BE ABLE TO COMPARE TO PREVIOUS RESEARCH, AND SEARCH FOR POTENTIAL ERRORS

tabstat profit profitsreportedinsource , by(ventureid)


* SCATTERPLOT PROFIT OVER TIME, INCLUDING REGRESSION LINE

*twoway (scatter profit YEARAF) (lfit profit YEARAF)

* REGRESS PROFIT ON A NUMBER OF DIFFERENT VARS IN OUR DATASET AND IN THE TSTD

*reg profit b3.nation b3.perspec SLAXIMP VYMRTRAT, robust hc3
*reg profit b3.nation b3.perspec SLAXIMP VYMRTRAT markup, robust hc3
*reg profit b3.nation b3.perspec SLAXIMP VYMRTIMP, robust hc3
*reg profit b3.nation b3.perspec YEARAF, robust hc3
*reg profit b3.nation b3.perspec b3.MAJBYIMP, robust hc3



save "${output}\Total database.dta", replace

*/
*/
end

capture erase "$output/Table6.xls"
capture erase "$output/Table6.txt"
capture erase "$output/Comparison between different assumptions.xls"
capture erase "$output/Comparison between different assumptions.txt"
capture erase "$output/TableBaseline-Imputed.xls"
capture erase "$output/TableBaseline-Imputed.txt"


profit_regv2 0.5 1 1 0 1 0 1 0

capture erase "Comparison between different assumptions.csv"
capture _renamefile "Comparison between different assumptions.txt" "Comparison between different assumptions.csv"

