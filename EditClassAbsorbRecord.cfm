<cfset pageTitle = "Home - Stipends WF">

<cfif isdefined('record')>
	<cfset session.record = '#record#'>
</cfif>

<cfif isdefined('SaveRecord')>
	
	<cfset tempAmount = NumberFormat(#form.absNumHours# * 33.99, '___.__')>
	
	<cfquery name="UpdateRecord" datasource="BusinessPLUS" >
		UPDATE Stipend_Abs_DTL
		SET	name = '#form.absName#',
			empid = '#form.absEmpID#',
			jobdate = '#form.absJobDate#',
			NumHours = '#form.absNumHours#',
			GrossAmount = '#tempAmount#',
			jobid = '#form.absJobID#',
			subbedfor = '#form.absSubbedFor#'
		WHERE tbl_index = '#session.record#'	
	</cfquery>
	
	<cflocation url="EditViewClassAbsorb.cfm?setid=#session.classabsorb.set#" >	
</cfif>

<cfif isdefined('Cancel')>
	<cflocation url="EditViewClassAbsorb.cfm?setid=#session.classabsorb.set#" >
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
  	
  	<!--- Get Data fOr Record --->
  	<cfquery name="GetData" datasource="BusinessPLUS" >
  		SELECT *
  		FROM Stipend_Abs_DTL
  		WHERE tbl_index = '#session.record#'	
  	</cfquery>
  	
  	<center>
  		<table border="1">
  			<tr>
				<th>Legal Name<br> (No Nicknames)</th>
				<th>Employee ID</th>
				<th>Date of Class Absorption</th>
				<th>Number of hours</th>
				<th>Hourly Rate</th>
				<th>Gross Amount</th>
				<th>Job ID</th>
				<th>Name of Teacher Subbed for</th>
			</tr>
			<cfform action="EditClassAbsorbRecord.cfm" method="post" name="EditRecord">
				<cfoutput query="GetData">
					<tr>
						<td><cfinput name="absName" type="text" value="#name#" class="txt-box"></td>
						<td><cfinput name="absEmpID" type="text" value="#empid#" class="txt-box"></td>
						<td><cfinput name="absJobDate" type="datefield" value="#jobdate#"></td>
						<td><cfinput name="absNumHours" type="text" value="#NumHours#" class="txt-box"></td>
						<td>33.99</td>
						<td>#GrossAmount#<br>will be recalculated on save</td>
						<td><cfinput name="absJobID" type="text" value="#jobid#" class="txt-box"></td>
						<td><cfinput name="absSubbedFor" type="text" value="#subbedfor#" class="txt-box"></td>
					</tr>
					<tr>
						<th colspan="4"><cfinput name="SaveRecord" type="submit" value="Save Record" class="submit-lu"></th>
						<th colspan="3"><cfinput name="Cancel" type="submit" value="Cancel" class="submit-lu"></th>
					</tr>
				</cfoutput>
			</cfform>
  		</table>
  	</center>
  	
  	
  	
  </body>
  </html>