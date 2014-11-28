<HTML>
<HEAD>
<TITLE>Analysis Page</TITLE>
</HEAD>
<BODY background="blank.jpg">
	<%@ page import="java.sql.*"%>
	<%
	if (session.getAttribute("USERNAME") == null){
		response.sendRedirect("welcome.html");
	}else{
		String userName = (String)session.getAttribute("USERNAME");
		out.println("<p align='right'>Welcome,"+userName+"</p><form NAME='logout' ACTION='logout.jsp' Method='get'><input style='float: right;' NAME='back' TYPE='submit' VALUE='log out'></form>");
	}
%>
	<%
	//establish the connection to the underlying database
	Connection con = null;
	//load and register the driver
	Class drvClass = Class.forName("oracle.jdbc.driver.OracleDriver");
	DriverManager.registerDriver((Driver) drvClass.newInstance());
	//establish the connection
	con = DriverManager.getConnection("jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS","****","****");
	con.setAutoCommit(false);
%>
	<%!
	// Returns a string value that is then appended on to corresponding queries
	public String findAppend(String owner,String subject,String fDate,String tDate){
		//none selected
		if(owner.equals("") && subject.equals("") && fDate.equals("") && tDate.equals("")){
			return " ";
		// after fDate
		}else if(owner.equals("") && subject.equals("") && fDate.equals("")==false && tDate.equals("")){
			return "WHERE i.timing >='"+fDate+"'";
		// before tDate
		}else if(owner.equals("") && subject.equals("") && fDate.equals("") && tDate.equals("")==false){
			return "WHERE i.timing <='"+tDate+"'";
		}
		//owner only
		else if(owner.equals("")==false && subject.equals("") && fDate.equals("") && tDate.equals("")){
			return " i.owner_name='"+owner+"' ";
		}
		//subject only
		else if(owner.equals("") && subject.equals("")==false && fDate.equals("") && tDate.equals("")){
			//return " i.subject LIKE '%"+subject+"%' ";
			return " CONTAINS(i.subject,'"+subject+"') > 0 ";		
		}
		//date only
		else if(owner.equals("") && subject.equals("") && fDate.equals("")==false && tDate.equals("")==false){
			return "WHERE i.timing between '"+fDate+"' AND "+"'"+tDate+"'";
		}
		//owner and subject
		else if(owner.equals("")==false && subject.equals("")==false && fDate.equals("") && tDate.equals("")){
			return " i.owner_name='"+owner+"' AND "+"CONTAINS(i.subject,'"+subject+"') > 0";
		}
		//owner and date
		else if(owner.equals("")==false && subject.equals("") && fDate.equals("")==false && tDate.equals("")==false){
			return " i.owner_name='"+owner+"' AND i.timing between '"+fDate+"' AND "+"'"+tDate+"' ";
		}
		//subject and date
		else if(owner.equals("") && subject.equals("")==false && fDate.equals("")==false && tDate.equals("")==false){
			return " CONTAINS(i.subject,'"+subject+"') > 0 AND i.timing between '"+fDate+"' AND "+"'"+tDate+"' ";
		}
		//all
		else{
			return " i.owner_name='"+owner+"' AND CONTAINS(i.subject,'"+subject+"') > 0 AND i.timing between '"+fDate+"' AND "+"'"+tDate+"' ";
		}
	}
%>
	<%!
