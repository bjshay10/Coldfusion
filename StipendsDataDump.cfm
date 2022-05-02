<cfset pageTitle = "Home - Stipends WF">

<!DOCTYPE html>
<html lang="en">

  <head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Stipends Application">
    <meta name="author" content="BJS">
    <title>Home - Stipends WF</title>
    
   </head>
   
   <cfinclude template="header.cfm">
   
   <link rel="stylesheet" type="text/css" href="./vendor/css/grid.css">
   		
   	<body>
   		
   		<div class="row js--wp-1">
   			<div class="col span-1-of-1 box">
		   		<cfif isdefined('type')>
		   			<cfif #type# eq "PP">	
		   				
		   				<!--- query to get PP data --->
		   				<cfquery name="getPPData" datasource="BusinessPLUS">
		   					SELECT 'PP'+m.setid as SET_ID, username, building, principal, principal_app_deny, principal_app_deny_date, hr_app_deny, hr_app_deny_date, payroll_status,
									enteredon, submitted, comments, ExportDate, FiscalYR, name, empid, period, dateassign, jobnumber, subbedfor, subbedforid, dateentered
							FROM Stipend_PP_MSTR m INNER JOIN Stipend_PP_DTL d ON m.setid = d.setid
							WHERE enteredon is not null and FiscalYR = '#Session.FiscalYR#'
		   				</cfquery>		   				
		   				
		   				<!--- write data to users h drive --->
		   				<cfset tempDateExported_mmddyyyy = '#dateformat(NOW(), "mmddyyyy")#'>
		   				<cfset tempFileName = 'PPDataDump_#tempDateExported_mmddyyyy#.csv'>
		   				
		   				
		   				<!---\\ifasbitech\bi-tech$\StipendsData\#tempFileName# --->
		   				<cffile action="write" file="\\ifasbitech\StipendsData$\#tempFileName#" charset="utf-8" output="SetId,username,building,principal, principal_app_deny, principal_app_deny_date, hr_app_deny, hr_app_deny_date, payroll_status,enteredon, submitted, comments, ExportDate, FiscalYR, name, empid, period, dateassign, jobnumber, subbedfor, subbedforid, dateentered">
		   				
		   				<cfloop query="getPPData" >
		   					<cfset writeLine = ''>
		   					
		   					<cffile action="append" file="\\ifasbitech\StipendsData$\#tempFileName#" output="#Set_Id#,#username#,#building#,#principal#, #principal_app_deny#, #principal_app_deny_date#, #hr_app_deny#, #hr_app_deny_date#, #payroll_status#,#enteredon#, #submitted#, #comments#, #ExportDate#, #FiscalYR#, #name#, #empid#, #period#, #dateassign#, #jobnumber#, #subbedfor#, #subbedforid#, #dateentered#" >
		   				</cfloop>
		   				<!--- Display where saved --->
		   				
		   				Planning Period Data	
		   			<cfelse>
		   				<!---Query to get CA Data --->
		   				<!--- write data to users h drive --->
		   				Class Absorption
		   			</cfif>
		   		</cfif>
		   	</div>
	   	</div>
   		
   		<div class="row js--wp-1">	
			<div class="col span-1-of-1 box">
   				<h2>Stipends Data Dump for <cfoutput>#session.FiscalYR#</cfoutput></h2>
   			</div>
   		</div>
   		<div class="row js--wp-1">
			<div class="col span-1-of-2 box">
				<a class="nav-link" href="StipendsDataDump.cfm?type=PP">Planning Period</a>	
			</div>
			<div class="col span-1-of-2 box">
				<a class="nav-link" href="StipendsDataDump.cfm?type=CA">Class Absorption</a>	
			</div>
   		</div>
  	</body>
	
	
	
  </html> 