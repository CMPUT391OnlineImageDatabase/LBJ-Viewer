<%@ page import="java.io.*,java.util.*" %>
<HTML>
<HEAD>

<BODY>
<%@ page import="java.sql.*" %>
<% 


	        //get the user input from the login page
	        // New location to be redirected
  		    String site = new String("profile.jsp");
        	String userName = (request.getParameter("USERID")).trim();
	        String passwd = (request.getParameter("PASSWD")).trim();
			if (userName.equals("admin") && passwd.equals("admin")){
				session.setAttribute("USERNAME","admin");
				response.setHeader("Refresh", "0;url=profile.jsp");
			}else{

	        //establish the connection to the underlying database
        	Connection conn = null;
	
	        String driverName = "oracle.jdbc.driver.OracleDriver";
           	String dbstring="jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
	

		        //load and register the driver
        		Class drvClass = Class.forName(driverName); 
	        	DriverManager.registerDriver((Driver) drvClass.newInstance());

	

	        	//establish the connection 
		        conn = DriverManager.getConnection(dbstring,"****","*****");
          
        		conn.setAutoCommit(false);
	        
	

	        //select the user table from the underlying db and validate the user name and password
        	Statement stmt = null;
	        ResultSet rset = null;
	        String sql = "select password from users where user_name = '"+userName+"'";

	        	stmt = conn.createStatement();
		        rset = stmt.executeQuery(sql);

	        String truepwd = "";
	
        	while(rset != null && rset.next())
	        	truepwd = (rset.getString(1)).trim();
	
        	//display the result
	        if(passwd.equals(truepwd)){
		        out.println("<p><b>Your Login is Successful!</b></p>");
		        session.setAttribute("USERNAME",userName);
		        response.setStatus(response.SC_MOVED_TEMPORARILY);
		        response.setHeader("Location", site);
	        }else{
	        	out.println("<p><b>Either your userName or Your password is inValid!</b></p>");
				out.println("<p><b>Gonna go back to Login page in 5 seconds or you can press the button below</b></p>");
				response.setHeader("Refresh", "5;url=welcome.html");
				out.println("<form method=post action=welcome.html>");
				out.println("<input type=submit name=bSubmit value=Home>");
		       	out.println("</form>");
                conn.close();
		}}


%>



</BODY>
</HTML>
