component 
{
	this.name = "Stipends WF" & left( hash( getCurrentTemplatePath()), 64 );

	this.applicationTimeout = CreateTimeSpan( 1, 0, 0, 0 ); // 1 day

	this.customTagPaths = [ expandPath( '/CustomTags' ) ];

	this.mappings = 
	{
		"/com" 		 = expandPath( '/com' ),
		"/foo" 		 = expandPath( '/userdata/foo' ),
		"/oldphotos" = expandPath( '/wwwroot/assets/archived/olderStaffPhotos' ),
		"/catalog" 	 = expandPath( '/wwwroot/app/v2/catalogdata/' )
	};

	this.sessionManagement = true;
	this.sessionTimeout = CreateTimeSpan( 0, 0, 45, 0 ); // 45 minutes
	
	
/*
	this.datasources.my_datasource = {
		"driver" = "MSSQLServer",
		"username" = "sa",
		"password" = "password",
		"url" = "jdbc:macromedia:sqlserver://localhost\MSSQL2008;databaseName=vandelayDB;;sendStringParametersAsUnicode=false;querytimeout=0;MaxPooledStatements=1000"
	};

	this.datasources.my_datasource_reporting_server = {
		"driver" = "MSSQLServer",
		"username" = "sa",
		"password" = "password",
		"url" = "jdbc:macromedia:sqlserver://localhost\MSSQL2008;databaseName=vandelayReporting;;sendStringParametersAsUnicode=false;querytimeout=0;MaxPooledStatements=1000"
	};
*/
	// CF ORM settings
//	this.ormenabled = true;
//	this.ormsettings.cfclocation = "model";
//	this.ormSettings.dbCreate = "none"; 		// CFHibernate will NOT alter the database structure.
//	this.ormSettings.dialect = "MicrosoftSQLServer";


	this.datasource = "BusinessPlus";

	this.blockedExtForFileUpload = "cfm, cfc, jsp";


	// For a more complete list of Application.CFC settings, refer to the Adobe documention found here: 
	// https://helpx.adobe.com/coldfusion/cfml-reference/application-cfc-reference/application-variables.html
	// You can also find more useful information at these links:
	// https://cfdocs.org/application-cfc
	// http://www.learncfinaweek.com/week1/Application_cfc/

	public boolean function onApplicationStart() 
	{
	//	application.fileServerIPAddress 		= "127.0.0.1";
	//	application.customerServiceEmailAddress = "support@d51schools.org";
	//	application.mailServerIPAddress 		= "10.5.11.99";
	
	
		return true; 
	}

	public void function onSessionStart() 
	{ 
		session.created = Now(); // timestamp when this session was created;
		session.IPCreated = cgi.remote_addr;	// where did this user come from?
		session.loggedIn = false;	// new users are logged out by default;
		session.isAdmin = false;	// no way a new user can be an admin if they haven't logged in yet.
		
		session.user = {
		        authorized = false
		        , admin = false
		        , username = ''
		        , building = ''
		        , email = ''        
		        , memberOf = ''        
		        , displayName = ''        
		        , empid = ''
		        , special = ''  
		    };
	
	    // Create Object for utils ... queries 
	    //session.myUtils = createObject("component", "com/utils");
	    //session.myUtils = new com.utils();

		/*session.r1 = new com.Reviewer();*/
		/*session.c1 = new com.Cardholder();*/
		

	} // end on session start

	// the target page is passed in for reference, 
    // but you are not required to include it
	function onRequestStart( string targetPage ) 
	{

	}

	function onRequest( string targetPage ) 
	{
		try 
		{
           include arguments.targetPage;
		} 
		catch (any e) 
		{
			WriteOutput( "Error trying to include template." );
			WriteDump( e );
        }
	}
	
	function onRequestEnd( string targetPage ) 
	{
		
	}

	function onSessionEnd( struct SessionScope, struct ApplicationScope ) 
	{
	}
	function onApplicationEnd( struct ApplicationScope ) 
	{

	}

	function onError( any Exception, string EventName ) 
	{
		WriteOutput( "bad thing happened!" );
		WriteDump( arguments.exception );
		WriteDump( arguments.eventName );
	}

	public boolean function onMissingTemplate( required string targetPage ) 
	{ 
		WriteOutput( "The #arguments.targetPage# page was not found!" );
		// log this 404 somewhere for later research...
		return true; 
	} 


}