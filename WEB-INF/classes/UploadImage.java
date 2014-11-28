/***
 *  A sample program to demonstrate how to use servlet to 
 *  load an image file from the client disk via a web browser
 *  and insert the image into a table in Oracle DB.
 *  
 *  Copyright 2007 COMPUT 391 Team, CS, UofA                             
 *  Author:  Fan Deng
 *                                                                  
 *  Licensed under the Apache License, Version 2.0 (the "License");         
 *  you may not use this file except in compliance with the License.        
 *  You may obtain a copy of the License at                                 
 *      http://www.apache.org/licenses/LICENSE-2.0                          
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *  
 *  Shrink function from
 *  http://www.java-tips.org/java-se-tips/java.awt.image/shrinking-an-image-by-skipping-pixels.html
 *
 *
 *  the table shall be created using the following
      CREATE TABLE pictures (
            pic_id int,
	        pic_desc  varchar(100),
		    pic  BLOB,
		        primary key(pic_id)
      );
      *
      *  One may also need to create a sequence using the following 
      *  SQL statement to automatically generate a unique pic_id:
      *
      *   CREATE SEQUENCE pic_id_sequence;
      *
      ***/

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.*;
import oracle.sql.*;
import oracle.jdbc.*;
import java.awt.Image;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;

/**
 *  The package commons-fileupload-1.0.jar is downloaded from 
 *         http://jakarta.apache.org/commons/fileupload/ 
 *  and it has to be put under WEB-INF/lib/ directory in your servlet context.
 *  One shall also modify the CLASSPATH to include this jar file.
 */
import org.apache.commons.fileupload.DiskFileUpload;
import org.apache.commons.fileupload.FileItem;

public class UploadImage extends HttpServlet {
    public String response_message;
    public void doPost(HttpServletRequest request,HttpServletResponse response)
	throws ServletException, IOException {
	//  change the following parameters to connect to the oracle database
	String username = "lingbo";
	String password = "TlboSci1994";
	String drivername = "oracle.jdbc.driver.OracleDriver";
	String dbstring ="jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
	int pic_id;

	try {
	    //Parse the HTTP request to get the image stream
	    DiskFileUpload fu = new DiskFileUpload();
	    List FileItems = fu.parseRequest(request);
	        
	    // Process the uploaded items, assuming only 1 image file uploaded
	    int nbFiles = FileItems.size();
	    FileItem[] items = new FileItem[nbFiles];
	    Iterator i = FileItems.iterator();
	    int j = 0;
	    items[j] = (FileItem)i.next();
	    while (i.hasNext() && !items[j].isFormField()) {
	    	j++;
	    	items[j] = (FileItem) i.next();
	    }

	    	
        // Connect to the database and create a statement
        Connection conn = getConnected(drivername,dbstring, username,password);
	    Statement stmt = conn.createStatement();
	    response_message = "";
	    
	    for (int n=0;n<j;n++) {
	    	InputStream instream = items[n].getInputStream();
	    	BufferedImage img = ImageIO.read(instream);
	    	BufferedImage thumbNail = shrink(img, 10);
	    	/*
		     *  First, to generate a unique pic_id using an SQL sequence
		     */
		    ResultSet rset1 = stmt.executeQuery("SELECT pic_id_sequence.nextval from dual");
		    rset1.next();
		    pic_id = rset1.getInt(1);
		    HttpSession session = request.getSession();
		    session.setAttribute("currentid",pic_id);
		    String counterquery = "INSERT INTO imagescount VALUES("+pic_id+",0)";
		    stmt.execute("INSERT INTO images VALUES("+pic_id+",'admin',1,'testsub','testplace',SYSDATE,'testdesc',empty_blob(),empty_blob())");
		    stmt.execute("commit");
		    stmt.execute(counterquery);
		    stmt.execute("commit");
		    stmt.execute("INSERT INTO imagesviewer VALUES("+pic_id+",'admin')");
		    stmt.execute("commit");
		    // to retrieve the lob_locator 
		    // Note that you must use "FOR UPDATE" in the select statement
		    //String cmd = "SELECT * FROM pictures WHERE pic_id = "+pic_id+" FOR UPDATE";
		    String cmd = "SELECT * FROM images WHERE photo_id = "+pic_id+" FOR UPDATE";
		    ResultSet rset = stmt.executeQuery(cmd);
		    rset.next();
		    //BLOB myblob = ((OracleResultSet)rset).getBLOB(3);
		    BLOB myblob = ((OracleResultSet)rset).getBLOB(8); // 8 column index is thumbnail
		    BLOB ablob = ((OracleResultSet)rset).getBLOB(9); // 9 column index is img

		    //Write the image to the blob object
		    OutputStream outstream = myblob.setBinaryStream(1);
		    ImageIO.write(thumbNail, "gif", outstream);
		    
		    OutputStream outstream2 = ablob.setBinaryStream(1);
		    ImageIO.write(img, "gif", outstream2);
		    
		    instream.close();
		    outstream.close();
	            stmt.executeUpdate("commit");
		    response_message = " Upload Ok! ";
	    }
        	conn.close();
        	response.sendRedirect("uploaddata.jsp");
	} catch( Exception ex ) {
	    //System.out.println( ex.getMessage());
	    response_message = ex.getMessage();
	    
	}

	//Output response to the client
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

    //shrink image by a factor of n, and return the shrinked image
    public static BufferedImage shrink(BufferedImage image, int n) {

        int w = image.getWidth() / n;
        int h = image.getHeight() / n;

        BufferedImage shrunkImage =
            new BufferedImage(w, h, image.getType());

        for (int y=0; y < h; ++y)
            for (int x=0; x < w; ++x)
                shrunkImage.setRGB(x, y, image.getRGB(x*n, y*n));

        return shrunkImage;
    }
}
