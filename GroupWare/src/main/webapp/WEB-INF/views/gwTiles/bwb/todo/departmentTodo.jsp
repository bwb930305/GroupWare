<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
	String ctxPath = request.getContextPath();
%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<style>
	table#clientList{
		border:solid 0px black;
		border-collapse: collapse;
		width: 800px;
		margin-left:45px;
	}
	
	table#clientList td{
		border:solid 1px black;
		text-align: center;
	}
	
	table#clientList th{
		border:solid 1px black;
		font-weight: bolder;
		text-align: center;
	}
	
	table#headerMenu {
		border-collapse: collapse;
		width: 800px;
		margin-left:29px;
		margin-bottom:20px;
	}
	
	table#headerMenu td{
		border:solid 1px black;
		padding-left: 5px;
		text-align: center;
	}
	
	table#headerMenu th{
		border:solid 1px black;
		padding-left: 5px;
		text-align: center;
	}
	
	h4.modal-title{
		margin-left:15px;
		font-weight: bolder;
	}
	
	div.client-pageBar{
		border:solid 0px red;
		margin-top: 20px;
		margin-left: 280px;
		width: 300px;
		text-align: center; 
	}
	
	div#DepartmentMenu{
		border:solid 1px black;
	}
	
	label.period{
		width:60px;
	}
	
	span.dsubmenu{
		display: inline-block;
		width: 80px;
		margin-right: 20px;
		font-weight: bolder;
	}
	
	div.ddiv{
		margin-left:15px;
		height:50px;
		border-bottom:solid 1px #ccc;
		padding-top:10px;"
	}
	
	div#dbuttons{
		padding-top:10px;
		margin-left: 400px;
	}
	
	div#DepartmentInfo{
		width:1000px;
		border:solid 1px black;
		margin-top: 15px;
	}
	
	span.sInfo{
		display:inline-block;
	}
	
	span.sheader{
		font-weight: bolder;
	}
	
	button.ingdetail{
		font-size:8pt;
		display: inline-block;
		margin-bottom:5px;
	}
	
	div.getOneInfo{
		margin-bottom:15px;
		border-bottom: solid 1px #ccc;
	}
	
	div#pageBar{
		border:solid 0px red;
		text-align:center;
	}
	
	div#toDoTitle{
		font-weight: bolder;
		font-size: 15pt;
	}
	
	div#infoMenu{
		background-color: #94b8b8 !important;
	}
	
	span.buttonspan{
		font-size:8pt;
	}
	
	button.buttonMail{
		height: 17px;
		background-color: #b3e0ff;
		font-weight: bolder;
	}
	
	th.menuName{
		background-color: #94B8B8;
	}
</style>

