<cfset pageTitle = "Home - Stipends WF">

<!DOCTYPE html>
<html lang="en">



  <head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Stipends Application">
    <meta name="author" content="BJS">
    	
    <title>Stipend - Planning Period</title>

   </head>
   
   <cfinclude template="header.cfm">
   
<body>
	
	<!--- get pending mstr and detail --->
	<cfquery name="getMSTRData" datasource="BusinessPLUS">
		SELECT *
		FROM Stipend_PP_MSTR
		WHERE setid = '#session.pending.setid#'
	</cfquery>
	
	<cfquery name="getDTLData" datasource="BusinessPLUS">
		SELECT *
		FROM Stipend_PP_DTL
		WHERE setid = '#session.pending.setid#'
	</cfquery>
	
	
	
	<center>
		<table border="1" align="center" >
			<tr>
				<th colspan="2" align="center">Entered By: <cfoutput>#getMSTRData.username#</cfoutput></th>
				<th colspan="2" align="center">Set ID: <cfoutput>#getMSTRData.setid#</cfoutput></th>
				<th colspan="2" align="center">Record Count: <cfoutput>#getDTLData.recordcount#</cfoutput></th>
			</tr>
			<tr>
				<th align="center" colspan="2">
					<cfif #getMSTRData.submitted# eq 'N'>
						Submitted: NO
					<cfelse>
						Submitted: YES
					</cfif>
				</th>
				<th align="center" colspan="2">Principal: <cfoutput>#getMSTRData.principal#</cfoutput></th>
				<th align="center" colspan="2">
					<cfif #getMSTRData.principal_app_deny# eq 'P'>
						Principal Status: PENDING	
					<cfelseif #getMSTRData.principal_app_deny# eq 'N'>
						Principal Status: DENIED
					<cfelse>
						Principal Status: APPROVED
					</cfif>
				</th>
			<tr>
				<th align="center" colspan="3">
					<cfif #getMSTRData.hr_app_deny# eq 'P'>
						HR Status: PENDING
					<cfelseif #getMSTRData.hr_app_deny# eq 'N'>
						HR Status: DENIED
					<cfelse>
						HR Status: APPROVED
					</cfif>
				</th>
				<th align="center" colspan="3">
					<cfif #getMSTRData.payroll_status# eq 'P'>
						Payroll Status: PENDING	
					<cfelseif #getMSTRData.payroll_status# eq 'N'>
						Payroll Status: DENIED
					<cfelse>
						Payroll Status: COMPLETE
					</cfif>
				</th>
			</tr>
			<tr>
				<th>Legal Name<br> (No Nicknames)</th>
				<th>Employee ID</th>
				<th># of Planning Period</th>
				<th>Date of Assign</th>
				<th>Job ID</th>
				<th>Name of Teacher Subbed for</th>
			</tr>
			<cfoutput query="getDTLData">
				<tr>
					<td>#name#</td>
					<td>#empid#</td>
					<td>#period#</td>
					<td>#DateFormat(dateassign, "mm/dd/yyyy")#</td>
					<td>#jobnumber#</td>
					<td>#subbedfor#</td>
				</tr>			
			</cfoutput>
		</table>
		<div class="row js--wp-1">
			<div class="col span-1-of-2 box">
				<a href="hrListStipends.cfm"><h3>Return to List of Stipends</h3></a><br>
			</div>
			<div class="col span-1-of-2 box">
				<a href="index.cfm"><h3>Home</h3></a><br>
			</div>
		</div>
	</center>
	
</body>
</html>