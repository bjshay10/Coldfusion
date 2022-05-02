<cfset pageTitle = "Home - Stipends WF">

<!--- lookup for Emplyee Doing the Subbing --->
<cfif isdefined('EmpLU')>
	<cfset session.NumHours = '#form.NumHours#'>
	<cfset session.jobnumber = '#form.ppJobNum#'>
	<cflocation url="employeeLU.cfm?stype=E&source=A" >
</cfif>

<!--- lookup for the staff be subbed for --->
<cfif isdefined('StaffLU')>
	<cfset session.NumHours = '#form.NumHours#'>
	<cfset session.jobnumber = '#form.ppJobNum#'>
	<cflocation url="employeeLU.cfm?stype=S&source=A" >
</cfif>

<cfif isdefined('fsetID')>
	<!--- get setid information --->
	<cfquery name="getInfo" datasource="BusinessPLUS">
		SELECT *
		FROM Stipend_Abs_MSTR
		WHERE setid = '#fsetID#'
	</cfquery>	
	
	<cfset session.mstr.EnteredBy = '#getInfo.username#'>
	<cfset session.mstr.stipendset = '#getInfo.setid#'>
	<cfset session.mstr.building = '#getInfo.building#'>
	<cfset session.mstr.principal = '#getInfo.principal#'>
	<cfset session.mstr.enteredon = #dateformat(getInfo.enteredon,"mm/dd/yyyy")#>
</cfif>

