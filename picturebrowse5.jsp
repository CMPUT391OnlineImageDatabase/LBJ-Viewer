<%@ page language="java" import="java.io.*,java.util.*,javax.servlet.*" %>
<%@ page import="java.servlet.http.*,java.sql.*,oracle.jdbc.driver.*,java.text.*,java.net.*" %>
<%@ page import="org.apache.commons.fileupload.*, org.apache.commons.fileupload.disk.*, org.apache.commons.fileupload.servlet.*" %>
<%@ page import="java.util.List" %>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title> Photo List </title>
<body bgcolor="#FFFFFF" text="#cccccc" >
<center>
<h3>The List of Images </h3>



<%
try {
    
    String userName = (String)session.getAttribute("USERNAME");
    String query = "SELECT * from images";
    //establish the connection to the underlying database
	Connection conn = null;
    String driverName = "oracle.jdbc.driver.OracleDriver";
   	String dbstring="jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
    //load and register the driver
	Class drvClass = Class.forName(driverName); 
	DriverManager.registerDriver((Driver) drvClass.newInstance());
	//establish the connection 
    conn = DriverManager.getConnection(dbstring,"****","****");
	conn.setAutoCommit(false);
	
    String p_id = "";
    String permi = "";
    String owner_name = "";
    String name = "";
    
    List<String> pic_id_display_list = new ArrayList<String>();
    
	if (userName.equals("admin")){
		
		Statement stmt = conn.createStatement();
	    	ResultSet rset = stmt.executeQuery(query);
		while (rset.next() ) {
			
	        p_id = (rset.getObject(1)).toString();
	        pic_id_display_list.add(p_id);
	    	
		}
	}else{
		
		Statement stmt = conn.createStatement();
	    ResultSet rset = stmt.executeQuery(query);
	    while (rset.next() ) {
	        p_id = (rset.getObject(1)).toString();
	        permi = (rset.getObject(3)).toString();
	        owner_name = (rset.getObject(2)).toString();
	        if (permi.equals("2")){
	        	if (owner_name.equals(userName)){
	        		
	        		pic_id_display_list.add(p_id);
	        	}else{
	        		continue;
	        	}
	        }else if (permi.equals("1")){
	        	
	        	pic_id_display_list.add(p_id);
	        }else{
	        	
	        	Statement stmt1 = conn.createStatement();
	        	ResultSet rset1 = stmt1.executeQuery("select user_name from groups where group_id='"+permi+"'");
	        	rset1.next();
	        	name = (rset1.getObject(1)).toString();
	        	if (name.equals(userName)){
	        		
	        		pic_id_display_list.add(p_id);
	                		
	        	}else{
	        		Statement stmt2 = conn.createStatement();
	        		ResultSet rset2 = stmt2.executeQuery("select friend_id from group_lists where group_id='"+permi+"'");
	        		while (rset2.next()){
	        			name = (rset2.getObject(1)).toString();
	        			if (name.equals(userName)){
	        				pic_id_display_list.add(p_id);
	        			}
	        		}
	        		stmt2.close();
	        	}
	        	stmt1.close();
	        }
	    }
	}
	
	String sortquery = "select image_id,max(counter) from imagescount group by image_id order by max(counter) desc";
	Statement stmtlast = conn.createStatement();
	ResultSet rsetlast = stmtlast.executeQuery(sortquery);
	
	int iterator = 0;
	while (rsetlast.next() && rsetlast != null) {
		p_id = (rsetlast.getObject(1)).toString();
		if (pic_id_display_list.contains(p_id)) {
			// specify the servlet for the image
			out.println("<a href=\"/OnlineImageProcess/GetOnePic?big"+p_id+"\">");
			// specify the servlet for the themernail
			out.println("<img src=\"/OnlineImageProcess/GetOnePic?"+p_id +
			"\"></a>");
			iterator++;
			if (iterator == 5) {
				break;
			}
		}
		else {
			continue;
		}
	}
	
    conn.close();
} catch ( Exception ex ){ out.println( ex.toString() );}
%>
<P><a href="profile.jsp"> Return </a></P>
</body>
</center>
</html>
