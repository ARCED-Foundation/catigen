
clear all
set more off
set seed 3256545
set sortseed 3256545

*** Enumerator ID list
	gl enumlist = "1 2"

* Import sample list
	import excel using "sample list.xlsx", clear first
	
* Rename variables
	ren (idno phone name) (id_key resp_pn full_name)
	cap tostring id_key, replace
	
* Generate variables
	g enumid 				= ""
	g respondents_details 	= id_key + "|" + full_name + "|" + schoolname + "|0|-|-"
	g now_closed			= "No"

* Assign randomly
	g rand = runiform() if mi(enumid)
	sort rand
	egen enumsl=cut(rand) if mi(enumid), group(`=wordcount("${enumlist}")')
	recode enumsl (0=`=wordcount("${enumlist}")')
		
	forval user=1/`=wordcount("${enumlist}")' {
	    cap replace enumid = "`=word("${enumlist}", `user')'" if enumsl == `user'

	}
	drop enumsl
	
	export delim "respondents.csv", replace
