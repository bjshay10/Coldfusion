<cfset pageTitle = "Home - Stipends WF">

<!--- Temp/session variables for editing record --->
<!--- Source Page --->
<cfif not isdefined('session.temp.src')>
	<cfset session.temp.src = '#src#'>
</cfif>

<!--- Record guid --->
<cfif not isdefined('session.temp.record')>
	<cfset session.temp.record = '#record#'>
</cfif>

<!--- employee lookup --->
<cfif isdefined('eLUName')>
	<cfset session.LUName = '#eLUName#'>
</cfif>

<cfif isdefined('eLUID')>
	<cfset session.LUID = '#eLUID#'>
</cfif>

<cfif isdefined('sLUName')>
	<cfset session.sLUName = '#sLUName#'>
</cfif>

<!--- End Temp variables --->

<!--- Employee Lookups --->
<!--- lookup for Emplyee Doing the Subbing --->
<cfif isdefined('EmpLU')>
	<cfset session.period = '#form.ppPeriod#'>
	<cfset session.dateassigned = '#form.ppDateOfAssign#'>
	<cfset session.jobnumber = '#form.ppJobNum#'>
	<cflocation url="employeeLU.cfm?stype=E&source=ppRec" >
</cfif>

<!--- lookup for the staff be subbed for --->
<cfif isdefined('StaffLU')>
	<cfset session.period = '#form.ppPeriod#'>
	<cfset session.dateassigned = '#form.ppDateOfAssign#'>
	<cfset session.jobnumber = '#form.ppJobNum#'>
	<cflocation url="employeeLU.cfm?stype=S&source=ppRec" >
</cfif>
<!--- End Employee Lookups --->

<!--- Save / Cancel Button --->
	<!--- save --->
	<cfif isdefined('Submit')>
		<cfset session.ppempName = '#form.ppName#'>
		<cfset session.ppempID = '#form.ppEmpID#'>
		<cfset session.period = '#form.ppPeriod#'>
		<cfset session.dateassigned = '#form.ppDateOfAssign#'>
		<cfset session.jobnumber = '#form.ppJobNum#'>
		<cfset session.subbedfor = '#form.ppSubbedFor#'>
		
		<cfif #session.temp.src# eq 'PP' or #session.temp.src# eq 'PPm'>
			<cfquery name="updateDTL" datasource="BusinessPLUS">
				UPDATE Stipend_PP_DTL
				SET	name = '#session.ppempName#',
					empid = '#session.ppempID#',
					period = '#session.period#',
					dateassign = '#session.dateassigned#',
					jobnumber = '#session.jobnumber#',
					subbedfor = '#session.subbedfor#'
				WHERE tbl_index = '#session.temp.record#'
			</cfquery>
		<cfelseif #session.temp.src# eq 'ABS'>
		</cfif>
		
		<cfset StructDelete(Session,"LUName")>
		<cfset StructDelete(Session,"sLUName")>
		<cfset StructDelete(Session,"LUID")>
		<cfset StructDelete(session, "period")>
		<cfset StructDelete(Session,"dateassigned")>
		<cfset StructDelete(Session,"jobnumber")>
		
		<cfset StructDelete(Session, "temp.record")>
		<cfset StructDelete(Session, "temp.src")>
		
		
		<cfif #session.temp.src# eq 'PP'>
			<cflocation url="PP_EditView.cfm?editview=#session.pp.ev#&setid=#session.pp.set#" >
		<cfelseif #session.temp.src# eq 'PPm'>
			<cflocation url="PlanningPeriod.cfm?&setid=#session.mstr.stipendset#">
		<cfelseif #session.temp.src# eq 'PPM'>
			<cflocation url="PlanningPeriod.cfm?&setid=#session.mstr.stipendset#">
		</cfif>
	</cfif>
	
	<!--- cancel --->
	<cfif isdefined('Cancel')>
		<cfif #session.temp.src# eq 'PP'>
			<cflocation url="PP_EditView.cfm?editview=#session.pp.ev#&setid=#session.pp.set#" >
		<cfelseif #session.temp.src# eq 'PPm'>
			<cflocation url="PlanningPeriod.cfm?&setid=#session.mstr.stipendset#">
		<cfelseif #session.temp.src# eq 'PPM'>
			<cflocation url="PlanningPeriod.cfm?&setid=#session.mstr.stipendset#">
		</cfif>
	
	</cfif>
