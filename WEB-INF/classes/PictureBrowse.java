import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import oracle.jdbc.driver.*;
import java.text.*;
import java.net.*;

/**
 *  A simple example to demonstrate how to use servlet to 
 *  query and display a list of pictures
 *
 *  @author  Li-Yan Yuan
 *
 */
public class PictureBrowse extends HttpServlet{
    
    /**
     *  Generate and then send an HTML file that displays all the thermonail
     *  images of the photos.
     *
     *  Both the thermonail and images will be generated using another 
     *  servlet, called GetOnePic, with the photo_id as its query string
     *
     */
    public void doPost(HttpServletRequest request,
                      HttpServletResponse res)
        throws ServletException, IOException {

        //  change the following parameters to connect to the oracle database
        String username = "lingbo";
        String password = "TlboSci1994";
        String drivername = "oracle.jdbc.driver.OracleDriver";
        String dbstring ="jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
        //  send out the HTML file
        res.setContentType("text/html");
        PrintWriter out = res.getWriter ();

        out.println("<html>");
        out.println("<head>");
        out.println("<title> Photo List </title>");
        out.println("</head>");
        out.println("<body bgcolor=\"#FFFFFF\" text=\"#cccccc\" >");
        out.println("<center>");
        out.println("<h3>The List of Images </h3>");

        /*
         *   to execute the given query
         */
        try {
        	HttpSession session = request.getSession();
        	String userName = (String)session.getAttribute("USERNAME");
            //String query = "select pic_id from pictures";
            /**/String query = "select * from images";

            Connection conn = getConnected(drivername,dbstring, username,password);
            Statement stmt = conn.createStatement();
            ResultSet rset = stmt.executeQuery(query);
            String p_id = "";
            String permi = "";
            String owner_name = "";
            String name = "";

            while (rset.next() ) {
                p_id = (rset.getObject(1)).toString();
                permi = (rset.getObject(3)).toString();
                owner_name = (rset.getObject(2)).toString();
                if (permi.equals("2")){
                	if (owner_name == userName){
                		// specify the servlet for the image
                        out.println("<a href=\"/OnlineImageProcess/GetOnePic?big"+p_id+"\">");
                        // specify the servlet for the themernail
                        out.println("<img src=\"/OnlineImageProcess/GetOnePic?"+p_id +
                                    "\"></a>");
                	}else{
                		continue;
                	}
                }else if (permi.equals("1")){
                	// specify the servlet for the image
                    out.println("<a href=\"/OnlineImageProcess/GetOnePic?big"+p_id+"\">");
                    // specify the servlet for the themernail
                    out.println("<img src=\"/OnlineImageProcess/GetOnePic?"+p_id +
                                "\"></a>");
                }else{
                	ResultSet rset1 = stmt.executeQuery("select user_name from groups where group_id='"+permi+"'");
                	rset1.next();
                	name = (rset1.getObject(1)).toString();
                	if (name == userName){
                		// specify the servlet for the image
                        out.println("<a href=\"/OnlineImageProcess/GetOnePic?big"+p_id+"\">");
                        // specify the servlet for the themernail
                        out.println("<img src=\"/OnlineImageProcess/GetOnePic?"+p_id +
                                    "\"></a>");
                	}else{
                		ResultSet rset2 = stmt.executeQuery("select friend_id from group_lists where group_id='"+permi+"'");
                		while (rset2.next()){
                			name = (rset2.getObject(1)).toString();
                			if (name == userName){
                				// specify the servlet for the image
                                out.println("<a href=\"/OnlineImageProcess/GetOnePic?big"+p_id+"\">");
                                // specify the servlet for the themernail
                                out.println("<img src=\"/OnlineImageProcess/GetOnePic?"+p_id +
                                            "\"></a>");
                			}
                		}
                	}
                }
            }
            stmt.close();
            conn.close();
        } catch ( Exception ex ){ out.println( ex.toString() );}
    
        out.println("<P><a href=\"/OnlineImageProcess/profile.jsp\"> Return </a>");
        out.println("</body>");
        out.println("</html>");
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
