<!---<cfapplication name="StipendsWF" sessionmanagement="yes" sessiontimeout="#CreateTimeSpan(0,0,60,0)#">--->

<cfset pageTitle = "Home - Stipends WF">


<!--- session variables --->
<cfif isdefined('editview')>
	<cfset session.pp.ev = '#editview#'>
</cfif>

<cfif isdefined('setid')>
	<cfset session.pp.set = '#setid#'>
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
<!--- end session variables --->

<!--- Employee LOokups --->
<!--- lookup for Emplyee Doing the Subbing --->
<cfif isdefined('EmpLU')>
	<cfset session.period = '#form.ppPeriod#'>
	<cfset session.dateassigned = '#form.ppDateOfAssign#'>
	<cfset session.jobnumber = '#form.ppJobNum#'>
	<cflocation url="employeeLU.cfm?stype=E&source=ppEV" >
</cfif>

<!--- lookup for the staff be subbed for --->
<cfif isdefined('StaffLU')>
	<cfset session.period = '#form.ppPeriod#'>
	<cfset session.dateassigned = '#form.ppDateOfAssign#'>
	<cfset session.jobnumber = '#form.ppJobNum#'>
	<cflocation url="employeeLU.cfm?stype=S&source=ppEV" >
</cfif>

<!--- End employee lookups --->

<!--- Save Record --->
<!--- Insert into DTL tabel --->
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
		WHERE setid = '#session.pp.set#'	
	</cfquery>
	
	<!--- Save DTL Record --->
	<cfif #session.ppempName# gt ''>
		<cfquery name="insertDTL" datasource="BusinessPLUS">
			INSERT INTO Stipend_PP_DTL 
				(tbl_index, setid, name, empid, period, dateassign, jobnumber, subbedfor, dateentered)
			VALUES
				(NEWID(), '#session.pp.set#', '#session.ppempName#', '#session.ppempID#', '#session.period#', '#session.dateassigned#', '#session.jobnumber#', '#session.subbedfor#', '#session.dateentered#')
		</cfquery>
	</cfif>
	
	<cfset StructDelete(Session,"LUName")>
	<cfset StructDelete(Session,"sLUName")>
	<cfset StructDelete(Session,"LUID")>
	<cfset StructDelete(session, "period")>
	<cfset StructDelete(Session,"dateassigned")>
	<cfset StructDelete(Session,"jobnumber")>
	
</cfif>
<!--- End Save Recod --->

<!--- Submit to Principal --->
<cfif isdefined('ppSubmit')>
	
	<!--- COMMENTS --->
	<cfset session.ppComments = '#form.ppComments#'>
	<!--- Save detail record if there is new data --->
	<cfset session.ppempName = '#form.ppLegalName#'>
	<cfset session.ppempID = '#form.ppEmpID#'>
	<cfset session.period = '#form.ppPeriod#'>
	<cfset session.dateassigned = '#form.ppDateOfAssign#'>
	<cfset session.jobnumber = '#form.ppJobNum#'>
	<cfset session.subbedfor = '#form.ppSubbedFor#'>
	<cfset session.dateentered = '#dateformat(NOW(), "mm/dd/yyyy")#'>
	
	<!--- Save DTL Record --->
	<cfif #session.ppempName# gt ''>
		<cfquery name="insertDTL" datasource="BusinessPLUS">
			INSERT INTO Stipend_PP_DTL 
				(tbl_index, setid, name, empid, period, dateassign, jobnumber, subbedfor, dateentered)
			VALUES
				(NEWID(), '#session.pp.set#', '#session.ppempName#', '#session.ppempID#', '#session.period#', '#session.dateassigned#', '#session.jobnumber#', '#session.subbedfor#', '#session.dateentered#')
		</cfquery>
	</cfif>	
	
	<!--- mark as submitted to principal --->
	<cfquery name="updateMSTR" datasource="BusinessPLUS">
		UPDATE Stipend_PP_MSTR
		SET submitted = 'Y',
			comments = '#session.ppComments#'
		WHERE SetID = '#session.pp.set#'
			
	</cfquery>
	
	<cfquery name="getPrinEmail" datasource="BusinessPLUS">
		SELECT principal
		FROM 	Stipend_PP_MSTR
		WHERE SetID = '#session.pp.set#'
	</cfquery>
	
	<!--- email principal---> 
	<cfmail from="hr@mesa.k12.co.us" subject="Planning Period Stipend" to="#getPrinEmail.principal#" type="html" bcc="bj.shay@d51schools.org">
		A Planning Period Stipend has been submitted for you to review.<br>
		<a href = 'https://apps.mesa.k12.co.us/stipends/'>https://apps.mesa.k12.co.us/stipends/</a>
	</cfmail>
	<!--- return to index.cfm --->
	<!--- get rid of session variables --->
	
	<cflocation url="PP_List.cfm" >