<script type="text/javascript">

	$(document).ready(function(){
		
		// ???????????? ?????? ??? ????????? ??? ??????????????? ??????
		var periodChoice = "${paraMap.period}";
		var searchProject = "${paraMap.searchProject}";
		var searchWhoCharge = "${paraMap.searchWhoCharge}";
		var statusChoice_es = "${paraMap.statusChoice_es}";
		
		$("input:radio[name=periodChoice]").each(function(index,item){
			
			if(periodChoice == $(item).val()){
				$(item).prop("checked",true);
				return false;
			}
			
		});
		
		if(statusChoice_es!=""){
			
			var statusChoiceArr = statusChoice_es.split(",");
			
			$("input:checkbox[name=statusChoice]").each(function(index,item){
				
				for(var i=0; i<statusChoiceArr.length; i++){
					if($(item).val()==statusChoiceArr[i]){
						$(item).prop("checked",true)
						break;
					}
				}// end of for--
			})// end of each(function
		}// end of if
		
		$("input#searchProject").val(searchProject);
		$("input#searchWhoCharge").val(searchWhoCharge);
		
		// ???????????? ?????? ??? ????????? ??? ??????????????? ???
		
		
		
		
		
		
		// ???????????? 
		$("button#whatSearch").click(function(){

			var period = $("input:radio[name=periodChoice]:checked").val();
			
			var statusChoiceArr = new Array();
			
			$("input:checkbox[name=statusChoice]:checked").each(function(index,item){
				
				var statusChoice = $(this).val();
				statusChoiceArr.push(statusChoice);
				
			}); // end of $("input:radio[name=statusChoice]").each(function(index,item){
			
			var statusChoice_es = statusChoiceArr.join();
			
			var searchProject = $("input#searchProject").val();
			var searchWhoCharge = $("input#searchWhoCharge").val();
			
			location.href="<%= ctxPath%>/t1/departmentTodo.tw?period="+period+"&statusChoice_es="+statusChoice_es+"&searchProject="+searchProject+"&searchWhoCharge="+searchWhoCharge;

			
		});// end of $("button#whatSearch").click(function(){
			
		// ?????? ?????? ???????????????	
		$("div.getOneInfo").click(function(){
			
			var startdate = $(this).find("span.startDate").text();
			var pNo = $(this).find("input.pNo").val();
			var endDate = $(this).prop("id");
			var currentShowPageNo = "1";
			
			if(startdate=="-"){
				alert("??????????????? ????????? ?????? ???????????????. \n??????????????? ??????????????????.");
				return;
			}
			else{
				$("div#myModal").modal();
				getOneDoInfo(pNo,endDate,currentShowPageNo);
			}
			
		}); // end of $("div#btn").click(function(){
		
			
			
		// ?????????????????? ??????????????? ???????????????
		$(document).on("click",("span.producting"),function(){
			var clientmobile1 = $(this).parent().prev().prop("id");
			var clientmobile = clientmobile1.split("-").join("");
			var clientname = $(this).parent().prev().prev().prev().text();
			
			var fk_pNo =  $(this).parent().prev().find("input.fk_pNo").val();
			
			$.ajax({
				url:"<%= ctxPath%>/t1/sendEmailIngTodo.tw",
				data:{"clientmobile":clientmobile,
					  "fk_pNo":fk_pNo},
				type:"post",
				dataType:"json",
				success:function(json){
					
					if(json.n==0){
						alert(clientname+" ????????? ??????????????? [???????????????]????????? ??????????????????.");
					}
					else{
						alert("??????????????? ??????????????????.");
					}
				},
		    	error: function(request, status, error){
		            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		        }
				
			}); // end of ajax
			
			
		});// end of $(document).on("click",("span.producting"),function(){
			
		// ?????????????????? ???????????? ???????????????
		$(document).on("click",("span.productCompleted"),function(){
			var clientmobile1 = $(this).parent().prev().prop("id");
			var clientmobile = clientmobile1.split("-").join("");
			var clientname = $(this).parent().prev().prev().prev().text();
			var fk_pNo =  $(this).parent().prev().find("input.fk_pNo").val();
			
			$.ajax({
				url:"<%= ctxPath%>/t1/sendEmailIngDone.tw",
				data:{"clientmobile":clientmobile,
					  "fk_pNo":fk_pNo},
				type:"post",
				dataType:"json",
				success:function(json){
					if(json.n==0){
						alert(clientname+" ????????? ??????????????? ??????????????? ??????????????????.");
					}
					else{
						alert("??????????????? ??????????????????.");
					}
				},
		    	error: function(request, status, error){
		            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		        }
			});
			
			
			
		}); // end of $(document).on("click",("span.productCompleted"),function(){
		
			
	})// end of $(document).ready(function(){
		
	// Function Declaration
	
	// ????????? ?????? #1
	function getOneDoInfo(pNo,endDate,currentShowPageNo){
		 
		$.ajax({
			url:"<%= ctxPath%>/t1/deptgetOneInfoheader.tw",
			type:"get",
			data:{"pNo":pNo},
			dataType:"json",
			success:function(json){
				
				var html = "";
				html+="<table id='headerMenu'>";
				html+="<th class='menuName'>???????????????</th>";
				html+="<th class='menuName'>???????????????</th>"
				html+="<th class='menuName'>???????????????</th>";
				html+="<th class='menuName'>???????????????</th>";
				html+="<th class='menuName'>????????????</th>";
				html+="<tr>";
				html+="<td>"+json.pname+"</td>";
				html+="<td>"+json.nowno+"</td>";
				html+="<td>"+json.minino+"</td>";
				html+="<td>"+json.maxno+"</td>";
				html+="<td>"+json.startDate+" - "+json.endDate+"("+json.period+")</td>";
				html+="</tr>";
				html+="</talbe>"
				
				$("div.modal-body").html(html);
				
				if(endDate == '-'){
					$("h4.modal-title").text("?????????");
				}
				else{
					$("h4.modal-title").text("????????????");
				}
				
				selectClient(pNo,endDate,currentShowPageNo);
				
			},
	    	error: function(request, status, error){
	            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	        }
		}); // end of $.ajax({ 
		
		
	}// end of function getOneDoInfo(pNo,endDate)
	
	// ???????????? ??? ??????????????? ?????? ?????????????????? ??????????????? ????????????
	function selectClient(pNo,endDate,currentShowPageNo){
		
		$.ajax({
			url:"<%= ctxPath%>/t1/selectClient.tw",
			data:{"pNo":pNo,
				  "currentShowPageNo":currentShowPageNo},
			type:"post",
			dataType:"json",
			success:function(json){
				var html ="";
				html+="<table id='clientList'>";
				html+="<th colspan='4' style='text-align:center; backgroud-color:#0088cc;'>*** ??????????????? ***</th>";
				html+="<tr>"
				html+="<td>????????????</td>";
				html+="<td>?????????</td>";
				html+="<td>?????????</td>";
				html+="<td></td>";
				html+="</tr>"
				
				$.each(json,function(index,item){
					
					html +="<tr>";
					html +="<td>"+item.clientname+"</td>";
					html +="<td>"+item.cnumber+"</td>";
					html +="<td id='"+item.clientmobile+"'>"+item.clientmobile+"<input class='fk_pNo' type='hidden' value='"+pNo+"'></td>";
					if(endDate == '-'){
						html +="<td><span class='producting buttonspan'><button class='buttonMail'>???????????????</button></span></td>";
					}
					else{
						html +="<td><span class='productCompleted buttonspan'><button class='buttonMail'>???????????????</button></span></td>";
					}
					html +="</tr>";
				});
				
				html +="</table>";
				$("div.client-body").html(html);
				
				// ???????????? ?????? ??????
				clientPagebar(pNo,endDate,currentShowPageNo);
				
			},
	    	error: function(request, status, error){
	            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	        }
	
		}); // end of $.ajax({
				
	}// end of function selectClient(pNo,endDate,currentShowPageNo){
		
	function clientPagebar(pNo,endDate,currentShowPageNo){
		
		$.ajax({
			url:"<%= ctxPath%>/t1/clientPagebar.tw",
			data:{"sizePerPage":"3",
				  "pNo":pNo},
			dataType:"json",
			success:function(json){
				
				if(json.totalPage>0){
					
					var totalPage = json.totalPage;
					
					var pageBarHTML = "<ul style='list-style: none;'>";
					
					var blockSize = 3;
					
					var loop = 1;
					
					if(typeof currentShowPageNo == "string"){
			        	currentShowPageNo = Number(currentShowPageNo);
			        }
					
					var pageNo = Math.floor((currentShowPageNo - 1)/blockSize) * blockSize + 1;
					
					// === [?????????][??????] ????????? ===       a href='javascript:selectClient("+pNo+","+endDate+",1)'
					if(pageNo != 1) {
						pageBarHTML += "<li style='display:inline-block; width:50px; font-size:10pt;'><a href='javascript:selectClient("+pNo+",\""+endDate+"\",\"1\")'>[?????????]</a></li>";
						pageBarHTML += "<li style='display:inline-block; width:50px; font-size:10pt;'><a href='javascript:selectClient("+pNo+",\""+endDate+"\",\""+(pageNo-1)+"\")'>[??????]</a></li>";
						
					}
					
					
					while(!((loop>blockSize)||pageNo>totalPage)) {
						
						if(pageNo == currentShowPageNo) {
							pageBarHTML += "<li style='display:inline-block; width:50px; font-size:10pt; border:solid 0px gray; color:red; padding:2px 4px;'>"+pageNo+"</li>";
			            }
						else {
							pageBarHTML += "<li style='display:inline-block; width:50px; font-size:10pt;'><a href='javascript:selectClient("+pNo+",\""+endDate+"\",\""+pageNo+"\")'>"+pageNo+"</a></li>";
						}
						
						loop++;
						pageNo++;
					}// end of while() { 
					
					// === [??????][?????????] ????????? ===
					if(pageNo <= totalPage) { // ????????? ?????????????????? ?????? ????????? ???????????????
						
						pageBarHTML += "<li style='display:inline-block; width:50px; font-size:10pt;'><a href='javascript:selectClient("+pNo+",\""+endDate+"\",\""+pageNo+"\")'>[??????]</a></li>";
						pageBarHTML += "<li style='display:inline-block; width:50px; font-size:10pt;'><a href='javascript:selectClient("+pNo+",\""+endDate+"\",\""+totalPage+"\")'>[?????????]</a></li>";
						
					}
					
					pageBarHTML += "</ul>";
		               
					$("div.client-pageBar").html(pageBarHTML);
					
					
				}// end of if(json.totalPage>0){
				
				
			},
	    	error: function(request, status, error){
	            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	        }
			
		});
		
		
	} // end of function clientPagebar(currentShowPageNo)

