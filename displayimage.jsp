<!DOCTYPE html PUBLIC "-//w3c//dtd html 4.0 transitional//en">
<html><head>
<script type="text/javascript"></script>
<meta http-equiv="content-type" content="text/html; charset=windows-1252">
<title>Upload Image</title>
<style type="text/css">
body{
	font-family: 'Helvetica', 'Arial', sans-serif;
}
#form_a{
	margin: 0 auto;
	position:absolute;
	right: 0px;
	width: 60px;
}
#update{
	margin: 0 auto;
	width: 280px;
}
#desc{
	padding:5px;
	border:2px;
	solid #ccc;
-webkit-border-radius: 5px;
	border-radius: 5px;
}
input[type=text] {
	padding:5px;
	border:2px;
	solid #ccc;
-webkit-border-radius: 5px;
	border-radius: 5px;
}
input[type=text]:focus {border-color:#333;}
input[type=submit]{padding:5px 5px; background:#fff; border:0 none;
	cursor:pointer;
	-webkit-border-radius: 5px;
	border-radius: 5px; }
.h1{
	font-family:Helvetica
	text-align:center}
.img{
	text-align:center;
	margin-top:10px;
	margin-bottom:10px;
	padding:50px;
.table{
	border: 1px solid black;
	text-align:center;
}
.log{
	text-align:right;
}
}
</style>
</head>
<center>
<body background="http://wallpaperscraft.com/image/66199/1920x1200.jpg">
<%@ page import="java.sql.*" %>
<%String owner = (String)request.getAttribute("owner"); %>

<%
String uname = (String)session.getAttribute("USERNAME");
if (uname == null){
	response.sendRedirect("welcome.html");
}else{
	String userName = (String)session.getAttribute("USERNAME");
	out.println("<p align='right'>Welcome,"+userName+"</p><form NAME='Logout' ACTION='logout.jsp' Method='get'><input  NAME='back' TYPE='submit' VALUE='logout' id='form_a'></form>");
}
int flag =0;
if(uname.equals(owner) || uname == "admin"){
	flag = 1;
}
//get information
String id = (String)request.getAttribute("pic_id");
String permitted = (String)request.getAttribute("permitted");
String subject = (String)request.getAttribute("subject");
String place = (String)request.getAttribute("place");
String timing = (String)request.getAttribute("timing");
//timing = timing.substring(0, 10);
String description = (String)request.getAttribute("description");

//establish the connection to the underlying database
Connection conn = null;

//load and register the driver
Class drvClass = Class.forName("oracle.jdbc.driver.OracleDriver"); 
DriverManager.registerDriver((Driver) drvClass.newInstance());

//establish the connection 
conn = DriverManager.getConnection("jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS","****","****");
conn.setAutoCommit(false);
	
//set up rank count.
Boolean viewed = false;
String userName = (String)session.getAttribute("USERNAME");
Statement stmt5 = conn.createStatement();
ResultSet rset5 = stmt5.executeQuery("select people_viewed from imagesviewer where image_id='"+id+"'");
Statement stmt4 = conn.createStatement();
ResultSet rset4 = stmt4.executeQuery("select counter from imagescount where image_id='"+id+"'");
rset4.next();
int count = Integer.parseInt(rset4.getObject(1).toString());
while (rset5.next()){
	if (userName.equals(rset5.getObject(1).toString())){
		viewed = true;
	}
}
if (!viewed){
	count++;
	stmt4.execute("UPDATE imagescount set counter='"+count+"' where image_id='"+id+"'");
	stmt4.execute("commit");
	stmt4.execute("INSERT INTO imagesviewer VALUES('"+id+"','"+userName+"')");
}

//if username is owner then flag = 1 and editing is allowed; else dont allow
if (flag == 1){
	out.println("<form action='deletepicture.jsp' method='post' name='delete'><input type= 'hidden' name='pic_id' value='"+id+"'><input type='submit' name='deletebuton' value='Delete'></form>");
	out.println("<p class='img'><img src='/OnlineImageProcess/GetOnePic?disp"+id+"'></p>");
	out.println("<form name='update-image' method='POST' action='UpdateImage' id='update'>");
	out.println("<table class>");
	out.println("<input type= 'hidden' name='picid' value='"+id+"'>");
	out.println("<tr valign='top' align='middle'><td width='52%'><b>Subject</b></td>");
	out.println("<td width='48%'><input type=text name=SUBJ value='"+subject+"'maxlength=128></td></tr>");
	out.println("<tr valign='top' align='middle'><td><b>Place</b></td>");
	out.println("<td><input type=text name=PLACE value='"+place+"' maxlength=128></td></tr>");
	out.println("<tr valign='top' align='middle'><td><b>Date</b></td>");
	out.println("<td><input type=text name=DATE value='"+timing+"'maxlength=38></td></tr>");
	out.println("<tr valign='top' align='middle'><td><b>Permitted</b></td>");

		
	out.println("<input type=hidden name=OWNER value="+userName+">");
	if(permitted.equals("1")){
		out.println("<td><select name='PERMITTED'><option value='1' selected='selected'>public</option><option value='2'>private</option>");
	}else if(permitted.equals("2")){
		out.println("<td><select name='PERMITTED'><option value='1'>public</option><option value='2' selected='selected'>private</option>");
	}else{
		out.println("<td><select name='PERMITTED'><option value='1'>public</option><option value='2'>private</option>");
	}
	String group_name = "";
	String group_id = "";

	Statement stmt1 = conn.createStatement();
	Statement stmt2 = conn.createStatement();
	Statement stmt3 = conn.createStatement();
	ResultSet rset1 = stmt1.executeQuery("select * from groups where user_name='"+userName+"'");
	while (rset1.next()){
		group_name = (rset1.getObject(3)).toString();
		group_id = (rset1.getObject(1)).toString();
		if(permitted.equals(group_id)){
			out.println("<option value='"+group_id+"' selected='selected'>"+group_name+"</option>");
		}else{
			out.println("<option value='"+group_id+"'>"+group_name+"</option>");
		}
	}
	ResultSet rset2 = stmt2.executeQuery("select group_id from group_lists where friend_id='"+userName+"'");
	while (rset2.next()){
		group_id = (rset2.getObject(1)).toString();
		ResultSet rset3 = stmt3.executeQuery("select group_name from groups where group_id='"+group_id+"'");
		while (rset3.next()){
			group_name = (rset3.getObject(1)).toString();
			if(permitted.equals(group_id)){
				out.println("<option value='"+group_id+"' selected='selected'>"+group_name+"</option>");
			}else{
				out.println("<option value='"+group_id+"'>"+group_name+"</option>");
			}
		}
	}
	out.println("</select></td></tr>");
	out.println("<tr valign='top' align='middle'><td><b> Description</b></td>");
	out.println("<td><textarea type=text name='DESC' cols='23' rows='3' maxlength='2048'>"+description+"</textarea>");
	out.println("</td></tr><tr valign='top' align='middle'><td><input name='submit' value='Update Image' type='submit' id='form_b'></td></form>");
	out.println("<form action='picturebrowse.jsp' method='get' name='back'>");
	out.println("<td><input name='gobackbutton' value='Go Back' type='submit'></td><form>");
	out.println("</tr></table>");
	
}else{
	//Display information only Not Editable
	out.println("<p class='img'><img src='/OnlineImageProcess/GetOnePic?disp"+id+"'></p>");
	out.println("<table class>");
	out.println("<input type= 'hidden' name='picid' value='"+id+"'>");
	out.println("<tr valign='top' align='middle'><td width='52%'><b>Subject</b></td>");
	out.println("<td width='48%'><input type=text name=SUBJ readonly='readonly' value='"+subject+"'maxlength=128></td></tr>");
	out.println("<tr valign='top' align='middle'><td><b>Place</b></td>");
	out.println("<td><input type=text name=PLACE readonly='readonly' value='"+place+"' maxlength=128></td></tr>");
	out.println("<tr valign='top' align='middle'><td><b>Date</b></td>");
	out.println("<td><input type=text name=DATE readonly='readonly' value='"+timing+"'maxlength=38></td></tr>");
	out.println("<tr valign='top' align='middle'><td><b>Permitted</b></td>");
	Statement stmt6 = conn.createStatement();
	ResultSet rset6 = stmt6.executeQuery("Select group_name from groups where group_id="+permitted);
	rset6.next();
	String permi = rset6.getObject(1).toString();
	out.println("<td><input type=text name=PERMITTED readonly='readonly' value='"+permi+"' maxlength=38></td></tr>");
	out.println("<tr valign='top' align='middle'><td><b> Description</b></td>");
	out.println("<td><textarea type=text name='DESC' cols='23' rows='3' maxlength='2048' readonly='readonly'>"+description+"</textarea>");
	out.println("</td></tr><tr valign='top' align='middle'>");
	out.println("<form action='picturebrowse.jsp' method='get' name='back'>");
	out.println("<td><input name='gobackbutton' value='Go Back' type='submit'></td><form>");
	out.println("</tr></table>");
}
conn.close();
 %>


</center>
</body></html>