</cfif>
<!--- End Submit to principal --->

<!--- Principal --->

<!--- Approve --->
<cfif isdefined('prinApprove')>
	<!--- Mark as approved and redirect to list --->
	<cfquery name="prinApproveSet" datasource="BusinessPLUS" >
		UPDATE Stipend_PP_MSTR	
		SET principal_app_deny = 'Y',
			principal_app_deny_date = '#DateFormat(NOW(), 'mm/dd/yyyy')#'
		WHERE setid = '#session.pp.set#'
	</cfquery>
	
	<cfmail from="hr@mesa.k12.co.us" subject="Planning Period Stipend" to="Rachel.Talley@d51schools.org" >
		You have pending stipends to approve or deny.<br><br>
		<a href = 'https://apps.mesa.k12.co.us/stipends/'>https://apps.mesa.k12.co.us/stipends/</a>		
	</cfmail>
	
	<cflocation url='PP_List.cfm'>
</cfif>
<!--- Deny --->
<cfif isdefined('prinDeny')>
	<!--- Mark as approved and redirect to list --->
	<cfquery name="prinApproveSet" datasource="BusinessPLUS" >
		UPDATE Stipend_PP_MSTR	
		SET principal_app_deny = 'N',
			principal_app_deny_date = #DateFormat(NOW(), 'mm/dd/yyyy')#
		WHERE setid = '#session.pp.set#'
	</cfquery>
	
	<cflocation url='PP_List.cfm'>
</cfif>
<!--- Principal End --->

<!--- HR --->
<cfif isdefined('hrApprove')>
	<!--- Mark as approved and redirect to list --->
	<cfquery name="hrApproveSet" datasource="BusinessPLUS" >
		UPDATE Stipend_PP_MSTR	
		SET hr_app_deny = 'Y',
			hr_app_deny_date = '#DateFormat(NOW(), "mm/dd/yyyy")#'
		WHERE setid = '#session.pp.set#'
	</cfquery>
	
	<cfmail from="hr@mesa.k12.co.us" subject="Planning Period Stipend" to="payroll@d51schools.org" >
		You have pending stipends to approve or deny.<br><br>
		<a href = 'https://apps.mesa.k12.co.us/stipends/'>https://apps.mesa.k12.co.us/stipends/</a>		
	</cfmail>
	
	<!--- send email to payroll? --->
	
	<cflocation url='PP_List.cfm'>
</cfif>
<!--- hr save --->
<cfif isdefined('hrsave')>
	<cfquery name="UpdateDB" datasource="BusinessPLUS">
		UPDATE Stipend_PP_MSTR
		SET comments = '#form.hrComments#'
		WHERE setid = '#session.pp.set#'
	</cfquery>
</cfif>
<cfif isdefined('hrDeny')>
	<!--- Mark as approved and redirect to list --->
	<cfquery name="hrApproveSet" datasource="BusinessPLUS" >
		UPDATE Stipend_PP_MSTR	
		SET hr_app_deny = 'N',
			hr_app_deny_date = '#DateFormat(NOW(), "mm/dd/yyyy")#'
		WHERE setid = '#session.pp.set#'
	</cfquery>
	
	<cflocation url='PP_List.cfm'>
