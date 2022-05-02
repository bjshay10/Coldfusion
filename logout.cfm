<CFLOCK SCOPE="session" TYPE="Exclusive" TIMEOUT="60" THROWONTIMEOUT="No" >
	<!---<CFSET StructDelete(session,"user")>--->
	<CFSET StructClear(session)>
<!---		    <cfset session.user = {
		        authorized = false
		        , admin = false
		        , username = ''
		        , building = ''
		        , email = ''        
		        , memberOf = ''        
		        , displayName = ''  
		        , filter = ''      
		        , empid = ''      
		    } />--->
</CFLOCK>
<cflocation url="login.cfm">