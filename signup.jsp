<HTML>
<HEAD>

<TITLE>Sign-Up Page</TITLE>
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
input[type=reset]{padding:5px 5px; background:#eee; border:0 none;
	cursor:pointer;
	-webkit-border-radius: 5px;
	border-radius: 5px; }
input[type=password] {
	padding:5px;
	border:4px;
	solid #ccc;
-webkit-border-radius: 5px;
	border-radius: 5px;
}
input[type=password]:focus {border-color:#333;}

}
</style>
<script type="text/javascript">
function checkform(form){
	if (form.USERID.value == ""){
		alert("Please input your Username");
		form.USERID.focus();
		return false;
	}
	if (form.PASSWD.value == ""){
		alert("Please input your Password");
		form.PASSWD.focus();
		return false;
	}
	if (form.FIRST.value == ""){
		alert("Please input your First Name");
		form.FIRST.focus();
		return false;
	}
	if (form.LASTN.value == ""){
		alert("Please input your Last Name");
		form.LASTN.focus();
		return false;
	}
	if (form.MAIL.value == ""){
		alert("Please input your Mail");
		form.MAIL.focus();
		return false;
	}
	if (form.PHONE.value == ""){
		alert("Please input your Phone");
		form.PHONE.focus();
		return false;
	}
	if (form.ADDRESS.value == ""){
		alert("Please input your Address");
		form.ADDRESS.focus();
		return false;
	}
	return true;
}
</script>
</HEAD>

<BODY background="http://bgwallpaper.net/image/designs-download-background-design-red-light-desktop-142119.jpg">

<Center>
<p><font size="7" face="Verdana" color="#0080ff">Enter Your Personal Information</font></p>
<p></p>
<form name=signinform method="post" action=signup.jsp onsubmit="return checkform(this);">
<table border="0" width="30%" cellpadding="5">
<tr valign="top" align="left"><td><b>Username</b></td>
<td><input type=text name=USERID maxlength=20></td></tr>
<tr valign="top" align="left"><td><b>Password</b></td>
<td><input type=password name=PASSWD maxlength=20></td></tr>
<tr valign="top" align="left"><td><b>First Name</b></td>
<td><input type=text name=FIRST maxlength=20></td></tr>
<tr valign="top" align="left"><td><b>Last Name</b></td>
<td><input type=text name=LASTN maxlength=20></td></tr>
<tr valign="top" align="left"><td><b>Email</b></td>
<td><input type=text name=MAIL maxlength=20></td></tr>
<tr valign="top" align="left"><td><b>Address</b></td>
<td><input type=text name=ADDRESS maxlength=20></td></tr>
<tr valign="top" align="left"><td><b>Phone Number</b></td>
<td><input type=text name=PHONE maxlength=20></td></tr>
<tr valign="top" align="left"><td><input type=submit name=bSubmit value=Submit></td>
</form>
<td><INPUT TYPE="reset" NAME="Reset" VALUE="Reset"></td></tr>
</table>

<%@ page import="java.sql.*" %>
<% 

        if(request.getParameter("bSubmit") != null)
        {
		boolean check = true;
	        //get the user input from the login page
        	String userName = (request.getParameter("USERID")).trim();
	        String passwd = (request.getParameter("PASSWD")).trim();
        	
        	String fname = (request.getParameter("FIRST")).trim();
	        String lname = (request.getParameter("LASTN")).trim();
        	
        	String email = (request.getParameter("MAIL")).trim();
	        String pnum = (request.getParameter("PHONE")).trim();

        	String addr = (request.getParameter("ADDRESS")).trim();
        	

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
	        
		//check wheter the username is valid
		String sql = "select user_name from users";
		Statement stmt = conn.createStatement();
		ResultSet rset = stmt.executeQuery(sql);
		String name = "";
		while (rset.next()){
			name = (rset.getObject(1)).toString();
			if (name.equals(userName)){
				check = false;
				break;
			}
		}
			
			
			if (check){
				//select the user table from the underlying db and validate the user name and password
	        		Statement stmt1 = null;
				ResultSet rset1 = null;
				
				Statement stmt2 = null;
				ResultSet rset2 = null;
				String sql1 = "insert into persons values('"+userName+"','"+fname+"','"+lname+"','"+addr+"','"+email+"','"+pnum+"')";
				String sql2 = "insert into users values('"+userName+"','"+passwd+"',SYSDATE)";
		        
	
				stmt2 = conn.createStatement();
				rset2 = stmt2.executeQuery(sql2);
	
	     			stmt1 = conn.createStatement();
		  	 	rset1 = stmt1.executeQuery(sql1);
				
		  	 	out.println("<p><b>Sign up success!</b></p>");
		 		out.println("<p><b>Gonna go back to Login page in 5 seconds or you can press the button below</b></p>");
				response.setHeader("Refresh", "5;url=welcome.html");
				out.println("<form method=post action=welcome.html>");
				out.println("<input type=submit name=bSubmit value=Home>");
	       			out.println("</form>");
			}else{
				out.println("<p><b>The username has been used</b></p>");
			}
	       
      	    conn.close();

        }
%>

</BODY>
</HTML>
