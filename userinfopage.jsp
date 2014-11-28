<!DOCTYPE html PUBLIC "-//w3c//dtd html 4.0 transitional//en">
<html>
<head>
<meta http-equiv="content-type"
	content="text/html; charset=windows-1252">
<title>UserinfoPage</title>
<style type="text/css">
body {
	font-family: 'Helvetica', 'Arial', sans-serif;
}

#desc {
	padding: 5px;
	border: 2px; solid #ccc;
	-webkit-border-radius: 5px;
	border-radius: 5px;
	outline: $00FF00 dotted thick;
}

input[type=text] {
	outline: $00FF00 dotted thick;
	padding: 5px;
	border: 4px; solid #e0e0e0;
	-webkit-border-radius: 5px;
	border-radius: 5px;
}

input[type=text]:focus {
	border-color: #afa;
}

input[type=submit] {
	padding: 5px 5px;
	background: #eee;
	border: 0 none;
	cursor: pointer;
	-webkit-border-radius: 5px;
	border-radius: 5px;
}

input[type=reset] {
	padding: 5px 5px;
	background: #eee;
	border: 0 none;
	cursor: pointer;
	-webkit-border-radius: 5px;
	border-radius: 5px;
}

input[type=button] {
	padding: 5px 5px;
	background: #eee;
	border: 0 none;
	cursor: pointer;
	-webkit-border-radius: 5px;
	border-radius: 5px;
}
</style>
<script type="text/javascript">
function checkform(form){
	if (form.passWord.value == ""){
		alert("Please input the password");
		form.passWord.focus();
		return false;
	return true;
}

</script>
</head>
<center>
	<%@ page import="java.sql.*"%>
	<% 
if (session.getAttribute("USERNAME") == null){
	response.sendRedirect("welcome.html");
}else{
	String userName = (String)session.getAttribute("USERNAME");
	out.println("<p align='right'>Welcome,"+userName+"</p><form NAME='logout' ACTION='logout.jsp' Method='get'><input style='float: right;' NAME='back' TYPE='submit' VALUE='log out'></form>");		
	
    	//create string to save info
	String passWord = "";
	String firstName = "";
	String lastName = "";
    	String address = "";
    	String email = "";
    	String phone = "";
    
	if (request.getParameter("ChangeInfo") == null){
		out.println("<h1>User Info Page</h1>");
		
		//establish the connection to the underlying database
	    	Connection conn = null;
		
		//load and register the driver
	    	Class drvClass = Class.forName("oracle.jdbc.driver.OracleDriver"); 
		DriverManager.registerDriver((Driver) drvClass.newInstance());
	
		//establish the connection 
		conn = DriverManager.getConnection("jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS","****","*****");
	    	conn.setAutoCommit(false);
	    
	    	//Sql statement
		String query1 = "select * from users where user_name='"+userName+"'";
		String query2 = "select * from persons where user_name='"+userName+"'";
	    
		//get info
	    	Statement stmt1 = conn.createStatement();
	    	ResultSet rset1 = stmt1.executeQuery(query1);
	    	while (rset1.next()){
	    		passWord = rset1.getObject(2).toString();
	    	}
	    
	    	Statement stmt2 = conn.createStatement();
	    	ResultSet rset2 = stmt2.executeQuery(query2);
	    	while (rset2.next()){
		    firstName = rset2.getObject(2).toString();
		    lastName = rset2.getObject(3).toString();
		    address = rset2.getObject(4).toString();
		    email = rset2.getObject(5).toString();
		    phone = rset2.getObject(6).toString();
	    	}
	    
	    	//layout 
	    	out.println("<form action='userinfopage.jsp' method='post' name='Changeuserinfo' onsubmit='return checkform(this);'>");
	    	out.println("<table border='0' width='30%' cellpadding='5'>");
	    	out.println("<tr valign='top' align='left'><td><b>UserName:</b></td><td>");
	    	out.println("<td><input type=text name=userName disabled='disabled' value='"+userName+"'></td></tr>");
	    	out.println("<tr valign='top' align='left'><td><b>PassWord:</b></td><td>");
	    	out.println("<td><input type=password name=passWord value='"+passWord+"'></td></tr>");
	    	out.println("<tr valign='top' align='left'><td><b>FirstName:</b></td><td>");
	    	out.println("<td><input type=text name=firstName value='"+firstName+"'></td></tr>");
	    	out.println("<tr valign='top' align='left'><td><b>LastName:</b></td><td>");
	    	out.println("<td><input type=text name=lastName value='"+lastName+"'></td></tr>");
	    	out.println("<tr valign='top' align='left'><td><b>Address:</b></td><td>");
	    	out.println("<td><input type=text name=address value='"+address+"'></td></tr>");
	    	out.println("<tr valign='top' align='left'><td><b>Email:</b></td><td>");
	    	out.println("<td><input type=text name=email value='"+email+"'></td></tr>");
	    	out.println("<tr valign='top' align='left'><td><b>Phone:</b></td><td>");
	    	out.println("<td><input type=text name=phone value='"+phone+"'></td></tr>");
	    	out.println("<tr><td><input name='ChangeInfo' value='Submit' type='submit'></td></tr></form></table>");
	
	    	conn.close();
		}else if (request.getParameter("ChangeInfo") != null){
			//establish the connection to the underlying database
			Connection conn = null;
		
			//load and register the driver
			Class drvClass = Class.forName("oracle.jdbc.driver.OracleDriver"); 
			DriverManager.registerDriver((Driver) drvClass.newInstance());
	
			 //establish the connection 
			conn = DriverManager.getConnection("jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS","lingbo","TlboSci1994");
	    		conn.setAutoCommit(false);
	    
			//get parameter
			passWord = request.getParameter("passWord");
	    		firstName = request.getParameter("firstName");
	    		lastName = request.getParameter("lastName");
	    		address = request.getParameter("address");
	    		email = request.getParameter("email");
	    		phone = request.getParameter("phone");
	    
			 String query1 = "update users set password='"+passWord+"' where user_name='"+userName+"'";
			 String query2 = "update persons set first_name='"+firstName+"', last_name='"+lastName+"',address='"+address+"',email='"+email+"',phone='"+phone+"' where user_name='"+userName+"'";
	    
			Statement stmt = conn.createStatement();
			stmt.execute(query1);
			stmt.execute(query2);
			stmt.executeUpdate("commit");
			stmt.close();
		
			conn.close();
		
			response.setHeader("Refresh", "0;url=profile.jsp");
		}
	}
%>
<p><a href="profile.jsp">back</a></p>
</center>
</html>
