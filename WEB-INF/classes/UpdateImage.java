import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.*;
import oracle.sql.*;
import oracle.jdbc.*;

/**
 *  The package commons-fileupload-1.0.jar is downloaded from 
 *         http://jakarta.apache.org/commons/fileupload/ 
 *  and it has to be put under WEB-INF/lib/ directory in your servlet context.
 *  One shall also modify the CLASSPATH to include this jar file.
 */
import org.apache.commons.fileupload.DiskFileUpload;
import org.apache.commons.fileupload.FileItem;

public class UpdateImage extends HttpServlet {
    public String response_message;
    public void doPost(HttpServletRequest request,HttpServletResponse response)
	throws ServletException, IOException {
	//  change the following parameters to connect to the oracle database
	String username = "lingbo";
	String password = "TlboSci1994";
	String drivername = "oracle.jdbc.driver.OracleDriver";
	String dbstring ="jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
			    
    	String subject = request.getParameter("SUBJ");
    	String place = request.getParameter("PLACE");
	String date = request.getParameter("DATE");
    	String perm = request.getParameter("PERMITTED");
	String desc = request.getParameter("DESC");
	String id = request.getParameter("picid");
	
	 try {
			
	        // Connect to the database and create a statement
	        Connection conn = getConnected(drivername,dbstring, username,password);
		    Statement stmt = conn.createStatement();

			String asql=
					"UPDATE images "+
					"SET subject ='"+subject+"',"+
						"timing =TO_DATE('"+date+"','yyyy/mm/dd hh24:mi:ss'), "+
						"permitted ='"+perm+"',"+
						"place ='"+place+"',"+
						"description ='"+desc+
					"' WHERE photo_id ="+id;	
			//System.out.println("dsa: "+asql);
			stmt.execute(asql);		    
			//System.out.println(asql);

		    conn.close();
	    
	    
	    response_message = " Update OK!  ";

		//response.setHeader("Success!", "5;url=uploadimage.jsp");
	} catch( Exception ex ) {
	    //System.out.println( ex.getMessage());
		System.out.println("Update failed");
	    response_message = ex.getMessage();
	}
	//response.setHeader("Success!", " 10;url=/OnlineImageProcess/GetOnePic?big"+id);
	
	//response.sendRedirect("/OnlineImageProcess/picturebrowse.jsp");
	response.sendRedirect("/OnlineImageProcess/GetOnePic?big"+id);
}

    /*
      /*   To connect to the specified database
    */
    private static Connection getConnected( String drivername,
					    String dbstring,
					    String username, 
					    String password  ) 
	throws Exception {
	Class drvClass = Class.forName(drivername); 
	DriverManager.registerDriver((Driver) drvClass.newInstance());
	return( DriverManager.getConnection(dbstring,username,password));
    } 
}
