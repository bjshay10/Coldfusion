<cfset pageTitle = "Home - Stipends WF">

<!--- next is clicked --->
<cfif isdefined('submit')>
	<!--- update variables --->
	<cfset session.mstr.EnteredBy = '#session.user.username#'>
	<cfset session.mstr.stipendset = '#RIGHT(form.setid,6)#'>
	<cfset session.mstr.building = '#session.user.building#'>
	<cfset session.mstr.principal = '#form.principal#'>
	<cfset session.mstr.enteredon = #dateformat(NOW(),"mm/dd/yyyy")#>
	<!--- move to PlanningPeriod.cfm --->
	
	<!--- P's for the status is for pendeing'--->
	<cfquery name="insertMSTR" datasource="BusinessPLUS">
		INSERT INTO Stipend_Abs_MSTR	(tbl_Index, setid, username, building, principal, enteredon, principal_app_deny, hr_app_deny, payroll_status, submitted, FiscalYR)
		VALUES (NEWID(), '#session.mstr.stipendset#', '#session.mstr.EnteredBy#', '#session.building.bldgnum#', rtrim('#session.mstr.principal#'), '#session.mstr.enteredon#', 'P','P','P', 'N','#Session.FiscalYR#')
	</cfquery>
	
	<cflocation url="ClassAbsorb.cfm">
</cfif>

<cfif type eq 'Absorb'>
	<cfset Session.StipendType = 'Absorb'>
</cfif>

<!DOCTYPE html>
<html lang="en">



  <head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Stipends Application">
    <meta name="author" content="BJS">
    
    <cfif #session.StipendType# eq 'Absorb'>	
    	<title>Stipend - New Class Absorption</title>
    </cfif>

   </head>
   
   <cfinclude template="header.cfm">
   
<body>	
	<!--- new set id --->
	<!--- old <cfset session.StipendSet =  'A'&'#session.building.code#'&'#dateformat(NOW(), "mmddyy")#'>--->
	
	<!--- check for Set uniquness --->
	<cfquery name="GetNextSetID" datasource="BusinessPLUS" >
		SELECT (MAX(setid) + 1) as NewID
		FROM Stipend_Abs_Mstr	
	</cfquery>	
	
	<cfset session.StipendSet = 'CA'&'#NUMBERFORMAT(GetNextSetID.NewID, "000009")#'>
	
	
	<!--- principal lookup --->
	<cfquery name="prinLookup" datasource="BusinessPLUS">
		SELECT E_MAIL
		FROM IFAS_DIRECTORY_LOC_VIEW INNER JOIN hr_empmstr ON
			IFAS_DIRECTORY_LOC_VIEW.EVAL_ID = hr_empmstr.ID
		WHERE Location = '#session.building.bldgnum#' 	
	</cfquery>
	<!--- if user is in SpecialAccess then get matching principal --->
	<cfquery name="CheckSpecialAccess" datasource="BusinessPLUS">
		SELECT *
		FROM Stipend_Special_Access
		WHERE	username = '#session.user.username#' and accessLevel = 'Secretaries' 
	</cfquery>
	
	<cfif #CheckSpecialAccess.RecordCount# neq 0>
		<!--- get matching "principal" --->
		<cfquery name="GetSpecAccPrin" datasource="BusinessPLUS">
			SELECT 	*
			FROM 	Stipend_Special_Access
			WHERE	accessLevel = 'Principals' and building = '#CheckSpecialAccess.building#'
		</cfquery>
		
		<!--- get email --->
		<cfquery name="GetEmail" datasource="BusinessPLUS">
			SELECT 	e_mail
			FROM	hr_empmstr
			WHERE	HR12 = '#GetSpecAccPrin.username#'
		</cfquery>
		<cfset session.principalEmail = #GetEmail.e_mail#>
	<cfelse>
		<cfset session.principalEmail = #prinLookup.E_Mail#>
	</cfif>
	
	<cfform name="abs_stipend_mstr" action="New_Stipend.cfm" method="post">
	<center>
		<table id="new-pp-stipend-table">
			<cfif #session.StipendType# eq 'Absorb'>
				<th id="new-pp-stipend-th" colspan="2">NEW - REQUEST FOR ABSORPTION COMPENSATION WHEN<br></th>
			</cfif>
	SUBSTITUTING FOR CERTIFIED EMPLOYEE(S)<br><br></th>
			<tr id="new-pp-stipend-tr">
				<td id="new-pp-stipend-td">Entered By:</td>
				<td id="new-pp-stipend-td"><cfinput type="text" name="userDisplayName" value="#session.user.displayname#" size=40 class="txt-box"></td>
			</tr>
			<tr id="new-pp-stipend-tr">
				<td id="new-pp-stipend-td">Location:</td>
				<td id="new-pp-stipend-td"><cfinput type="text" name="userLocation" value="#session.user.building#"  size=40 class="txt-box"></td>
			</tr>
			<tr id="new-pp-stipend-tr">
				<td id="new-pp-stipend-td">New Set ID:</td>
				<td id="new-pp-stipend-td"><cfinput type="text" name="setID" value="#session.stipendset#"  size=40 class="txt-box"></td>
			</tr>
			<!--- list principals and ap's of school--->
			<tr id="new-pp-stipend-tr">
				<td id="new-pp-stipend-td">Administrator to Approve:</td>
				<td id="new-pp-stipend-td"><cfinput type="text" name="principal" value="#session.principalEmail#" size=40 class="txt-box"></td>
			</tr>
			<tr>
				<td colspan="2" align="center"><cfinput name="submit" type="submit" value="Next" class="submit"> </td>
			</tr>
		</table>
		<div class="row js--wp-1">
			<a href="index.cfm"><h3>Home</h3></a><br>
		</div>
	</center>
	</cfform>
</body>

</html>