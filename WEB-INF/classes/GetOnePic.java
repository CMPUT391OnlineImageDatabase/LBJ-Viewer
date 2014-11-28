import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

/**
 *  This servlet sends one picture stored in the table below to the client 
 *  who requested the servlet.
 *
 *   picture( photo_id: integer, title: varchar, place: varchar, 
 *            sm_image: blob,   image: blob )
 *
 *  The request must come with a query string as follows:
 *    GetOnePic?12:        sends the picture in sm_image with photo_id = 12
 *    GetOnePic?big12: sends the picture in image  with photo_id = 12
 *
 *  @author  Li-Yan Yuan
 *
 */
public class GetOnePic extends HttpServlet{

    /**
     *    This method first gets the query string indicating PHOTO_ID,
     *    and then executes the query 
     *          select image from yuan.photos where photo_id = PHOTO_ID   
     *    Finally, it sends the picture to the client
     */

    public void doGet(HttpServletRequest request,
		      HttpServletResponse response)
	throws ServletException, IOException {
        String username = "lingbo";
        String password = "TlboSci1994";
        String drivername = "oracle.jdbc.driver.OracleDriver";
        String dbstring ="jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
        
	//  construct the query  from the client's QueryString
	String picid  = request.getQueryString();
	String query;
//
//	if ( picid.startsWith("big") ) { 
//	   // query = "select test from pictures where pic_id=" + picid.substring(3);
// query = "select pic from pictures where pic_id=" + picid.substring(3);
//	}else{
//	    query = "select pic from pictures where pic_id=" + picid.substring(3);
//}
	if ( picid.startsWith("disp") ) { 
	    query = "select photo from images where photo_id=" + picid.substring(4);            
//RequestDispatcher rd = request.getRequestDispatcher("GetBigPic");
//rd.forward(request,response);
	}else if(picid.startsWith("big")){
	query = "select photo from images where photo_id=" + picid.substring(3); 
	String id = picid.substring(3);         

	String q2 =  "select owner_name, permitted, subject, place, timing, description from images where photo_id="+ picid.substring(3);
	Connection conn2 = null;
	try {
		conn2 = getConnected(drivername,dbstring, username,password);
	    Statement stmt2 = conn2.createStatement();
	    ResultSet rset2 = stmt2.executeQuery(q2);
	    response.setContentType("text/html");
       

	    if ( rset2.next() ) {
 			String owner,permitted,subject,place,timing,description;
	        subject = rset2.getString("subject");
	        place = rset2.getString("place");
			owner = rset2.getString("owner_name");
			permitted = rset2.getString("permitted");
			timing = rset2.getString("timing");
			description = rset2.getString("description");
			request.setAttribute("pic_id", id);
			request.setAttribute("owner",owner);
			request.setAttribute("permitted", permitted);
			request.setAttribute("subject", subject);
			request.setAttribute("place", place);
			request.setAttribute("timing", timing);
			request.setAttribute("description", description);
			conn2.close();
            }
	    else
	      System.out.println("oops");
	} catch( Exception ex ) {
	   ex.getMessage();
	}


	request.getRequestDispatcher("displayimage.jsp").forward(request, response); 
		/*
	String query2;

	query2 = "select owner_name, permitted, subject, place, timing, description from images where photo_id="
	        + picid.substring(3);
			try {
	    Statement stmt2 = conn.createStatement();
	    ResultSet rset2 = stmt2.executeQuery(query2);
	    response.setContentType("text/html");
            String owner,permitted,subject,place,timing,description;

	    if ( rset2.next() ) {
	        subject = rset2.getString("subject");
	        place = rset2.getString("place");
                out.println("<html><head><title>"+subject+ "</title>+</head>" +
	                 "<body bgcolor=\"#000000\" text=\"#cccccc\">" +
		 "<center><img src = \"/OIP/GetOnePic?"+picid+"\">" +
			 "<h3>" + subject +"  at " + place + " </h3>" +
			 "</body></html>");
            }
	    else
	      out.println("<html> Pictures are not avialable</html>");
	} catch( Exception ex ) {
	    out.println(ex.getMessage() );
	}
		*/	
	}	
	else
	query = "select thumbnail from images where photo_id=" + picid;
	//ServletOutputStream out1 = response.getOutputStream();
	PrintWriter out = response.getWriter ();
	/*
	 *   to execute the given query
	 */
	Connection conn = null;
	try {
	    conn = getConnected(drivername,dbstring, username,password);
	    Statement stmt = conn.createStatement();
	    ResultSet rset = stmt.executeQuery(query);

	    if ( rset.next() ) {
		response.setContentType("image/gif");
		InputStream input = rset.getBinaryStream(1);	    
		int imageByte;
		while((imageByte = input.read()) != -1) {
		    out.write(imageByte);
		}
		input.close();

	    } 
	    else 
		out.println("no picture available");
	} catch( Exception ex ) {
	    out.println(ex.getMessage() );
	}
	
	// to close the connection
	finally {
	    try {
		conn.close();
	    } catch ( SQLException ex) {
		out.println( ex.getMessage() );
	    }
	}
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
