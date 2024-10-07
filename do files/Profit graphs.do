
clear
*ssc install estout, replace
*ssc install outreg2, replace

if lower(c(username)) == "kraemer" {
	!subst X: /d
	!subst X:   "C:\Users\Kraemer\Documents"
	capture cd "X:\slaveprofits\"
	if _rc != 0 cd  "C:\Users\Kraemer\Documents\slaveprofits"
	global output "C:\Users\Kraemer\Documents\slaveprofits\script guillaume-claire-judith\output"
	global tastdb "C:\Users\Kraemer\Documents\slaveprofits\script guillaume-claire-judith"
	global slaves "C:\Users\Kraemer\Documents\slaveprofits\script guillaume-claire-judith\slaves"

}

 if lower(c(username)) == "claire" {
	!subst X: /d
	!subst X:   "/Users/guillaume-claire-judith/"
	capture cd "X:/slaveprofits/"
	if _rc != 0 cd  "/Users/h-claire-judith/slaveprofits/"
	global output "/Users/guillaume-claire-judith/Desktop/temp"
	global tastdb "/Users/guillaume-claire-judith/slaveprofits/script guillaume-claire-judith/"
	global slaves "/Users/guillaume-claire-judith/slaveprofits/script guillaume-claire-judith/slaves/"

}

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


capture program drop profit_graphs
program define profit_graphs
args OR VSDO VSDR VSDT VSRV VSRT INV INT IMP
*eg profit_graphs 0.5 1 1 0 1 0 1 0 for the baseline
* eg profit_graphs 0.5 1 1 0 1 0 1 0 IMP for the baseline + imputed



use "${output}Ventures&profit_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.dta", clear

*keep if completedataonoutlays=="yes" & completedataonreturns=="yes"
drop if completedataonoutlays=="no" & completedataonreturns=="no"
drop if profit ==.

label var profit "(Net returns over net outlays) -1"


graph bar (count) profit, over(nationality) scheme(s1color)
graph export "$graphs/nbr_by_nationality_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.png", as(png) replace

hist YEARAF, freq scheme(s1color)
graph export "$graphs/hist_by_year_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.png",as(png) replace


quietly summarize profit
local m=r(mean)
hist profit, freq norm ///
	note(`"mean = `=string(`m',"%6.2f")'%"') ///
	scheme(s1color) name(All_nationalities, replace) title("All sample")

graph export "$graphs/hist_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.png",as(png) replace
 
quietly summarize profit
local max=r(max)
display "`max'"

local natlist "Danish Dutch English French Spanish"
if "`IMP'"=="onlyIMP" local natlist "Dutch English French"


foreach nat in `natlist' {
	quietly summarize profit if nationality =="`nat'"
	local m=r(mean)
	hist profit if nationality =="`nat'", width(0.15) freq norm ///
	note(`"mean = `=string(`m',"%6.2f")'%"') ///
	xscale(range(-1 `max')) xlabel(-1 (0.5) `max') ///
	scheme(s1color) title ("`nat'") name(`nat', replace)
}
graph combine `natlist' All_nationalities, scheme(s1color)
graph export "$graphs/hist_by_nationality_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.png",as(png) replace



twoway (scatter profit YEARAF if nationality=="French", msymbol(plus)) ///
		(scatter profit YEARAF if nationality=="English", msymbol(X)) ///
		(scatter profit YEARAF if nationality=="Dutch", msymbol(Oh)) ///
		(scatter profit YEARAF if nationality=="Danish", msymbol(dh)) ///
		(scatter profit YEARAF if nationality=="Spanish", msymbol(th)), ///
		legend(label(1 "French") label(2 "English") label(3 "Dutch") ///
		label(4 "Danish") label(5 "Spanish")) scheme(s1color)
graph export "$graphs/scatter_year_profit_OR`OR'_VSDO`VSDO'_VSDR`VSDR'_VSDT`VSDT'_VSRV`VSRV'_VSRT`VSRT'_INV`INV'_INT`INT'`IMP'.png",as(png) replace
		
end

profit_graphs 0.5 1 1 0 1 0 1 0
profit_graphs 0.5 1 1 0 1 0 1 0 IMP
profit_graphs 0.5 1 1 0 1 0 1 0 onlyIMP	
