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
	
	<!--- Get Pending --->
	<!--- Query --->
	<cfquery name="getPending" datasource="BusinessPLUS">
		SELECT *
		FROM Stipend_PP_MSTR
		WHERE hr_app_deny = 'P'
	</cfquery>
	
	<!--- display --->
	<center>
		<table border="1" align="center">
			<tr>
				<th>Set ID</th>
				<th>Entered By</th>
				<th>Entered On</th>
			</tr>
			<cfoutput query="getPending">
				<tr>
					<td><a href="hrAppDeny.cfm?setid=#setid#">#setid#</a></td>
					<td>#username#</td>
					<td>#DateFormat(enteredon, "mm/dd/yyyy")#</td>
				</tr>
			</cfoutput>
		</table>
		<div class="row js--wp-1">
			<a href="index.cfm"><h3>Home Screen</h3></a><br>
		</div>
	</center>
	
</body>

</html>