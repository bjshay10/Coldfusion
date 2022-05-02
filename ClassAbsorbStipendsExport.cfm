 <cfset pageTitle = "Home - Stipends WF">

<!--- if button to export is pressed --->
<cfif isdefined('ExportSet')>
<!---Export data --->
	<cfset session.batchName = '#batchID#'>
	<cfset session.payPeriod = '#payPeriod#'>
	<cfset tempDateExported = '#dateformat(NOW(), "mm/dd/yyyy")#'>
	
	<cfquery name="getApprovedSets" datasource="BusinessPLUS" >
		SELECT *
		FROM Stipend_Abs_MSTR M INNER JOIN Stipend_Abs_DTL D ON
			M.setid = D.setid
		WHERE m.payroll_status = 'A'	
	</cfquery>
	
	<!--- Set File Name --->
	<cfset tempFileName = '#session.batchName#'>
	
	<cffile action="write" file="\\bplus71db\data$\#tempFileName#" charset="utf-8" output="EMP-ID,BATCH-NAME,PAY-PERIOD,DATE,HRS,HRS-NO,PAY-AMT,PAY-OVR,GLKEY,GLOBJ">
	
	<cfloop query="getApprovedSets">
		<cfset writeLine = ''>
		<cffile action="append" file="\\bplus71db\data$\#tempFileName#" output="#empid#,#session.batchName#,#session.payPeriod#,#dateformat(dateentered, 'yyyymmdd')#,,3148,#grossamount#,Y,1600009011,52200" >1
	</cfloop>	

<!--- mark as exported --->
	<cfquery name="MarkExported" datasource="BusinessPLUS" >
		UPDATE Stipend_Abs_MSTR
		SET payroll_status = 'E',
			ExportDate = '#tempDateExported#'
		WHERE payroll_status = 'A'
	</cfquery>
<!--- go back to home page --->
	<cflocation url="index.cfm" >
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
	
	<!--- Get approved for export stipends --->
	<cfquery name="ToBeExported" datasource="businessPLUS">
		SELECT *
		FROM Stipend_Abs_MSTR
		WHERE payroll_status = 'A'
	</cfquery>
	<!--- Display the list --->
	<center>
		<table border="1" >
			<tr>
				<th>Set ID:</th>
				<th>Entered By:</th>
				<th>Entered On:</th>
			</tr>
			<cfform name="ExportStipends" action="ClassAbsorbStipendsExport.cfm" method="post">
				<cfoutput query="ToBeExported">
					<tr>
						<td>CA#setid#</td>
						<td>#username#</td>
						<td>#LSDateFormat(enteredon, "mm-dd-yyyy")#</td>
					</tr>
				</cfoutput>
				<tr>
					<td colspan="1">Batch ID: </td>
					<cfset batchid = 'TC'&'#LSDateFormat(NOW(), "mmddyy")#'>
					<td colspan="2"><cfinput name="batchID" type="text" required="true" class="txt-box" value="#batchid#"></td>
				</tr>
				<tr>
					<td>Pay Period:</td>
					<td colspan="2"><cfinput name="payPeriod" type="text" required="true" class="txt-box" value=""></td>
				</tr>
				<tr>
					<td colspan="3" align="center"><cfinput name="ExportSet" type="submit" value="Export" class="submit-lu"></td>
				</tr>
			</cfform>
		</table>
		<div class="row js--wp-1">
			<a href="index.cfm"><h3>Home</h3></a><br>
		</div>
	</center>
	<!--- Button to Export --->
</body>
</html>