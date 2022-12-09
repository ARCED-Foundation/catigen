*! version 1.0.1 SoTLab, ARCED Foundation 14jun2022
cap pr drop catigen
 
program catigen, rclass
	vers 15.0
	
	syntax using, Saving(str) ATTACHment(str)
		
	
	**# download CATI template
		/*
				copy "https://github.com/ARCED-Foundation/catigen/raw/master/templates/ARCED_Advanced%20CATI%20starter%20kit%20sample%20form%20(non-case%20management).xlsx" ///
						`"`saving'"', replace
		*/
		
		copy "https://github.com/ARCED-Foundation/catigen/raw/master/templates/Advanced%20CATI%20starter%20kit%20sample%20form%20(non-case%20management).xlsx" ///
						`"`saving'"', replace
		
		
		cap mkdir "`attachment'"
		if !_rc di as result `"Attachment folder not found, now created a new folder:{browse "`attachment'": `attachment'}"', _n
		
		loc filelist = "phone-call.fieldplugin.zip  launch-sms.fieldplugin.zip table-list.fieldplugin.zip respondents_advanced.xml template_user_assignment.do"
		
		foreach file of loc filelist {
			noi di as result "downloading `file'"
			qui copy "https://github.com/ARCED-Foundation/catigen/raw/master/templates/`file'" ///
				"`attachment'/`file'", replace
		}
			
		noi di as result "Downloads completed.", _n
		
	qui {
		
		**# setup workspace
			tempfile olddata
			save `olddata', replace emptyok
	
		**# Work on settings sheet
			import excel `using', sheet(settings) clear first
			drop if _n>1
			
			levelsof form_id, clean loc(formid) 
			replace version = `"=TEXT(YEAR(NOW())-2000, "00") & TEXT(MONTH(NOW()), "00") & TEXT(DAY(NOW()), "00") & TEXT(HOUR(NOW()), "00") & TEXT(MINUTE(NOW()), "00")"' in 1
			replace instance_name = "concat('Status: ', $" + "{call_status_label}, 'ID: ', $" + "{id})" in 1
		
			set obs 2
			foreach var of varlist form_title form_id version public_key submission_url default_language instance_name {
				cap confirm var `var'
				if _rc g `var' = ""
				
				tostring `var', replace
				replace `var' = "" if `var' == "."
				replace `var' = `var'[1] in 2
				replace `var' = "`var'"  in 1
			}
			

			export excel form_title form_id version public_key submission_url default_language instance_name ///
						 using `"`saving'"', keepcellfmt sheet(settings) sheetmodify	
						 
			putexcel set `"`saving'"', sheet(settings) modify
			putexcel C2 = formula(TEXT(YEAR(NOW())-2000, "00") & TEXT(MONTH(NOW()), "00") & TEXT(DAY(NOW()), "00") & TEXT(HOUR(NOW()), "00") & TEXT(MINUTE(NOW()), "00"))
			putexcel clear
			
			
		**# Work on Choices sheet
			import excel `using', sheet(choices) clear first all
			
			* Find all labels 
				unab capilabels: label*
				loc capicount `=wordcount("`capilabels'")'
			
				loc x = 1
				foreach var of local capilabels {
						loc lang`x' = "`var'"
						loc ++x
				}				
			
			tempfile capi_choice 
			save `capi_choice'

			import excel using `"`saving'"', sheet(choices) clear first all

			* rename all labels to make them uniform			
				unab catilabels: label* 
				foreach var of local catilabels {
					forval x = 1/`capicount' {
						if regex(lower("`var'"), lower("`lang`x''")) {
							ren `var' `lang`x''
						}					
					}						
				}
		
			merge m:m list_name value using `capi_choice', nogen
			drop if mi(list_name)
			
			foreach var of varlist _all {
				capture assert mi(`var')
				if !_rc {
					drop `var'
				}
			}
			
			set obs `=_N+1'
			
			foreach var of varlist _all {
				tostring `var', replace
				replace `var' = "`var'" in `=_N'
			}
			
			g sl = _N - _n
			replace sl = 999999 if value=="value"
			gsort -sl
			drop sl
			
			unab labels: label* 
			foreach var of local labels {
				if `var' != "label" replace `var' = regexr(`var', "label", "label::") in 1
			}
			
			export excel using `"`saving'"', keepcellfmt sheet(choices) sheetmodify
			
			
		**# Work on survey sheet
			import excel `using', sheet(survey) clear first all
			
			* Drop empty variables, however, not the necessary columns for SurveyCTO
				foreach var of varlist _all {
					capture assert mi(`var')
					if !_rc & length("`var'")<=2 {
						drop `var'
					}
				}
			
			* Find all labels 
				unab capilabels: label*
				loc capicount `=wordcount("`capilabels'")'
			
				loc x = 1
				foreach var of local capilabels {
						loc lang`x' = "`var'"
						loc ++x
				}	
				
			* Find all hints 
				unab capihintvars: hint*
				loc capihintcount `=wordcount("`capihintvars'")'
			
				loc x = 1
				foreach var of local capihintvars {
						loc hint`x' = "`var'"
						loc ++x
				}
				
				* Find all constraintmessage 
				unab capiconsmessvars: constraintmessage*
				loc capiconsmesscount `=wordcount("`capiconsmessvars'")'
			
				loc x = 1
				foreach var of local capiconsmessvars {
						loc constraintmessage`x' = "`var'"
						loc ++x
				}
				
				* Find all mediaimage
				unab capimimagevars: mediaimage*
				loc capmimagecount `=wordcount("`capimimagevars'")'
			
				loc x = 1
				foreach var of local capimimagevars {
						loc capimimagevars`x' = "`var'"
						loc ++x
				}
				
			
			
			gen capisl = _n // Generate a serial so that the question order does not change mistakenly
			
			* Drop the missing rows at the end
				egen miss = rownonmiss(_all), strok		 
				forval x = `=_N'(-1)1 {
					drop if miss[_n-1]==1 & miss[_n-2]==1 & miss[_n-3]==1 & miss[_n-4]==1 & miss[_n-5]==1
				}
	
			
			tempfile capi_survey 
			save `capi_survey'

			import excel using `"`saving'"', sheet(survey) clear first all
			
			* Drop empty variables, however, not the necessary columns for SurveyCTO
				foreach var of varlist _all {
					capture assert mi(`var')
					if !_rc & length("`var'")<=2 {
						drop `var'
					}
				}

			* rename all '===labels===' to make them uniform			
				unab catilabels: label* 
				foreach var of local catilabels {
					forval x = 1/`capicount' {
						if regex(lower("`var'"), lower("`lang`x''")) {
							ren `var' `lang`x''
						}
					}						
				}
			/*
				Do the above for hint constraintmessage mediaimage mediaaudio mediavideo
				
			*/
			* rename all '===hints===' to make them uniform			
				unab catihintvars: hint* 
				foreach var of local catihintvars {
					forval x = 1/`capihintcount' {
						if regex(lower("`var'"), lower("`hint`x''")) {
							ren `var' `hint`x''
						}
					}						
				}
			

				* rename all '===constraintmessage===' to make them uniform			
					unab caticonsmsvars: constraintmessage* 
					
					if `capiconsmesscount'==1 {
						cap g `capiconsmessvars' = constraintmessageenglish

						foreach var of local caticonsmsvars {
							if "`var'" != "`capiconsmessvars'"	drop `var'					
						}
					}
					

					else {
						foreach var of local caticonsmsvars {
							forval x = 1/`capiconsmesscount' {
								if regex(lower("`var'"), lower("`consms`x''")) & !mi("`consms`x''") {
									ren `var' `consms`x''
								}
							}						
						}
					}

					order `capiconsmessvars', after(constraint)
				
				
				
				* drop all '===mediaimage===' to make them uniform			
					drop mediaimage* 
				
				
			
				
			* Separate the first and last part of CATI
				gen catisl = _n 
				g drop =  _n if name[_n-1]=="have_availability" 
				replace drop = drop[_n-1]+1 if !mi(drop[_n-1])
				
				* Save last part in memory 
					preserve 
						drop if mi(drop)
						
						* Drop the missing rows at the end
							egen miss = rownonmiss(_all), strok		 
							forval x = `=_N'(-1)1 {
								drop if miss[_n-1]==1 & miss[_n-2]==1 & miss[_n-3]==1 & miss[_n-4]==1 & miss[_n-5]==1
							}
				
						tempfile cati_end
						save `cati_end', replace
					restore 
		
				* Keep only first part 
					keep if mi(drop)
					set obs `=_N+3'
					
				* Bring in CAPI 
					append using `capi_survey'
					set obs `=_N+3'			
					
				* Bring in CATI last part
					append using `cati_end'
				
				* Order media image
					order media*, after(repeat_count)
				
				/*
								
						Drop the duplicated variables in SurveyCTO
								
				*/
			set obs `=_N+1'
			
			foreach var of varlist _all {
				tostring `var', replace
				replace `var' = "`var'" in `=_N'
			}
			
			g sl = _N - _n
			replace sl = 999999 if type=="type"
			gsort -sl
			drop sl
			
			
			* Fix the names adding ::
			
				foreach langs in label hint constraintmessage mediaimage mediaaudio mediavideo {
					unab labels: `langs'* 
					foreach var of local labels {
						if `var' != "`langs'" replace `var' = regexr(`var', "`langs'", "`langs'::") in 1
					}		
				}
				

				unab media_vars: media*
				foreach var of loc media_vars {
					replace `var' = regexr(`var', "media", "media::") in 1
				}
				
				
				unab cons_vars: constraintmessage*
				foreach var of loc cons_vars {
					replace `var' = regexr(`var', "constraint", "constraint ") in 1
				}
				
			
			* Finding duplicate fields and stop the program
			
				duplicates tag name if !mi(name) & !inlist(type, "end group", "end repeat", "type"), gen(dup)
				sum dup 
				if `r(max)'>0 {
					levelsof name if dup>0 & !mi(dup), clean loc(dupvars)
													
					disp as err `"CATI template already have these variables. Either remove or rename them from the CAPI file and try again."'
					foreach var of loc dupvars {
						disp as err "	`var'"
					}
					rm `"`saving'"'
					ex 110
				}
			
			drop catisl capisl miss drop dup			
			export excel using `"`saving'"', keepcellfmt sheet(survey) sheetmodify
			
		**# Work on XML file 
			file open xmlfile using "`attachment'/respondents_advanced.xml", write read
			file seek xmlfile 1155
			file write xmlfile "`formid'</linkObjectId>" _skip(21) _char(10) _char(09) _char(09)
			file seek xmlfile 826
			file write xmlfile "`formid'</formId>" _skip(25) _char(10) _char(09) _char(09) 
			file close xmlfile
			
		noi di as result `"The CATI questionnaire is saved here {browse "`saving'":`saving'}"', _n
			
	* retrieve memory data
		u `olddata', clear
		
	}
	
	* Further Instructions
		noi {
			di as result "Further instrustions:"
			di as text `"	- The CAPI questions are inserted from row 137."'
			di as text `"	- Delete any blank rows if you wish."'
			di as text `"	- Check the {browse "`attachment'/respondents_advanced.xml":respondents_advanced.xml} file and see everything is fine."'
			di as text `"	- Use the {browse "`attachment'/template_user_assignment.do":template_user_assignment.do} for generating respondents.csv preload file."'
			di as text `"	- Upload the CATI with attaching phone-call.fieldplugin.zip launch-sms.fieldplugin.zip and table-list.fieldplugin.zip"'
			di as text `"	- Read further about the CATI workflow on {browse "https://support.surveycto.com/hc/en-us/articles/360046370714-Advanced-CATI-sample-workflow":this SurveyCTO Blog}."', _n
			di as result `"catigen is developed by {browse "https://sotlab.arced.foundation":Solutions of Things Lab (SoTLab)} of {browse "https://arced.foundation":ARCED Foundaiton}."'
		}
		 
end


