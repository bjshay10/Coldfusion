<cfset pageTitle = "Home - Stipends WF">

<cfif isdefined('editview')>
	<cfset session.classabsrob.ev = '#editview#'>
</cfif>

<cfif isdefined('setid')>
	<cfset session.classabsorb.set = '#setid#'>
</cfif>

<!--- lookup for Emplyee Doing the Subbing --->
<cfif isdefined('EmpLU')>
	<cfset session.NumHours = '#form.NumHours#'>
	<cfset session.jobnumber = '#form.ppJobNum#'>
	<cflocation url="employeeLU.cfm?stype=E&source=EV" >
</cfif>

<!--- lookup for the staff be subbed for --->
<cfif isdefined('StaffLU')>
	<cfset session.NumHours = '#form.NumHours#'>
	<cfset session.jobnumber = '#form.ppJobNum#'>
	<cflocation url="employeeLU.cfm?stype=S&source=EV" >
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

<!--- Submit Set to principal --->
<cfif isdefined('SubmitSet')>
	<!--- mark as submitted to principal --->
	<cfquery name="updateMSTR" datasource="BusinessPLUS">
		UPDATE Stipend_Abs_MSTR
		SET submitted = 'Y'
		WHERE SetID = '#session.classabsorb.set#'
	</cfquery>
	
	<!--- email principal --->
	<cfmail from="hr@mesa.k12.co.us" subject="Class Absorption Stipend" to="bj.shay@d51schools.org" type="html">
		A Class Absorption Stipend has been submitted for you to review.<br>
		<a href = 'https://apps.mesa.k12.co.us/stipends/'>https://apps.mesa.k12.co.us/stipends/</a>
	</cfmail>
	<!--- return to index.cfm --->
	<!--- get rid of session variables --->
	
	<cflocation url="index.cfm" >
</cfif>

<!--- Save Record --->
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
				(NEWID(), '#session.classabsorb.set#', '#session.ppempName#', '#session.ppempID#', '#session.Numhours#', '#session.grossamount#', '#session.jobnumber#', '#session.subbedfor#', '#session.dateentered#', '#session.jobDate#')
		</cfquery>
	</cfif>
	
	<cfset session.caComments = '#form.ppComments#'>
	<cfquery name="updateMSTR" datasource="BusinessPLUS" >
		UPDATE 	Stipend_Abs_MSTR
		set comments = '#session.caComments#'
		WHERE SetID = '#session.classabsorb.set#'
	</cfquery>
	
	<cfset StructDelete(Session,"LUName")>
	<cfset StructDelete(Session,"sLUName")>
	<cfset StructDelete(Session,"LUID")>
	<cfset StructDelete(Session,"numhours")>
	<cfset StructDelete(Session,"jobnumber")>
	
</cfif>

<!--- Delete Record --->
<cfif isdefined('delete')>
	<!--- delete record provided --->
	
	<cfquery name="DeleteRecord" datasource="BusinessPLUS" >
		DELETE FROM Stipend_Abs_DTL
		WHERE tbl_index = '#record#'
	</cfquery>
</cfif>

<!--- Principals --->
<!--- Approve --->
<cfif isdefined('PrinApprove')>
	<!--- Update DB --->
	<cfset dateApproved = '#dateformat(NOW(), "mm/dd/yyyy")#'>
	
	<cfquery name="UpdateDB" datasource="BusinessPLUS">
		UPDATE Stipend_Abs_MSTR
		SET principal_app_deny = 'Y',
			principal_app_deny_date = '#dateApproved#'
		WHERE setid = '#session.classabsorb.set#'
	</cfquery>
	
	<!--- Email HR --->
	<cfmail from="bj.shay@d51schools.org" subject="Pending Stipends" to="rachel.talley@d51schools.org" type="html" >
		You have pending stipends to approve or deny.<br><br>
		<a href = 'https://apps.mesa.k12.co.us/stipends/'>https://apps.mesa.k12.co.us/stipends/</a>		
	</cfmail>
	
	<!--- Back to Absorb Stipend Screen --->
	<cflocation url="ClassAbsorbStipendList.cfm">
