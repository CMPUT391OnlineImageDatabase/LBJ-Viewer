<!DOCTYPE html PUBLIC "-//w3c//dtd html 4.0 trnsitional//en">
<HTMl>
<Head>
<META http-equiv="content-type" content="text/html; charset=windows-1252">
<title>Sample program -- Profile page</title>
<style type="text/css">
#desc{
	padding:5px;
	border:2px;
	solid #ccc;
-webkit-border-radius: 5px;
	border-radius: 5px;
}
body{
	font-family: 'Helvetica', 'Arial', sans-serif;
}
input[type=text] {
	padding:5px;
	border:4px;
	solid #ccc;
-webkit-border-radius: 5px;
	border-radius: 5px;
}
input[type=text]:focus {border-color:#333;}
input[type=submit]{padding:5px 5px; background:#eee; border:0 none;
	cursor:pointer;
	-webkit-border-radius: 5px;
	border-radius: 5px; }
input[type=reset]{padding:5px 5px; background:#eee; border:0 none;
	cursor:pointer;
	-webkit-border-radius: 5px;
	border-radius: 5px; }
input[type=checkbox]{padding:5px 5px; background:#eee; border:0 none;
	cursor:pointer;
	-webkit-border-radius: 5px;
	border-radius: 5px; }
</style>
<script type="text/javascript">
function checkform(form){
	if (form.GPNM.value == ""){
		alert("Please input the GroupName");
		form.GPNM.focus();
		return false;
	}
	return true;
}
</script>
</HEAD>
<center>

<BODY background="http://jmw-custombuilder.com/wp-content/uploads/2013/04/jmw_background3.jpg">
<%@ page import="java.sql.*" %>
<%
if (session.getAttribute("USERNAME") == null){
	response.sendRedirect("welcome.html");
}else{
	String userName = (String)session.getAttribute("USERNAME");
	out.println("<p align='right'>Welcome,"+userName+"</p><form NAME='logout' ACTION='logout.jsp' Method='get'><input style='float: right;' NAME='back' TYPE='submit' VALUE='log out'></form>");	
	int group_id;
	if (request.getParameter("submit") == null){
	     try{
	    	 String query = "select user_name from users";
	    	 
	    	 //establish the connection to the underlying database
	         Connection conn = null;
		
		     //load and register the driver

	         Class drvClass = Class.forName("oracle.jdbc.driver.OracleDriver"); 
	         DriverManager.registerDriver((Driver) drvClass.newInstance());

	         //establish the connection 
		     conn = DriverManager.getConnection("jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS","lingbo","TlboSci1994");
	         conn.setAutoCommit(false);
	         
	         Statement stmt = conn.createStatement();
	         ResultSet rset = stmt.executeQuery(query);
	         String uName = "";
	         out.println("<form name='create-groups' method='POST' action='creategroups.jsp' onSubmit='return checkform(this);'>");
	         out.println("<table border='0' width='30%' cellpadding='5'>");
	         out.println("<tr valign='top' align='left'><td><b>Group Name</b></td>");
	         out.println("<td><input type=text name=GPNM maxlength=24></td></tr>");
	         out.println("<tr valign='top' align='left'><td><b>Notice</b></td>");
	         out.println("<td><textarea name='DESC' cols='30' rows='3' maxlength='1024' id='desc'>");
	         out.println("Enter Notice.</textarea></td></tr>");
	         out.println("<tr><td clospan=2><b>The List of Friends </b></td></tr>CREATE GROUPS</font></p><p></p>");
	         while(rset.next()){
	        	 uName = (rset.getObject(1)).toString();
	        	 if (uName.equals(userName) == false && uName.equals("admin") == false){
	        	 	 out.println("<tr><td>");
	        		 out.println(uName+"</td><td><input type='checkbox' name='selectfriends' value="+uName+"></td></tr>");
	        	 }
	         }
	         stmt.close();
	         conn.close();
	     } catch ( Exception ex ){ out.println( ex.toString() );}
	     out.println("<tr><td><input name='submit' value='Create' type='submit'></td></form>");
	     out.println("<td><input name='reset' value='Reset' type='reset'></td></tr></table>");
	   
	}else{
		String groupName = (request.getParameter("GPNM")).trim();
		String notice = (request.getParameter("DESC")).trim();
		String[] items = (request.getParameterValues("selectfriends"));
		
		
		//establish the connection to the underlying database
        Connection conn = null;
	
	    //load and register the driver

        Class drvClass = Class.forName("oracle.jdbc.driver.OracleDriver"); 
        DriverManager.registerDriver((Driver) drvClass.newInstance());

        //establish the connection 
	    conn = DriverManager.getConnection("jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS","lingbo","TlboSci1994");
        conn.setAutoCommit(false);
        
        
		Statement stmt = conn.createStatement();
		
		//Generate a unique id for group
		
		ResultSet rset = stmt.executeQuery("SELECT group_id_sequence.nextval from dual");
	    rset.next();
	    group_id = rset.getInt(1);
		
	    // isert value to table group
	    
	    stmt.execute("insert into groups values('"+group_id+"','"+userName+"','"+groupName+"',SYSDATE)");
	    for (String friendName : items){
	    	stmt.execute("insert into group_lists values('"+group_id+"','"+friendName+"',SYSDATE,'"+notice+"')");
	    }
	    
	    out.println("<center>");
	    out.println("<p><b>Create group sucess!</b></p>");
	    out.println("<p><b>Gonna go back to Profile page in 5 seconds or you can press the button below</b></p>");
	    response.setHeader("Refresh", "5;url=profile.jsp");
	    out.println("<form method=post action=profile.jsp>");
		out.println("<input type=submit name=bSubmit value=Home>");
   	    out.println("</form>");
   	    out.println("</center>");
   	    
   	    stmt.close();
   	    conn.close();
		
	}
}
%>
<P><a href="profile.jsp"> Return </a></P>
</center>
</BODY>
</HTML>
