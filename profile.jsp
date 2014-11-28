<!DOCTYPE html PUBLIC "-//w3c//dtd html 4.0 trnsitional//en">
<HTMl>
<Head>
<META http-equiv="content-type" content="text/html; charset=windows-1252">
<title>Profile Page</title>
<style type="text/css">
body{
	font-family: 'Helvetica', 'Arial', sans-serif;
	font-size: 12pt;
}
input[type=text] {
	padding:5px;
	border:2px;
	solid #ccc;
-webkit-border-radius: 5px;
	border-radius: 5px;
}
input[type=text]:focus {border-color:#333;}
input[type=submit]{padding:5px 5px; background:#eee; border:0 none;
	cursor:pointer;
	-webkit-border-radius: 5px;
	border-radius: 5px; }

}
</style>
</HEAD>
<div id="Layer1" style="position:absolute; width:100%; height:100%; z-index:-1"> 
<BODY background="http://jmw-custombuilder.com/wp-content/uploads/2013/04/jmw_background3.jpg">
</div>
<% 
if (session.getAttribute("USERNAME") == null){
	response.sendRedirect("welcome.html");
}else{
	String userName = (String)session.getAttribute("USERNAME");
	out.println("<p align='right'>Welcome,"+userName+"</p><form NAME='logout' ACTION='logout.jsp' Method='get'><input style='float: right;' NAME='back' TYPE='submit' VALUE='log out'></form>");
}
%>
<center>
<p>
<font size="8" face="Verdana" >
Home Page
</font>
</p>

<p>
</p>

<table border="0" width="30%" size="30" cellpadding="5">
<tr><td>
Create groups:
<form name="create-a-group" method="POST" enctype="multipart/form-data" action="creategroups.jsp"></td>
<td><input name="submit" value="create groups" type="submit"></td>
</tr>
</form>

<tr><td>
View Groups:
<form name="view-group" method="POST" enctype="multipart/form-data" action="viewgroup.jsp"></td>
<td><input name="viewgroupbutton" value="View groups" type="submit"></td>
</tr>
</form>

<tr><td>
Upload images:
<form name="upload_image" method="POST" entype="multipart/form-data" action="uploadimage.jsp"></td>
<td><input name="submit" value="upload image" type="submit"></td>
</tr>
</form>


<TD></TD>
<TR></TR>
<tr><td>
Browse pictures:
<form name="picture_browse" method="POST" entype="multipart/form-data" action="picturebrowse.jsp"></td>
<td><input name="submit" value="browse image" type="submit"></td>
</tr>
</form>

<TD></TD>
<TR></TR>
<tr><td>
Search pictures:
<form name="picture_search" method="POST" entype="multipart/form-data" action="search.jsp"></td>
<td><input name="submit" value="search picture" type="submit"></td>
</tr>
</form>

<TD></TD>
<TR></TR>
<tr><td>
Change User Info:
<form name="changuserinfo" method="POST" entype="multipart/form-data" action="userinfopage.jsp"></td>
<td><input name="submit" value="Change" type="submit"></td>
</tr>
</form>
<% 
if (session.getAttribute("USERNAME") == "admin"){
	out.println("<TD></TD><TR></TR>");
	out.println("<tr><td>Online Analysis Program:");
	out.println("<form name='date_analysis' method='POST' entype='multipart/form-data' action='olap.jsp'></td>");
	out.println("<td><input name='submit' value='Analysis' type='submit'></td></tr></form>");
}
%>


</center>
</BODY>
</HTML>
