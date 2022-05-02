<cfset pageTitle = "Home - Stipends WF">

<!--- lookup for Emplyee Doing the Subbing --->
<cfif isdefined('EmpLU')>
	<cfset session.period = '#form.ppPeriod#'>
	<cfset session.dateassigned = '#form.ppDateOfAssign#'>
	<cfset session.jobnumber = '#form.ppJobNum#'>
	<cflocation url="employeeLU.cfm?stype=E&source=P" >
</cfif>

<!--- lookup for the staff be subbed for --->
<cfif isdefined('StaffLU')>
	<cfset session.period = '#form.ppPeriod#'>
	<cfset session.dateassigned = '#form.ppDateOfAssign#'>
	<cfset session.jobnumber = '#form.ppJobNum#'>
	<cflocation url="employeeLU.cfm?stype=S&source=P" >
</cfif>

<cfif isdefined('fsetID')>
	<!--- get setid information --->
	<cfquery name="getInfo" datasource="BusinessPLUS">
		SELECT *
		FROM Stipend_PP_MSTR
		WHERE setid = '#fsetID#'
	</cfquery>	
	
	<cfset session.mstr.EnteredBy = '#getInfo.username#'>
	<cfset session.mstr.stipendset = '#getInfo.setid#'>
	<cfset session.mstr.building = '#getInfo.building#'>
	<cfset session.mstr.principal = '#getInfo.principal#'>
	<cfset session.mstr.enteredon = #dateformat(getInfo.enteredon,"mm/dd/yyyy")#>
</cfif>

<cfif isdefined('ppSave') or isdefined('ppSave2')>
	<!--- new guid value --->
	<!--- setid is set --->
	<cfset session.ppempName = '#form.ppLegalName#'>
	<cfset session.ppempID = '#form.ppEmpID#'>
	<cfset session.period = '#form.ppPeriod#'>
	<cfset session.dateassigned = '#form.ppDateOfAssign#'>
	<cfset session.jobnumber = '#form.ppJobNum#'>
	<cfset session.subbedfor = '#form.ppSubbedFor#'>
	<cfset session.dateentered = '#dateformat(NOW(), "mm/dd/yyyy")#'>
	<cfset session.ppComments = '#form.ppComments#'>
	
	<!--- Add comments to MSTR --->
	<cfquery name="updateMSTR" datasource="BusinessPLUS" >
		UPDATE Stipend_PP_MSTR
		SET comments = '#session.ppComments#'
		WHERE setid = '#session.mstr.stipendset#'	
	</cfquery>
	
	<cfif #session.ppempName# gt ''>
		<cfquery name="insertDTL" datasource="BusinessPLUS">
			INSERT INTO Stipend_PP_DTL 
				(tbl_index, setid, name, empid, period, dateassign, jobnumber, subbedfor, dateentered)
			VALUES
				(NEWID(), '#session.mstr.stipendset#', '#session.ppempName#', '#session.ppempID#', '#session.period#', '#session.dateassigned#', '#session.jobnumber#', '#session.subbedfor#', '#session.dateentered#')
		</cfquery>
	</cfif>
	
	<cfset StructDelete(Session,"LUName")>
	<cfset StructDelete(Session,"sLUName")>
	<cfset StructDelete(Session,"LUID")>
	<cfset StructDelete(session, "period")>
	<cfset StructDelete(Session,"dateassigned")>
	<cfset StructDelete(Session,"jobnumber")>
	<cfset StructDelete(Session,"ppComments")>	
	
</cfif>