<!--- End Save / Cancel --->

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
	
	<!--- Get Record Data --->
	<!--- Planning Period Record --->
	<cfif #session.temp.src# eq 'PP' or #session.temp.src# eq 'PPm'>
		<cfquery name="getData" datasource="BusinessPLUS" >
			SELECT *
			FROM Stipend_PP_DTL
			WHERE tbl_index = '#session.temp.record#'	
		</cfquery>		
		
		<!--- Planning Period form --->
		<cfform name="ppEditRecord" action="editStipendRecord.cfm" method="post">
			<cfoutput query="getData">
				<center>
					<table border="1">
						<tr>
							<th>Legal Name<br> (No Nicknames)</th>
							<th>Employee ID</th>
							<th>## of Planning Period</th>
							<th>Date of Assign</th>
							<th>Job ID</th>
							<th>Name of Teacher Subbed for</th>
						</tr>
						<tr>
							<td>
								<cfif isdefined('session.LUName')>
									<cfinput name="ppName" type="text" required="true" value="#session.LUName#" class="txt-box"><cfinput type="submit" name="EmpLU" value="Lookup" class="submit-lu">
								<cfelse>
									<cfinput name="ppName" type="text" required="true" value="#name#" class="txt-box"><cfinput type="submit" name="EmpLU" value="Lookup" class="submit-lu">
								</cfif>
							</td>
							<td>
								<cfif isdefined('session.LUID')>
									<cfinput name="ppEmpID" type="text" value="#session.LUID#" class="txt-box"><cfinput type="submit" name="EmpLU" value="Lookup" class="submit-lu">	
								<cfelse>
									<cfinput name="ppEmpID" type="text" value="#empid#" class="txt-box"><cfinput type="submit" name="EmpLU" value="Lookup" class="submit-lu">
								</cfif>								
							</td>
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
										<cfif #period# eq '00'><option value="00" selected="true">00</option><cfelse><option value="00">00</option></cfif>
										<cfif #period# eq '01'><option value="01" selected="true">01<cfelse><option value="01">01</option></cfif>
										<cfif #period# eq '02'><option value="02" selected="true">02<cfelse><option value="02">02</option></cfif>
										<cfif #period# eq '03'><option value="03" selected="true">03<cfelse><option value="03">03</option></cfif>
										<cfif #period# eq '04'><option value="04" selected="true">04<cfelse><option value="04">04</option></cfif>
										<cfif #period# eq '05'><option value="05" selected="true">05<cfelse><option value="05">05</option></cfif>
										<cfif #period# eq '06'><option value="06" selected="true">06<cfelse><option value="06">06</option></cfif>
										<cfif #period# eq '07'><option value="07" selected="true">07<cfelse><option value="07">07</option></cfif>
										<cfif #period# eq '08'><option value="08" selected="true">08<cfelse><option value="08">08</option></cfif>
										<cfif #period# eq '09'><option value="09" selected="true">09<cfelse><option value="09">09</option></cfif>
										<cfif #period# eq '10'><option value="10" selected="true">10<cfelse><option value="10">10</option></cfif>
										<cfif #period# eq '11'><option value="11" selected="true">11<cfelse><option value="11">11</option></cfif>
									</cfselect>
								</cfif>
							</td>
							<td>
								<cfif isdefined('session.dateassigned')>
									<cfinput name="ppDateOfAssign" type="text" value="#DateFormat(session.dateassigned,"mm/dd/yyyy")#" class="txt-box">
								<cfelse>
									<cfinput name="ppDateOfAssign" type="text" value="#DateFormat(dateassign, "mm/dd/yyyy")#" class="txt-box">
								</cfif>
								</td>
							<td>
								<cfif isdefined('session.jobnumber')>
									<cfinput name="ppJobNum" type="text" value="#session.jobnumber#" class="txt-box"> 
								<cfelse>
									<cfinput name="ppJobNum" type="text" value="#jobnumber#" class="txt-box">
								</cfif>
							</td>
							<td>
								<cfif isdefined('session.sLUName')>
									<cfinput name="ppSubbedFor" type="text" required="true" value="#session.sLUName#" class="txt-box"><cfinput type="submit" name="StaffLU" value="Lookup" class="submit-lu">
								<cfelse>
									<cfinput name="ppSubbedFor" type="text" value="#subbedfor#" class="txt-box"><cfinput type="submit" name="StaffLU" value="Lookup" class="submit-lu">
								</cfif>
								
							</td>	
						</tr>
						<tr>
							<td colspan="3" align="center">
								<cfinput type="submit" name="Submit" value="Save" class="submit-lu">		
							</td>
							<td colspan="3" align="center">
								<cfinput type="submit" name="Cancel" value="Cancel" class="submit-lu">	
							</td>
						</tr>
					</table>
				</center>
			</cfoutput>
		</cfform>
		
	<!--- Class Absorption Record --->
	<cfelseif #session.temp.src# eq 'ABS'>
		<cfquery name="getData" datasource="BusinessPLUS" >
			SELECT *
			FROM Stipend_Abs_DTL
			WHERE tbl_index = '#session.temp.record#'	
		</cfquery>
		
		<!--- Class Absorption Record --->
		<cfform name="classAbsorbEditRecord" action="editStipendRecord.cfm" method="post">
		</cfform>
	</cfif>
	
</body>
</html>