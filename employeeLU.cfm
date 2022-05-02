<cfset pageTitle = "Home - Stipends WF">

<cfif isdefined('submit')>
	<!--- search for employee --->
	<cfset criteria = '#empName#'>
	
	<cfquery name="searchquery" datasource="BusinessPLUS">
		SELECT M.Name, M.ID
		FROM hr_empmstr M INNER JOIN hr_emppay P ON
			M.ID = P.ID
		WHERE FISCALYR = '2021-22' and POSITION LIKE '%%' and BARG_UNIT = 'MVEA'
			AND (LOWER(SUBSTRING(M.Name, charindex(',',M.Name),len(m.name))+' '+left(M.Name, charindex(',',M.Name)))) LIKE '%#criteria#%'
		GROUP BY M.Name, M.ID
	</cfquery>
</cfif>

<cfif isdefined('source')>
	<cfset session.source = '#source#'>
</cfif>


<!DOCTYPE html>
<html lang="en">
	
  <head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Stipends Application">
    <meta name="author" content="BJS">
    	
    <cfif #session.source# eq 'P'>
    	<title>Stipend - Planning Period</title>
    <cfelseif #session.source# eq 'A'>
    	<title>Stipend - Class Absorption</title>
    </cfif>

   </head>
   
   <cfinclude template="header.cfm">
   
<body>
	<cfif isdefined('stype')>
		<cfset session.stype = '#stype#'>
	</cfif>
	<cfform name="empLU" method="post" action="employeeLU.cfm">
		<center>
		<table align="center" >
			<tr>
				<th colspan="2">Employee Lookup</th>
			</tr>
			<tr>
				<td>Name:</td>
				<td><cfinput name="empName" type="text" class="txt-box"></td>
			</tr>
			<Tr>
				<td colspan="2" align="center"><cfinput name="submit" type="submit" value="Search" class="submit"></td>
			</Tr>
		</table>
		</center>	
	</cfform>
	
	<!--- Results data --->
	<cfif isdefined('searchquery')>
		<center>
		<table align='center'>
				<tr><td>Name</td><td>ID</td></tr>
			<cfoutput query="searchquery">
				<tr>
					<cfif #session.stype# eq 'E' and #session.source# eq 'P'>
						<td><a href="PlanningPeriod.cfm?eLUName=#name#&eLUID=#id#">#name#</a></td>
						<td><a href="PlanningPeriod.cfm?eLUName=#name#&eLUID=#id#">#id#</a></td>
					<cfelseif #session.stype# eq 'S'and #session.source# eq 'P'>
						<td><a href="PlanningPeriod.cfm?sLUName=#name#&sLUID=#ID#">#name#</a></td>
						<td><a href="PlanningPeriod.cfm?sLUName=#name#&sLUID=#ID#">#id#</a></td>
					<cfelseif #session.stype# eq 'E' and #session.source# eq 'A'>
						<td><a href="ClassAbsorb.cfm?eLUName=#name#&eLUID=#id#">#name#</a></td>
						<td><a href="ClassAbsorb.cfm?eLUName=#name#&eLUID=#id#">#id#</a></td>
					<cfelseif #session.stype# eq 'S'and #session.source# eq 'A'>
						<td><a href="ClassAbsorb.cfm?sLUName=#name#&sLUID=#ID#">#name#</a></td>
						<td><a href="ClassAbsorb.cfm?sLUName=#name#&sLUID=#ID#">#id#</a></td>
					<cfelseif #session.stype# eq 'E' and #session.source# eq 'EV'>
						<td><a href="EditViewClassAbsorb.cfm?eLUName=#name#&eLUID=#id#">#name#</a></td>
						<td><a href="EditViewClassAbsorb.cfm?eLUName=#name#&eLUID=#id#">#id#</a></td>
					<cfelseif #session.stype# eq 'S'and #session.source# eq 'EV'>
						<td><a href="EditViewClassAbsorb.cfm?sLUName=#name#&sLUID=#ID#">#name#</a></td>
						<td><a href="EditViewClassAbsorb.cfm?sLUName=#name#&sLUID=#ID#">#id#</a></td>
					<cfelseif #session.stype# eq 'E' and #session.source# eq 'ppEV'>
						<td><a href="PP_EditView.cfm?eLUName=#name#&eLUID=#id#">#name#</a></td>
						<td><a href="PP_EditView.cfm?eLUName=#name#&eLUID=#id#">#id#</a></td>
					<cfelseif #session.stype# eq 'S'and #session.source# eq 'ppEV'>
						<td><a href="PP_EditView.cfm?sLUName=#name#&sLUID=#ID#">#name#</a></td>
						<td><a href="PP_EditView.cfm?sLUName=#name#&sLUID=#ID#">#id#</a></td>
					<cfelseif #session.stype# eq 'E' and #session.source# eq 'ppRec'>
						<td><a href="editStipendRecord.cfm?eLUName=#name#&eLUID=#id#&src=#session.temp.src#&record=#session.temp.record#">#name#</a></td>
						<td><a href="editStipendRecord.cfm?eLUName=#name#&eLUID=#id#&src=#session.temp.src#&record=#session.temp.record#">#id#</a></td>
					<cfelseif #session.stype# eq 'S'and #session.source# eq 'ppRec'>
						<td><a href="editStipendRecord.cfm?sLUName=#name#&sLUID=#ID#&src=#session.temp.src#&record=#session.temp.record#">#name#</a></td>
						<td><a href="editStipendRecord.cfm?sLUName=#name#&sLUID=#ID#&src=#session.temp.src#&record=#session.temp.record#">#id#</a></td>
					</cfif>						
				</tr>
			</cfoutput> 
		</table>
		</center>
	</cfif>
</body>

</html>