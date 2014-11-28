<html>
<head>
<title>Edit Group</title>
</head>
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
<body>
<center>
<%@ page import="java.sql.*" %>
<%
if (session.getAttribute("USERNAME") == null){
	response.sendRedirect("welcome.html");
}else{
	String userName = (String)session.getAttribute("USERNAME");
	out.println("<p align='right'>Welcome,"+userName+"</p><form NAME='logout' ACTION='logout.jsp' Method='get'><input style='float: right;' NAME='back' TYPE='submit' VALUE='log out'></form>");
	
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
	
	String group_id = "";
	String group_name = "";
	String name = "";
	String notice = "";
	Statement stmt = conn.createStatement();
	ResultSet rset = stmt.executeQuery("select * from groups where user_name='"+userName+"'");
	
	out.println("<p><b><I>Select Group</I></b></p>");
	out.println("<form name='choosegroup' action='editgroup.jsp' method='post'>");
	out.println("<table border='0' width='30%' cellpadding='5'>");
	out.println("<tr><td><select name='groups'>");
	
	while(rset.next()){
		group_id = rset.getObject(1).toString();
		group_name = rset.getObject(3).toString();
		out.println("<option value='"+group_id+"'>"+group_name+"</option>");
	}
	out.println("</select></td>");
	out.println("<td><input name='choosegroupbutton' value='Choose Group' type='submit'></td></tr></table>");
	
	if (request.getParameter("deletememberbutton") != null){
		String[] friends = request.getParameterValues("deletefriends");
		Statement stmt1 = conn.createStatement();
		for (String friend : friends){
			stmt1.execute("delete from group_lists where friend_id='"+friend+"'");
		}
		stmt1.execute("commit");
		response.setHeader("Refresh", "0;url=profile.jsp");
	}
	if (request.getParameter("addmemberbutton") != null){
		String[] friends = request.getParameterValues("addfriends");
		notice = request.getParameter("notice");
		group_id = request.getParameter("group_id");
		Statement stmt1 = conn.createStatement();
		for (String friend : friends){
			stmt1.execute("insert into group_lists values('"+group_id+"','"+friend+"',SYSDATE,'"+notice+"')");
		}
		stmt1.execute("commit");
		response.setHeader("Refresh", "0;url=profile.jsp");
	}
	if (request.getParameter("choosegroupbutton") != null){
		group_id = request.getParameter("groups");
		//out.println("<p><b><I>Current group choosen: "+currentgroup+"</I></b></p>");
		
		//Delete member
		out.println("<form name='deletemember' action='editgroup.jsp' method='post'>");
		out.println("<table border='0' width='30%' cellpadding='5'>");
		out.println("<tr><th colspan='2'>Delete members</th></tr>");
		Statement stmt1 = conn.createStatement();
		ResultSet rset1 = stmt1.executeQuery("select * from group_lists where group_id='"+group_id+"'");
		while(rset1.next()){
			name = rset1.getObject(2).toString();
			out.println("<tr><td>");
			out.println(name+"</td><td><input type='checkbox' name='deletefriends' value="+name+"></td></tr>");
		}
		out.println("<tr><td colspan='2'><input name='deletememberbutton' value='Delete Member' type='submit'></td></tr></form></table>");
		stmt1.close();
		
		//Add new member
		out.println("<form name='addmember' action='editgroup.jsp' method='post'>");
		out.println("<table border='0' width='30%' cellpadding='5'>");
		out.println("<tr><th colspan='2'>Add new members</th></tr>");
		Statement stmt2 = conn.createStatement();
		Statement stmt3 = conn.createStatement();
		ResultSet rset2 = stmt2.executeQuery("select u.user_name from users u where u.user_name not in (select g.friend_id from group_lists g where group_id='"+group_id+"' group by g.friend_id) AND u.user_name<>'"+userName+"' AND u.user_name<>'admin'");
		while(rset2.next()){
			name = rset2.getObject(1).toString();
			out.println("<tr><td>");
			out.println(name+"</td><td><input type='checkbox' name='addfriends' value="+name+"></td></tr>");
		}
		out.println("<tr><td>Enter Notice:</td><td><textarea name='notice' cols='30' rows='3' maxlength='1024' id='desc'>Enter Notice.</textarea></td></tr>");
		out.println("<input type='hidden' name='group_id' value='"+group_id+"'>");
		out.println("<tr><td colspan='2'><input name='addmemberbutton' value='Add Member' type='submit'></td></tr></form></table>");
		stmt2.close();
		stmt3.close();
	}
	conn.close();
}
	
%>
<P><a href="profile.jsp"> Return </a></P>
</center>
</body>
</html>
