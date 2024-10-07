**calcul de profits**
**run Klaas algo**
**recopier algo en l'adaptant à dataframe python**
cd "C:\Users\Hannah\Documents"

import delimited using df_total.csv, encoding(utf8)
save df_total.dta,


capture tostring meansofpaymentreturn, replace
capture tostring dateoftransaction, replace
capture replace value=subinstr(value, ",", ".",.)
capture destring value, force replace
capture destring estimate, replace
save "C:\Users\Hannah\Documents\df_total.dta", replace 

import delimited using df_total.dta, encoding(utf8)
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

**pb: klass a renommé les variables, avant de faire son merge. recopier suite merge en faisant attention à ces noms de variables. sinon, algo marche pour l'instant**