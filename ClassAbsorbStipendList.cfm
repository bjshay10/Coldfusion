<cfset pageTitle = "Home - Stipends WF">

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
		<!--- secretary list pending submition  redirect to ClassAbsorb.cfm --->
		<!--- Get pending submition --->
		<cfquery name="GetPending" datasource="BusinessPLUS">
			SELECT *
			FROM Stipend_Abs_MSTR
			WHERE username = '#session.user.username#' AND submitted = 'N'
		</cfquery>
		
		<center>
			
		<cfif #GetPending.recordcount# gt 0>
			
			<table border="1">
				<tr>
					<th colspan="3">NOT YET SUBMITTED</th>
				</tr>
				<tr>
					<th>SetID</th>
					<th>Entered On</th>
					<th></th>
				</tr>
				<cfoutput query="GetPending">
					<tr>
						<td>CA#setid#</td>
						<td>#dateformat(enteredon,"mm/dd/yyyy")#</td>
						<td><a href="EditViewClassAbsorb.cfm?editview=edit&setid=#setid#">EDIT/SUBMIT</a></td>
					</tr>
				</cfoutput>
			</table>
		<cfelse>
			NO PENDING STIPENDS TO SUBMIT
		</cfif>
		
		<cfquery name="GetSubmitted" datasource="BusinessPLUS" >
			SELECT *
			FROM Stipend_Abs_MSTR
			WHERE username = '#session.user.username#' AND submitted = 'Y'
		</cfquery>
		
		<br><br><br>
		
		<cfif #GetSubmitted.recordcount# gt 0>
			<table border="1">
				<tr>
					<th colspan="3">SUBMITTED</th>
				</tr>
				<tr>
					<th>SetID</th>
					<th>Entered On</th>
					<th></th>
				</tr>
				<cfoutput query="GetSubmitted">
					<tr>
						<td>CA#setid#</td>
						<td>#dateformat(enteredon,"mm/dd/yyyy")#</td>
						<td><a href="EditViewClassAbsorb.cfm?editview=view&setid=#setid#">VIEW</a></td>
					</tr>
				</cfoutput>
			</table>
		</cfif>
		
		
		<!--- secretary list submitted can redirect to view only page --->
	<cfelseif (FindNoCase("Principals", session.user.memberof) neq 0) or (#Session.user.special# eq 'Prin')>
		<!--- Principal List submitted rediret to principal approval page --->
		<!--- Get pending submition --->		
		<cfquery name="GetPending" datasource="BusinessPLUS" >
			SELECT *
			FROM Stipend_Abs_MSTR
			WHERE principal = '#session.user.email#' AND submitted = 'Y' AND principal_app_deny = 'P'
		</cfquery>
		
		<cfif #GetPending.recordcount# gt 0>
			<center>
				<table border="1">
					<tr>
						<th colspan="3">SUBMITTED</th>
					</tr>
					<tr>
						<th>SetID</th>
						<th>Entered On</th>
						<th></th>
					</tr>
					<cfoutput query="GetPending">
						<tr>
							<td>CA#setid#</td>
							<td>#dateformat(enteredon,"mm/dd/yyyy")#</td>
							<td><a href="EditViewClassAbsorb.cfm?editview=predit&setid=#setid#">VIEW</a></td>
						</tr>
					</cfoutput>
				</table>
			</center>
		</cfif>
		
		<!--- Get Submitted --->
		<cfquery name="GetSubmitted" datasource="BusinessPLUS" >
			SELECT *
			FROM Stipend_Abs_MSTR
			WHERE principal = '#session.user.email#' AND submitted = 'Y' AND (principal_app_deny = 'Y' or principal_app_deny = 'N')
		</cfquery>
		
		<br><br><br>
		
		<cfif #GetSubmitted.recordcount# gt 0>
			<center>
				<table border="1">
					<tr>
						<th colspan="3">SUBMITTED</th>
					</tr>
					<tr>
						<th>SetID</th>
						<th>Entered On</th>
						<th></th>
					</tr>
					<cfoutput query="GetSubmitted">
						<tr>
							<td>CA#setid#</td>
							<td>#dateformat(enteredon,"mm/dd/yyyy")#</td>
							<td><a href="EditViewClassAbsorb.cfm?editview=view&setid=#setid#">VIEW</a></td>
						</tr>
					</cfoutput>
				</table>
			</center>
		</cfif>
		<!--- Principal View approved/denied redirect to view only page --->
	<cfelseif (FindNoCase("Human Resources", session.user.memberof) neq 0)>
		<!--- HR list all stipends yet to be approved and all approved by principals --->
		
		<cfquery name="GetPending" datasource="BusinessPLUS">
			SELECT *
			FROM Stipend_Abs_MSTR
			WHERE submitted = 'Y' AND principal_app_deny = 'Y' and hr_app_deny = 'P' AND payroll_status = 'P'
		</cfquery>

			
		<cfif #GetPending.recordcount# gt 0>
			<center>
				<table border="1">
					<tr>
						<th colspan="3">PENDING HR APPROVAL</th>
					</tr>
					<tr>
						<th>SetID</th>
						<th>Entered On</th>
						<th></th>
					</tr>
					<cfoutput query="GetPending">
						<tr>
							<td>CA#setid#</td>
							<td>#dateformat(enteredon,"mm/dd/yyyy")#</td>
							<td><a href="EditViewClassAbsorb.cfm?editview=hredit&setid=#setid#">EDIT/SUBMIT</a></td>
						</tr>
					</cfoutput>
				</table>
			</center>
		<cfelse>
			NO PENDING STIPENDS TO APPROVE
		</cfif>
		
		<cfquery name="GetSubmitted" datasource="BusinessPLUS" >
			SELECT *
			FROM Stipend_Abs_MSTR
			WHERE hr_app_deny <> 'P' and hr_app_deny <> 'X'
		</cfquery>
		
		<br><br><br>
		
		<cfif #GetSubmitted.recordcount# gt 0>
			<center>
				<table border="1">
					<tr>
						<th colspan="4">OTHER STATUS</th>
					</tr>
					<tr>
						<th>SetID</th>
						<th>Entered On</th>
						<th>STATUS</th>
						<th>&nbsp</th>
					</tr>
					<cfoutput query="GetSubmitted">
						<tr>
							<td>CA#setid#</td>
							<td>#dateformat(enteredon,"mm/dd/yyyy")#</td>
							<td>
								Submitted: #submitted#<br>
								Principal: #principal_app_deny#<br>
								HR: #hr_app_deny#<br>
								Payroll: #payroll_status#
							</td>
							<td><a href="EditViewClassAbsorb.cfm?editview=hredit&setid=#setid#">VIEW</a></td>
						</tr>
					</cfoutput>
				</table>
			</center>
		</cfif>
		
		<!--- search page redirect to view only page--->
	<cfelseif (FindNoCase("Fiscal_Services", session.user.memberof) neq 0) OR (#session.user.username# eq 'abierman')>	
		<!--- Payroll list stipends approved by HR --->
		<cfquery name="GetPending" datasource="BusinessPLUS">
			SELECT *
			FROM Stipend_Abs_MSTR
			WHERE submitted = 'Y' And principal_app_deny = 'Y' AND hr_app_deny = 'Y' and payroll_status = 'P'
		</cfquery>
		
			
		<cfif #GetPending.recordcount# gt 0>
			<center>
				<table border="1">
					<tr>
						<th colspan="3">PENDING APPROVAL FOR EXPORT</th>
					</tr>
					<tr>
						<th>SetID</th>
						<th>Entered On</th>
						<th></th>
					</tr>
					<cfoutput query="GetPending">
						<tr>
							<td>CA#setid#</td>
							<td>#dateformat(enteredon,"mm/dd/yyyy")#</td>
							<td><a href="EditViewClassAbsorb.cfm?editview=view&setid=#setid#">EDIT/SUBMIT</a></td>
						</tr>
					</cfoutput>
				</table>
			</center>
		<cfelse>
			NO PENDING STIPENDS TO APPROVE
		</cfif>
		
		<cfquery name="GetSubmitted" datasource="BusinessPLUS" >
			SELECT *
			FROM Stipend_Abs_MSTR
			WHERE hr_app_deny <> 'P' and hr_app_deny <> 'X' and hr_app_deny <> 'Y'
		</cfquery>
		
		<br><br><br>
		
		<cfif #GetSubmitted.recordcount# gt 0>
			<center>
				<table border="1">
					<tr>
						<th colspan="4">OTHER STATUS</th>
					</tr>
					<tr>
						<th>SetID</th>
						<th>Entered On</th>
						<th>STATUS</th>
						<th></th>
					</tr>
					<cfoutput query="GetSubmitted">
						<tr>
							<td>CA#setid#</td>
							<td>#dateformat(enteredon,"mm/dd/yyyy")#</td>
							<td>
								Submitted: #submitted#<br>
								Principal: #principal_app_deny#<br>
								HR: #hr_app_deny#<br>
								Payroll: #payroll_status#
							</td>
							<td><a href="EditViewClassAbsorb.cfm?editview=view&setid=#setid#">VIEW</a></td>
						</tr>
					</cfoutput>
				</table>
			</center>
		</cfif>
		<!--- search page redirect to view only page--->
		
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