<cfif isdefined('ppSave') or isdefined('caSave')>
	<!--- new guid value --->
	<!--- setid is set --->
	<cfset session.ppempName = '#form.ppLegalName#'>
	<cfset session.ppempID = '#form.ppEmpID#'>
	
	<cfset session.jobDate = '#dateformat(form.jobDate, "mm/dd/yyyy")#'>
	
	<cfset session.jobnumber = '#form.ppJobNum#'>
	<cfset session.subbedfor = '#form.ppSubbedFor#'>
	<cfset session.dateentered = '#dateformat(NOW(), "mm/dd/yyyy")#'>
	<cfif session.ppempName gt ''>
		<cfset session.NumHours = '#form.NumHours#'>
		<cfset session.grossamount = NumberFormat(#form.NumHours# * 33.99, '___.__')>
	
		<cfquery name="insertDTL" datasource="BusinessPLUS">
			INSERT INTO Stipend_Abs_DTL 
				(tbl_index, setid, name, empid, numhours, GrossAmount, jobid, subbedfor, dateentered, jobdate)
			VALUES
				(NEWID(), '#session.mstr.stipendset#', '#session.ppempName#', '#session.ppempID#', '#session.Numhours#', '#session.grossamount#', '#session.jobnumber#', '#session.subbedfor#', '#session.dateentered#', '#session.jobDate#')
		</cfquery>
	</cfif>
	
	<cfset session.caComments = '#form.ppComments#'>
	<cfquery name="updateMSTR" datasource="BusinessPLUS" >
		UPDATE 	Stipend_Abs_MSTR
		set comments = '#session.caComments#'
		WHERE SetID = '#session.mstr.stipendset#'
	</cfquery>
	
	<cfset StructDelete(Session,"LUName")>
	<cfset StructDelete(Session,"sLUName")>
	<cfset StructDelete(Session,"LUID")>
	<cfset StructDelete(Session,"numhours")>
	<cfset StructDelete(Session,"jobnumber")>
	
</cfif>

<cfif isdefined('ppSubmit')>
	<!--- mark as submitted to principal --->
	<cfquery name="updateMSTR" datasource="BusinessPLUS">
		UPDATE Stipend_Abs_MSTR
		SET submitted = 'Y'
		WHERE SetID = '#session.mstr.stipendset#'
	</cfquery>
	
	<cfquery name="getPrinEmail" datasource="BusinessPLUS">
		SELECT principal
		FROM Stipend_Abs_MSTR
		WHERE SetID = '#session.mstr.stipendset#'
	</cfquery>
	
	<!--- Update db with last row if there is any --->
	<cfif #form.ppLegalName# gt ''>
		<cfset session.ppempName = '#form.ppLegalName#'>
		<cfset session.ppempID = '#form.ppEmpID#'>
		
		
		<cfset session.jobnumber = '#form.ppJobNum#'>
		<cfset session.subbedfor = '#form.ppSubbedFor#'>
		<cfset session.dateentered = '#dateformat(NOW(), "mm/dd/yyyy")#'>
		<cfif session.ppempName gt ''>
			<cfset session.NumHours = '#form.NumHours#'>
			<cfset session.grossamount = NumberFormat(#form.NumHours# * 33.99, '___.__')>
		
			<cfquery name="insertDTL" datasource="BusinessPLUS">
				INSERT INTO Stipend_Abs_DTL 
					(tbl_index, setid, name, empid, numhours, GrossAmount, jobid, subbedfor, dateentered)
				VALUES
					(NEWID(), '#session.mstr.stipendset#', '#session.ppempName#', '#session.ppempID#', '#session.Numhours#', '#session.grossamount#', '#session.jobnumber#', '#session.subbedfor#', '#session.dateentered#')
			</cfquery>
		</cfif>
		
		<cfset session.caComments = '#form.ppComments#'>
		<cfquery name="updateMSTR" datasource="BusinessPLUS" >
			UPDATE 	Stipend_Abs_MSTR
			set comments = '#session.caComments#'
			WHERE SetID = '#session.mstr.stipendset#' 
		</cfquery>
		
		<cfset StructDelete(Session,"LUName")>
		<cfset StructDelete(Session,"sLUName")>
		<cfset StructDelete(Session,"LUID")>
		<cfset StructDelete(Session,"numhours")>
		<cfset StructDelete(Session,"jobnumber")>
	</cfif>
	<!--- email principal --->
	<cfmail from="hr@mesa.k12.co.us" subject="Class Absorption Stipend" to="#getPrinEmail.principal#" type="html"  bcc="bj.shay@d51schools.org">
		A Class Absorption Stipend has been submitted for you to review.<br>
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
    	
    <title>Stipend - Class Absorption</title>

   </head>
   
   <cfinclude template="header.cfm">
   
<body>
	<h1>REQUEST FOR COMPENSATION WHEN ABSORBING ADDITIONAL STUDENTS AS A RESULT OF A FAILED TO FILL SUB JOB</h1><br>

<!--- Text from PDF to describe the form --->
<p>
	Pay the following employee(s) a stipend from Account # 1600009011-52200 for absorbing students into their class as a result of an unfilled absence per MVEA agreement:
</p><br>

<p>
	When a substitute teacher or administrator is not available to cover a teacher's absence, other teachers may incorporate the students into their classroom for the day.  When multiple teachers or counselors incorporate the students into their classroom they will split a stipend based on the hourly wage of the District's maximum teacher salary times the number of hours the teacher is with the students (maximum of 5.5 hours per day).  Probationary teachers or teacher or counselors on a T/CIP Building Support Plan or District Support Plan will be eligable to cover classes after consultation with an administrator.
</p><br>

<p>
	In order to pay a planning period stipend to another teacher, the teacher absence must show in the Absence Management system and have a “failed to fill” status. The Absence Management system automatically updates an absence status to “failed to fill” if a substitute has not been assigned to the absence after the absence start time.
</p><br>
<p>
	The original form must be received by the Substitute Office on the 10th working day of the month in order for it to be paid in the next payroll. Forms received after this deadline will be paid the following month.
</p><br>

<cfquery name="getSetStatus" datasource="BusinessPLUS">
	SELECT *
	FROM Stipend_Abs_MSTR
	WHERE setid = '#session.mstr.stipendset#'
</cfquery>

<cfquery name="getDTL" datasource="BusinessPLUS">
	SELECT *
	FROM Stipend_Abs_DTL
	WHERE setid = '#session.mstr.stipendset#'
</cfquery>

<cfquery name="getSetRecordCount" datasource="BusinessPLUS">
	SELECT *
	FROM Stipend_Abs_DTL
	WHERE	setid = '#session.mstr.stipendset#' 	
</cfquery>

<!--- Table to enter data --->
	<center>
	<table border="1" class="stipend-new">
		<tr>
			<th colspan="3" align="center">Entered By: <cfoutput>#session.user.displayName#</cfoutput></th>
			<th colspan="3" align="center">Set ID: <cfoutput>CA#session.mstr.stipendset#</cfoutput></th>
			<th colspan="3" align="center">Record Count: <cfoutput>#getSetRecordCount.recordcount#</cfoutput></th>
		</tr>
		<tr>
			<th align="center" colspan="3">
				<cfif #getSetStatus.submitted# eq 'N'>
					Submitted: NO
				<cfelse>
					Submitted: YES
				</cfif>
			</th>
			<th align="center" colspan="3">Principal: <cfoutput>#getSetStatus.principal#</cfoutput></th>
			<th align="center" colspan="3">
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
			<th align="center" colspan="4">
				<cfif #getSetStatus.hr_app_deny# eq 'P'>
					HR Status: PENDING
				<cfelseif #getSetStatus.hr_app_deny# eq 'N'>
					HR Status: DENIED
				<cfelse>
					HR Status: APPROVED
				</cfif>
			</th>
			<th align="center" colspan="5">
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
			<th>Date of Class Absorption</th>
			<th># of Hours<br> (MAX 5.5)</th>
			<th>Hourly Rate</th>
			<th>Gross Amount</th>
			<th>Job ID</th>
			<th>Name of Teacher Subbed for</th>
			<th>Edit/Delete</th>
		</tr>
		<cfoutput query="getDTL">
			<tr>
				<td>#name#</td>
				<td>#empid#</td>
				<td>#DateFormat(jobdate, "mm/dd/yyyy")#</td>
				<td>#NumHours#</td>				
				<td>33.99</td>
				<td>#GrossAmount#</td>
				<td>#jobid#</td>
				<td>#subbedfor#</td>
				<td><a href="EditClassAbsorbRecord.cfm?record=#tbl_index#">Edit</a><br> / <a href="deleteStipendRecord.cfm?record=#tbl_index#">Delete</a></td>
			</tr>			
		</cfoutput>
		<!--- list existing enteries for the set --->
<cfform name="PPStipendEntry" action="ClassAbsorb.cfm" method="post">
		<tr>
			<!--- if e --->
			<cfif isdefined('session.LUName')>
				<td><cfinput name="ppLegalName" type="text" required="true" value="#session.LUName#" class="txt-box"><cfinput type="submit" name="EmpLU" value="Lookup" class="submit-lu"></td>
				<td><cfinput name="ppEmpID" type="text" value="#session.LUID#" class="txt-box"><cfinput type="submit" name="EmpLU" value="Lookup" class="submit-lu"></td>
			<cfelse>
				<td><cfinput name="ppLegalName" type="text" value="" class="txt-box"><cfinput type="submit" name="EmpLU" value="Lookup" class="submit-lu"></td>
				<td><cfinput name="ppEmpID" type="text" value="" class="txt-box"><cfinput type="submit" name="EmpLU" value="Lookup" class="submit-lu"></td>
			</cfif>
			<cfif isdefined('session.dateofassign')>
				<td><cfinput name="jobDate" type="date" value="#session.jobDate#" class="txt-box"></td>
			<cfelse>
				<td><cfinput name="jobDate" type="date" value="" class="txt-box"></td>
			</cfif>
			<cfif isdefined('session.numhours')>
				<td><cfinput name="NumHours" type="text" value="#session.numhours#" class="txt-box"></td>
			<cfelse>
				<td><cfinput name="NumHours" type="text" value="" class="txt-box"></td>
			</cfif>
			<td>33.99 </td>
			<td>will calculate on save</td>
			<cfif isdefined('session.jobnumber')>
				<td><cfinput name="ppJobNum" type="text" value="#session.jobnumber#" class="txt-box"> </td>
			<cfelse>
				<td><cfinput name="ppJobNum" type="text" value="" class="txt-box"> </td>
			</cfif>
			<!--- if s --->
			<cfif isdefined('session.sLUName')>
				<td><cfinput name="ppSubbedFor" type="text" required="true" value="#session.sLUName#" class="txt-box"><cfinput type="submit" name="StaffLU" value="Lookup" class="submit-lu"></td>
			<cfelse>
				<td><cfinput name="ppSubbedFor" type="text" value="" class="txt-box"><cfinput type="submit" name="StaffLU" value="Lookup" class="submit-lu"></td>
			</cfif>
			<td><cfinput name="ppSave" type="submit" value="Save Record" class="submit-lu"></td>
		</tr>
		<tr>
			<td colspan="9" align="center">
				Comments:<cftextarea name="ppComments" cols="75" rows="4" value="#getSetStatus.comments#">		
				</cftextarea>
			</td>
		</tr>
		<tr>
			<td colspan="4" align="center"><cfinput name="caSave" type="submit" value="Save" class="submit"></td>
			<td colspan="5" align="center"><cfinput name="ppSubmit" type="submit" value="Submit To Principal" class="submit"></td>
		</tr>
</cfform>
	</table>
	</center>
<br>
<p>
	Classified employees may not be paid with stipends; they must be paid for work on an hourly basis with time cards.
</p>
<br>
<p>
	This form must be signed by the principal or assistant principal
</p>
  <cfinclude template="footer.cfm">

<!---<cfdump var="#session.mstr#">--->
</body>