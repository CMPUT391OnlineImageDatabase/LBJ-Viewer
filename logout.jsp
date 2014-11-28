<html>
<body>
<%
session.removeAttribute("USERNAME");
response.sendRedirect("welcome.html");
%>
</body>
</html>
