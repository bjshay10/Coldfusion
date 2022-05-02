<cfset currentURL = CGI.SERVER_NAME & cgi.REQUEST_URI >
 
<!---<cfif not StructKeyExists(session.user, "authorized")>--->
<cfif not structkeyexists(session, "user")>
	<cflocation url="login.cfm">
<cfelse>
	<cfif #session.user.authorized# eq false>
		authorized false<br>
		<cflocation url="login.cfm">
	<cfelse>
		<!---authorized--->
		<!---<cfdump var="#session.user#" >--->
		<cfquery name="FY" datasource="BusinessPLUS">
			SELECT FiscalYR
			FROM Stipend_FiscalYR
		</cfquery>
		<cfset Session.FiscalYR = "#FY.FiscalYR#">
		<!---<cfdump var="#Session.FiscalYR#">--->
	</cfif>
</cfif>

<link rel="stylesheet" type="text/css" href="./css/normalize.css">
<link rel="stylesheet" type="text/css" href="./css/custom.css">
	<link rel="stylesheet" type="text/css" href="./vendor/css/grid.css">
	


<header>
	<nav>
		<div class="row">
			<!---<img src="images/logosmaller.jpg" class="logo"></img>--->
			<!---<img src="images/SD51_Logo_2018_BW.jpg" class="logo"></img>--->
			<img src="images/SD51_Logo_2018_GREEN.png" class="logo"></img>
			<ul class="main-nav js--main-nav">
				<li class="main-nav-li-h1"><h1>Stipends Entry</h1></li>
				<li><a class="logout" href="logout.cfm">Logout</a></li>
			</ul>				
		</div>
	</nav>
</header>




<div class="navbar">
	<div class="title">
		
	</div>
	<div class="logout">
		
	</div>
</div>

    <!-- Navigation x
	<a class="navbar-brand" href="index.cfm">Home - Stipends</a>
	
	<li class="nav-item">
		<a class="nav-link" href="PlanningPeriod.cfm">Planning Period</a>
	</li>
	<li class="nav-item">
		<a class="nav-link" href="studentIncorporation.cfm">Student Incorporation</a>
	</li>
    <li class="nav-item">
      <a class="nav-link" href="">&nbsp;</a>
    </li>--->
    <!---<li class="nav-item">--->
      
    <!---</li>---> 
    