</script>
<div id="content" style="border: solid 0px black; margin-left: 70px; margin-top: 50px; width:1000px;">
	<div id="toDoTitle" style="margin-top: 30px; margin-bottom: 30px;">${dname} ????????? ?????? ????????????</div>
	<div id="DepartmentMenu"  style="height:250px;">
		<form name="whatSearch">
		<div id="period" class="ddiv">
			<span class="dsubmenu">??????(?????????)</span>
			<label class="period" id="period1"><input name="periodChoice" type="radio" id="period1" value="7">1??????</label>
			<label class="period" id="period2"><input name="periodChoice" type="radio" id="period2" value="30">1??????</label>
			<label class="period" id="period3"><input name="periodChoice" type="radio" id="period3" value="90">3??????</label>
			<label class="period" id="period4"><input name="periodChoice" type="radio" id="period4" value="-1">??????</label>
		</div>
		<div id="doStatus" class="ddiv">
			<span class="dsubmenu">????????????</span>
			<label id="status1"><input name="statusChoice" type="checkbox" id="status1" value="1">?????????</label>
			<label id="status2"><input name="statusChoice" type="checkbox" id="status2" value="2">?????????</label>
			<label id="status3"><input name="statusChoice" type="checkbox" id="status3" value="3">?????????</label>
			<label id="status4"><input name="statusChoice" type="checkbox" id="status4" value="4">??????</label>
			<label id="status5"><input name="statusChoice" type="checkbox" id="status5" value="5">??????</label>
			<label id="status6"><input name="statusChoice" type="checkbox" id="status6" value="6">??????</label>
		</div>
		<div id="projectName" class="ddiv">
			<span class="dsubmenu">???????????????</span>
			<input type="text" id="searchProject" name="searchProject" placeholder="????????? ??????????????????."  />
		</div>
		<div id="whoAssigned" class="ddiv">
			<span class="dsubmenu">????????????</span>
			<input type="text" id="searchWhoCharge" name="searchWhoCharge" placeholder="????????? ??????????????????."  />
		</div>
		<div id="dbuttons">	
		<button type="button" id="whatSearch">??????</button>
		<button type="reset">?????????</button>
		</div>
		</form> 
	</div>
	
	
	<div id="DepartmentInfo">
		<div id="infoMenu" style="padding-left:9px; margin-bottom:6px; border-bottom:solid 1px #ccc;">
			<span class="sInfo sheader" style="width:50px;">??????</span>
			<span class="sInfo sheader" style="width:240px;">???????????????</span>
			<span class="sInfo sheader" style="width:100px;">?????????</span>
			<span class="sInfo sheader" style="width:100px;">?????????</span>
			<span class="sInfo sheader" style="width:100px;">?????????</span>
			<span class="sInfo sheader" style="width:100px;">?????????</span>
			<span class="sInfo sheader" style="width:100px;">?????????</span>
			<span class="sInfo sheader" style="width:70px;">?????????</span>
			<span class="sInfo sheader" style="width:70px;">??????</span>
		</div>
	
		
		<div id="infoContent" style="margin-left:10px;">
			<c:if test="${not empty productList}">
				<c:forEach var="product" items="${productList}">
					<div class="getOneInfo" id="${product.endDate}">
					<input type="hidden" class="pNo" value="${product.pNo}"/>
					<span class="sInfo" style="width:50px; padding-left:8px;">${product.rno}</span>
					<c:if test="${product.hurryno eq 1}">
						<span class="sInfo" style="width:240px; color:red;">${product.pName}</span>
					</c:if>
					<c:if test="${product.hurryno eq 0}">
						<span class="sInfo" style="width:240px;">${product.pName}</span>
					</c:if>
					<span class="sInfo" style="width:100px;">${product.name}</span>
					<span class="sInfo" style="width:100px;">${product.assignDate}</span>
					<span class="startDate sInfo" style="width:100px;">${product.startDate}</span>
					<span class="sInfo" style="width:100px;">${product.dueDate}</span>
					<span class="sInfo" style="width:100px;">${product.endDate}</span>
					<span class="sInfo" style="width:70px;">${product.employeeName}</span>
					<c:choose>
						<c:when test="${product.ingdetail eq '0'}"><button class="ingdetail">?????????</button></c:when>
						<c:when test="${product.ingdetail eq '-1'}"><button class="ingdetail">??????</button></c:when>
						<c:when test="${product.startDate == '-'}">
							<c:if test="${product.assignDate == '-'}">
								<button class="ingdetail">?????????</button>
							</c:if>
							<c:if test="${product.assignDate != '-'}">
								<button class="ingdetail">?????????</button>
							</c:if>
						</c:when>
						<c:when test="${product.endDate != '-'}"><button class="ingdetail">??????</button></c:when>
						<c:otherwise><button class="ingdetail">??????</button></c:otherwise>
					</c:choose>
					</div>
				</c:forEach>
			</c:if>
			<c:if test="${empty productList}">
				${loginuser.name}?????? ??????????????? ???????????? ????????????.
			</c:if>
		</div>
		
		<div id="pageBar">${pageBar}</div>
	</div>

   <!-- Modal -->
   <div class="modal fade" id="myModal" role="dialog">
     <div class="modal-dialog modal-lg">
       <div class="modal-content">
         <div class="modal-header">
           <button type="button" class="close" data-dismiss="modal">&times;</button>
           <h4 class="modal-title"></h4>
         </div>
         <div class="modal-body">
         </div>
         <div class="client-body">
         </div>
         <div class="client-pageBar">
         </div>
         
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
        </div>
      </div>
    </div>
  </div>
</div>