</cfif>
<!--- Deny --->
<cfif isdefined('PrinDeny')>
	<!--- Update DB --->
	<cfset dateApproved = '#dateformat(NOW(), "mm/dd/yyyy")#'>
	
	<cfquery name="UpdateDB" datasource="BusinessPLUS">
		UPDATE Stipend_Abs_MSTR
		SET principal_app_deny = 'N',
			principal_app_deny_date = '#dateApproved#'
		WHERE setid = '#session.classabsorb.set#'
	</cfquery>
	
	<!--- Back to Absorb Stipend Screen --->
	<cflocation url="ClassAbsorbStipendList.cfm">
</cfif>
<!--- hr save --->
<cfif isdefined('hrsave')>
	<cfquery name="UpdateDB" datasource="BusinessPLUS">
		UPDATE Stipend_Abs_MSTR
		SET comments = '#form.hrComments#'
		WHERE setid = '#session.classabsorb.set#'
	</cfquery>
</cfif>
<!--- Approve --->
<cfif isdefined('HRApprove')>
	<!--- Update DB --->
	<cfset dateApproved = '#dateformat(NOW(), "mm/dd/yyyy")#'>
	
	<cfquery name="UpdateDB" datasource="BusinessPLUS">
		UPDATE Stipend_Abs_MSTR
		SET hr_app_deny = 'Y',
			hr_app_deny_date = '#dateApproved#',
			comments = '#form.hrComments#'
		WHERE setid = '#session.classabsorb.set#'
	</cfquery>
	
	<!--- Email HR --->
	<cfmail from="bj.shay@d51schools.org" subject="Pending Stipends" to="bj.shay@d51schools.org" type="html" >
		You have pending stipends to approve or deny.<br><br>
		<a href = 'https://apps.mesa.k12.co.us/stipends/'>https://apps.mesa.k12.co.us/stipends/</a>		
	</cfmail>
	
	<!--- Back to Absorb Stipend Screen --->
	<cflocation url="ClassAbsorbStipendList.cfm">
</cfif>
<!--- Deny --->
<cfif isdefined('HRDeny')>
	<!--- Update DB --->
	<cfset dateApproved = '#dateformat(NOW(), "mm/dd/yyyy")#'>
	
	<cfquery name="UpdateDB" datasource="BusinessPLUS">
		UPDATE Stipend_Abs_MSTR
		SET hr_app_deny = 'N',
			hr_app_deny_date = '#dateApproved#'
		WHERE setid = '#session.classabsorb.set#'
	</cfquery>
	
	<!--- Back to Absorb Stipend Screen --->
	<cflocation url="ClassAbsorbStipendList.cfm">
</cfif>

<!--- Delete Set --->
<cfif isdefined('DeleteSet')>
	
	<cfquery name="DeleteSetMSTR" datasource="BusinessPLUS" >
		DELETE FROM Stipend_Abs_MSTR
		WHERE setid = '#session.classabsorb.set#'		
	</cfquery>
	
	<cfquery name="DeleteSetDTL" datasource="BusinessPLUS">
		DELETE FROM Stipend_Abs_DTL
		WHERE setid = '#session.classabsorb.set#'	
	</cfquery>
	
	<cflocation url="index.cfm">
	<!---redirect to home --->
</cfif>