</cfif>
<!--- HR end --->


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
	
	
	
	<!--- Set building number --->
	
	<!---<cfdump var="#session.user#" ><br>
	<cfdump var="#structkeyexists(session, "user")#" ><br>--->
	<cfif (FindNoCase("Secretaries",session.user.memberOf) neq 0) or (#Session.user.special# eq 'Sec')>
		<!--- Get Data for Requested Stipend --->
		<!--- Main Data --->
		<cfquery name="GetMSTRData" datasource="BusinessPLUS" >
			SELECT 	*
			FROM	Stipend_PP_MSTR
			WHERE	setid = '#session.pp.set#'
		</cfquery>
		
		<!--- Detail Data --->
		<cfquery name="GetDTLData" datasource="BusinessPLUS" >
			SELECT 	*
			FROM	Stipend_PP_DTL
			WHERE	setid = '#session.pp.set#'	
		</cfquery>
		
		<!--- Record Count --->
		<cfquery name="getSetRecordCount" datasource="BusinessPLUS">
			SELECT *
			FROM Stipend_PP_DTL
			WHERE	setid = '#session.pp.set#' 	
		</cfquery>
		
		<cfset viewer = 'sec'>
	<cfelseif (FindNoCase("Principals", session.user.memberof) neq 0) or (#Session.user.special# eq 'Prin')>
		<!--- if not approved show approve button --->
		<!--- Main Data --->
		<cfquery name="GetMSTRData" datasource="BusinessPLUS" >
			SELECT 	*
			FROM	Stipend_PP_MSTR
			WHERE	setid = '#session.pp.set#'
		</cfquery>
		
		<!--- Detail Data --->
		<cfquery name="GetDTLData" datasource="BusinessPLUS" >
			SELECT 	*
			FROM	Stipend_PP_DTL
			WHERE	setid = '#session.pp.set#'	
		</cfquery>
		
		<!--- Record Count --->
		<cfquery name="getSetRecordCount" datasource="BusinessPLUS">
			SELECT *
			FROM Stipend_PP_DTL
			WHERE	setid = '#session.pp.set#' 	
		</cfquery>
		
		<cfset viewer = 'prin'>	
	<cfelseif (FindNoCase("Human Resources", session.user.memberof) neq 0)>
		<!--- Get Data for Requested Stipend --->
		<!--- Main Data --->
		<cfquery name="GetMSTRData" datasource="BusinessPLUS" >
			SELECT 	*
			FROM	Stipend_PP_MSTR
			WHERE	setid = '#session.pp.set#'
		</cfquery>
		
		<!--- Detail Data --->
		<cfquery name="GetDTLData" datasource="BusinessPLUS" >
			SELECT 	*
			FROM	Stipend_PP_DTL
			WHERE	setid = '#session.pp.set#'	
		</cfquery>
		
		<!--- Record Count --->
		<cfquery name="getSetRecordCount" datasource="BusinessPLUS">
			SELECT *
			FROM Stipend_PP_DTL
			WHERE	setid = '#session.pp.set#' 	
		</cfquery>
		
		<cfset viewer = 'HR'>	
	<cfelseif (FindNoCase("Fiscal_Services", session.user.memberof) neq 0) OR (#session.user.username# eq 'abierman')>
		<!--- if approved but not marked export show approve for export button --->
		<!--- if exported don't show buttons--->
	<cfelseif (FindNoCase("Technology", session.user.memberof) neq 0)>
		Technology View <br><br>
		
			- Secretaries <br>
			- Principals<br>
			- HR<br>
			- Payroll<br>
	<cfelse>
		Not in right group
	</cfif>	
	
	<!--- Display Data --->
	
	<!--- Main Data --->
	<center>
		<div style="overflow-x:auto;">
		<table border="1">
			<tr>
				<th colspan="2" align="center">Entered By: <cfoutput>#session.user.displayName#</cfoutput></th>
				<th colspan="2" align="center">Set ID: <cfoutput>PP#session.pp.set#</cfoutput></th>
				<th colspan="3" align="center">Record Count: <cfoutput>#getSetRecordCount.recordcount#</cfoutput></th>
			</tr>
			<tr>
				<th align="center" colspan="2">
					<cfif #GetMSTRData.submitted# eq 'N'>
						Submitted: NO
					<cfelse>
						Submitted: YES
					</cfif>
				</th>
				<th align="center" colspan="3">Principal: <cfoutput>#GetMSTRData.principal#</cfoutput></th>
				<th align="center" colspan="2">
					<cfif #GetMSTRData.principal_app_deny# eq 'P'>
						Principal Status: PENDING	
					<cfelseif #GetMSTRData.principal_app_deny# eq 'N'>
						Principal Status: DENIED
					<cfelse>
						Principal Status: APPROVED
					</cfif>
				</th>
			</tr>
			<tr>
				<th align="center" colspan="3">
					<cfif #GetMSTRData.hr_app_deny# eq 'P'>
						HR Status: PENDING
					<cfelseif #GetMSTRData.hr_app_deny# eq 'N'>
						HR Status: DENIED
					<cfelse>
						HR Status: APPROVED
					</cfif>
				</th>
				<th align="center" colspan="4">
					<cfif #GetMSTRData.payroll_status# eq 'P'>
						Payroll Status: PENDING	
					<cfelseif #GetMSTRData.payroll_status# eq 'N'>
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
			<cfoutput query="GetDTLData">
				<tr>
					<td>#name#</td>
					<td>#empid#</td>
					<td>#period#</td>
					<td>#DateFormat(dateassign, "mm/dd/yyyy")#</td>
					<td>#jobnumber#</td>
					<td>#subbedfor#</td>
					<cfif #session.pp.ev# eq 'edit' or #session.pp.ev# eq 'hredit'>
						<td><a href="editStipendRecord.cfm?src=PP&record=#tbl_index#">Edit</a> / <a href="deleteStipendRecord.cfm?src=PPEV&record=#tbl_index#">Delete</a></td>
					<cfelse>
						<td></td>
					</cfif>
				</tr>
			</cfoutput>
			<cfif #session.pp.ev# eq 'predit' or #session.pp.ev# eq 'prview'>
				<tr>
					<td colspan="7" align="center">
						Comments:<cfoutput>#GetMSTRData.comments#</cfoutput>
					</td>
				</tr>
			</cfif>
			<cfoutput>
				<cfif #session.pp.ev# eq 'edit'>
					<cfform name="PPStipendEntry" action="PP_EditView.cfm" method="post">
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
							<!--- if s --->
							<cfif isdefined('session.sLUName')>
								<td><cfinput name="ppSubbedFor" type="text" required="true" value="#session.sLUName#" class="txt-box"><cfinput type="submit" name="StaffLU" value="Lookup" class="submit-lu"></td>
							<cfelse>
								<td><cfinput name="ppSubbedFor" type="text" value="" class="txt-box"><cfinput type="submit" name="StaffLU" value="Lookup" class="submit-lu"></td>
							</cfif>
							<td><cfinput name="ppSave" type="submit" value="Save Record" class="submit-lu"></td>
						</tr>
						<cfif #session.pp.ev# neq 'hredit'>
							<tr>
								<td colspan="7" align="center">
									Comments:<cftextarea name="ppComments" cols="75" rows="4" value="#GetMSTRData.comments#">		
									</cftextarea>
								</td>
							</tr>
						</cfif>
						
						<tr>
							<td colspan="3" align="center"><cfinput name="ppSave2" type="submit" value="Save" class="submit"></td>
							<td colspan="4" align="center"><cfinput name="ppSubmit" type="submit" value="Submit To Principal" class="submit"></td>
						</tr>
						
				</cfform>
				</cfif>
				<cfif #session.pp.ev# eq 'predit'>
					<cfform name="prinApprove" action="PP_EditView.cfm" method="post">
						<tr>
							<td colspan="4" align="center"><cfinput type="submit" name="prinApprove" value="Approve" class="submit"></td>
							<td colspan="3" align="center"><cfinput type="submit" name="prinDeny" value="Deny" class="submit"></td>
						</tr>
					</cfform>
				</cfif>
				<!---<tr>
					<td colspan="7" align="center">
						Comments:<cftextarea name="viewComments" cols="75" rows="4" value="#GetMSTRData.comments#">		
						</cftextarea>
					</td>
				</tr>--->
				<cfif #session.pp.ev# eq 'hredit'>
					<cfform name="hrSubmit" action="PP_EditView.cfm" method="post">
						<tr>
							<cfquery name="GetCommentsTest" datasource="BusinessPLUS">
								SELECT 	*
								FROM	Stipend_PP_MSTR
								WHERE	setid = '#session.pp.set#'	
							</cfquery>
							<td colspan="7" align="center">
								Comments:<cftextarea name="hrComments" cols="75" rows="4" value="#GetCommentsTest.comments#">		
								</cftextarea>
								<cfinput name="hrSave" type="submit" value="Save Comments" class="submit-lu">
							</td>
						</tr>
						<tr>
							<td colspan="4" align="center"><cfinput type="submit" name="hrApprove" value="Approve" class="submit"></td>
							<td colspan="3" align="center"><cfinput type="submit" name="hrDeny" value="Deny" class="submit"></td>
						</tr>
					</cfform>	
				</cfif>		
			</cfoutput>
		</table>
		</div>
			</center>
		<div class="row js--wp-1">	
			<div class="col span-3-of-4 box">
				<a href="index.cfm">HOME</a>
			</div>
			<div class="col span-1-of-4 box">
				<a href="PP_List.cfm">STIPEND LIST</a>
			</div>
		</div

		
	
	
	<!---<cfdump var= #Session.user.memberof#>--->
	
	</body>
	
	
	
  </html>  
 