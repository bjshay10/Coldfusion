<cfset pageTitle = "Home - Stipends WF">

<cfif isdefined('Export')>
	<cfset session.batchName = '#batchName#'>
	<cfset session.payPeriod = '#payPeriod#'>
	<cfset tempDateExported = '#dateformat(NOW(), "mm/dd/yyyy")#'>
	<cfset tempDateExported_mmddyyyy = '#dateformat(NOW(), "mmddyyyy")#'>
	
	<!--- need a date entered maybe first month of the payperiod or last day of payperiod??? --->
	
	
	<!--- get data --->
	<cfquery name="getApprovedSets" datasource="BusinessPLUS">
		SELECT *
		FROM Stipend_MOU_RawData
		WHERE PayrollStatus = 'A'	
	</cfquery>
	
	<cfset tempFileName = '#session.batchName#'>
	<cfset tempFileName2 = 'MOUsProcessed_#tempDateExported_mmddyyyy#'>
	<!--- write to file --->
	<cffile action="write" file="\\bplus71db\data$\#tempFileName#" charset="utf-8" output="EMP-ID,BATCH-NAME,PAY-PERIOD,DATE,HRS,HRS-NO,PAY-AMT,PAY-OVR,GLKEY,GLOBJ">
	
	<cfloop query="getApprovedSets">
		<!--- empid, batchname, recno, payperiod, date (yyyymmdd),hrs,hrsno,hrscode,hrsovr,--->
		<cfset writeLine = ''>
		<cfset tempPayPeriod = #session.payPeriod# & repeatstring("", 8 - len(#session.payPeriod#))>
		<cfset tempamount = #getApprovedSets.grossPay#>
		<cfset tempKey = #LEFT(getApprovedSets.AccountCode,10)#>
		<cfset tempObj = #RIGHT(getApprovedSets.AccountCode,5)#>
		
		<cffile action="append" file="\\bplus71db\data$\#tempFileName#" output="#getApprovedSets.employeeID#,#session.batchName#,#session.payPeriod#,#dateformat(tempDateExported, 'yyyymmdd')#,,3100,#tempamount#,Y,#tempKey#,#tempObj#" >
		<cffile action="append" file="\\bplus71db\data$\#tempFileName#" output="#getApprovedSets.employeeID#,#session.batchName#,#session.payPeriod#,#dateformat(tempDateExported, 'yyyymmdd')#,#getApprovedSets.hoursWorked#,3007,,,#tempKey#,#tempObj#" >
		
		<!--- mark sets as Exported ('E') --->
		<cfquery name="updateSets" datasource="BusinessPLUS">
			UPDATE 	Stipend_MOU_RawData
			SET		PayrollStatus = 'E',
					ExportDate = '#tempDateExported#',
					ExportUser = '#session.user.username#'
			WHERE PayrollStatus = 'A'
		</cfquery>
	</cfloop>
	<!---\\odinapp1\c$\Data Export\ --->
	<cffile action="write" file="\\ODINAPP1\MOUsPaid$\#tempFileName2#" charset="utf-8" output="formURL,AccountCode,legalName,employeeID, grossPay,ExportDate">
	<!---<cffile action="write" file="\\ODINAPP1\C$\Data Export\#tempFileName2#" charset="utf-8" output="formURL,AccountCode,legalName,employeeID, grossPay,ExportDate">--->
	<cfloop query="getApprovedSets">
		<cfset writeLine = ''>
		<cffile action="append" file="\\ODINAPP1\MOUsPaid$\#tempFileName2#" output="#getApprovedSets.formURL#,#getApprovedSets.AccountCode#,#getApprovedSets.legalName#,#getApprovedSets.employeeID#,#getApprovedSets.grossPay#,#getApprovedSets.ExportDate#" >
		<!---<cffile action="append" file="\\ODINAPP1\C$\Data Export\#tempFileName2#" output="#getApprovedSets.formURL#,#getApprovedSets.AccountCode#,#getApprovedSets.legalName#,#getApprovedSets.employeeID#,#getApprovedSets.grossPay#,#getApprovedSets.ExportDate#" >--->	
	</cfloop>
	
	
	
	<!--- go to index --->
	<cflocation url="index.cfm" >
</cfif>

<!DOCTYPE html>
<html lang="en">



  <head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Stipends Application">
    <meta name="author" content="BJS">
    	
    <title>Stipend - Class Absorption</title>

   </head>
   
   <cfinclude template="header.cfm">
   
<body>
	
	<!--- Check person type Secretary, Principal, HR, Payroll --->
	
	<cfif (FindNoCase("Secretaries",session.user.memberOf) neq 0) or (#Session.user.special# eq 'Sec')>
		---<br>
		<a href="index.cfm">Main Page</a>
	<cfelseif (FindNoCase("Principals", session.user.memberof) neq 0) or (#Session.user.special# eq 'Prin')>
		---<br>
		<a href="index.cfm">Main Page</a>
	<cfelseif (FindNoCase("Human Resources", session.user.memberof) neq 0)>
		<a href="index.cfm">Main Page</a>
		
		<!--- search page redirect to view only page--->
	<cfelseif (FindNoCase("Fiscal_Services", session.user.memberof) neq 0) OR (#session.user.username# eq 'abierman')>	
		<cfquery name="getStipends" datasource="BusinessPLUS">
			SELECT *
			FROM Stipend_MOU_RawData
			WHERE PayrollStatus = 'A'
		</cfquery>
		
		<cfform action="MOUStipendExport.cfm" method="post" name="ExportMOUStipends">
			 <center>
				<table border="1" align="center" >
					<tr>
						<th colspan="5">MOU Stipends to be Exported</th>
					</tr>
							
					<tr>
						<td colspan="2">Batch Name:<br><cfinput type="text" name="batchName" required="yes"></td>
						<td colspan="3">Pay Period:<br><cfinput name="payPeriod" type="text" required="yes"></td>
					</tr>
					<tr>
						<th>Person</th>
						<th>Employee ID</th>
						<th>Building</th>
						<th>Amount</th>
						<th>Account</th>
					</tr>
					<cfoutput query="getStipends">
						<tr>
							<td>#legalName#</td>
							<td>#employeeID#</td>
							<td>#location#</td>
							<td>#grossPay#</td>
							<td>#AccountCode#</td>
						</tr>
					</cfoutput>
					<tr>
						<td colspan="5" align="center"><cfinput name="Export" type="submit" value="Export" class="submit"></td>
					</tr>
				</table>
			</center>			
		</cfform>
		<!--- List approved stipends  redirect to view only page --->
	<cfelseif (FindNoCase("Technology", session.user.memberof) neq 0)>
		<!--- Payroll list stipends approved by HR --->

		<!--- search page redirect to view only page--->

		<!--- List approved stipends  redirect to view only page --->
	<cfelse>
		Not in right group
	</cfif>
		<center>
		<div class="row js--wp-1">
			<a href="index.cfm"><h3>Home</h3></a><br>
		</div>
	</center>








	
	
</body>
</html>