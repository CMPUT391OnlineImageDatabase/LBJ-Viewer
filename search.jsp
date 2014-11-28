<%@ page language="java" import="java.io.*,java.util.*,javax.servlet.*" %>
<%@ page import="java.servlet.http.*,java.sql.*,oracle.jdbc.driver.*,java.text.*,java.net.*" %>
<%@ page import="org.apache.commons.fileupload.*, org.apache.commons.fileupload.disk.*, org.apache.commons.fileupload.servlet.*" %>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<HTML>
<HEAD>
<TITLE>Photo List</TITLE>
<style type="text/css">

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
<META http-equiv="content-type"
content="text/html; charset=windows-1250">
<body bgcolor="#ffff00" text="#000000" >
<%
String uname = (String)session.getAttribute("USERNAME");
if (uname == null){
	response.sendRedirect("welcome.html");
}else{
	String userName = (String)session.getAttribute("USERNAME");
	out.println("Welcome,"+userName+"</p><form NAME='Logout' ACTION='logout.jsp' Method='get'><input  NAME='back' TYPE='submit' VALUE='logout' id='form_a'></form>");
}%>
<FORM NAME="searchpicture" ACTION="searchresults.jsp" METHOD="post" >
	Enter keywords <INPUT TYPE="text" Name="key" size="50"></input>
	
	and/or time period (Format: DD/MM/YYYY) between <TD><input
		name="dateStart" type="text" size="30"></input></TD> and <TD><input
		name="dateEnd" type="text" size="30"></input></TD>
		
	<p>Select sorting method:</p>
	<input type="radio" name="SEARCHORDER" value="recentFirst">Most
	Recent First<br> <input type="radio" name="SEARCHORDER" value="recentLast">Most Recent Last<br> <input
	type="radio" name="SEARCHORDER" value="relevant">Most Relevant<br>
	<input type="submit" name="SEARCHDATA" value="Search">

</form>

<%
	String error = (String) session.getAttribute("error");
	if (error != null) {
			out.println(error);
			session.removeAttribute("error");
	}
%>


<h3> The List of Images </h3>


<P><a href="profile.jsp"> Return </a>
</BODY>
</HTML>


