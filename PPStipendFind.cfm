<cfset pageTitle = "Planning Period Stipend Find">

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
   
   <h1>Planning Period Stipend Lookup</h1>
   

  <!--- query to get all non submitted stipends --->
  <cfquery name="getPendingStipends" datasource="BusinessPLUS">
    SELECT *
    FROM Stipend_PP_MSTR mstr
    WHERE mstr.submitted = 'N' and mstr.username = '#session.user.username#'
  </cfquery>


  <!--- NOT SUBMITTED --->

<center>
  <table>
  	<tr>
  		<th>SetID</th>
  		<th>Entered On</th>
  		<th></th>
  	</tr>
  	<cfoutput query="getPendingStipends">
  		<tr>
  			<td>#SetID#</td>
  			<td>#dateformat(enteredon, "mm/dd/yyyy")#</td>
  			<td><a href="PlanningPeriod.cfm?fsetID=#SetID#">edit</a> </td>
  		</tr>
  	</cfoutput>		
  </table>

   
	<cfquery name="getSubmitted" datasource="BusinessPLUS">
		SELECT *
		FROM Stipend_PP_MSTR
		WHERE	building = '#session.building.bldgnum#' and submitted = 'Y' 		
	</cfquery>
  	<br><br><br>
  	<table>
  		<tr>
  			<th colspan="6">Submitted Stipends</th>
  		</tr>
  		<tr>
  			<th>SETID</th>
  			<th>DATE</th>
  			<th>Submitted</th>
  			<th>Principal</th>
  			<th>HR</th>
  			<th>Payroll</th>
  		</tr>
  		<cfoutput query="getSubmitted">
  			<tr>
  				<td><a href="viewPendingPP.cfm?setid=#setid#">#setid#</a></td>
  				<td>#dateformat(enteredon, "mm/dd/yyyy")#</td>
  				<td align="center">#submitted#</td>
  				<td>
  					<cfif #getSubmitted.principal_app_deny# eq 'P'>
  						Pending
  					<cfelseif #getSubmitted.principal_app_deny# eq 'N'>
  						Not Approved
  					<cfelse>
  						Approved
  					</cfif>
  				</td>
  				<td>
  					<cfif #getSubmitted.hr_app_deny# eq 'P'>
  						Pending
  					<cfelseif #getSubmitted.hr_app_deny# eq 'N'>
  						Not Approved
  					<cfelse>
  						Approved
  					</cfif>
  				</td>
  				<td>
  					<cfif #getSubmitted.payroll_status# eq 'P'>
  						Pending
  					<cfelseif #getSubmitted.payroll_status# eq 'E'>
  						Exported
  					<cfelse>
  						?
  					</cfif>
  				</td>
  			</tr>
  		</cfoutput>
  	</table>
  	<div class="row js--wp-1">
		<a href="index.cfm"><h3>Home</h3></a><br>
	</div>
  	  </center>

    </body>