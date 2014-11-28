<!DOCTYPE html PUBLIC "-//w3c//dtd html 4.0 transitional//en">
<html><head>
<meta http-equiv="content-type" content="text/html; charset=windows-1252">
<title>Upload Image</title>
<style type="text/css">
body{
	font-family: 'Helvetica', 'Arial', sans-serif;
}
#desc{
	padding:5px;
	border:2px;
	solid #ccc;
-webkit-border-radius: 5px;
	border-radius: 5px;
	outline: $00FF00 dotted thick;
}
input[type=text] {
	outline: $00FF00 dotted thick;
	padding:5px;
	border:4px;
	solid #e0e0e0;
-webkit-border-radius: 5px;
	border-radius: 5px;
}
input[type=text]:focus {border-color:#afa;}
input[type=submit]{padding:5px 5px; background:#eee; border:0 none;
	cursor:pointer;
	-webkit-border-radius: 5px;
	border-radius: 5px; }
input[type=reset]{padding:5px 5px; background:#eee; border:0 none;
	cursor:pointer;
	-webkit-border-radius: 5px;
	border-radius: 5px; }
input[type=button]{padding:5px 5px; background:#eee; border:0 none;
	cursor:pointer;
	-webkit-border-radius: 5px;
	border-radius: 5px; }

</style>
</head>
<body background="http://bgwallpaper.net/image/designs-download-background-design-red-light-desktop-142119.jpg">
<%@ page import="java.sql.*" %>
<%
if (session.getAttribute("USERNAME") == null){
	response.sendRedirect("welcome.html");
}else{
	String userName = (String)session.getAttribute("USERNAME");
	out.println("<p align='right'>Welcome,"+userName+"</p><form NAME='logout' ACTION='logout.jsp' Method='get'><input style='float: right;' NAME='back' TYPE='submit' VALUE='log out'></form>");
	//establish the connection to the underlying database
	Connection conn = null;

	//load and register the driver
	Class drvClass = Class.forName("oracle.jdbc.driver.OracleDriver"); 
	DriverManager.registerDriver((Driver) drvClass.newInstance());

	//establish the connection 
	conn = DriverManager.getConnection("jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS","****","*****");
	conn.setAutoCommit(false);

	Statement stmt = conn.createStatement();
	ResultSet rset = stmt.executeQuery("SELECT pic_id_sequence.nextval from dual");
	rset.next();
	int pic_id = rset.getInt(1);
	session.setAttribute("getid", pic_id);
	session.setAttribute("currentid", pic_id);
	conn.close();
}			
%>
<p>
<font size="8" face="Verdana" color="#0080ff">
Upload Your Image.
</font>
</p>

<p>
</p>

Please input or select the path of the image!
<form name="upload-image" method="POST" enctype="multipart/form-data" action="UploadImage">
<table border="0" width="30%" cellpadding="5">
<tr>
<td><B>File path: </B></td>
<td>
<input name="file-path"" type="file" class="upload" multiple="">
</td>
</tr>
<tr>
<td><input name=".submit" value="Upload" type="submit"></td>
<td><input name=".reset" value="Reset" type="reset"></td>
</tr>
</table>
</form>
<P><a href="profile.jsp"> Return </a></P>
</body></html>
