<HTML>
<HEAD>
<TITLE>OLAP</TITLE>
<!--Adapted from http://javarevisited.blogspot.ca/2013/10/how-to-use-multiple-jquery-ui-date.html-->
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
</script>
<script>
$(function() {
$( "#2datepicker" ).datepicker();
});
</script>
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
form {
    display: inline;
}
</style>
</HEAD>
<BODY
	background="http://mycolorscreen.com/wp-content/uploads/wallpapers_2012/163987/lightgrey.png">
	<%@ page import="java.sql.*"%>
	<%
	if (session.getAttribute("USERNAME") == null){
		response.sendRedirect("welcome.html");
	}else{
		String userName = (String)session.getAttribute("USERNAME");
		out.println("<p align='right'>Welcome,"+userName+"</p><form NAME='logout' ACTION='logout.jsp' Method='get'><input style='float: right;' NAME='back' TYPE='submit' VALUE='log out'></form>");
	}
	// Checks if user is admin; if not then redirect to profile.jsp
	if (!session.getAttribute("USERNAME").equals("admin")){
		 response.sendRedirect("profile.jsp");
	}
%>
	<H1>
		<CENTER>
			<font color=Teal>Please Enter the information to search the
				database for analysis: </font>
		</CENTER>
	</H1>
	<FORM NAME="RunAnalysis" ACTION="analysis.jsp" METHOD="post">
		<TABLE style="margin: 0px auto">
			<TR>
				<TD><B>Select a user:</B></TD>
				<TD><SELECT NAME='owner'>
						<%
	//establish the connection to the underlying database
	Connection conn = null;
	//load and register the driver
	Class drvClass = Class.forName("oracle.jdbc.driver.OracleDriver");
	DriverManager.registerDriver((Driver) drvClass.newInstance());
	//establish the connection
	conn = DriverManager.getConnection("jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS","*****","***");
	conn.setAutoCommit(false);
	Statement s=conn.createStatement();
	// selects for all existing users that have uploaded a photo
	String sql = "SELECT * FROM users u WHERE u.user_name=ANY(SELECT i.owner_name FROM images i)";
	ResultSet resSet=s.executeQuery(sql);
	while(resSet.next()){
		String owner = resSet.getString("user_name");
		out.println("<OPTION VALUE='"+owner+"' SELECTED> User:"+owner+" </OPTION>");
	}
	conn.close();
%>
						<OPTION VALUE="" SELECTED></OPTION>
				</SELECT></TD>
			</TR>
			<TR>
				<TD></TD>
				<TD><input type="checkbox" name="SortByUser" value="True"><B><I><font
							color=Teal>Search by User.</font></I></B></TD>
			</TR>
			<TR>
				<TD><B>Subject:</B></TD>
				<TD><INPUT TYPE="text" NAME="Subject" VALUE=""></TD>
			</TR>
			<TR>
				<TD></TD>
				<TD><input type="checkbox" name="SortBySubject" value="True"><B><I><font
							color=Teal>Search by Subject.</font></I></B></TD>
			</TR>
			<TR>
				<TD><B>From (MM-DD-YYYY): </B></TD>
				<TD><INPUT TYPE="text" id="datepicker" NAME="fDate" VALUE=""></TD>
			</TR>
			<TR>
				<TD><B>To (MM-DD-YYYY): </B></TD>
				<TD><INPUT TYPE="text" id="2datepicker" NAME="tDate" VALUE=""></TD>
			</TR>
			<TR>
				<TD><B>Group by range:</B></TD>
				<TD><SELECT NAME='sortByRange'>
						<OPTION VALUE='week' SELECTED>Week</OPTION>
						<OPTION VALUE='month' SELECTED>Month</OPTION>
						<OPTION VALUE='year' SELECTED>Year</OPTION>
						<OPTION VALUE="" SELECTED></OPTION>
				</SELECT></TD>
			</TR>
	
			<TR>
				<TD>
				<center>
						<INPUT TYPE='submit' NAME='StartAnalysis' VALUE='Run' theme="simple">
				</center>
				</TD>
			</TR>
			
		
	</FORM>
	
			<TR>
				<TD>
		<center>
		<form method=post action=profile.jsp>
			<input type=submit name=bSubmit value=Return  theme="simple" align='right'>
		</form>
			</center>
			</TD>
			</TR>
			
	</TABLE>
	
</BODY>
</HTML>
