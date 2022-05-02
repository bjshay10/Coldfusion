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
	<!--- Get user data from lanaccounts (3 digit school code) --->
	<cfquery name="getLanaccountInfo" datasource="lanaccounts" >
		SELECT BldgNum
		FROM accounts
		WHERE username = '#session.user.username#'
	</cfquery>
	
	<!--- Get school code and org name from Stipend_SchoolCodes --->
	<cfquery name="getSchCodeInfo" datasource="BusinessPLUS">
		SELECT *
		FROM Stipend_SchoolCodes
		WHERE SCHOOL_CODE = '#getLanaccountInfo.BldgNum#'
	</cfquery>
	
	<!--- Set building number --->
	<cfset session.building.bldgnum = '#getSchCodeInfo.SCHOOL_CODE#'>
	<cfset session.building.code = '#getSchCodeInfo.ALT_ID#'>
	<cfset session.building.Name = '#getSchCodeinfo.Organization_Name#'>
	
	<!--- Look for additional entry accesses one for Secretaries and one for princpal --->
	<cfquery name="SecSpecialAccess" datasource="BusinessPLUS">
		SELECT *
		FROM Stipend_Special_Access
		WHERE	username = '#session.user.username#' and accessLevel = 'Secretaries'
	</cfquery>
	<!---<cfif #SecSpecialAccess.RecordCount# neq 0>
		<cfset Session.user.special eq 'Sec'>
	</cfif>--->
	<cfquery name="PrinSpecialAccess" datasource="BusinessPLUS">
		SELECT *
		FROM Stipend_Special_Access
		WHERE username = '#session.user.username#' and accessLevel = 'Principals'
	</cfquery>
	<!---<cfif #PrinSpecialAccess.RecordCount# neq 0>
		<cfset Session.user.special eq 'Prin'>
	</cfif>--->

	<!---<cfdump var="#session.user#" ><br>
	<cfdump var="#structkeyexists(session, "user")#" ><br>--->
	<cfif (FindNoCase("Secretaries",session.user.memberOf) neq 0) or (#session.user.special# eq 'Sec')>
		<div class="row js--wp-1">
			<div class="col span-1-of-2 box">
				<H2>Planning Period Stipend</H2>
					<br>
					<a class="nav-link" href="new_ppstipend.cfm">New Planning Period Stipend</a><br>
					<a class="nav-link" href="PP_List.cfm">View/Edit Existing</a><br>
					<br>
			</div>
			<div class="col span-1-of-2 box">
				<h2>Absorbing Additional Students</h2>
					<br>
					<a class="nav-link" href="new_stipend.cfm?type=Absorb">New Class Absorption Stipend</a><br>
					<a class="nav-link" href="ClassAbsorbStipendList.cfm">View/Edit Existing</a><br>
					<br>
			</div>
		</div>
	<cfelseif (FindNoCase("Principals", session.user.memberof) neq 0) or (#session.user.special# eq 'Prin')>
		<div class="row js--wp-1">
			<div class="col span-1-of-2 box">
				<h2>Planning Period Stipend</h2><br>
				<a class="nav-link" href="PP_List.cfm">Planning Period Stipends</a><br>
				<!---<a class="nav-link" href="prinListStipends.cfm"> - Previous Stipends</a><br>--->
			</div>
			<div class="col span-1-of-2 box">	
				<h2>Absorbing Additional Students</h2>
					<br>
					<a class="nav-link" href="ClassAbsorbStipendList.cfm">Class Absorption Stipends</a><br>
					<!---<a class="nav-link" href="ClassAbsorbStipendList.cfm">- Previous Stipends</a><br>--->
			</div>
		</div>
	<cfelseif (FindNoCase("Human Resources", session.user.memberof) neq 0)>
		<div class="row js--wp-1">	
			<div class="col span-1-of-2 box">
				<h2>Planning Period Stipends</h2><br>
				<a class="nav-link" href="PP_List.cfm">Pending Approval</a><br>
				<!---<a class="nav-link" href="hrListStipends.cfm">- Previously approved</a><br>--->
			</div>
			<div class="col span-1-of-2 box">	
				<h2>Absorbing Additional Students</h2><br>
				<a class="nav-link" href="ClassAbsorbStipendList.cfm">Stipends</a><br>
			</div>
		</div>
		<div class="row js--wp-1">
			<div class="col span-1-of-2 box">
				<h2>Data</h2>
				<a class="nav-link" href="StipendsDataDump.cfm">Data Dump</a>
			</div>
		</div>
	<cfelseif (FindNoCase("Fiscal_Services", session.user.memberof) neq 0) OR (#session.user.username# eq 'abierman')>
		<div class="row js--wp-1">	
			<div class="col span-1-of-2 box">
				<h2>Planning Period Stipend</h2><br>
					<a href="payrollListStipends.cfm?view=Pending">Pending to be Exported</a><br>
					<a href="payrollExportStipends.cfm?view=ToBe">Export Stipends</a><br>
					- Exported<br>
			</div>
			<div class="col span-1-of-2 box">
				<h2>Absorbing Additional Students</h2><br>
					<a class="nav-link" href="ClassAbsorbStipendList.cfm">Stipends to Approve for Export</a><br>
					<a class="nav-link" href="ClassAbsorbStipendsExport.cfm">Export Approved Stipends</a><br>
					<a class="nav-link" href="ClassAbsorbStipendList.cfm">View Approved Stipends</a><br>
			</div>
		</div>
		<div class="row js--wp-1">
			<div class="col span-1-of-2 box">
				<h2>MOU Stipends</h2>
					<a class="nav-link" href="MOUStipendList.cfm">MOU Stipends to Approve for Export</a><br>
					<a class="nav-link" href="MOUStipendExport.cfm">Export Approved MOU Stipends</a><br>
					<a class="nav-link" href="MOUStipendListExported.cfm">View Approved MOU Stipends</a><br>
			</div>
			<div class="col span-1-of-2 box">
			</div>
		</div>
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
	
	</body>
	
	
	
  </html>  
 