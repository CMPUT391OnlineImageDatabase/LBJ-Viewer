<html>
<head>
<meta charset="utf-8">
<title>jQuery UI Datepicker - Default functionality</title>
<link rel="stylesheet"
	href="//code.jquery.com/ui/1.11.2/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script src="//code.jquery.com/ui/1.11.2/jquery-ui.js"></script>
<link rel="stylesheet" href="/resources/demos/style.css">
<script>
$(function() {
$( "#datepicker" ).datepicker();
});
</script></head>
<body>
<%@ page import="java.sql.*" %>
<%if (request.getParameter(".submit") != null){
	int pic_id;
	int current_pic_id;
	//establish the connection to the underlying database
	Connection conn = null;

	//load and register the driver
	Class drvClass = Class.forName("oracle.jdbc.driver.OracleDriver"); 
	DriverManager.registerDriver((Driver) drvClass.newInstance());

	//establish the connection 
	conn = DriverManager.getConnection("jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS","lingbo","TlboSci1994");
	conn.setAutoCommit(false);
	
	Statement stmt = conn.createStatement();
	
	String name = request.getParameter("OWNER");
	String subject = request.getParameter("SUBJ").trim();
	String place = request.getParameter("PLACE").trim();
	String permitted = request.getParameter("PERMITTED").trim();
	String desc = request.getParameter("DESC").trim();
	String date = request.getParameter("Date");
	pic_id = (Integer)session.getAttribute("getid") + 1;
	current_pic_id = (Integer)session.getAttribute("currentid");
	while (pic_id <= current_pic_id){
		stmt.execute("INSERT INTO imagesviewer VALUES('"+pic_id+"','"+name+"')");
		stmt.execute("commit");
		stmt.execute("update images set timing=TO_DATE('"+date+"','mm/dd/yyyy hh24:mi:ss'),owner_name='"+name+"',permitted='"+permitted+"',subject='"+subject+"',place='"+place+"',description='"+desc+"'where photo_id='"+pic_id+"'");
		pic_id++;
	}
	session.removeAttribute("getid");
	session.removeAttribute("currentid");
    stmt.execute("commit");
    conn.close();
    
    response.sendRedirect("profile.jsp");
}
%>
<table border="0" width="30%" cellpadding="5">
<form name="upload-data" method="POST" action="uploaddata.jsp">
<tr valign="top" align="left"><td><b>Subject</b></td>
<td><input type=text name=SUBJ maxlength=128>
</td>
</tr>
<tr valign="top" align="left"><td><b>Place</b></td>
<td><input type=text name=PLACE maxlength=128>
</td>
</tr>
<tr valign="top" align="left"><td><b>Permitted</b></td>
<%

	//establish the connection to the underlying database
	Connection conn = null;

	//load and register the driver
	Class drvClass = Class.forName("oracle.jdbc.driver.OracleDriver"); 
	DriverManager.registerDriver((Driver) drvClass.newInstance());

	//establish the connection 
	conn = DriverManager.getConnection("jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS","lingbo","TlboSci1994");
	conn.setAutoCommit(false);

	String userName = (String)session.getAttribute("USERNAME");
	
	out.println("<input type=hidden name=OWNER value="+userName+">");
	out.println("<td><select name='PERMITTED'><option value='1' selected>public</option><option value='2'>private</option>");
	
	String group_name = "";
	String group_id = "";

	Statement stmt1 = conn.createStatement();
	Statement stmt2 = conn.createStatement();
	Statement stmt3 = conn.createStatement();
	ResultSet rset1 = stmt1.executeQuery("select * from groups where user_name='"+userName+"'");
	while (rset1.next()){
		group_name = (rset1.getObject(3)).toString();
		group_id = (rset1.getObject(1)).toString();
		out.println("<option value='"+group_id+"'>"+group_name+"</option>");
	}
	ResultSet rset2 = stmt2.executeQuery("select group_id from group_lists where friend_id='"+userName+"'");
	while (rset2.next()){
		group_id = (rset2.getObject(1)).toString();
		ResultSet rset3 = stmt3.executeQuery("select group_name from groups where group_id='"+group_id+"'");
		while (rset3.next()){
			group_name = (rset3.getObject(1)).toString();
			out.println("<option value='"+group_id+"'>"+group_name+"</option>");
		}
	}
	out.println("</select></td>");
	
	conn.close();
%>
</tr>
<tr valign="top" align="left"><td><b>Date</b></td>
<td><input type="text" id="datepicker" name="Date"></td></tr>
<tr valign="top" align="left"><td><b>Description</b></td>
<td><textarea name="DESC" cols="30" rows="3" maxlength="2048" id="desc">
Enter Description.
</textarea>
</td>
</tr>
<tr>
<td><input name=".submit" value="Upload" type="submit"></td>
<td><input name=".reset" value="Reset" type="reset"></td>
</tr>
</table>
</form>
</body>
</html>
