# catigen (beta) 

``catigen`` is a Stata module to automatically generate <a href="https://www.surveycto.com" target="_blank">SurveyCTO</a> advanced CATI from a <a href="https://www.surveycto.com" target="_blank">SurveyCTO</a> CAPI. This program uses <a href="https://support.surveycto.com/hc/en-us/articles/360046370714-Advanced-CATI-sample-workflow" target="_blank">SurveyCTO advanced CATI</a> template to generate a new CATI based on a SurveyCTO CAPI.

The program does the followings:

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1. Downloads the templates from ARCED's <a href="https://github.com/ARCED-Foundation/catigen/tree/master/templates" target="_blank">GitHub repo</a>.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2. Generates the CATI XLSForm

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3. Create the xml file for server dataset

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4. Saves a sample do file that can be used to generate preload file for server dataset




# Versions
Current version at <a href="https://github.com/ARCED-Foundation/catigen#installation" target="_blank">GitHub</a>: 1.0.1 (beta) <br>



# Installation

```Stata

** Install from GitHub
    net install catigen, all replace from(https://raw.githubusercontent.com/ARCED-Foundation/catigen/master)

```

## Syntax
```stata
catigen using filename, saving(filename) attachment(folderpath) 

help catigen
```

## Options
| Options      | Description |
| ---        |    ----   |
| <u>s</u>aving |  The name and path of the CATI XLSform to be saved | 
| <u>attach</u>ment   | The folder name and path where the attachments will be saved |


## Example Syntax
```Stata

    catigen using "Baseline/dropout_survey_2022.xlsx", ///
			saving("Baseline/Dropout Survey CATI Form.xlsx") ///
			attachment("Baseline/Attachments")

```

Please report all bugs/feature request to the <a href="https://github.com/ARCED-Foundation/catigen/issues" target="_blank"> github issues page</a> or e-mail sotlab@arced-foundation.org.


## Authors
Mehrab Ali

Tasmin Pritha

<a href="https://sotlab.arced.foundation" target="_blank">Solutions of Things Lab</a>, <a href="https://arced.foundation" target="_blank">ARCED Foundation</a>
```
   _____     _______ _           _     
  / ____|   |__   __| |         | |  
  | (___   ___ | |  | |     __ _| |__  
   \___ \ / _ \| |  | |    / _  |  _ \ 
   ____) | (_) | |  | |___| (_| | |_) | 
  |_____/ \___/|_|  |______\__,_|_.__/ 
        Solutions of Things Lab 
```