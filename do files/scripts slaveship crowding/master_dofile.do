clear all
set mem 1g
set more off

**********************
* Define macros
**********************

local root "/Users/nic/Projects/slave_trade_companies"

global do_files "`root'/do_files"
	global do_datawork "`root'/do_files/datawork"
	global do_reg "`root'/do_files/analysis"
	global do_charts "`root'/do_files/plots"

global data "`root'/data"
global tempdata "`root'/tempdata"

global output "`root'/output"
global plots "`root'/plots"
global temp "`root'/temp"


**********************
* do files
**********************

*do "$do_files/data_master.do"		/* Import and clean data;		*/
									/* create variables				*/


*do "$do_files/reg_master.do"		/* regressions and other 		*/
									/* numerical analysis			*/
