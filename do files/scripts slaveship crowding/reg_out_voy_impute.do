capture log close

log using "$output/reg_outcomes.log", replace


#delimit ;
use "$data/voy_mi", clear;
/*drop if region>60700;
drop if voy_middle==1 | voy_court==1 | voy_oth==1 | voy_pre==1;
should be done at imputation stage
*/

local dest "all";


/*************************
* Define macros ;
**************************/;


		/* outreg options for all outreg	*/;

local out2opts "append";					/* outreg optiosn for all outreg after first */;


la var voyage "VOYTIME";
la var yeardep "YEAR";

local name_na "North America";
local name_wi "West Indies & Guyana";
local name_bra "Brazil";
local name_all "All";

local first_all "replace";
local first_na "append";
local first_wi "append";
local first_bra "append";

/*************************
* Perform Imputed Estimation
**************************/;


	foreach drate_y in mrate_pct  {; //mrate_crew

if "`drate_y'"=="mrate_pct" {;
	local outfile_a "t_voy_impute";
	local outtitle "Table XXXX. Middle Passage Mortality using Imputed Voyage Duration";
	local outopts `"label ctitle("Mortality", "Rate (%)")
		 bracket"';	
	local out_tex "tex(frag)";
};

if "`drate_y'"=="mrate_crew" {;
	local outfile_a "t_voy_impute_crew";
	local outtitle "Table XXXX. Crew Mortality using Imputed Voyage Time";
	local outopts `"label ctitle("Crew" "Mortality", "Rate")
		bracket"';		
	local out_tex "tex(frag)";
};

	
mi estimate, post: reg `drate_y' crowd_mod voyage tonmod
	 i.year10 i.I_route , 
	robust;
outreg2 crowd_mod  voyage tonmod    
	using "$output/`outfile_a'_ofc.txt",
	`outopts' 
	`first_`dest''
	title(`outtitle')
	addtext(
		"Decade Fixed Effects", "√",
		"Route Fixed Effects", "√"
	) ;


mi estimate, post: reg `drate_y'  crowd_mod voyage tonmod  
	 i.year10 i.I_route  
	   i.rig_x,
	robust;
outreg2 crowd_mod  voyage tonmod    
	using "$output/`outfile_a'_ofc.txt",
	`outopts' 
	`out2opts'
	addtext(
		"Decade Fixed Effects", "√",
		"Route Fixed Effects", "√",
		`"Rig Fixed Effects "', "√"
	) ;
	
mi estimate, post: reg `drate_y'  crowd_mod voyage tonmod 
	 i.year10 i.I_route  
	  i.national_x,
	robust;
outreg2 crowd_mod  voyage tonmod    
	using "$output/`outfile_a'_ofc.txt",
	`outopts' 
	`out2opts'
	addtext(
		"Decade Fixed Effects", "√",
		"Route Fixed Effects", "√",
		`"Nation Fixed Effects "', "√"
	) ;
	
mi estimate, post: reg `drate_y' crowd_mod voyage tonmod 
	 i.year10 i.I_route  
	  i.rig_x  i.national_x,
	robust;
outreg2 crowd_mod  voyage tonmod    
	using "$output/`outfile_a'_ofc.txt",
	`outopts' 
	`out2opts'
	addtext(
		"Decade Fixed Effects", "√",
		"Route Fixed Effects", "√",
		`"Nation Fixed Effects "', "√",
		`"Rig Fixed Effects "', "√"
	) ;
	/*
mi estimate, post: reg `drate_y'  amo  tonmod crowd_mod voyage   i.I_route t,
	robust;
outreg2  amo tonmod crowd_mod voyage t
	using "$output/`outfile_a'_ofc.txt",
	`outopts' 
	`out2opts'
	addtext("Route Fixed Effects", "√",
		`"Rig Fixed Effects "', "√"
	) ;
	*/
	};		// end y variable loop
*};			// end destination loop


