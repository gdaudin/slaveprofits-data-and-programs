
if lower(c(username)) == "guillaumedaudin" {
	global dir "~/Répertoires GIT/slaveprofits"
	cd "$dir"
	global output "~/Répertoires GIT/slaveprofits/output/"
	global graphs "$dir/graphs"
}

else if lower(c(username)) == "xronkl" {
	global dir "S:\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\GIT\slaveprofits"
	cd "$dir"
	global output "$dir\output\"
	global graphs "$dir\graphs\"
}
clear

do "$dir/do files/irrGD.do"

capture program drop IRR_computation
program define IRR_computation
args OR VSDO VSDR VSDT VSRV VSRT INV INT

use "${output}Database for IRR computation_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'.dta", clear


sort ventureid line_number
/*
For the English ones, here is Klas’s opinion : 
I found the time to check now. There are no ships for which
we have full info for all transactions and full info on
 date of these transactions. There are, however, 
 five English obs where we have dates for all transactions
 known from the sources, but not for our hypothetical values.
 Potentially these could be use for IRR calcs,
 if you make assumptions that the dating of hypothetical
 transactions occurred around same time as known transactions?
 The five are:
DR001, DR006, DR009, DR010, DR053,
*/

local possibleventures "GD002 GD003 GD013 GD014 GD015 GD015 GD016 GD017 GD018"
local possibleventures "`possibleventures' GD019 GD020 GD021 GD022 GD023 GD024 GD025 GD026 GD027"
local possibleventures "`possibleventures' GD028 GD029 GD033 GD034 GD035 GD036 GD037 GD038 GD039"
local possibleventures "`possibleventures' GD040 GD041 GD042 GD043 GD044 GD045 GD046 GD052 GD155"
local possibleventures "`possibleventures' GD156 GD157 GD158 GD159 GD160"
local possibleventures "`possibleventures' DR001 DR006 DR009 DR010 DR053"
**GD013 not possible because of no link with TSTD
drop if voyageidintstd==""
**GD014 is only 1 voyage in TSTD
drop if ventureid=="GD014"
**GD020 has only 3 out 4 voyages in TSTD
drop if ventureid=="GD020"
**GD021 the last voyage does not have a departure date in TSTD
drop if ventureid=="GD021"
**GD025 mis-identified in TSTD
drop if ventureid=="GD025"
**GD026 missing a voyage in TSTD
drop if ventureid=="GD026"
**GD028 missing a voyage in TSTD
drop if ventureid=="GD028"
**GD029 missing a voyage in TSTD
drop if ventureid=="GD029"
**GD036 missing a voyage in TSTD
drop if ventureid=="GD036"
**GD038 No departure date in TSTD
drop if ventureid=="GD038"
**GD045 No departure date in TSTD
drop if ventureid=="GD045"
**GD155 Missing departure dates in TSTD
drop if ventureid=="GD155"


keep if strpos("`possibleventures'",ventureid)!=0

keep if completedataonoutlays=="yes" | completedataonoutlays=="with estimates" 
keep if completedataonreturns=="yes" | completedataonreturns=="with estimates" 

*They all have departure dates (DATEDEP) except GD042 which is many ships and DR001
*I go and take it from TSDT database, one of the three ships for GD042.
*They have three departure dates. I take the earliest one 
replace DATEDEP = -5.581e+12 if ventureid=="GD042"


**Date treatement
*This transforms the date_time (e_tc) format into a date format (e_d)
replace DATEDEP=dofc(DATEDEP)
replace DATEEND=dofc(DATEEND)
foreach rank of numlist 1(1)7 {
	foreach var of varlist DATEEND DATEDEP {
	replace `var'`rank'=dofc(`var'`rank')
	}
}


format dateoftransaction DATEDEP* DATEEND* %d


*January 1st dates are dates we know only the year of. They will not do : I drop them.
replace dateoftransaction=. if (datepart(dateoftransaction,"m")==1 & datepart(dateoftransaction,"d")==1)

**Because of the limitations of the irr function, we need to aggregate "After outfitting" and "Outfitting"
**This assumes the investment is one month before the departure if missing
replace dateoftransaction=DATEDEP-35 if timing=="Outfitting" & dateoftransaction==. & transaction_year==datepart(DATEDEP,"y")
replace dateoftransaction=DATEDEP if  timing=="After outfitting" & dateoftransaction==. & transaction_year==datepart(DATEDEP,"y")

**This assumes that no slave ventures has two departures on the same year
foreach rank of numlist 1(1)7 {
	foreach var of varlist DATEDEP {
        replace dateoftransaction=DATEDEP`rank'-35 if timing=="Outfitting" & dateoftransaction==. & transaction_year==datepart(DATEDEP`rank',"y")
        replace dateoftransaction=DATEDEP`rank' if  timing=="After outfitting" & dateoftransaction==. & transaction_year==datepart(DATEDEP`rank',"y")       
	}
}




