<html>
<head>
<title>View Groups</title>
</head>
<body>
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
</style>
<center>
<%@ page import="java.sql.*" %>
<%
if (session.getAttribute("USERNAME") == null){
	response.sendRedirect("welcome.html");
}else{
	String userName = (String)session.getAttribute("USERNAME");
	out.println("<p align='right'>Welcome,"+userName+"</p><form NAME='logout' ACTION='logout.jsp' Method='get'><input style='float: right;' NAME='back' TYPE='submit' VALUE='log out'></form>");
	
	String group_id = "";
	String group_owner = "";
	String group_name = "";
	String date_created = "";
	String group_member = "";
	String date_invited = "";
	String notice = "";
	int attempts = 0;
	//admin page
	if (session.getAttribute("USERNAME") == "admin"){
		
		//get connection to oracle
		//establish the connection to the underlying database
        	Connection conn = null;
	
		//load and register the driver
	        Class drvClass = Class.forName("oracle.jdbc.driver.OracleDriver"); 
	        DriverManager.registerDriver((Driver) drvClass.newInstance());

	        //establish the connection 
		conn = DriverManager.getConnection("jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS","****","*****");
        	conn.setAutoCommit(false);
        
		//page set up
		out.println("<p><b><I>Group that can modify</I></b></p>");
		out.println("<table border='0' width='30%' cellpadding='5'>");
		out.println("<tr><td><b>Group ID</b></td>");
		out.println("<td><b>Group Owner</b></td>");
		out.println("<td><b>Group Name</b></td>");
		out.println("<td><b>Date Created</b></td>");
		out.println("<td><b>Group Member</b></td>");
		out.println("<td><b>Date Invited</b></td>");
		out.println("<td><b>Notice</b></td></tr>");
		
		String query = "select * from groups";
		
		Statement stmt = conn.createStatement();
		ResultSet rset = stmt.executeQuery(query);
		
		while (rset.next()){
			attempts = 0;
		 	if (rset.getObject(2) != null){
				group_id = rset.getObject(1).toString();
				out.println("<td>"+group_id+"</td>");
				group_owner = rset.getObject(2).toString();
				out.println("<td>"+group_owner+"</td>");
				group_name = rset.getObject(3).toString();
				out.println("<td>"+group_name+"</td>");
				date_created = rset.getObject(4).toString();
				out.println("<td>"+date_created+"</td>");
				String query2 = "select * from group_lists where group_id="+group_id;
				Statement stmt1 = conn.createStatement();
				ResultSet rset1 = stmt1.executeQuery(query2);
				while(rset1.next()){
					if (attempts != 0){
						out.println("<tr><td></td><td></td><td></td><td></td>");
					}
					group_member = rset1.getObject(2).toString();
					out.println("<td>"+group_member+"</td>");
					date_invited = rset1.getObject(3).toString();
					out.println("<td>"+date_invited+"</td>");
					notice = rset1.getObject(4).toString();
					out.println("<td>"+notice+"</td>");
					out.println("</tr>");
					attempts++;
				}
			} 
		}
		out.println("</table>");
		conn.close();
	}else{
		//get connection to oracle
		//establish the connection to the underlying database
        Connection conn = null;
	
	    //load and register the driver

        Class drvClass = Class.forName("oracle.jdbc.driver.OracleDriver"); 
        DriverManager.registerDriver((Driver) drvClass.newInstance());

        //establish the connection 
	conn = DriverManager.getConnection("jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS","*****","*****");
        conn.setAutoCommit(false);
        
	//page set up(Group can modify)
	out.println("<p><b><I>Group that can modify</I></b></p>");
	out.println("<table border='0' width='30%' cellpadding='5'>");
	out.println("<tr><th>Group ID</th>");
	out.println("<th>Group Owner</th>");
	out.println("<th>Group Name</th>");
	out.println("<th>Date Created</th>");
	out.println("<th>Group Member</th>");
	out.println("<th>Date Invited</th>");
	out.println("<th>Notice</th></tr>");
		
	String query = "select * from groups";
		
	Statement stmt = conn.createStatement();
	ResultSet rset = stmt.executeQuery(query);
		
	while (rset.next()){
		attempts = 0;
	 	if (rset.getObject(2) != null && (rset.getObject(2)).equals(userName)){
			group_id = rset.getObject(1).toString();
			out.println("<tr><td>"+group_id+"</td>");
			group_owner = rset.getObject(2).toString();
			out.println("<td>"+group_owner+"</td>");
			group_name = rset.getObject(3).toString();
			out.println("<td>"+group_name+"</td>");
			date_created = rset.getObject(4).toString();
			out.println("<td>"+date_created+"</td>");
			String query2 = "select * from group_lists where group_id="+group_id;
			Statement stmt1 = conn.createStatement();
			ResultSet rset1 = stmt1.executeQuery(query2);
			while(rset1.next()){
				if (attempts != 0){
					out.println("<tr><td></td><td></td><td></td><td></td>");
				}
				group_member = rset1.getObject(2).toString();
				out.println("<td>"+group_member+"</td>");
				date_invited = rset1.getObject(3).toString();
				out.println("<td>"+date_invited+"</td>");
				notice = rset1.getObject(4).toString();
				out.println("<td>"+notice+"</td>");
				out.println("</tr>");
				attempts++;
			}
		} 
	}
	out.println("</table>");
		
		
	//page set up (group cannot modify)
	out.println("<p><b><I>Group that cannot modify</I></b></p>");
	out.println("<table border='0' width='30%' cellpadding='5'>");
	out.println("<tr><td><b>Group ID</b></td>");
	out.println("<td><b>Group Owner</b></td>");
	out.println("<td><b>Group Name</b></td>");
	out.println("<td><b>Date Created</b></td>");
	out.println("<td><b>Group Member</b></td>");
	out.println("<td><b>Date Invited</b></td>");
	out.println("<td><b>Notice</b></td><td></td></tr>");
	
	query = "select * from group_lists";
	Statement stmt2 = conn.createStatement();
	ResultSet rset2 = stmt2.executeQuery(query);
	while(rset2.next()){
		group_member = rset2.getObject(2).toString();
		group_id = rset2.getObject(1).toString();
		if (group_member.equals(userName)){
			Statement stmt3 = conn.createStatement();
			ResultSet rset3 = stmt3.executeQuery("select * from groups where group_id='"+group_id+"'");
			while(rset3.next()){
				attempts = 0;
				group_id = rset3.getObject(1).toString();
				out.println("<tr><td>"+group_id+"</td>");
				group_owner = rset3.getObject(2).toString();
				out.println("<td>"+group_owner+"</td>");
				group_name = rset3.getObject(3).toString();
				out.println("<td>"+group_name+"</td>");
				date_created = rset3.getObject(4).toString();
				out.println("<td>"+date_created+"</td>");
				String query2 = "select * from group_lists where group_id="+group_id;
				Statement stmt4 = conn.createStatement();
				ResultSet rset4 = stmt4.executeQuery(query2);
				while(rset4.next()){
					if (attempts != 0){
						out.println("<tr><td></td><td></td><td></td><td></td>");
					}
					group_member = rset4.getObject(2).toString();
					out.println("<td>"+group_member+"</td>");
					date_invited = rset4.getObject(3).toString();
					out.println("<td>"+date_invited+"</td>");
					notice = rset4.getObject(4).toString();
					out.println("<td>"+notice+"</td>");
					out.println("</tr>");
					attempts++;
				}
				}
			}
		}
		out.println("</table>");
		conn.close();
	}	
}
%>
<table border='0' width='30%' cellpadding='5'>
<tr><td><form name="editgroup" action="editgroup.jsp" method="post"><input type="submit" name="editgroupbutton" value="Edit Group"></form></td>
<td><form action="profile.jsp" name="goback"><input type="submit" name="gobackbutton" value="Go Back"></form></td></tr></table>

</center>
</body>
</html>
