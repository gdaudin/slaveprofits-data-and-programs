/**********************
* Create summary stats table from outreg
**********************/

clear*
capture log close
use "$data/extravars", clear
drop if voy_middle==1 | voy_pre==1 | voy_court==1 | voy_oth==1
drop if region>60700

keep mrate_pct mrate_crew_pct tonmod crowd_mod voyage time_coast

log using "$output/sumlog.log", replace
sum *
sum *, det



*outreg2 using myfile,  sum(log) replace eqdrop(N  max min) see
*outreg2 using "$output/sumstats2.txt" if 1==1, sum(detail) replace eqkeep(N max min) see
*outreg2 using "$output/sumstats.txt", sum(detail) replace see

display "=== BREAK ===="
drop if crowd_mod==. | mrate_pct==.

sum *
sum *,det

log close
