<cfset pageTitle = "Home - Stipends WF">

<cfif isdefined('Cancel')>
	<cflocation url="PlanningPeriod.cfm?fsetID=#session.mstr.stipendset#">
</cfif>

<cfif isdefined('Delete')>
	<cfquery name="deleteRecord" datasource="BusinessPLUS">
		DELETE FROM	Stipend_PP_DTL
		WHERE tbl_index = '#session.delete.record#'
	</cfquery>
	
	<cfif #src# eq 'PP'>
		<cflocation url="PlanningPeriod.cfm?fsetID=#session.mstr.stipendset#">
	<cfelseif #src# eq 'PPEV'>
		<cflocation url="PP_EditView.cfm?setID=#session.pp.set#">
	</cfif>
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
	
	<cfquery name="getInfo" datasource="BusinessPLUS">
		SELECT *
		FROM Stipend_PP_DTL
		WHERE tbl_index = '#record#'
	</cfquery>
	
	<cfset session.delete.record = '#getInfo.tbl_index#'>
	
	<cfform name="deleteRecord">
		<cfoutput query="getInfo">
			<center>
				<table align="center" >
					<tr>
						<td colspan="2">Name: #name#</td>
					</tr>
					<tr>
						<td colspan="2">EmpID: #empid#</td>
					</tr>
					<tr>
						<td colspan="2">Period: #period#</td>
					</tr>
					<tr>
						<td colspan="2">Date of Assignment: #DateFormat(dateassign, "mm/dd/yyyy")#</td>
					</tr>
					<tr>
						<td colspan="2">Job Number: #jobnumber#</td>
					</tr><tr>
						<td colspan="2">Subbed For: #subbedfor#</td>
					</tr>
					<tr>
						<td><cfinput name="Delete" type="submit" value="Delete"></td>
						<td><cfinput name="Cancel" type="submit" value="Cancel"></td>
					</tr>
				</table>
			</center>			
		</cfoutput>
	</cfform>
	
</body>
</html>