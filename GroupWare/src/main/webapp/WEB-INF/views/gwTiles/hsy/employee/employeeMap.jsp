<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<% String ctxPath= request.getContextPath(); %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap-theme.min.css">
<style type="text/css">

	div#employeeMapContainer{ 
		border: solid 0px red;
		overflow: hidden;
		width:1300px;
		margin: 0 auto;
		position: relative;
		left: -150px;
		padding-bottom: 100px;
	}
	
	div#employeeMapTitle{
		border: solid 0px red;
		margin: 70px 0px 30px 70px;
		font-size: 22pt;
		font-weight: bold;
	}
	
	div#employeeBox{
		border: solid 2px #003d66;
		margin: 0px 0px 30px 70px;
		float: left;
		width: 340px;
		padding: 0px 20px;
	}
	
	div.companyName{
		font-size: 15pt;
		padding: 15px 0px;
		color:#004d80;
		font-weight: bold;
	}
	
	div.clickMenu{
		border-top: solid 1px #003d66;
		font-size: 15pt;
		padding: 15px 0px;
		color:#004d80;
		font-weight: bold;
	}
	
	div#allBt {
		float: left;
		margin-bottom: 20px;
		border: solid 0px red;
		margin: 20px 0px 20px 70px;
		border: solid 0px red;
		width: 350px;
	}
	
	div#allBt button{
		width: 162px;
		height: 40px;
		margin-left: 11px;
		background-color: #003d66;
		color:#fff;
		border: none;
	}
	
	span.plus, span.minus{
		display: inline-block;
		width: 30px;
	}
	
	div#employeeMapContainer li{
		line-height: 30px;
	
	}
	
	div#employeeMapContainer ul{
		list-style-type: none;
	}
	
	div.modalLocation {margin-top:100px;}
	
	table#employeeListTable tr.employeeListTr{
		cursor:pointer;
		height: 50px;
	}
	
	table#employeeListTable tr{
		border-top: solid 1px #003d66;
		border-bottom: solid 1px #003d66;
		text-align: center;
	}
	
	table#employeeListTable tr.employeeListTr:hover{
		background-color: #ccebff;
		color: #006bb3;
	}
	
	ul.hideInfo li:hover{
		color: #0071bd;
		font-weight: bold;
	}
	
	div#employeeMapA{
		margin-top:20px; 
		font-size:13pt;
	}
	
	div#employeeMapA a{
		text-decoration: none;
		color: #696969;
	}

	table#oneEmployeeTable{
		width: 95%;
		margin: 0 auto;
	}

	table#oneEmployeeTable th, table#oneEmployeeTable td {
		border: solid 1px #bdc2bd;
		border-collapse: collapse;
		height: 50px;
		vertical-align: middle;
	}
	
	table#oneEmployeeTable th {
		text-align: center;
		color: #fff;
		background-color: #003d66;
	}
	
	table#oneEmployeeTable td {padding-left: 15px;}
		
	button.sendMail{
		cursor:pointer;
		margin-left: 65px;
		width: 120px;
		height: 30px;
		border: solid 1px #caceca;
		border-radius: 4px;
		text-shadow: 0px 1px 0px #ccc;
	}
	
	button.sendMail:hover{
		font-weight: bold;
		color: #003d66;
		border: solid 1px #003d66;
	}
	
	span.attendanceSeq1{background-color: #b30000;}
	
	span.attendanceSeq2{background-color: #008060;}
	
	span.attendanceSeq{
		margin-left: 10px;
		color: #fff;
		font-weight: bold;
		display: inline-block;
		width: 100px;
		height: 30px;
		font-size: 14pt;
		text-align: center;
		padding-top: 4px;
		border-radius: 8%;
		position: relative;
		top: 3px;
	}
	
</style>

<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
<script type="text/javascript">

	$(document).ready(function(){
		
		
		// ???????????? ??????????????? ???????????? show ????????? ?????? 
		$("ul.hideInfo").hide();
		$("span.minus").hide();
		$("ul.companyHideInfo").show();
		$("div.companyName").find("span.minus").show();
		$("div.companyName").find("span.plus").hide();
		
		// searchType??? searchWord??? ???????????? ??????
		if("${searchType}"!=""){
			$("select#searchType").val("${searchType}");
		}
		if("${searchWord}"!=""){
			 $("input#searchWord").val("${searchWord}")
		}
		
		
		// ????????? ???????????????
		$("div.companyName").click(function(){
			if($("div.hideDeptInfo").css('display')=='none'){
				$("div.hideDeptInfo").show(500);
				$(this).next().show(500);
				$(this).find("span.minus").show();
				$(this).find("span.plus").hide();
				
			}
			else{
				$("div.hideDeptInfo").hide();
				$(this).next().hide();
				$("span.minus").hide();
				$("span.plus").show();
				$("ul.hideInfo").hide();
				
			}
		});	// end of $("div.companyName").click(function(){-----
		
		
		// ???????????? ???????????????
		$("div.clickMenu").click(function(){
			if($(this).next().css('display')=='none'){
				$(this).next().show(500);
				$(this).find("span.minus").show();
				$(this).find("span.plus").hide();
			}
			else{
				$(this).next().hide();
				$(this).find("span.minus").hide();
				$(this).find("span.plus").show();
			}
		}); // end of $("div.clickMenu").click(function(){-----

		
		// ??????????????? ??????????????????????????? ????????? ??????
		$("input#searchWord").keydown(function(event){
			 if(event.keyCode==13){ 
				 goSearchEmployee();
			  }
		});	// end of $("input#searchWord").keydown(function(event){----
		
		
		// ??????????????? ?????? ?????? ??? ???????????? ??????????????? ??????
		$("div#employeeMapContainer li").click(function(){
			
			var employeeid= $(this).prop('id');
			getOneEmployeeInfo(employeeid);
			
			$("div.modal").modal();
		});
		
		// ?????????????????? ?????? ?????? ??? ???????????? ??????????????? ??????
		$("table#employeeListTable tr.employeeListTr").click(function(){
			
			var employeeid= $(this).prop('id');
			getOneEmployeeInfo(employeeid);
			
			$("div.modal").modal();
		});	
		
		
		// ??????????????? ?????? ????????? ?????????
		$(document).on('click',"button.sendMail",function(){
			
			var addrsBookEmail= $(this).prev().text();
			location.href="<%=ctxPath%>/t1/new_mail.tw?addrsBookEmail="+addrsBookEmail;
		});
		
		
	}); // end of $(document).ready(function(){----------
	
		
	// ========= function declaration =========
	
	// ???????????? ??????
	function showAll(){
		$("span.minus").show();
		$("span.plus").hide();
		$("ul.hideInfo").show();
		$("div.hideDeptInfo").show(500); 
		
	}// end of function showAll(){-----
		
	// ???????????? ??????
	function hideAll(){
		$("span.minus").hide();
		$("span.plus").show();
		$("ul.hideInfo").hide();
		$("div.hideDeptInfo").hide();
		
	}// end of function hideAll(){-------
		
	// ??????????????????	
	function goSearchEmployee(){
		
		var searchType= $("select#searchType").val();
		var searchWord= $("input#searchWord").val().trim();
		
		if(searchWord!="" && searchType==""){ // ???????????? ??????????????? ??????????????? ???????????? ?????? ??????
			alert("??????????????? ????????? ?????????.");
			return;
		}
		
		location.href="<%=ctxPath%>/t1/employeeMap.tw?searchType="+searchType+"&searchWord="+searchWord;	
	
	} // end of function goSearchEmployee(){------- 	
	
		
	// ???????????? ?????? ??????	
	function getOneEmployeeInfo(employeeid){
		 
		$.ajax({
	    	url:"<%=ctxPath%>/t1/employeeInfoAjaxHsy.tw",
	   		type:"POST",
	   		data:{"employeeid":employeeid},
	   		dataType:"json",
	   		success:function(json){
				
	   			var html= "<table id='oneEmployeeTable'>"+
					   		  "<tr>"+
					   		  	"<td rowspan='4' style='width:130px; padding-left:0px;'>"+
					   		  	"<img src='<%=ctxPath%>/resources/images/bwb/"+json.fileName+"' width='130px' height='150px' />"+
					   		  	"</td>"+
					   		  "</tr>"+
		   					  "<tr>"+
		   					  	"<th style='width: 70px;'>??????</th>"+
		   					 	"<td style='width: 80px;'>"+json.employeeid+"</td>"+
		   						"<th>?????????</th>"+
		   						"<td colspan='3'>"+
		   							"<span>"+json.email+"</span>"+
		   							"<button type='button' class='sendMail'>???????????????</button>";
	   							if(json.attendanceSeq!="?????? ???"){
	   								html+="<span class='attendanceSeq attendanceSeq1'>"+json.attendanceSeq+"</button>";
	   							}
	   							else{
	   								html+="<span class='attendanceSeq attendanceSeq2'>"+json.attendanceSeq+"</button>";
	   							}
		   							
		   				html+=  "</td>"+
		   					  "</tr>"+
		   					  "<tr>"+
		   						"<th>?????????</th>"+
		   						"<td>"+json.name+"</td>"+
		   						"<th>????????????</th>"+
		   						"<td>"+json.cmobile+"</td>"+
		   						"<th>?????????</th>"+
		   						"<td>"+json.mobile+"</td>"+
		   					  "</tr>"+
		   					  "<tr>"+
			   					"<th>??????</th>"+
			   					"<td>"+json.dname+"</td>"+
			   					"<th>??????</th>"+
			   					"<td>"+json.pname+"</td>"+
			   					"<th>??????</th>"+
			   					"<td>"+json.duty+"</td>"+
		   					  "</tr>"+
	   			      	  "</table>";
	   				      	  
	   			 $("div.modal-body").html(html);
	   		},
	   		error: function(request, status, error){
	        	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	        }
	   }); // end of ajax-----------------------------
	   	    
	} // end of function getOneEmployeeInfo(employeeid){---------
		
</script>

	<div id="employeeMapContainer">
		<div id="employeeMapTitle">T1Works ?????????</div>
		
		<div id="allBt">
			<button type="button" style="margin-left:0px;" onclick='javascript:showAll();'>???&nbsp;&nbsp;??????????????????</button>
			<button type="button" onclick='javascript:hideAll();'>???&nbsp;&nbsp;??????????????????</button>
		</div>
		
		<div style="float:right;">
			<select id="searchType" style="height: 30px; width: 120px; cursor:pointer; position:relative; top: -65px;">
				<option value="">&nbsp;&nbsp;???????????????</option>
				<option value="name">&nbsp;&nbsp;?????????</option>
				<option value="dname">&nbsp;&nbsp;??????</option>
				<option value="pname">&nbsp;&nbsp;??????</option>
				<option value="email">&nbsp;&nbsp;?????????</option>
			</select>
			<input type="text" id="searchWord" placeholder="   ???????????? ???????????????." style="height: 30px; width: 230px; position:relative; top: -65px;" />
			<button type="button" onclick="javascript:goSearchEmployee();" style="height: 30px; background-color: #003d66; color:#fff; border:none; position:relative; top: -65px;">??????</button>
		</div>
		
		<div style="clear:both;"></div>
		
		<div id="employeeBox" style="cursor:pointer;">
			<div class="companyName">
				<span class="plus" style="color:#262626; font-weight:bold;">???</span>
				<span class="minus" style="color:#5e5e5e; font-weight:bold;">???</span>
				T1Works
			</div>
			<c:forEach var="memberVO" items="${employeeList}">
				<ul class="hideInfo companyHideInfo">
				<c:if test="${memberVO.fk_pcode eq '4'}">
					<li id="${memberVO.employeeid}">${memberVO.name} ??????</li>
				</c:if>
				</ul>
			</c:forEach>
			
			<c:forEach var="departmentVO" items="${departmentList}">
				<div class="clickMenu hideDeptInfo">
					<span class="plus" style="color:#262626; font-weight:bold;">???</span>
					<span class="minus" style="color:#5e5e5e; font-weight:bold;">???</span>
					${departmentVO.dname}
				</div>
				<ul class="hideInfo">
				<c:forEach var="memberVO" items="${employeeList}">
					<c:if test="${departmentVO.dcode eq memberVO.fk_dcode}">
						<li id="${memberVO.employeeid}">${memberVO.name}
							<c:if test="${memberVO.fk_pcode eq '1'}">??????</c:if>
							<c:if test="${memberVO.fk_pcode eq '2'}">??????</c:if>
							<c:if test="${memberVO.fk_pcode eq '3'}">??????</c:if>
						</li>
					</c:if>
				</c:forEach>
				</ul>
			</c:forEach>
			
		</div>
		
		<div style="border: solid 0px red; float:right; width: 700px; position:relative; top: -60px;">
			<div style="margin-bottom:20px; font-weight:bold; padding-left: 15px;"><h4>????????????</h4></div>
			<table id="employeeListTable">
				<tr style="height:50px; background-color: #003d66; color:#fff; font-weight: bold; ">
					<th style="width: 100px; text-align: center;">??????</th>
					<th style="width: 100px; text-align: center;">?????????</th>
					<th style="width: 90px; text-align: center;">??????</th>
					<th style="width: 100px; text-align: center;">??????</th>
					<th style="width: 150px; text-align: center;">????????????</th>
					<th style="width: 150px; text-align: center;">?????????</th>
					<th style="width: 170px; text-align: center;">?????????</th>
				</tr>
				<c:if test="${not empty pagingEmployeeList}">
					<c:forEach var="memberVO" items="${pagingEmployeeList}">
						<tr class="employeeListTr" id="${memberVO.employeeid}">
							<td>${memberVO.employeeid}</td>
							<td>${memberVO.name}</td>
							<td>${memberVO.pname}</td>
							<td>${memberVO.dname}</td>
							<td>${memberVO.mobile}</td>
							<td>${memberVO.cmobile}</td>
							<td>${memberVO.email}</td>
						</tr>
					</c:forEach>
				</c:if>
				<c:if test="${empty pagingEmployeeList}">
					<tr><td colspan="7" style="height: 50px;">??????????????? ???????????? ????????? ????????????.</td></tr>
				</c:if>
			</table>
			<div id="employeeMapA" align="center">${pageBar}</div>
		</div>
		
		<!-- ??? ???????????? modal??? ???????????? -->
		<div class="modal fade modalLocation" id="layerpop" >
	  		<div class="modal-dialog modal-lg">
		    	<div class="modal-content">
			      	<!-- header -->
			      	<div class="modal-header">
			        	<!-- ??????(x) ?????? -->
			        	<button type="button" class="close" data-dismiss="modal">??</button>
			        	<!-- header title -->
			        	<h4 class="modal-title">?????? ????????????</h4>
			      	</div>
			      	<!-- body (ajax??? ?????? ????????????) -->
			      	<div class="modal-body"></div>
			      	<!-- Footer -->
			      	<div class="modal-footer">
			        	<button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
			      	</div>
		    	</div>
	  		</div>
		</div>
	</div>