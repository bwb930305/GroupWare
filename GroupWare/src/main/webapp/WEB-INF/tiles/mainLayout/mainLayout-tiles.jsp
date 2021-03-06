<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>

<%
   String ctxPath = request.getContextPath();
   //     /groupware
%> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>티원투어</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <link rel="stylesheet" type="text/css" href="<%=ctxPath %>/resources/css/mainStyle.css" />
</head>

<body>
	<div id="container"> <%-- (디자인은mainStyle.css에 있음) --%>
	    <div id="mainHeader">
	        <tiles:insertAttribute name="header" />     
	    </div>
	    
   	    <div id="mainSideinfo">
	        <tiles:insertAttribute name="sideinfo" />     
	    </div>
	      
	    <div id="mainContent">
	        <tiles:insertAttribute name="content" />
	    </div>
	      
	    <div id="mainFooter">
	       <tiles:insertAttribute name="footer" />
	    </div>
    </div>
</body>
</html>
  