<cfset currentURL = CGI.SERVER_NAME & cgi.REQUEST_URI >
<!---<cfdump var="#currentURL#" >--->

<cfscript>
	currentDirectory = getDirectoryFromPath( getCurrentTemplatePath() );
	envfile = FileRead("#currentDirectory#/env.txt");
	/*WriteOutput("#envfile#");*/
</cfscript>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Stipends WF - Login Form</title>

	    <!-- Bootstrap core CSS -->
	    <link rel="stylesheet" type="text/css" href="vendor/bootstrap/css/bootstrap.css" >

	    <!-- Custom styles for this template -->
	    <link rel="stylesheet" type="text/css" href="css/modern-business.css" >

	    <!-- Custom styles -->
	    <link rel="stylesheet" type="text/css" href="css/login.css" >

</head>

<body>
	<div class="login-form">
		<cfform name="authUser" id="authUser">
			 <fieldset>
		        <h2 class="text-center">Login</h2> 
		        <hr><cfoutput>
		        <h4 class="text-center">Stipends<br/>#envfile#</h4> </cfoutput>     
		        <div class="form-group">
		        	<cfinput type="text" class="form-control" placeholder="Username" name="username" message="Invalid ID" validateat="onSubmit" required="yes" id="username" size="10" >
			
		        </div>
		        <div class="form-group">
			   	    <cfinput type="password" class="form-control" placeholder="Password" name="password" message="Invalid Password" validateat="onSubmit" required="yes" id="password"  size="20" >
		        </div>
		        <div class="form-group">
		            <cfinput type="submit" name="Submit" value="Sign In" id="Submit" class="btn btn-primary btn-block">
		        </div>
		        <div class="clearfix">
		            <label class="pull-left checkbox-inline">Use your Network ID and Password</label>
		        </div>        
			 </fieldset>
		</cfform>
	</div>

<cfif IsDefined("url.TryAgain")> 
	<div class="alert alert-warning" role="alert" align="center">
	  <strong>Warning !</strong> Authentication Failure ... Please try again.
	  <cfdump var="#session.user#" >
	</div>
</cfif>

<cfif IsDefined("url.NotAuth")> 
	<div class="alert alert-danger" role="alert" align="center">
	  <strong>Error !</strong> You are not authorized to use this program. Please <a href="mailto:BJ.Shay@d51schools.org?subject=Access to Stipend WF Application" target="_blank">Contact Us</a> to request access.
	</div>
</cfif>

<cfif IsDefined("form.Submit")>
	<cftry>
        <cfldap action="query" 
           server="chief.mesa.k12.co.us" 
           name="GetAccounts" 
           start="DC=mesa,DC=k12,DC=co,DC=us"
           filter="(&(objectclass=user)(SamAccountName=#form.username#))"
           username="mesa\#form.username#" 
           password="#form.password#" 
           attributes = "cn,o,l,st,sn,c,mail,telephonenumber, givenname,homephone, streetaddress, postalcode, SamAccountname, physicalDeliveryOfficeName, department, memberof, displayName, employeeNumber">
        <cfif getaccounts.recordcount eq 0>
            <cflocation url="login.cfm?tryagain" addtoken="no">
        <cfelse>
			<cflock timeout=20 scope="session" type="Exclusive">
	            <cfset session.user.username = '#GetAccounts.cn#'>	            
	            <cfset session.user.displayName = '#GetAccounts.displayName#'>
	            <cfset session.user.building = '#GetAccounts.physicaldeliveryofficename#'>
	            <cfset session.user.email = '#GetAccounts.mail#'>
	            <cfset session.user.empid = '#GetAccounts.employeeNumber#'>
	            <cfset session.user.memberOf = '#GetAccounts.memberof#'>
				<cfquery name="checkSpecial" datasource="BusinessPLUS">
					SELECT *
					FROM Stipend_Special_Access
					WHERE	username = '#session.user.username#'
				</cfquery>
				<cfif #checkSpecial.RecordCount# eq 1 and #checkSpecial.accessLevel# eq 'Secretaries'>
					<cfset session.user.special = 'Sec'>
				<cfelseif #checkSpecial.RecordCount# eq 1 and #checkSpecial.accessLevel# eq 'Principals'>
					<cfset session.user.special = 'Prin'>
				<cfelse>
					<cfset session.user.special = ''>
				</cfif>
				
			<!---Check to see if the user is in one of the correct AD groups--->
				<cfif 
					(FindNoCase("Bi-Tech",session.user.memberOf) eq 0) and
						(FindNoCase("principals",session.user.memberOf) eq 0) and  
					 (FindNoCase("programmers",session.user.memberOf) eq 0) and
					 (FindNoCase("Secretaries", session.user.memberof) eq 0)>
					<cfif #checkSpecial.RecordCount# eq 0>
						<cfset session.user.authorized = false>
					<cfelse>
						<cfset session.user.authorized = true>
					</cfif>
				<cfelse>
					<cfset session.user.authorized = true>
				</cfif>
			</cflock>			
			
			<cfif #session.user.authorized# eq true>
				<!---Success--->
				<cfscript>
					/*session.r1.setUsername("#session.user.username#");*/
					/*session.r1 = new com.Reviewer("#session.user.username#",0,"","");*/
					/*session.c1 = new com.Cardholder();*/
					/*SessionRotate();*/
					
				    // Create Object for utils ... queries 
				    /*session.myUtils = createObject("component", "com/utils");*/
					
				</cfscript>
				
            	<cflocation url="index.cfm">
			<cfelse>
				<!---Not Authorized--->
				<cflocation url="login.cfm?NotAuth" addtoken="no">
			</cfif>
       </cfif>    
 <cfcatch type="any">
	<!---Login failure ... unable to query LDAP ... either bad username or password--->
  	<cflocation url="login.cfm?TryAgain" addtoken="no">
  <cfabort>
</cfcatch>

</cftry>
 </cfif> 

</body>
</html> 