<cfif isdefined('ppSubmit')>
	<!--- mark as submitted to principal --->
	<cfquery name="updateMSTR" datasource="BusinessPLUS">
		UPDATE Stipend_PP_MSTR
		SET submitted = 'Y'
		WHERE SetID = '#session.mstr.stipendset#'
	</cfquery>
	
	<cfquery name="getPrinEmail" datasource="BusinessPLUS">
		SELECT principal
		FROM Stipend_PP_MSTR
		WHERE SetID = '#session.mstr.stipendset#'
	</cfquery>
	
	<!--- save last record --->
	<cfif #form.ppLegalName# gt ''>
		<cfset session.ppempName = '#form.ppLegalName#'>
		<cfset session.ppempID = '#form.ppEmpID#'>
		<cfset session.period = '#form.ppPeriod#'>
		<cfset session.dateassigned = '#form.ppDateOfAssign#'>
		<cfset session.jobnumber = '#form.ppJobNum#'>
		<cfset session.subbedfor = '#form.ppSubbedFor#'>
		<cfset session.dateentered = '#dateformat(NOW(), "mm/dd/yyyy")#'>
		<cfset session.ppComments = '#form.ppComments#'>
		
		<!--- Add comments to MSTR --->
		<cfquery name="updateMSTR" datasource="BusinessPLUS" >
			UPDATE Stipend_PP_MSTR
			SET comments = '#session.ppComments#'
			WHERE SetID = '#session.mstr.stipendset#'	
		</cfquery>
		
		<cfif #session.ppempName# gt ''>
			<cfquery name="insertDTL" datasource="BusinessPLUS">
				INSERT INTO Stipend_PP_DTL 
					(tbl_index, setid, name, empid, period, dateassign, jobnumber, subbedfor, dateentered)
				VALUES
					(NEWID(), '#session.mstr.stipendset#', '#session.ppempName#', '#session.ppempID#', '#session.period#', '#session.dateassigned#', '#session.jobnumber#', '#session.subbedfor#', '#session.dateentered#')
			</cfquery>
		</cfif>
		
		<cfset StructDelete(Session,"LUName")>
		<cfset StructDelete(Session,"sLUName")>
		<cfset StructDelete(Session,"LUID")>
		<cfset StructDelete(session, "period")>
		<cfset StructDelete(Session,"dateassigned")>
		<cfset StructDelete(Session,"jobnumber")>
		<cfset StructDelete(Session,"ppComments")>	
	</cfif>
	
	<!--- email principal --->
	<cfmail from="hr@mesa.k12.co.us" subject="Planning Period Stipend" to="#getPrinEmail.principal#" type="html" bcc="bj.shay@d51schools.org">
		A Planning Period Stipend has been submitted for you to review.<br>
		<a href = 'https://apps.mesa.k12.co.us/stipends/'>https://apps.mesa.k12.co.us/stipends/</a>
	</cfmail>
	<!--- return to index.cfm --->
	<!--- get rid of session variables --->
	
	<cflocation url="index.cfm" >
</cfif>

<cfif isdefined('eLUName')>
	<cfset session.LUName = '#eLUName#'>
</cfif>

<cfif isdefined('eLUID')>
	<cfset session.LUID = '#eLUID#'>
</cfif>

<cfif isdefined('sLUName')>
	<cfset session.sLUName = '#sLUName#'>
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
	<h1>REQUEST FOR PLANNING PERIOD COMPENSATION WHEN<br>
SUBSTITUTING FOR CERTIFIED EMPLOYEE(S)</h1><br>

<!--- Text from PDF to describe the form --->
<p>
	Pay the following employee(s) a stipend from Account # 1600009011-52200 for using at least one full planning period to substitute teach for an unfilled absence as per MVEA agreement. Each full planning period (approximately 45 minutes) used to substitute teach will be compensated with a stipend of $33.99. No teacher will substitute teach during planning time more than once per week.
</p>
<br>
<p>
	Only as last resort, when no substitute teachers are available, may other teachers substitute during their planning time.
</p>
<br>
<p>
	In order to pay a planning period stipend to another teacher, the teacher absence must show in the Absence Management system and have a “failed to fill” status. The Absence Management system automatically updates anabsence status to “failed to fill” if a substitute has not been assigned to the absence after the absence start time.
</p>
<br>
<p>
	The original form must be received by the Substitute Office on the 10th working day of the month in order forit to be paid in the next payroll. Forms received after this deadline will be paid the following month.
</p>
<br>
<cfquery name="getSetStatus" datasource="BusinessPLUS">
	SELECT *
	FROM Stipend_PP_MSTR
	WHERE setid = '#session.mstr.stipendset#'
</cfquery>

<cfquery name="getDTL" datasource="BusinessPLUS">
	SELECT *
	FROM Stipend_PP_DTL
	WHERE setid = '#session.mstr.stipendset#'
