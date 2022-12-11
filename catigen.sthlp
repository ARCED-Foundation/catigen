{smcl}
{* *! version 1.0.1 SoTLab, ARCED Foundation 09dec2022}{...}
{title:Title}

{phang}
{cmd:catigen} {hline 2}
Automatically generates SurveyCTO CATI from a CAPI XLSForm


{marker syntax}{...}
{title:Syntax}

{p 8 10 2}
{cmd:catigen using} {it:{help filename}}{cmd:,}
{opth s:aving(filename)} {opth attach:ment(dir)}


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{p2coldent:* {opth s:aving(filename)}}The name and path of the CATI XLSform to be saved{p_end}
{p2coldent:* {opth attach:ment(dir)}}The folder name and path where the attachments will be saved{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}* {opt s:aving()} and {opt attach:ment()} are required.


{title:Description}

{pstd}
{cmd:catigen} is a Stata module to automatically generate SurveyCTO advanced CATI from a SurveyCTO CAPI. This program uses SurveyCTO advanced CATI template to generate a new CATI based on a SurveyCTO CAPI.

    The program does the followings:

       1. Downloads the templates from ARCED's {browse "https://github.com/ARCED-Foundation/catigen/tree/master/templates":GitHub repo}.

       2. Generates the CATI XLSForm

       3. Create the xml file for server dataset

       4. Saves a sample do file that can be used to generate preload file for server dataset

{marker examples}{...}
{title:Examples}

{pstd}
{p_end}{cmd}{...}
{phang2}. catigen using "Baseline/dropout_survey_2022.xlsx",
saving("Baseline/Dropout Survey CATI Form.xlsx")
attachment("Baseline/Attachments"){p_end}
{txt}{...}


{marker authors}{...}
{title:Authors}

{pstd}Mehrab Ali{p_end}
{pstd}Tasmin Pritha{p_end}

{pstd}{browse "https://sotlab.arced.foundation":Solutions of Things Lab}, {browse "https://arced.foundation":ARCED Foundation}{p_end}
{pstd}The GitHub repository for {cmd:catigen} is {browse "https://github.com/ARCED-Foundation/catigen":here}. For questions or suggestions, submit a
{browse "https://github.com/ARCED-Foundation/catigen/issues":GitHub issue}
or e-mail sotlab@arced-foundation.org.{p_end}
