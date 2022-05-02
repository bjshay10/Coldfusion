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
	

	<cfif view eq "pending">
		<!--- List Pending --->
		<!--- Query --->
		
		<cfquery name="getPending" datasource="BusinessPLUS">
			SELECT *
			FROM Stipend_PP_MSTR
			WHERE hr_app_deny = 'Y' and payroll_status = 'P'
		</cfquery>
		
		<!--- display --->
		<cfif #getPending.recordcount# gt 0>
			<center>
				<table border="1" align="center">
					<tr><th colspan="3">Pending Export Approval</th></tr>
					<tr>
						<th>Set ID</th>
						<th>Entered By</th>
						<th>Entered On</th>
					</tr>
					<cfoutput query="getPending">
						<tr>
							<td><a href="payrollViewStipends.cfm?setid=#setid#&view=Pending">PP#setid#</a></td>
							<td>#username#</td>
							<td>#DateFormat(enteredon, "mm/dd/yyyy")#</td>
						</tr>
					</cfoutput>
				</table>
			</center>
		</cfif>
	
	<cfelseif view eq "ToBe">
		<!--- get to be exported ---->
		<cfquery name="getToBeExported" datasource="BusinessPLUS">
			SELECT *
			FROM Stipend_PP_MSTR
			WHERE hr_app_deny = 'Y' and payroll_status = 'A'
		</cfquery>
		
		<!--- display --->
		<center>
			<table border="1" align="center">
				<tr><th colspan="3">To Be Exported</th></tr>
				<tr>
					<th>Set ID</th>
					<th>Entered By</th>
					<th>Entered On</th>
				</tr>
				<cfoutput query="getToBeExported">
					<tr>
						<td>#setid#</td>
						<td>#username#</td>
						<td>#DateFormat(enteredon, "mm/dd/yyyy")#</td>
					</tr>
				</cfoutput>
			</table>
		</center>
	</cfif>
	<center>
		<div class="row js--wp-1">
			<a href="index.cfm"><h3>Home Screen</h3></a><br>
		</div>
	</center>
	<!---
	
	<!--- List Exported --->
	<cfquery name="getPending" datasource="BusinessPLUS">
		SELECT *
		FROM Stipend_PP_MSTR
		WHERE hr_app_deny = 'A' and payroll_status = 'A'
	</cfquery>
	
	<!--- display --->
	<table border="1" align="center">
		<tr>
			<th>Set ID</th>
			<th>Entered By</th>
			<th>Entered On</th>
		</tr>
		<cfoutput query="getPending">
			<tr>
				<td><a href="payrollExportStipend.cfm?setid=#setid#&view=Exported">#setid#</a></td>
				<td>#username#</td>
				<td>#DateFormat(enteredon, "mm/dd/yyyy")#</td>
			</tr>
		</cfoutput>
	</table>--->

</body>
</html>