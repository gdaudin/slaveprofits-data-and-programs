clear all
set mem 1g


****************************
* 
/*
use tastdb_exp_2008
keep voyageid *rice*

* WARNING WARNING WARNING
* This code can't be run as-is.It is necessary
* to delete the sterling symbol form price.txt before continuing.
* Ideally there should be a shell script at this step, but since this data
* doesn't look useful for now we're just doing it manually.

outsheet using price.txt, replace
*/

insheet using "$data/price.txt",clear	
sort voyageid
save "$tempdata/priceclean", replace


use "$data/tastdb_exp_2008",clear
drop *rice*
sort voyageid
merge voyageid using "$tempdata/priceclean"
assert _merge==3
drop _merge

la var price "sterling price of prime male slaves sold"

*STRING CLEANUP
* Some string variables have junk in lieu of missing values for strings
* Any important ones exhibiting this have to be cleaned.

local caplist ""
local ownlist ""
foreach let in a b c  {
	local caplist "captain`let' `caplist'"
}
*display "`caplist'"

foreach let in a b c d e f g h i j k l m n o p {
	local ownlist "owner`let' `ownlist'"
}

local varlist "`caplist' `ownlist'"

foreach var in `varlist' {
	replace `var'="" if `var'=="."
	replace `var'="" if `var'=="  ."
}

replace captainc="" if captainc=="20 + 1 tons redwood"

compress
save "$tempdata/tastdb_clean", replace

*****************
*  price data

insheet using "$data/slaprice.csv", comma clear
rename year yeardep
forval i=1/5{
	gen year_L`i'=yeardep-`i'
}
keep year* *price*
sort yeardep
save "$tempdata/slaprice_davies", replace


insheet using "$data/eltis slave price 10.csv", comma clear names
drop v30 v19
foreach var in shipid year slavenumb pricreg price termmth ratei priceadjcash rank gulperlsterl stdlperlsterl llivretournoisperlsterl lequivalent equiv frenchprice jamaicaprime primeslaveratio jamadj2 {
	destring `var', replace force
}
forval i=1/5{
	gen year_L`i'=year-`i'
}
la var price "pound sterling price"
rename price price_eltis
rename shipid voyageid
rename year year_eltis
rename shipname shipname_eltis
compress
sort voyageid
save "$tempdata/slaprice_eltis10", replace


insheet using "$data/pricegalenson.csv", comma clear names
rename year yeardep
rename index galenson_index
la var galenson_index "galenson sterling price"
rename index_m5 galenson_m5 
la var galenson_m5 "galenson sterling lagged 5 year average"
rename index_i galenson_i 
la var galenson_i "galenson sterling interpolated"
sort yeardep
save "$tempdata/slaprice_galenson", replace



insheet using "$data/daviessugar.csv", clear comma
rename year yeardep
tsset yeardep
sort yeardep
save "$tempdata/sugar_price", replace
