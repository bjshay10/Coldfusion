<cfset pageTitle = "Home - Stipends WF">

<cfif isDefined('MarkToExport')>
	<!--- mark set as A --->
	<cfquery name="MarkToExport" datasource="BusinessPLUS">
		UPDATE Stipend_PP_MSTR
		SET payroll_status = 'A'
		WHERE setid = '#session.paypending.setid#'
	</cfquery>
	<!--- go back to list page --->
	<cflocation url="payrollListStipends.cfm?view=Pending" >
</cfif>

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
	
	<!--- change view based on view type P = Pending, A = Awaiting Export, E = Exported --->
	<cfset session.paypending.setid = #setid#>
	<cfif view eq 'Pending'>
	<!--- PENDING --->
		<!--- get pending info --->
		<cfquery name="getMSTRData" datasource="BusinessPLUS">
		SELECT *
		FROM Stipend_PP_MSTR
		WHERE setid = '#setid#'
	</cfquery>
	
	<cfquery name="getDTLData" datasource="BusinessPLUS">
		SELECT *
		FROM Stipend_PP_DTL
		WHERE setid = '#setid#'
	</cfquery>
		<!--- Display pending info --->
		<center>
			<table border="1" align="center" >
				<tr>
					<th colspan="2" align="center">Entered By: <cfoutput>#getMSTRData.username#</cfoutput></th>
					<th colspan="2" align="center">Set ID: <cfoutput>PP#getMSTRData.setid#</cfoutput></th>
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
				<tr>
					<td colspan="7" align="center">
						Comments: <cfoutput>#GetMSTRData.comments#"</cfoutput>
					</td>
				</tr>
				<cfform name="PP_MarkToExport" action="payrollViewStipends.cfm" method="post">
					<tr>
						<td colspan="6" align="center"><cfinput name="MarkToExport" type="submit" value="Mark For Export" class="submit"></td>
					</tr>
				</cfform>
				<!---<tr>
					<td colspan="6"><a href="PayrollListStipends.cfm">Return to List of Stipends</a></td>
				</tr>--->
			</table>
			<div class="row js--wp-1">
				<div class="col span-1-of-2 box">
					<a href="PayrollListStipends.cfm?view=Pending"><h3>Back to Pending</h3></a><br>
				</div>
				<div class="col span-1-of-2 box">
					<a href="index.cfm"><h3>Home</h3></a><br>
				</div>
			</div>
		</center>
		<!--- Button to mark for export --->
	<cfelseif view eq 'Awaiting'> 
	<!--- Awaiting export --->
		<!--- get awaiting info --->
		<!--- Display list awaiting --->
		<!--- button to export --->
	<cfelse>
	<!--- Exported --->
		<!--- get Exported info --->
		<!--- Display information --->
	</cfif>

</body>
</html>