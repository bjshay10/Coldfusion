<cfset pageTitle = "Home - Stipends WF">

<cfif isdefined('Export')>
	<cfset session.batchName = '#batchName#'>
	<cfset session.payPeriod = '#payPeriod#'>
	<cfset tempPPDateExported = '#dateformat(NOW(), "mm/dd/yyyy")#'>
	
	
	<!--- get data --->
	<cfquery name="getApprovedSets" datasource="BusinessPLUS">
		SELECT *
		FROM Stipend_PP_MSTR M INNER JOIN Stipend_PP_DTL D ON
				M.setid = D.setid
		WHERE payroll_status = 'A'	
	</cfquery>
	
	
	
	<!--- write to file --->
	<cfset tempFileName = '#session.batchName#'>
	
	<cffile action="write" file="\\bplus71db\data$\#tempFileName#" charset="utf-8" output="EMP-ID,BATCH-NAME,PAY-PERIOD,DATE,HRS,HRS-NO,RT,RT-OVR,GLKEY,GLOBJ">
	<cfloop query="getApprovedSets">
		<!--- empid, batchname, recno, payperiod, date (yyyymmdd),hrs,hrsno,hrscode,hrsovr,--->
		<cfset writeLine = ''>
		<cfset tempPayPeriod = #session.payPeriod# & repeatstring(" ", 8 - len(#session.payPeriod#))>
		<!---pad strings--->
		<!---<cfset tempid = '#empid#'>
		<cfset tempid = #tempid# & repeatstring(" ", 12 - len(#tempid#))>
		<cfset tempBatchID = '#session.batchName#'>
		<cfset tempBatchID = #tempBatchID# & repeatstring(" ", 16 - len(#session.batchName#))>
		<cfset tempRecNo = repeatstring(" ", 9)>
		<cfset tempPayPeriod = #session.payPeriod# & repeatstring(" ", 8 - len(#session.payPeriod#))>
		<cfset blank8 = repeatstring(" ", 8)>
		<cfset blank1 = " ">
		<cfset blank9 = repeatstring(" ", 9)>
		<cfset blank4 = repeatstring(" ", 4)>
		<cfset blank10 = repeatstring(" ", 10)>
		<cfset blank2 = "  ">
		<cfset key = "1600009011"  & repeatstring(" ", 30)>
		<cfset object = "52200" & repeatstring(" ", 3)>
		<cfset blank40 = repeatstring(" ", 40)>
		<cfset blank12 = repeatstring(" ", 12)>
		<cfset blank20 = repeatstring(" ", 20)>
		<cffile action="append" file="C:/ColdFusion2018/cfusion/wwwroot/StipendWF/TempFileDestination/#tempFileName#" output="#tempid##tempBatchID##tempRecNo##tempPayPeriod##dateformat(dateentered, 'yyyymmdd')#0000001.003006#blank8##blank1#000033.99Y#blank9##blank9##blank1##blank2##blank1##blank9##blank4##blank10##blank4##blank2##key##object##blank2##blank40##blank8##blank10##blank12##blank12##blank8##blank8##blank8##blank20##blank20##blank20##blank20##blank20##blank20##blank20##blank20##blank20##blank12##blank12##blank12##blank12##blank12##blank12##blank12##blank12##blank12##blank12##blank12##blank12##blank12##blank12##blank12##blank12##blank12##blank12##blank12##blank12##blank12##blank12##blank12#" >
		
		<cffile action="append" file="\\bplusap\data$\#tempFileName#" output="#empid#,#session.batchName#,#session.payPeriod#,#dateformat(dateentered, 'yyyymmdd')#,1.00,3147,33.99,Y,1600009011,52200" >
		--->
		<!--- set temp amount for Num periods * rate --->
		<cfset tempamount = 33.99 * #getApprovedSets.period#>
		<cffile action="append" file="\\bplus71db\data$\#tempFileName#" output="#empid#,#session.batchName#,#session.payPeriod#,#dateformat(dateentered, 'yyyymmdd')#,#tempPayPeriod#,3147,#tempamount#,Y,1600009011,52200" >
	</cfloop> 
	<!--- mark sets as Exported ('E') --->
	<cfquery name="MarkExported" datasource="BusinessPLUS" >
		UPDATE Stipend_PP_MSTR
		SET payroll_status = 'E',
			ExportDate = '#tempPPDateExported#'
		WHERE payroll_status = 'A'
	</cfquery> 
	<!--- go to index --->
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
	
	<!--- Get list of stipends to be exported --->
	<cfquery name="getStipends" datasource="BusinessPLUS">
		SELECT *
		FROM Stipend_PP_MSTR
		WHERE payroll_status = 'A'
	</cfquery>
	<cfform action="payrollExportStipends.cfm" method="post" name="exportStipends">
		<center>
			<table border="1" align="center" >
				<tr>
					<th colspan="3">Stipends to Be exported</th>
				</tr>
						
				<tr>
					<td colspan="2">Batch Name:<br><cfinput type="text" name="batchName" required="yes"></td>
					<td>Pay Period:<br><cfinput name="payPeriod" type="text" required="yes"></td>
				</tr>
				<tr>
					<th>SetID</th>
					<th>building</th>
					<th>Entered On</th>
				</tr>
				<cfoutput query="getStipends">
					<tr>
						<td>PP#setid#</td>
						<td>#building#</td>
						<td>#dateformat(enteredon, "mm/dd/yyyy")#</td>
					</tr>
				</cfoutput>
				<tr>
					<td colspan="3" align="center"><cfinput name="Export" type="submit" value="Export" class="submit"></td>
				</tr>
			</table>
			<div class="row js--wp-1">
				<a href="index.cfm"><h3>Home</h3></a><br>
			</div>
		</center>
	</cfform>
</body>
</html>