<cfif isdefined('PayApprove')>
	
	<!--- mark set as A --->
	<cfquery name="MarkToExport" datasource="BusinessPLUS">
		UPDATE Stipend_Abs_MSTR
		SET payroll_status = 'A'
		WHERE setid = '#session.classabsorb.set#'
	</cfquery>
	
	<cflocation url="ClassAbsorbStipendList.cfm" >
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
  	<center>
  	
	  	<cfif (FindNoCase("Secretaries",session.user.memberOf) neq 0) or (#Session.user.special# eq 'Sec')>
			<!--- Get StipendData --->
			<cfquery name="GetDataMstr" datasource="BusinessPLUS" >
				SELECT *
				FROM Stipend_Abs_MSTR
				WHERE	setid = '#session.classabsorb.set#'
			</cfquery>		
			<cfquery name="GetDataDTL" datasource="BusinessPLUS" >
				SELECT *
				FROM Stipend_Abs_DTL
				WHERE	setid = '#session.classabsorb.set#'
			</cfquery>
			
			<cfset viewer = "Secretaries">	
		<cfelseif (FindNoCase("Principals", session.user.memberof) neq 0) or (#Session.user.special# eq 'Prin')>
			<!--- Principal List submitted rediret to principal approval page --->
			<cfquery name="GetDataMstr" datasource="BusinessPLUS" >
				SELECT *
				FROM Stipend_Abs_MSTR
				WHERE	setid = '#session.classabsorb.set#'
			</cfquery>
			
			<cfquery name="GetDataDTL" datasource="BusinessPLUS" >
				SELECT *
				FROM Stipend_Abs_DTL
				WHERE	setid = '#session.classabsorb.set#'
			</cfquery>
			
			<cfset viewer = "principal">
			<!--- Principal View approved/denied redirect to view only page --->
		<cfelseif (FindNoCase("Human Resources", session.user.memberof) neq 0)>
			<!--- HR list all stipends yet to be approved and all approved by principals --->
	
			<cfquery name="GetDataMstr" datasource="BusinessPLUS" >
				SELECT *
				FROM Stipend_Abs_MSTR
				WHERE	setid = '#session.classabsorb.set#'
			</cfquery>
			
			<cfquery name="GetDataDTL" datasource="BusinessPLUS" >
				SELECT *
				FROM Stipend_Abs_DTL
				WHERE	setid = '#session.classabsorb.set#'
			</cfquery>
			
			<cfset viewer = "HR">
			
			<!--- search page redirect to view only page--->
		<cfelseif (FindNoCase("Fiscal_Services", session.user.memberof) neq 0) OR (#session.user.username# eq 'abierman')>	
			<!--- Payroll list stipends approved by HR --->
			<cfquery name="GetDataMstr" datasource="BusinessPLUS" >
				SELECT *
				FROM Stipend_Abs_MSTR
				WHERE	setid = '#session.classabsorb.set#'
			</cfquery>
			
			<cfquery name="GetDataDTL" datasource="BusinessPLUS" >
				SELECT *
				FROM Stipend_Abs_DTL
				WHERE	setid = '#session.classabsorb.set#'
			</cfquery>
			
			<cfset viewer = "payroll">
			
			<!--- List approved stipends  redirect to view only page --->
		<cfelseif (FindNoCase("Technology", session.user.memberof) neq 0)>
			<!--- Payroll list stipends approved by HR --->
	
			<!--- search page redirect to view only page--->
	
			<!--- List approved stipends  redirect to view only page --->
		<cfelse>
			Not in right group
		</cfif>
		
		<!--- Display data --->
		
		<cfoutput>
			<div style="overflow-x:auto;">
			<table border="1">
				<tr>
					<th colspan="3">Entered By: #GetDataMstr.username#</th>
					<th colspan="3">Set ID: CA#GetDataMstr.setid#</th>
					<th colspan="3">Record Count: #GETDataDTL.RecordCount#</th>
				</tr>
				<tr>
					<th colspan="3">
						<cfif #GetDataMstr.submitted# eq 'N'>
							Submitted: NO
						<cfelse>
							Submitted: YES
						</cfif>
					</th>
					<th colspan="3">Principal: <cfoutput>#GetDataMstr.principal#</cfoutput></th>
					<th colspan="3">
						<cfif #GetDataMstr.principal_app_deny# eq 'P'>
							Principal Status: PENDING	
						<cfelseif #GetDataMstr.principal_app_deny# eq 'N'>
							Principal Status: DENIED
						<cfelse>
							Principal Status: APPROVED
						</cfif>
					</th>
				</tr>
				<tr>
					<th colspan="4">
						<cfif #GetDataMstr.hr_app_deny# eq 'P'>
							HR Status: PENDING
						<cfelseif #GetDataMstr.hr_app_deny# eq 'N'>
							HR Status: DENIED
						<cfelse>
							HR Status: APPROVED
						</cfif>
					</th>
					<th colspan="5">
						<cfif #GetDataMstr.payroll_status# eq 'P'>
							Payroll Status: PENDING	
						<cfelseif #GetDataMstr.payroll_status# eq 'N'>
							Payroll Status: DENIED
						<cfelse>
							Payroll Status: COMPLETE
						</cfif>
					</th>
				</tr>
			</cfoutput>
			<tr>
				<th>Legal Name<br> (No Nicknames)</th>
				<th>Employee ID</th>
				<th>Date of Class Absorption</th>
				<th>Number of hours</th>
				<th>Hourly Rate</th>
				<th>Gross Amount</th>
				<th>Job ID</th>
				<th>Name of Teacher Subbed for</th>
				<th>Save/Delete</th>
			</tr>
				<cfoutput query="GetDataDTL">
					<tr>
						<td>#name#</td>
						<td>#empid#</td>
						<td>#DateFormat(jobdate, "mm/dd/yyyy")#</td>
						<td>#NumHours#</td>
						<td>33.99</td>
						<td>#GrossAmount#</td>
						<td>#jobid#</td>
						<td>#subbedfor#</td>
						<td>
							<cfif #session.classabsrob.ev# eq 'edit' or #session.classabsrob.ev# eq 'hredit'>
								<a href="EditClassAbsorbRecord.cfm?record=#tbl_index#">Edit</a><br>
								<a href="EditViewClassAbsorb.cfm?delete=Y&record=#tbl_index#">Delete</a>
							<cfelse>
							</cfif>
						</td>
					</tr>					
				</cfoutput>
				<cfif #session.classabsrob.ev# eq 'view' and viewer neq 'principal'and viewer neq 'HR' and viewer neq 'payroll'>
					<tr>
						<td colspan="8" align="center">
							Comments:<cfoutput>#GetDataMstr.comments#</cfoutput>		
						</td>
					</tr>
				</cfif>
				<cfif viewer eq 'Secretaries'>
					<cfif #session.classabsrob.ev# eq 'edit'>
						<cfform name="EditSet" action="EditViewClassAbsorb.cfm" method="post">
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
									Comments:<cftextarea name="ppComments" cols="75" rows="4" value="#GetDataMstr.comments#">		
									</cftextarea>
								</td>
							</tr>
							<cfif viewer eq 'Secretaries'>
								<tr>
									<th colspan="3"><cfinput name="caSave" type="submit" value="Save" class="submit-lu"></th>
									<th colspan="3"><cfinput name="DeleteSet" type="submit" value="Delete Stipend Set" class="submit-lu"></th>
									<th colspan="3"><cfinput name="SubmitSet" type="submit" value="Submit Stipend" class="submit-lu"></th>
								</tr>
							<cfelseif viewer eq 'principal'>
								
							<cfelseif viewer eq 'payroll'>

							<cfelse>
								
							</cfif>
						</cfform>
					</cfif>
				<!---<cfelseif viewer eq 'principal' and #GetDataMstr.principal_app_deny# eq 'D' or #GetDataMstr.principal_app_deny# eq 'A'>--->
				<cfelseif viewer eq 'principal' and #GetDataMstr.principal_app_deny# eq 'P'>
					<cfform name="PrinAppSet" action="EditViewClassAbsorb.cfm" method="post">
						<tr>
							<td colspan="9" align="center">
								Comments:<cfoutput>#GetDataMstr.comments#</cfoutput>
							</td>
						</tr>
						<tr>
							<th colspan="5"><cfinput name="PrinApprove" type="submit" value="Approve" class="submit-lu"></th>
							<th colspan="4"><cfinput name="PrinDeny" type="submit" value="Deny" class="submit-lu"></th>
						</tr>
					</cfform>
				<cfelseif viewer eq 'HR'>
					<cfform name="HRAppSet" action="EditViewClassAbsorb.cfm" method="post">
						<tr>
							<td colspan="9" align="center">
								Comments:<cftextarea name="hrComments" cols="75" rows="4" value="#GetDataMstr.comments#" ></cftextarea>
								<cfinput name="hrSave" type="submit" value="Save Comments" class="submit-lu">
							</td>
						</tr>
						<tr>
							<th colspan="5"><cfinput name="HRApprove" type="submit" value="Approve" class="submit-lu"></th>
							<th colspan="4"><cfinput name="HRDeny" type="submit" value="Deny" class="submit-lu"></th>
						</tr>
					</cfform>
				<cfelseif viewer eq 'payroll'>
					<cfform name="PayrollAppSet" action="EditViewClassAbsorb.cfm" method="post" >
						<tr>
							<td colspan="9" align="center">
								Comments:<cfoutput>#GetDataMstr.comments#</cfoutput>
							</td>
						</tr>
						<tr>
							<th colspan="9"><cfinput name="PayApprove" type="submit" value="Approve for Export" class="submit-lu"></th>
						</tr>
					</cfform>
				<cfelse>
				</cfif>
				
			</table>
			</div>
		<div class="row js--wp-1">
			<a href="index.cfm"><h3>Home</h3></a><br>
		</div>
	</center>
  	
  </body>
  </html>