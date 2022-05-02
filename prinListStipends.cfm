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
	
	<!--- Get list of requests --->
	<cfquery name="getStipends" datasource="BusinessPLUS">
		SELECT *
		FROM Stipend_PP_MSTR
		WHERE principal = '#session.user.email#' and principal_app_deny <> 'P'
	</cfquery>
	
	
		<!--- display --->
	<center>	
		<table border="1" align="center">
			<tr>
				<th>Set ID</th>
				<th>Entered By</th>
				<th>Entered On</th>
				<th>Approved?</th>
				<th>HR status</th>
				<th>Payroll Status</th>
			</tr>
			<cfoutput query="getStipends">
				<tr>
					<td><a href="prinViewStipend.cfm?setid=#setid#">#setid#</a></td>
					<td>#username#</td>
					<td>#DateFormat(enteredon, "mm/dd/yyyy")#</td>
					<td>
						<cfif #principal_app_deny# eq 'A'>
							Princpal Approved
						<cfelse>
							Prinpal Denied
						</cfif>
					</td>
					<td>
						<cfif #hr_app_deny# eq 'A'>
							HR Approved
						<cfelseif #hr_app_deny# eq 'P' >
							Pending HR Approval
						<cfelse>
							HR Denied
						</cfif>
					</td>
					<td>
						<cfif #payroll_status# eq 'A'>
							Payroll Approved
						<cfelseif #payroll_status# eq 'P' >
							Pending Payroll Approval
						<cfelseif #payroll_status# eq 'D'>
							Payroll Denied
						<cfelse>
							Payroll Exported
						</cfif>
					</td>
				</tr>
			</cfoutput>
		</table>
		<table>
			<tr>
				<td colspan="6" align="center"><a href="index.cfm">Return to main page</a></td>
			</tr>
		</table>
	</center>
</body>

</html>