</cfquery>

<cfquery name="getSetRecordCount" datasource="BusinessPLUS">
	SELECT *
	FROM Stipend_PP_DTL
	WHERE	setid = '#session.mstr.stipendset#' 	
</cfquery>

<!--- Table to enter data --->
	<center>
	<table border="1" class="stipend-new">
		<tr>
			<th colspan="2" align="center">Entered By: <cfoutput>#session.user.displayName#</cfoutput></th>
			<th colspan="2" align="center">Set ID: <cfoutput>PP#session.mstr.stipendset#</cfoutput></th>
			<th colspan="3" align="center">Record Count: <cfoutput>#getSetRecordCount.recordcount#</cfoutput></th>
		</tr>
		<tr>
			<th align="center" colspan="2">
				<cfif #getSetStatus.submitted# eq 'N'>
					Submitted: NO
				<cfelse>
					Submitted: YES
				</cfif>
			</th>
			<th align="center" colspan="3">Principal: <cfoutput>#getSetStatus.principal#</cfoutput></th>
			<th align="center" colspan="2">
				<cfif #getSetStatus.principal_app_deny# eq 'P'>
					Principal Status: PENDING	
				<cfelseif #getSetStatus.principal_app_deny# eq 'N'>
					Principal Status: DENIED
				<cfelse>
					Principal Status: APPROVED
				</cfif>
			</th>
		</tr>
		<tr>
			<th align="center" colspan="3">
				<cfif #getSetStatus.hr_app_deny# eq 'P'>
					HR Status: PENDING
				<cfelseif #getSetStatus.hr_app_deny# eq 'N'>
					HR Status: DENIED
				<cfelse>
					HR Status: APPROVED
				</cfif>
			</th>
			<th align="center" colspan="4">
				<cfif #getSetStatus.payroll_status# eq 'P'>
					Payroll Status: PENDING	
				<cfelseif #getSetStatus.payroll_status# eq 'N'>
					Payroll Status: DENIED
				<cfelse>
					Payroll Status: COMPLETE
				</cfif>
			</th>
		</tr>
		<tr>
			<th>Legal Name<br> (No Nicknames)</th>
			<th>Employee ID</th>
			<th># of Planning Period</th>
			<th>Date of Assign</th>
			<th>Job ID</th>
			<th>Name of Teacher Subbed for</th>
			<th>Edit/Delete</th>
		</tr>
		<cfoutput query="getDTL">
			<tr>
				<td>#name#</td>
				<td>#empid#</td>
				<td>#period#</td>
				<td>#DateFormat(dateassign, "mm/dd/yyyy")#</td>
				<td>#jobnumber#</td>
				<td>#subbedfor#</td>
				<td><a href="editStipendRecord.cfm?src=PPM&record=#tbl_index#">Edit</a> / <a href="deleteStipendRecord.cfm?src=PP&record=#tbl_index#">Delete</a></td>
			</tr>			
		</cfoutput>
		<!--- list existing enteries for the set --->
