<cfset pageTitle = "Home - Stipends WF">

<cfif isdefined('submit')>
	<cfquery name="updateMOUStipends" datasource="BusinessPLUS">
		UPDATE	Stipend_MOU_RawData
		SET	PayrollStatus = 'A'
		WHERE	((PayrollStatus IS NULL) and (ExportDate is NULL))	
	</cfquery>
	<cflocation url="MOUStipendExport.cfm" >
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
		WILL ADD LIST LATER<br>
		<a href="index.cfm">Main Page</a>
		
		<!--- search page redirect to view only page--->
	<cfelseif (FindNoCase("Fiscal_Services", session.user.memberof) neq 0) OR (#session.user.username# eq 'abierman')>	
		<!--- List MOU stipends to be exported --->
		<cfquery name="GetMOUStipends" datasource="BusinessPLUS">
			SELECT *
			FROM Stipend_MOU_RawData	
			WHERE PayrollStatus IS NULL AND ExportDate IS NULL
		</cfquery>
		
			
		<cfif #GetMOUStipends.recordcount# gt 0>
			<cfform name="MOUExport" action="MOUStipendList.cfm" method="Post">
				<center>
					<table border="1">
						<tr>
							<th colspan="7">PENDING APPROVAL FOR EXPORT</th>
						</tr>
						<tr>
							<th>Legal Name</th>
							<th>EmployeeID</th>
							<th>Location</th>
							<th>Hours Worked</th>
							<th>Gross Pay</th>
							<th>Account</th>
							<th>Export</th>
						</tr>
						<cfoutput query="GetMOUStipends">
							<tr>
								<td>#legalName#</td>
								<td>#employeeID#</td>
								<td>#location#</td>
								<td>#hoursWorked#</td>
								<td>#grossPay#</td>
								<td>#AccountCode#</td>
								<td></td>
							</tr>
						</cfoutput>
						<tr><td colspan="7"><center><cfinput name="submit" type="submit" value="Mark All for Export" class="submit"></center></td></tr>
					</table>
				</center>
			</cfform>
		<cfelse>
			NO PENDING STIPENDS TO APPROVE
		</cfif>
		
		<!---<cfquery name="GetSubmitted" datasource="BusinessPLUS" >
			
		</cfquery>--->
		
		<br><br><br>
		
		<!---<cfif #GetSubmitted.recordcount# gt 0>
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
		</cfif>--->
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