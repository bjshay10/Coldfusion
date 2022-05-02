<!---<cfapplication name="StipendsWF" sessionmanagement="yes" sessiontimeout="#CreateTimeSpan(0,0,60,0)#">--->

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
  <!-- Page Content -->
  	<!--- mstr data --->
	<cfquery name="getSetData" datasource="BusinessPLUS">
		SELECT *
		FROM Stipend_PP_MSTR
		WHERE setid= '#setid#'
	</cfquery>
	
	<!--- DTL data --->
	<cfquery name="getSetDTLData" datasource="BusinessPLUS">
		SELECT *
		FROM Stipend_PP_DTL
		WHERE setid = '#setid#'
	</cfquery>

	<center>
	<table border="1" align="center" >
		<cfoutput query="getSetData">
		<tr>
			<th colspan="2" align="center">Entered By: <cfoutput>#session.user.displayName#</cfoutput></th>
			<th colspan="2" align="center">Set ID: <cfoutput>#setid#</cfoutput></th>
			<th colspan="2" align="center">Record Count: <cfoutput>#getSetDTLData.recordcount#</cfoutput></th>
		</tr>
		<tr>
			<th align="center" colspan="2">
				<cfif #getSetData.submitted# eq 'N'>
					Submitted: NO
				<cfelse>
					Submitted: YES
				</cfif>
			</th>
			<th align="center" colspan="2">Principal: <cfoutput>#getSetData.principal#</cfoutput></th>
			<th align="center" colspan="2">
				<cfif #getSetData.principal_app_deny# eq 'P'>
					Principal Status: PENDING	
				<cfelseif #getSetData.principal_app_deny# eq 'N'>
					Principal Status: DENIED
				<cfelse>
					Principal Status: APPROVED
				</cfif>
			</th>
		</tr>
		<tr>
			<th align="center" colspan="3">
				<cfif #getSetData.hr_app_deny# eq 'P'>
					HR Status: PENDING
				<cfelseif #getSetData.hr_app_deny# eq 'N'>
					HR Status: DENIED
				<cfelse>
					HR Status: APPROVED
				</cfif>
			</th>
			<th align="center" colspan="3">
				<cfif #getSetData.payroll_status# eq 'P'>
					Payroll Status: PENDING	
				<cfelseif #getSetData.payroll_status# eq 'N'>
					Payroll Status: DENIED
				<cfelse>
					Payroll Status: COMPLETE
				</cfif>
			</th>
		</tr>
		</cfoutput>
		<tr>
			<th>Legal Name<br> (No Nicknames)</th>
			<th>Employee ID</th>
			<th># of Planning Period</th>
			<th>Date of Assign</th>
			<th>Job ID</th>
			<th>Name of Teacher Subbed for</th>
		</tr>
		<cfoutput query="getSetDTLData">
			<tr>
				<td>#name#</td>
				<td>#empid#</td>
				<td>#period#</td>
				<td>#dateformat(dateassign,"mm/dd/yyyy")#</td>
				<td>#jobnumber#</td>
				<td>#subbedfor#</td>
			</tr>	
		</cfoutput>	
	</table>
	<table width="50%">
		<tr>
			<td colspan="40%"><a href="PPStipendFind.cfm">Existing Stipends</a></td>
			<td colspan="20%"></td>
			<td colspan="40%"><a href="index.cfm">Home</a></td>
		</tr>
	</table>
	</center>
</body>
</html>