//sets date to specified format
public void setDateFormat(Connection con) throws SQLException{
	String sql="alter SESSION set NLS_DATE_FORMAT = 'MM/DD/YYYY'";
	Statement s=con.createStatement();
	s.executeQuery(sql);
}
%>
	<%
	// if this page is not redirected from the olap.jsp
	if(request.getParameter("StartAnalysis")==null){
		response.sendRedirect("profile.jsp");
	}
	out.println("<H1><CENTER>Analysis Results: </CENTER></H1>");
	out.println("<HR></HR>");
	
	// Get parameters from olap.jsp
	String fDate=request.getParameter("fDate");
	String tDate=request.getParameter("tDate");
	String owner=request.getParameter("owner");
	String subject=request.getParameter("Subject");
	out.println("<H1><CENTER>"+owner+" "+subject+" "+fDate+" "+tDate+"</CENTER></H1>"); //print parameter values for testing

	String sortUser=request.getParameter("SortByUser");
	String sortSub=request.getParameter("SortBySubject");
	String sortRange=request.getParameter("sortByRange");
	out.println("<H1><CENTER>"+sortUser+" "+sortSub+" "+sortRange+"</CENTER></H1>");
	Statement s =con.createStatement();
	//If sort by user is selected but no value is input then unselect sort user.
	String ps=null;String ts=null;String rs=null;
	if(owner != null && owner.equals("")){
		ps="Owner not select";
	if(sortUser!=null)
		sortUser=null;
	}else{
		String query="SELECT i.owner_name FROM images i WHERE i.owner_name='"+owner+"'";
		ResultSet res=s.executeQuery(query);
	while(res.next()){
		ps=res.getString("owner_name");
	}
}
	if(sortUser==null && owner.equals("")==false){
		owner="";
	}
	if(sortSub==null && subject.equals("")==false){
		subject="";
	}
	//If sort sub is selected but no value is given then unselect sort sub
	if(subject != null && subject.equals("")){
		ts="Subject not selected";
		if(sortSub != null)
			sortSub=null;
	}else{
		ts=subject;
	}
	
	// We'll allow user to select only fDate or only tDate and classify it was a search for time before or after
	if(fDate != null && fDate.equals("") && tDate != null && tDate.equals("")){
		rs="None";
	}else if((fDate.equals("") && (tDate.equals("")==false))){
		rs="before tDate: "+tDate;
	}else if((fDate.equals("")==false && (tDate.equals("")))){
		rs="after fDate: "+fDate;
	}else{
		rs="From "+fDate+" To "+tDate+" (DD-MM-YYYY)";
	}
	out.println("<CENTER><H4><font color=Maroon>Owner : "+ps+" ; Subj: "+ts+" With Date: " +rs+"</font></H4></CENTER>"); //* testoutput
	out.println("<HR></HR>");
	setDateFormat(con);
	ResultSet rSet=null;
	String sql=null;
	
	// Append value is calculated according to the admin specified values and an append is used by most queries to easily find and reuse 
	String append=findAppend(owner,subject,fDate, tDate);
	
	//Group By None
	if(sortUser==null && sortSub==null && sortRange.equals("")){
		sql="SELECT count(*) AS CNT "+
		"FROM images i "+append;
		rSet=s.executeQuery(sql);
		out.println("<TABLE style='margin: 0px auto'>");
			while(rSet.next()){
				int count=rSet.getInt("CNT");
				out.println("<H3><CENTER>1. Total number of images is "+count+" </CENTER></H3>");
			}
		out.println("</TABLE>");
	}else if (sortUser==null && sortSub==null && fDate.equals("")==false && tDate.equals("") && sortRange==null){
		sql="SELECT count(*) AS CNT "+
		"FROM images i "+
		" WHERE "+append;
		rSet=s.executeQuery(sql);
		out.println("<TABLE style='margin: 0px auto'>");
		out.println("<H3><CENTER>2;3.</CENTER></H3>");
	while(rSet.next()){
		int count=rSet.getInt("CNT");
		out.println("<H3><CENTER>2. Total number of images is "+count+"</CENTER></H3>");
	}
}
	else if(sortUser==null && sortSub==null && tDate.equals("")==false && fDate.equals("") && sortRange==null){
		sql="SELECT count(*) AS CNT "+
		"FROM images i "+
		" WHERE "+append;
		rSet=s.executeQuery(sql);
		out.println("<TABLE style='margin: 0px auto'>");
		out.println("<H3><CENTER>2.</CENTER></H3>");
	while(rSet.next()){
		int count=rSet.getInt("CNT");
		out.println("<H3><CENTER>2. Total number of images is "+count+"</CENTER></H3>");
	}
}
	//Group By User only
	else if(sortUser!=null && sortSub==null && sortRange.equals("")){
		sql="SELECT count(i.photo_id) AS CNT, i.photo_id, i.owner_name"+" FROM images i "+"WHERE"+
		append+" GROUP BY i.owner_name,i.photo_id";
		rSet=s.executeQuery(sql);
		out.println("<TABLE style='margin: 0px auto'>");
		int count=0;
		String name="";
		while(rSet.next()){
			count++;
			name =rSet.getString("owner_name");
			int count2=rSet.getInt("CNT");
			int pid=rSet.getInt("photo_id");
			out.println("<H3><CENTER> User: "+name+" has uploaded photo_id: ("+pid+")</CENTER></H3>");
		}
	out.println("<H3><CENTER>3. Total number of images uploaded by user: "+name+" is "+count+" </CENTER></H3>");
	out.println("</TABLE>");
	}
	//Group by Subject only
	else if(sortUser==null && sortSub!=null && sortRange.equals("")){
		sql="SELECT count(i.photo_id) AS CNT, i.photo_id, i.subject"+" FROM images i "+"WHERE"+
		append+" GROUP BY i.subject,i.photo_id";
		rSet=s.executeQuery(sql);
		out.println("<TABLE style='margin: 0px auto'>");
		int count=0;
		String name="";
		while(rSet.next()){
			count++;
			name =rSet.getString("subject");
			int count2=rSet.getInt("CNT");
			int pid=rSet.getInt("photo_id");
			out.println("<H3><CENTER> Photo_id: ("+pid+") contains subject: "+subject+" </CENTER></H3>");
		}
		out.println("<H3><CENTER>4. Total number of images uploaded with subject: "+subject+" is "+count+" </CENTER></H3>");
		out.println("</TABLE>");
	}
	//Group By time
	else if(sortUser==null && sortSub==null && sortRange.equals("")==false && fDate.equals("")==false && tDate.equals("")==false){
		if(sortRange.equals("year")){
			sql="SELECT count(*) AS CNT,EXTRACT(YEAR FROM i.timing) AS Y"+
			" FROM images i"+
			" WHERE i.timing between '"+fDate+"' AND "+"'"+tDate+"' "+
			"GROUP BY EXTRACT(YEAR FROM i.timing)";
			rSet=s.executeQuery(sql);
			out.println("<TABLE style='margin: 0px auto'>");
			int c=0;
			String year ="";

			while(rSet.next()){
				int count=rSet.getInt("CNT");
				year=rSet.getString("Y");
				c++;
				out.println("<TR><TD>5. Total number of images uploaded in "+year+" between "+fDate+" and "+tDate+" is "+count+"</TD></TR>");
			}
			out.println("</TABLE>");
		}else if(sortRange.equals("month")){
			sql="SELECT count(*) AS CNT,EXTRACT(YEAR FROM i.timing) AS Y,EXTRACT(MONTH FROM i.timing) AS M "+
			" FROM images i"+
			" WHERE i.timing between '"+fDate+"' AND "+"'"+tDate+"' "+
			" GROUP BY EXTRACT(YEAR FROM i.timing),EXTRACT(MONTH FROM i.timing)";
			rSet=s.executeQuery(sql);
			out.println("<TABLE style='margin: 0px auto'>");
			String year ="";
			String month ="";
			int c=0;
			while(rSet.next()){
				int count=rSet.getInt("CNT");
				year=rSet.getString("Y");
				c++;
				month=rSet.getString("M");
				out.println("<TR><TD>6.  Total number of images uploaded in "+year+"/"+month+" between "+fDate+" and "+tDate+" is "+count+"</TD></TR>");
			}
			out.println("</TABLE>");
		}else {
			sql="SELECT count(*) AS CNT,EXTRACT(YEAR FROM i.timing) AS Y, EXTRACT(MONTH FROM i.timing) AS M,to_char(i.timing,'w') AS W"+
			" FROM images i "+
			"WHERE i.timing between '"+fDate+"' AND "+"'"+tDate+"' "+
			" GROUP BY EXTRACT(YEAR FROM i.timing), EXTRACT(MONTH FROM i.timing),to_char(i.timing,'w')";
			rSet=s.executeQuery(sql);
			out.println("<TABLE style='margin: 0px auto'>");
			String year ="";
			String month ="";
			String week ="";
			int c =0;
			while(rSet.next()){
				int count=rSet.getInt("CNT");
				year=rSet.getString("Y");
				c++;
				month=rSet.getString("M");
				week=rSet.getString("W");
				out.println("<TR><TD>7.  Total number of images uploaded in "+year+"/"+month+"/"+week+" between "+fDate+" and "+tDate+" is "+count+"</TD></TR>");
			}
			out.println("</TABLE>");
		}
	}//Group By time & sorttime
	else if(sortUser==null && sortSub==null && sortRange.equals("")==false){
		if(sortRange.equals("year")){
			sql="SELECT count(*) AS CNT,EXTRACT(YEAR FROM i.timing) AS Y "+
			"FROM images i, persons p "+
			"WHERE i.owner_name=p.user_name "+append+
			"GROUP BY EXTRACT(YEAR FROM i.timing)";
			rSet=s.executeQuery(sql);
			out.println("<TABLE style='margin: 0px auto'>");
			while(rSet.next()){
				int count=rSet.getInt("CNT");
				String year=rSet.getString("Y");
				out.println("<TR><TD>55. Total number of images group by year "+year+" is "+count+"</TD></TR>");
			}
			out.println("</TABLE>");
		}else if(sortRange.equals("month")){
			sql="SELECT count(*) AS CNT,EXTRACT(YEAR FROM i.timing) AS Y, EXTRACT(MONTH FROM i.timing) AS M"+
			" FROM images i, persons p "+
			"WHERE i.owner_name=p.user_name "+append+
			" GROUP BY EXTRACT(YEAR FROM i.timing), EXTRACT(MONTH FROM i.timing)";
			rSet=s.executeQuery(sql);
			out.println("<TABLE style='margin: 0px auto'>");
			while(rSet.next()){
				int count=rSet.getInt("CNT");
				String year=rSet.getString("Y");
				String month=rSet.getString("M");
				out.println("<TR><TD>66. Total number of images group by year/month "+year+"/"+month+" is "+count+"</TD></TR>");
			}
			out.println("</TABLE>");
		}else {
			sql="SELECT count(*) AS CNT,EXTRACT(YEAR FROM i.timing) AS Y, EXTRACT(MONTH FROM i.timing) AS M,to_char(i.timing,'w') AS W"+
			" FROM images i, persons p "+
			"WHERE i.owner_name=p.user_name "+append+
			" GROUP BY EXTRACT(YEAR FROM i.timing), EXTRACT(MONTH FROM i.timing),to_char(i.timing,'w')";
			rSet=s.executeQuery(sql);
			out.println("<TABLE style='margin: 0px auto'>");
			while(rSet.next()){
				int count=rSet.getInt("CNT");
				String year=rSet.getString("Y");
				String month=rSet.getString("M");
				String week=rSet.getString("W");
				out.println("<TR><TD>77. Total number of images group by year/month/week "+year+"/"+month+"/"+week+" is "+count+"</TD></TR>");
			}
			out.println("</TABLE>");
		}
	}
	//Group by Subject and User
	else if(sortUser!=null && sortSub!=null && sortRange.equals("")){
		sql="SELECT count(i.photo_id) AS CNT,i.owner_name, i.photo_id, i.subject"+" FROM images i "+"WHERE"+
		append+" GROUP BY i.owner_name, i.subject,i.photo_id";
		rSet=s.executeQuery(sql);
		out.println("<TABLE style='margin: 0px auto'>");
		int count=0;
		String name="";
		while(rSet.next()){
			count++;
			name =rSet.getString("subject");
			int count2=rSet.getInt("CNT");
			int pid=rSet.getInt("photo_id");
			out.println("<H3><CENTER> Owner: "+owner+" has uploaded photo_id: ("+pid+") which contains subject: "+subject+" </CENTER></H3>");
		}
	out.println("<H3><CENTER>8. Total number of images uploaded by user: "+owner+" containing subject: "+subject+" is "+count+" </CENTER></H3>");
	out.println("</TABLE>");
	}
	//Group By time and user
	else if(sortUser!=null && sortSub==null && sortRange.equals("")==false){
		if(sortRange.equals("year")){
			sql="SELECT count(*) AS CNT,EXTRACT(YEAR FROM i.timing) AS Y "+
			"FROM images i "+
			"WHERE "+append+
			" GROUP BY EXTRACT(YEAR FROM i.timing) ";
			rSet=s.executeQuery(sql);
			out.println("<TABLE style='margin: 0px auto'>");
			int c = 0;
			while(rSet.next()){
				int count=rSet.getInt("CNT");
				String year=rSet.getString("Y");
				//String name=rSet.getString("owner_name");
				c++;
				out.println("<TR><TD>9. Total number of images uploaded in year: "+year+" uploaded by user: "+owner+" is "+count+"</TD></TR>");
			}
			out.println("</TABLE>");
		}else if(sortRange.equals("month")){
			sql="SELECT count(*) AS CNT,EXTRACT(YEAR FROM i.timing) AS Y, EXTRACT(MONTH from i.timing) AS M "+
			"FROM images i "+
			"WHERE "+append+
			" GROUP BY EXTRACT(YEAR FROM i.timing),EXTRACT(MONTH from i.timing)";
			rSet=s.executeQuery(sql);
			out.println("<TABLE style='margin: 0px auto'>");
			int c=0;
			while(rSet.next()){
				c++;
				int count=rSet.getInt("CNT");
				String year=rSet.getString("Y");
				String month=rSet.getString("M");
				//String name=rSet.getString("owner_name");
				out.println("<TR><TD>10. Total number of images uploaded in year/month: "+year+"/"+month+" uploaded by user: "+owner+" is "+count+"</TD></TR>");
			}
			out.println("</TABLE>");
		}else{
			sql="SELECT count(*) AS CNT,EXTRACT(YEAR FROM i.timing) AS Y, EXTRACT(MONTH from i.timing) AS M,to_char(i.timing,'w') AS W "+
			"FROM images i "+
			"WHERE "+append+
			" GROUP BY EXTRACT(YEAR FROM i.timing),EXTRACT(MONTH from i.timing),to_char(i.timing,'w')";
			rSet=s.executeQuery(sql);
			out.println("<TABLE style='margin: 0px auto'>");
			int c=0;
			while(rSet.next()){
				int count=rSet.getInt("CNT");
				c++;
				String year=rSet.getString("Y");
				String month=rSet.getString("M");
				String week=rSet.getString("W");
				//String name=rSet.getString("owner_name");
				out.println("<TR><TD>11. Total number of images uploaded in year/month/week: "+year+"/"+month+"/"+week+" uploaded by user: "+owner+" is "+count+"</TD></TR>");
			}
			out.println("</TABLE>");
		}
	}//Group By time and subject
	else if(sortUser==null && sortSub!=null && sortRange.equals("")==false){
		if(sortRange.equals("year")){
			sql="SELECT count(*) AS CNT,EXTRACT(YEAR FROM i.timing) AS Y "+
			//sql="SELECT count(*) AS CNT,EXTRACT(YEAR FROM i.timing) AS Y, i.subject "+
			"FROM images i "+
			"WHERE "+append+
			" GROUP BY EXTRACT(YEAR FROM i.timing)";				
			//" GROUP BY EXTRACT(YEAR FROM i.timing), i.subject";
			rSet=s.executeQuery(sql);
			out.println("<TABLE style='margin: 0px auto'>");
			int c =0;
			while(rSet.next()){
				int count=rSet.getInt("CNT");
				c++;
				String year=rSet.getString("Y");
				//String name=rSet.getString("subject");
				out.println("<TR><TD>12. Total number of images uploaded in year: "+year+" uploaded containing subject: "+subject+" is "+count+"</TD></TR>");
			}
			out.println("</TABLE>");
		}else if(sortRange.equals("month")){
			sql="SELECT count(*) AS CNT,EXTRACT(YEAR FROM i.timing) AS Y, EXTRACT(MONTH from i.timing) AS M "+
			"FROM images i "+
			"WHERE "+append+
			" GROUP BY EXTRACT(YEAR FROM i.timing),EXTRACT(MONTH from i.timing) ";
			rSet=s.executeQuery(sql);
			out.println("<TABLE style='margin: 0px auto'>");
			int c =0;
			while(rSet.next()){
				int count=rSet.getInt("CNT");
				c++;
				String year=rSet.getString("Y");
				String month=rSet.getString("M");
				//String name=rSet.getString("subject");
				out.println("<TR><TD>13. Total number of images uploaded in year/month: "+year+"/"+month+" uploaded containing subject: "+subject+" is "+count+"</TD></TR>");
			}
			out.println("</TABLE>");
		}else{
			sql="SELECT count(*) AS CNT,EXTRACT(YEAR FROM i.timing) AS Y, EXTRACT(MONTH from i.timing) AS M,to_char(i.timing,'w') AS W "+
			"FROM images i "+
			"WHERE "+append+
			" GROUP BY EXTRACT(YEAR FROM i.timing),EXTRACT(MONTH from i.timing),to_char(i.timing,'w')";
			rSet=s.executeQuery(sql);
			out.println("<TABLE style='margin: 0px auto'>");
			int c = 0;
			while(rSet.next()){
				int count=rSet.getInt("CNT");
				c++;
				String year=rSet.getString("Y");
				String month=rSet.getString("M");
				String week=rSet.getString("W");
				//String name=rSet.getString("subject");
				out.println("<TR><TD>14. Total number of images uploaded in year/month/week: "+year+"/"+month+"/"+week+" uploaded containing subject: "+subject+" is "+count+"</TD></TR>");
			}
			out.println("</TABLE>");
		}
	}//Group By owner,time and subject
	else if(sortUser!=null && sortSub!=null && sortRange.equals("")==false){
		if(sortRange.equals("year")){
			sql="SELECT count(*) AS CNT,EXTRACT(YEAR FROM i.timing) AS Y "+
			"FROM images i "+
			"WHERE "+append+
			" GROUP BY EXTRACT(YEAR FROM i.timing)";
			rSet=s.executeQuery(sql);
			out.println("<TABLE style='margin: 0px auto'>");
			while(rSet.next()){
				int count=rSet.getInt("CNT");
				String year=rSet.getString("Y");
				//String name=rSet.getString("owner_name");
				//String sub=rSet.getString("subject");
				out.println("<TR><TD>15. Total number of images uploaded in year: "+year+" uploaded containing subject: "+subject+" by user: "+owner+" is "+count+"</TD></TR>");
			}
			out.println("</TABLE>");
		}else if(sortRange.equals("month")){
			sql="SELECT count(*) AS CNT,EXTRACT(YEAR FROM i.timing) AS Y, EXTRACT(MONTH from i.timing) AS M "+
			"FROM images i "+
			"WHERE "+append+
			" GROUP BY EXTRACT(YEAR FROM i.timing),EXTRACT(MONTH from i.timing)";
			rSet=s.executeQuery(sql);
			out.println("<TABLE style='margin: 0px auto'>");
			while(rSet.next()){
				int count=rSet.getInt("CNT");
				String year=rSet.getString("Y");
				String month=rSet.getString("M");
				//String name=rSet.getString("owner_name");
				//String sub=rSet.getString("subject");
				out.println("<TR><TD>16. Total number of images uploaded in year/month: "+year+"/"+month+" uploaded containing subject: "+subject+" by user: "+owner+" is "+count+"</TD></TR>");
			}
			out.println("</TABLE>");
		}else{
			sql="SELECT count(*) AS CNT,EXTRACT(YEAR FROM i.timing) AS Y, EXTRACT(MONTH from i.timing) AS M,to_char(i.timing,'w') AS W "+
			"FROM images i "+
			"WHERE "+append+
			" GROUP BY EXTRACT(YEAR FROM i.timing),EXTRACT(MONTH from i.timing),to_char(i.timing,'w')";
			rSet=s.executeQuery(sql);
			out.println("<TABLE style='margin: 0px auto'>");
			while(rSet.next()){
				int count=rSet.getInt("CNT");
				String year=rSet.getString("Y");
				String month=rSet.getString("M");
				String week=rSet.getString("W");
				//String sub=rSet.getString("subject");
				//String name=rSet.getString("owner_name");
				out.println("<TR><TD>17. Total number of images uploaded in year/month/week: "+year+"/"+month+"/"+week+" uploaded containing subject: "+subject+" by user: "+owner+" is "+count+"</TD></TR>");
			}
			out.println("</TABLE>");
		}
	}else{
		out.println("<TABLE style='margin: 0px auto'>");
		out.println("<TR><TD>Error: Condition Not Specified</TD></TR>");
		out.println("</TABLE>");
	}
	con.close();
%>
	<FORM NAME='ReturnForm' ACTION='olap.jsp' METHOD='get'>
		<CENTER>
			<INPUT TYPE='submit' NAME='AnalysisRequest' VALUE='Return'>
		</CENTER>
	</FORM>
</BODY>
</HTML>
