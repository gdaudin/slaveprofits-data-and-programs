clear

use "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\Cash flow all.dta"

* STANDARDIZE THE LABELS USED IN CASH FLOW-DATABASE

replace timing="Return" if timing=="After outfitting" & typeofcashflow=="Return"
replace timing="Outfitting" if timing=="After Outfitting"
replace timing="Outfitting" if timing=="after outfitting"
replace timing="Outfitting" if timing=="After outfitting"
replace timing="Return" if timing=="return"

* ASSUMPTION ABOUT THE TIMING OF INSURANCE PAYMENTS FOR OBS WHERE EXACT TIMING IS UNKNONWN, I.E. THEY ARE NOW ASSUMED TO HAVE BEEN PAID ONLY AFTER THE VOYAGE

replace timing="Return" if timing=="Unknown" & specification=="Insurance"
replace timing="Return" if timing=="Unknown" & specification=="Assurances"
replace timing="Return" if timing=="Unknown" & specification=="Insurance (Assurances)"

* FILL IN INFORMATION ON TWO DUMMY VARS, ASSUMING BOTH OF THESE TO TAKE THE VALUE OF ZERO, IF MISSING.

replace intermediarytradingoperation=0 if missing(intermediarytradingoperation)
replace estimate=0 if missing(estimate)


* MERGE CASH FLOW AND VENTURE-DATABASES INTO ONE

merge m:1 ventureid using "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\Venture all.dta"
save "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\Total database.dta", replace

drop _merge


* GENERATE FOUR VARIABLES - EXPENDITURE, DISCOUTN, RETURN AND COSTONRETURN - BASED ON THE TYPE AND TIMING OF TRANSACTION

gen expenditure=value if typeofcashflow=="Expenditure" & timing=="Outfitting" & intermediarytradingoperation==0
replace expenditure=0 if missing(expenditure)
gen discount=value if typeofcashflow=="Return" & timing=="Outfitting" & intermediarytradingoperation==0
replace discount=0 if missing(discount)
gen return=value if typeofcashflow=="Return" & timing=="Return" & intermediarytradingoperation==0
replace return=0 if missing(return)
gen costonreturn=value if typeofcashflow=="Expenditure" & timing=="Return" & intermediarytradingoperation==0
replace costonreturn=0 if missing(costonreturn)

* SUM UP ALL THESE FOUR VARIABLES BY VENTURE

bysort ventureid: egen totalgrossexp=total(expenditure)
bysort ventureid: egen totaldisc=total(discount)
bysort ventureid: egen totalgrossreturn=total(return)
bysort ventureid: egen totalcostonreturn=total(costonreturn)

* DEAL WITH DANISH BARGUM TRADING SOCIETY WHERE SOME RETURNS ARE REPORTED COLLECTIVELY FOR SEVERAL VENTURES
bysort nameoftheownerortheoutfitter: egen totalgrossexp2=total(expenditure)
bysort nameoftheownerortheoutfitter: egen totaldisc2=total(discount)
bysort nameoftheownerortheoutfitter: egen totalgrossreturn2=total(return)
bysort nameoftheownerortheoutfitter: egen totalcostonreturn2=total(costonreturn)

replace totalgrossexp2=. if ventureid!="KR016"
replace totaldisc2=. if ventureid!="KR016"
replace totalgrossreturn2=. if ventureid!="KR016"
replace totalcostonreturn2=. if ventureid!="KR016"

replace totalgrossexp=totalgrossexp2 if ventureid=="KR016"
replace totaldisc=totaldisc2 if ventureid=="KR016"
replace totalgrossreturn=totalgrossreturn2 if ventureid=="KR016"
replace totalcostonreturn=totalcostonreturn2 if ventureid=="KR016"

replace completedataonoutlays="with estimates" if ventureid=="KR016"
replace completedataonreturns="with estimates" if ventureid=="KR016"

drop totalgrossexp2 totaldisc2 totalgrossreturn2 totalcostonreturn2

* GENERATE ESTIMATES FOR TOTAL NET EXPENDITURE, TOTALNETRETURN AND PROFIT (AS THEY ARE SUMMED BY VENTURE, THESE WILL ALSO BE BY VENTURE)
* NUMBER THE INDIVIDUAL OBSERVATIONS FOR EACH VENTURE, AND KEEP THE PROFIT ESTIMATES ONLY FOR ONE OBSERVATION PER VENTURE

gen totalnetexp=totalgrossexp-totaldisc
gen totalnetreturn=totalgrossreturn-totalcostonreturn
gen profit= totalnetreturn/ totalnetexp-1
bysort ventureid: gen seq=_n
replace profit=. if seq>1


save "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\Cash flow all.dta", replace

* STANDARDIZE THE SPELLING IN SOME VARIABLES

replace perspectiveofsource="Investor" if perspectiveofsource=="investor"
replace perspectiveofsource="Owner" if perspectiveofsource=="Owner?"
replace completedataonoutlays="no" if completedataonoutlays=="NO"
replace completedataonoutlays="no" if completedataonoutlays=="No "
replace completedataonoutlays="no" if completedataonoutlays=="no "
replace completedataonreturns="no" if completedataonreturns=="no "



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

* APPEND PRICE DATA FOR SLAVES
merge m:1 YEARAF using "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\Slave prices.dta"
drop _merge

save "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\Total database.dta", replace


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



save "C:\Users\xronkl\ShareFile\Personal Folders\Forskning - under arbete\Slave trade profits meta-study\STATA\Total database.dta", replace