*We assume the ship is sold 90 days after coming back
replace dateoftransaction=DATEEND+90 if specification=="Ship In" & dateoftransaction==.

*We assume insurance (British) is bought right at the begining. Idem for the ship
egen date_min = min(dateoftransaction), by(ventureid)
replace dateoftransaction=date_min if (specification=="Insurance"| specification=="Ship Out") & dateoftransaction==.

 


*Calcul du temps relatif en mois
egen dateoffirsttransaction=min(dateoftransaction), by(ventureid)
generate relative_timing = datediff(dateoffirsttransaction, dateoftransaction, "m")

replace value = - value if typeofcashflow=="Expenditure"

sort ventureid relative_ti

**I use Relative_flow to ease the algorithm (I think...)
gen Return = value if timing=="Return"
egen total_Return = total(Return), by (ventureid)
gen Relative_flow = value/total_Return
drop Return
drop total_Return

**Profit computation
gen Investment = -Relative_flow if Relative_flow<0
egen Total_Investment=total(Investment), by(ventureid)
gen Return = Relative_flow if Relative_flow >0
egen Total_Return=total(Return), by(ventureid)
gen profit = Total_Return/Total_Investment -1
drop Total* Investment* Return*


save "${output}temp.dta", replace
keep ventureid profit nationality
bys ventureid: keep if _n==1
save "${output}temp_profit.dta", replace

use "${output}temp.dta", clear
erase "${output}temp.dta"

collapse(sum) Relative_flow, by(ventureid relative_timing)




save "${output}Data_for_IRR_computation_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'.dta", replace

***IRR computation
gen new=0
encode(ventureid), gen(ventureid_num)
xtset ventureid_num  relative_timing
tsfill, full
replace Relative_flow=0 if new
drop new
drop ventureid
decode(ventureid_num), gen(ventureid)
drop   ventureid_num
levelsof ventureid, local(ventureid_list)

reshape wide Relative_flow, i(relative_timing) j(ventureid) string

gen ventureid = ""
gen irr =.



local j = 1
foreach i of local ventureid_list {
	display "`i'"
	capture irrGD(Relative_flow`i')
	replace ventureid = "`i'" if _n==`j'
	capture replace irr = (1+r(irr))^12-1 if _n==`j'
	local j = `j' + 1
}

keep ventureid irr
drop if ventureid ==""
merge 1:1 ventureid using "${output}temp_profit.dta"
assert _merge==3
drop _merge
erase "${output}temp_profit.dta"

save "${output}irr_results_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'.dta", replace

gen sample=substr(ventureid,1,2)


twoway (scatter irr profit if nationality=="French", msymbol(plus)) ///
		(scatter irr profit  if nationality=="English", msymbol(X)) ///
		(qfitci irr profit, color(%25) ), ///
		legend(label(1 "French") label(2 "English") label(3 "Quadratic fit")) scheme(s1color) ytitle("irr")
graph export "$graphs/scatter_irr_profit_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.png",as(png) replace
		

gen sq_profit = profit^2

reg irr profit if sample=="GD"
reg irr profit if sample=="DR"
reg irr profit

reg irr profit if sample=="GD" , noconstant
reg irr profit if sample=="DR", noconstant
reg irr profit, noconstant

reg irr profit sq_profit if sample=="GD"
reg irr profit sq_profit if sample=="DR"
reg irr profit sq_profit



bysort sample: summarize irr profit

display "mean:" _b[_cons]+_b[profit]*0.116+_b[sq_profit]*(0.116)^2
display "median:" _b[_cons]+_b[profit]*0.087+_b[sq_profit]*(0.087)^2

end


*IRR_computation 0.5 1 1 0 1 0 1 0
*For this exercice, we have to assume that the credits that are still outstanding are never paid back, as doing otherwise would front-load
* the timing of returns.

IRR_computation 0 1 1 0 1 0 1 0
use "${output}Ventures&profit_OR0.5_VSDO1_VSDR1_VSDT0_VSRV1_VSRT0_INV1_INT0.dta", clear
gen irr = _b[_cons]+_b[profit]*profit+_b[sq_profit]*profit^2