<cfform name="PPStipendEntry" action="PlanningPeriod.cfm" method="post">
		<tr>
			<!--- if e --->
			<cfif isdefined('session.LUName')>
				<td><cfinput name="ppLegalName" type="text" required="true" value="#session.LUName#" class="txt-box"><cfinput type="submit" name="EmpLU" value="Lookup" class="submit-lu"></td>
				<td><cfinput name="ppEmpID" type="text" value="#session.LUID#" class="txt-box"><cfinput type="submit" name="EmpLU" value="Lookup" class="submit-lu"></td>
			<cfelse>
				<td><cfinput name="ppLegalName" type="text" value="" class="txt-box"><cfinput type="submit" name="EmpLU" value="Lookup" class="submit-lu"></td>
				<td><cfinput name="ppEmpID" type="text" value="" class="txt-box"><cfinput type="submit" name="EmpLU" value="Lookup" class="submit-lu"></td>
			</cfif>
			<td>
				<cfif isdefined('session.period')>
					<cfselect name="ppPeriod" required="true" class="txt-box">
						<cfif #session.period# eq '00'><option value="00" selected="true">00</option><cfelse><option value="00">00</option></cfif>
						<cfif #session.period# eq '01'><option value="01" selected="true">01<cfelse><option value="01">01</option></cfif>
						<cfif #session.period# eq '02'><option value="02" selected="true">02<cfelse><option value="02">02</option></cfif>
						<cfif #session.period# eq '03'><option value="03" selected="true">03<cfelse><option value="03">03</option></cfif>
						<cfif #session.period# eq '04'><option value="04" selected="true">04<cfelse><option value="04">04</option></cfif>
						<cfif #session.period# eq '05'><option value="05" selected="true">05<cfelse><option value="05">05</option></cfif>
						<cfif #session.period# eq '06'><option value="06" selected="true">06<cfelse><option value="06">06</option></cfif>
						<cfif #session.period# eq '07'><option value="07" selected="true">07<cfelse><option value="07">07</option></cfif>
						<cfif #session.period# eq '08'><option value="08" selected="true">08<cfelse><option value="08">08</option></cfif>
						<cfif #session.period# eq '09'><option value="09" selected="true">09<cfelse><option value="09">09</option></cfif>
						<cfif #session.period# eq '10'><option value="10" selected="true">10<cfelse><option value="10">10</option></cfif>
						<cfif #session.period# eq '11'><option value="11" selected="true">11<cfelse><option value="11">11</option></cfif>
					</cfselect>
				<cfelse>
					<cfselect name="ppPeriod" required="true" class="txt-box">
						<option value="00">00</option>
						<option value="01">01</option>
						<option value="02">02</option>
						<option value="03">03</option>
						<option value="04">04</option>
						<option value="05">05</option>
						<option value="06">06</option>
						<option value="07">07</option>
						<option value="08">08</option>
						<option value="09">09</option>
						<option value="10">10</option>
						<option value="11">11</option>
					</cfselect>
				</cfif>
			</td>
			<td>
				<cfif isdefined('session.dateassigned')>
					<cfinput name="ppDateOfAssign" type="text" value="#DateFormat(session.dateassigned,"mm/dd/yyyy")#" class="txt-box">
				<cfelse>
					<cfinput name="ppDateOfAssign" type="text" value="#DateFormat(Now(),"mm/dd/yyyy")#" class="txt-box">
				</cfif> 
			</td>
			<td>
				<cfif isdefined('session.jobnumber')>
					<cfinput name="ppJobNum" type="text" value="#session.jobnumber#" class="txt-box"> 
				<cfelse>
					<cfinput name="ppJobNum" type="text" value="" class="txt-box">
				</cfif>
			</td>
			<!--- if edit --->
			<cfif isdefined('session.sLUName')>
				<td><cfinput name="ppSubbedFor" type="text" required="true" value="#session.sLUName#" class="txt-box"><cfinput type="submit" name="StaffLU" value="Lookup" class="submit-lu"></td>
			<cfelse>
				<td><cfinput name="ppSubbedFor" type="text" value="" class="txt-box"><cfinput type="submit" name="StaffLU" value="Lookup" class="submit-lu"></td>
			</cfif>
			<td><cfinput name="ppSave" type="submit" value="Save Record" class="submit-lu"></td>
		</tr>
		<tr>
			<cfif isdefined('session.ppComments')>
				<td colspan="7" align="center">
					Comments:<cftextarea name="ppComments" cols="75" rows="4" value="#session.ppComments#">		
					</cftextarea>
				</td>
			<cfelse>
				<td colspan="7" align="center">
					Comments:<cftextarea name="ppComments" cols="75" rows="4" value="">		
					</cftextarea>
				</td>
			</cfif>
		</tr>
		<tr>
			<td colspan="3" align='center'><cfinput name="ppSave2" type="submit" value="Save" class="submit"></td>
			<td colspan="4" align="center"><cfinput name="ppSubmit" type="submit" value="Submit To Principal" class="submit"></td>
		</tr>
</cfform>
	</table>
<!---<a href="index.cfm">HOME</a>--->
	</center>

<p>
	Classified employees may not be paid with stipends; they must be paid for work on an hourly basis with time cards.
</p>
<p>
	This form must be signed by the principal or assistant principal
</p>


<!---<cfdump var="#session.mstr#">--->
  <cfinclude template="footer.cfm">