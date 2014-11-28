<html>
<head></head>
<body>
<%@ page import="java.sql.*" %>
<%
	//establish the connection to the underlying database
	Connection conn = null;

	//load and register the driver
	Class drvClass = Class.forName("oracle.jdbc.driver.OracleDriver"); 
	DriverManager.registerDriver((Driver) drvClass.newInstance());

	//establish the connection 
	conn = DriverManager.getConnection("jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS","lingbo","TlboSci1994");
	conn.setAutoCommit(false);
	
	Statement stmt = conn.createStatement();
	String id = request.getParameter("pic_id");
	stmt.execute("delete from imagescount where image_id='"+id+"'");
	stmt.execute("commit");
	stmt.execute("delete from imagesviewer where image_id='"+id+"'");
	stmt.execute("commit");
	stmt.execute("delete from images where photo_id='"+id+"'");
	stmt.execute("commit");
	conn.close();
	response.sendRedirect("profile.jsp");
%>

</body>
</html>
