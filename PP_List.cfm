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
   
   <link rel="stylesheet" type="text/css" href="./vendor/css/grid.css">
   
  <!-- Page Content -->
	
	
	
	<!--- Set building number --->
	
	<!---<cfdump var="#session.user#" ><br>
	<cfdump var="#structkeyexists(session, "user")#" ><br>--->
	<cfif (FindNoCase("Secretaries",session.user.memberOf) neq 0) or (#Session.user.special# eq 'Sec')>
		<!--- list not submitted --->
		<cfquery name="getPending" datasource="BusinessPLUS" >
			SELECT *
			FROM Stipend_PP_MSTR
			WHERE username = '#session.user.username#' AND submitted = 'N'	
		</cfquery>
		
		<cfif #getPending.RecordCount# gt 0>
			<center>
				<table border="1" >
					<tr><th colspan="6">NOT YET SUBMITTED TO PRINCIPAL</th></tr>
					<tr>
						<th>Set ID</th>
						<th>Entered By</th>
						<th>Entered On</th>
						<th>Principal Status</th>
						<th>HR Status</th>
						<th>Payroll Status</th>
					</tr>
					<cfoutput query="getPending">
						<tr>
							<td><a href="PP_EditView.cfm?editview=edit&setid=#setid#">PP#setid#</a></td>
							<td>#username#</td>
							<td>#DateFormat(EnteredOn, "mm/dd/yyyy")#</td>
							<td>#principal_app_deny#</td>
							<td>#hr_app_deny#</td>
							<td>#payroll_status#</td>
						</tr>	
					</cfoutput>				
				</table>
			</center>
		</cfif>
		
		<!--- list submitted but not approved --->
		<cfquery name="getSubmitted" datasource="BusinessPLUS" >
			SELECT	*
			FROM	Stipend_PP_MSTR
			WHERE	username = '#session.user.username#' AND submitted = 'Y' AND principal_app_deny = 'P'
		</cfquery>
		
		<cfif #getSubmitted.RecordCount# gt 0>
			<center>
				<br>
				<table border="1" >
					<tr>
						<th colspan="7">SUBMITTED TO PRINCIPAL</th>
					</tr>
					<tr>
						<th>Set ID</th>
						<th>Entered By</th>
						<th>Entered On</th>
						<th>Principal Status</th>
						<th>HR Status</th>
						<th>Payroll Status</th>
					</tr>
					<cfoutput query="getSubmitted">
						<tr>
							<td><a href="PP_EditView.cfm?editview=edit&setid=#setid#">PP#setid#</a></td>
							<td>#username#</td>
							<td>#DateFormat(EnteredOn, "mm/dd/yyyy")#</td>
							<td>#principal_app_deny#</td>
							<td>#hr_app_deny#</td>
							<td>#payroll_status#</td>
						</tr>	
					</cfoutput>				
				</table>
			</center>
		</cfif>
		<!--- List all approved --->
		<cfquery name="getPAppDeny" datasource="BusinessPLUS" >
			SELECT	*
			FROM	Stipend_PP_MSTR
			WHERE	username = '#session.user.username#' AND submitted = 'Y' AND (principal_app_deny = 'Y' or principal_app_deny = 'N')
		</cfquery>
		
		<cfif #getPAppDeny.RecordCount# gt 0>
			<center>
				<br>
				<table border="1" >
					<tr>
						<th colspan="7">PRINCIPAL APPROVED OR DENIED</th>
					</tr>
					<tr>
						<th>Set ID</th>
						<th>Entered By</th>
						<th>Entered On</th>
						<th>Principal Status</th>
						<th>HR Status</th>
						<th>Payroll Status</th>
					</tr>
					<cfoutput query="getPAppDeny">
						<tr>
							<td><a href="PP_EditView.cfm?editview=view&setid=#setid#">PP#setid#</a></td>
							<td>#username#</td>
							<td>#DateFormat(EnteredOn, "mm/dd/yyyy")#</td>
							<td>#principal_app_deny#</td>
							<td>#hr_app_deny#</td>
							<td>#payroll_status#</td>
						</tr>	
					</cfoutput>				
				</table>
			</center>
		</cfif>	
	<cfelseif (FindNoCase("Principals", session.user.memberof) neq 0) or (#Session.user.special# eq 'Prin')>
		<!--- List not approved yet --->
		<cfquery name="getPending" datasource="BusinessPLUS" >
			SELECT *
			FROM Stipend_PP_MSTR
			WHERE	principal = '#session.user.email#' and submitted = 'Y' and principal_app_deny = 'P'
		</cfquery>
		
		<cfif #getPending.RecordCount# gt 0>
			<center>
				<table border="1">
					<tr>
						<th colspan="6">PENDING APPROVAL</th>
					</tr>					
					<tr>
						<th>Set ID</th>
						<th>Entered By</th>
						<th>Entered On</th>
						<th>Principal Status</th>
						<th>HR Status</th>
						<th>Payroll Status</th>
					</tr>
					<cfoutput query="getPending">
						<tr>
							<td><a href="PP_EditView.cfm?editview=predit&setid=#setid#">PP#setid#</a></td>
							<td>#username#</td>
							<td>#DateFormat(EnteredOn, "mm/dd/yyyy")#</td>
							<td>#principal_app_deny#</td>
							<td>#hr_app_deny#</td>
							<td>#payroll_status#</td>
						</tr>	
					</cfoutput>
				</table>
			</center>
		</cfif>
		<br>
		<!--- list approved and denied --->
		<cfquery name="getAppDeny" datasource="BusinessPLUS" >
			SELECT *
			FROM Stipend_PP_MSTR
			WHERE	principal = '#session.user.email#' and submitted = 'Y' and (principal_app_deny = 'Y' or principal_app_deny = 'N')
		</cfquery>
		
		<cfif #getAppDeny.RecordCount# gt 0>
			<center>
				<table border="1">
					<tr>
						<th colspan="6">APPROVED or DENIED</th>
					</tr>					
					<tr>
						<th>Set ID</th>
						<th>Entered By</th>
						<th>Entered On</th>
						<th>Principal Status</th>
						<th>HR Status</th>
						<th>Payroll Status</th>
					</tr>
					<cfoutput query="getAppDeny">
						<tr>
							<td><a href="PP_EditView.cfm?editview=prview&setid=#setid#">PP#setid#</a></td>
							<td>#username#</td>
							<td>#DateFormat(EnteredOn, "mm/dd/yyyy")#</td>
							<td>#principal_app_deny#</td>
							<td>#hr_app_deny#</td>
							<td>#payroll_status#</td>
						</tr>	
					</cfoutput>
				</table>
			</center>
		</cfif>
		
		<br>
		<!--- Not yet submitted --->
		<cfquery name="getOther" datasource="BusinessPLUS" >
			SELECT *
			FROM Stipend_PP_MSTR
			WHERE	principal = '#session.user.email#' and submitted = 'N' and (principal_app_deny <> 'A' or principal_app_deny <> 'N')
		</cfquery>
		
		<cfif #getOther.RecordCount# gt 0>
			<center>
				<table border="1">
					<tr>
						<th colspan="6">NOT SUBMITTED APPROVAL</th>
					</tr>					
					<tr>
						<th>Set ID</th>
						<th>Entered By</th>
						<th>Entered On</th>
						<th>Principal Status</th>
						<th>HR Status</th>
						<th>Payroll Status</th>
					</tr>
					<cfoutput query="getOther">
						<tr>
							<td><a href="PP_EditView.cfm?editview=prview&setid=#setid#">PP#setid#</a></td>
							<td>#username#</td>
							<td>#DateFormat(EnteredOn, "mm/dd/yyyy")#</td>
							<td>#principal_app_deny#</td>
							<td>#hr_app_deny#</td>
							<td>#payroll_status#</td>
						</tr>	
					</cfoutput>
				</table>
			</center>
		</cfif>
	<cfelseif (FindNoCase("Human Resources", session.user.memberof) neq 0)>
		<!--- Approved By Principal --->
		<cfquery name="getPending" datasource="BusinessPLUS" >
			SELECT *
			FROM Stipend_PP_MSTR
			WHERE submitted = 'Y' and principal_app_deny = 'Y' AND hr_app_deny = 'P'	
		</cfquery>
		
		<cfif #getPending.RecordCount# gt 0>
			<center>
				<table border="1" >
					<tr><th colspan="6">APPROVED BY PRINCIPAL</th></tr>
					<tr>
						<th>Set ID</th>
						<th>Entered By</th>
						<th>Entered On</th>
						<th>Principal Status</th>
						<th>HR Status</th>
						<th>Payroll Status</th>
					</tr>
					<cfoutput query="getPending">
						<tr>
							<td><a href="PP_EditView.cfm?editview=hredit&setid=#setid#">PP#setid#</a></td>
							<td>#username#</td>
							<td>#DateFormat(EnteredOn, "mm/dd/yyyy")#</td>
							<td>#principal_app_deny#</td>
							<td>#hr_app_deny#</td>
							<td>#payroll_status#</td>
						</tr>	
					</cfoutput>				
				</table>
			</center>
		</cfif>
		
		<!--- list not submitted --->
		<cfquery name="getDenied" datasource="BusinessPLUS" >
			SELECT *
			FROM Stipend_PP_MSTR
			WHERE submitted = 'Y' and principal_app_deny = 'N' AND hr_app_deny = 'P'
		</cfquery>
		
		<cfif #getDenied.RecordCount# gt 0>
			<center>
				<table border="1" >
					<tr><th colspan="6">DENIED BY PRINCIPAL</th></tr>
					<tr>
						<th>Set ID</th>
						<th>Entered By</th>
						<th>Entered On</th>
						<th>Principal Status</th>
						<th>HR Status</th>
						<th>Payroll Status</th>
					</tr>
					<cfoutput query="getDenied">
						<tr>
							<td><a href="PP_EditView.cfm?editview=hredit&setid=#setid#">PP#setid#</a></td>
							<td>#username#</td>
							<td>#DateFormat(EnteredOn, "mm/dd/yyyy")#</td>
							<td>#principal_app_deny#</td>
							<td>#hr_app_deny#</td>
							<td>#payroll_status#</td>
						</tr>	
					</cfoutput>				
				</table>
			</center>
		</cfif>
		
		<!--- list  --->
		<cfquery name="getOTHER" datasource="BusinessPLUS" >
			SELECT *
			FROM Stipend_PP_MSTR
			WHERE hr_app_deny = 'Y'
		</cfquery>
		
		<cfif #getOTHER.RecordCount# gt 0>
			<center>
				<table border="1" >
					<tr><th colspan="6">OTHER</th></tr>
					<tr>
						<th>Set ID</th>
						<th>Entered By</th>
						<th>Entered On</th>
						<th>Principal Status</th>
						<th>HR Status</th>
						<th>Payroll Status</th>
					</tr>
					<cfoutput query="getOTHER">
						<tr>
							<td><a href="PP_EditView.cfm?editview=hredit&setid=#setid#">PP#setid#</a></td>
							<td>#username#</td>
							<td>#DateFormat(EnteredOn, "mm/dd/yyyy")#</td>
							<td>#principal_app_deny#</td>
							<td>#hr_app_deny#</td>
							<td>#payroll_status#</td>
						</tr>	
					</cfoutput>				
				</table>
			</center>
		</cfif>
	<cfelseif (FindNoCase("Fiscal_Services", session.user.memberof) neq 0) OR (#session.user.username# eq 'abierman')>
		<!--- List not approved yet --->
		<!--- list approved to be exported --->
		<!--- List exported --->
	<cfelseif (FindNoCase("Technology", session.user.memberof) neq 0)>
		Technology View <br><br>
			
			- Secretaries <br>
			- Principals<br>
			- HR<br>
			- Payroll<br>
	<cfelse>
		Not in right group
	</cfif>	
	

	<!---<cfdump var= #Session.user.memberof#>--->
	
 
  <cfinclude template="footer.cfm">