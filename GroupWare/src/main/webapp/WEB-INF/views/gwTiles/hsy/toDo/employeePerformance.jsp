<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% String ctxPath= request.getContextPath(); %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap-theme.min.css">
<style>

	.highcharts-figure, .highcharts-data-table table {
	    min-width: 310px; 
	    max-width: 800px;
	    margin: 1em auto;
	    display: none;
	}
	
	#container {
	    height: 400px;
	}
	
	.highcharts-data-table table {
		font-family: Verdana, sans-serif;
		border-collapse: collapse;
		border: 1px solid #EBEBEB;
		margin: 10px auto;
		text-align: center;
		width: 100%;
		max-width: 500px;
	}
	.highcharts-data-table caption {
	    padding: 1em 0;
	    font-size: 1.2em;
	    color: #555;
	}
	.highcharts-data-table th {
		font-weight: 600;
	    padding: 0.5em;
	}
	.highcharts-data-table td, .highcharts-data-table th, .highcharts-data-table caption {
	    padding: 0.5em;
	}
	.highcharts-data-table thead tr, .highcharts-data-table tr:nth-child(even) {
	    background: #f8f8f8;
	}
	.highcharts-data-table tr:hover {
	    background: #f1f7ff;
	}
	
	div#employeePerfBox{
		border: solid 0px red;
		width: 1400px;
		margin-bottom: 150px;
		margin-left: 100px;
		overflow: hidden;
	}
	
	div#employeePerfChartContainer{
		float: left;
		border: solid 0px red;
		width: 50%;
		height: 500px;
		margin-right: 100px;
	}

	table#employeePerfTable{
		border: solid 2px #c2c2c7;
		border-collapse: collapse;
		width: 100%;
	}

	table#employeePerfTable th, table#employeePerfTable td{
		border: solid 1px #c2c2c7;
		border-left: solid 2px #c2c2c7;
		text-align: center;
		height: 40px;
	}
	
	table#employeePerfTable tr.tableTop {border-bottom: solid 2px #c2c2c7;}
	table#employeePerfTable tr.tablebottom {border-top: solid 2px #c2c2c7;}
	
	table#employeePerfTable tr.selectedTr{
		background-color: #ffff99;
		font-weight: bold;
	}
	
	span.showPerfDetail{cursor: pointer;}
	span.showPerfDetail:hover {
		color: #009999;
		font-weight: bold;
	}
	
	div.modalLocation {margin-top:70px;}
	
	Table.modalTable{
		border: solid 1px #96979c;
		border-collapse: collapse;
		width: 90%;
		margin: 0 auto;
		margin-bottom: 15px;
	}
	
	Table.modalTable th, Table.modalTable td {
		border: solid 1px #96979c;
		text-align: center;
		font-size: 10pt;
		padding: 4px 0px;
		vertical-align: middle;
	}
	
	Table.modalTable th{
		background-color: #002266;
		color:#fff;
		font-weight: bold;
		border: solid 1px #002266;
		text-align: center;
		border-right: solid 1px #96979c;
	}
	
	
</style>

<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/modules/exporting.js"></script>
<script src="https://code.highcharts.com/modules/export-data.js"></script>
<script src="https://code.highcharts.com/modules/accessibility.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>

<script type="text/javascript">
	
	$(document).ready(function(){
		
		// ?????? ????????? ?????????????????? ???????????? ?????????????????? select option ?????????
		var currentYear=Number("${currentYear}");
		var hireYear=Number("${hireYear}");
		var html="";
		for(var i=currentYear; i>=hireYear; i--) {html+="<option value="+i+">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+i+"???</option>";}
		$("select#searchYear").html(html);
		
		// ??????????????? ???????????? ??? select option ????????? (??????????????? ?????? ???????????????, ??????????????? ?????? ????????? ??????)=> default??? ????????????
		monthOptionByYear(currentYear);
		$("select#searchYear").val("${currentYear}");
		$("select#searchMonth").val("${currentMonth}");
		
		// ????????? ????????? ????????? ???????????? ajax ?????? => default??? ????????????
		EmployeePerformanceInfo('${currentYear}','${currentMonth}');
		
		
		// ???????????? change ????????? ??????
		$("select#searchYear").bind('change',function(){
			
			// 1) ????????? ????????? ?????? ????????? ?????? ????????? ??????
			var selectedYear= $(this).val();
			monthOptionByYear(selectedYear);
			
			// 2) ?????? ??????????????? ?????? ??? ????????? ????????? ajax??? ????????? ?????? => ????????? ????????? ?????? ?????? ????????? ??? ?????? ??????
			var year= $(this).val();
			var month= $(this).next().val();
			EmployeePerformanceInfo(year,month);
			
		}); // end of $("select#monthOptionByYear").bind('change',function(){-----
		
			
		// ????????? change ????????? ??????	
		$("select#searchMonth").bind('change',function(){
			
			// ?????? ??????????????? ?????? ??? ????????? ????????? ajax??? ????????? ?????? => ?????? ????????? ????????? ??????????????? ????????? ??????
			var year= $(this).prev().val();
			var month= $(this).val();
			EmployeePerformanceInfo(year,month);
			
		}); // end of $("select#searchMonth").bind('change',function(){---------
		
		
		// ????????? ?????? ?????? ????????? ?????? 
		$(document).on('click','span.showPerfDetail',function(){
			var certainDate= $(this).prop('id');
			getPerfClientInfoForModal(certainDate);
			$("div.modal").modal();
		});	
			
			
	}); // end of $(document).ready(function(){-------------------

		
	// ==== function declaration ====
	// ??????????????? ???????????? ??? select option ????????? (??????????????? ?????? ???????????????, ??????????????? ?????? ????????? ??????)		
	function monthOptionByYear(year){ 
		
		var currentYear=Number("${currentYear}");
		var hireYear=Number("${hireYear}");
		var currentMonth= Number("${currentMonth}");
		var hireMonth= Number("${hireMonth}");
		var hireDay= Number("${hireDay}");
		year= Number(year); // ?????? ????????? ??????
	   			
	    var html="";
	    
	   	if(currentYear==year){ // 1) ????????????????????? ????????? ?????? ????????? ???????????? ??????
	   		for(var i=1; i<=currentMonth; i++){
	   			if(i<10){html+="<option value="+i+">&nbsp;&nbsp;0"+i+"???</option>";} // ?????? ???????????? ?????? ?????? 0 ?????? 
	   			else{html+="<option value="+i+">&nbsp;&nbsp;"+i+"???</option>";} // ?????? ???????????? ?????? ?????? 0 ?????? ??????
	   		}
		}
	    else if(hireYear==year){ // 2) ????????????????????? ??????????????? ???????????? ??????
		    for(var i=hireMonth; i<=12; i++){
		    	if(i<10){html+="<option value="+i+">&nbsp;&nbsp;0"+i+"???</option>";} // ?????? ???????????? ?????? ?????? 0 ?????? 
	   			else{html+="<option value="+i+">&nbsp;&nbsp;"+i+"???</option>";} // ?????? ???????????? ?????? ?????? 0 ?????? ??????
		    }	
		}
	   	else{ // 3) 1????????? 12????????? ?????? ???????????? ??????
	   		for(var i=1; i<=12; i++){
	   			if(i<10){html+="<option value="+i+">&nbsp;&nbsp;0"+i+"???</option>";} // ?????? ???????????? ?????? ?????? 0 ?????? 
	   			else{html+="<option value="+i+">&nbsp;&nbsp;"+i+"???</option>";} // ?????? ???????????? ?????? ?????? 0 ?????? ??????
	   		}
	   	}		
		
	   	$("select#searchMonth").html(html);
	   	
	} // end of function monthOptionByYear(year){---------

		
	// ????????? ?????? ?????? ??? ??????????????? ?????? ??????????????? ???????????? ????????? ????????? ???????????? ?????? ??????
	function getPerfClientInfoForModal(certainDate){
			
		$.ajax({
			url:"<%=ctxPath%>/t1/getPerfClientInfoForModal.tw", 
			type:"POST",
			data:{"certainDate":certainDate,"employeeid":"${loginuser.employeeid}"},
			dataType: "JSON",
			success: function(json){
				
				var html="";
				
				if(json.length==0){ // ?????? ????????? ?????? ????????? ??? ?????? ?????? ??????
					html="<div align='center' style='padding: 30px 0px; font-size: 13pt; color: red;'>????????? ???????????? ????????????.</div>";
				}
				else{
					
					
					$.each(json,function(index,item){
						
						html+="<div style='border: solid 2px #bfbfc0; padding-top: 20px; width: 90%; margin: 0 auto; margin-bottom: 50px;'>"+
								"<table class='modalTable'>"+
									"<tr>"+
									   "<th style='width:15%;'>??????</th>"+
									   "<td style='width:15%;'>"+item.rno+"&nbsp;???</td>"+
									   "<th style='width:15%;'>?????????</th>"+
									   "<td style='width:55%;'>"+item.pName+"</td>"+
						   			"</tr>"
						   	 	"</table>";
						
						html+=	"<table class='modalTable'>"+
						   			"<tr>"+
									   "<th>???????????????</th>"+
									   "<th>???????????????</th>"+
									   "<th>???????????????</th>"+
									   "<th style='border-right: solid 1px #002266;'>?????? ?????? ???</th>"+
						   			"</tr>"+
						   			"<tr>"+
									   "<td>"+item.dueDate+"</td>"+
									   "<td>"+item.startDate+"</td>"+
									   "<td>"+item.endDate+"</td>"+
									   "<td>"+item.nowNo+"&nbsp;???</td>"+
						   			"</tr>"+
								  "</table>"+
							  "</div>";
					}); // end of $.each(json,function(){--------
					
						
				} // end of else-----------------------------
				
				$("h4.modal-title").text("  "+certainDate+" ?????? ????????????");
				$("div.modal-body").html(html);
			},
			error: function(request, status, error){
		        alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		    }
		}); // end of $.ajax({-------- 
		
	} // end of function getPerfClientInfoForModal(-------
		
	
</script>


<div id="employeePerfBox">
	
	<div style="margin: 70px 0px 80px 65px; font-size: 22pt; font-weight: bold;" >${sessionScope.loginuser.name}??????&nbsp;????????????</div>
	<div id="employeePerfChartContainer"></div>
	<div id="employeePerfTableContainer" style="float: right; width: 42%; padding-top: 80px; border: solid 0px red;">
		<div style="position:relative; top: -70px;" align="right">
			<span style="font-size: 13pt; margin-right:15px; position:relative; top: 2.5px;">????????????</span>
			<select id="searchYear" style="height: 30px; width: 120px; cursor:pointer;"></select>
			<select id="searchMonth" style="height: 30px; width: 80px; cursor:pointer;"></select>
		</div>
		
		<table id="employeePerfTable"></table>
	</div>
	
	<!-- ???????????? ???????????? modal??? ???????????? -->
	<div class="modal fade modalLocation" id="layerpop" >
  		<div class="modal-dialog modal-lg">
	    	<div class="modal-content">
		      	<!-- header -->
		      	<div class="modal-header">
		        	<!-- ??????(x) ?????? -->
		        	<button type="button" class="close" data-dismiss="modal">??</button>
		        	<!-- header title -->
		        	<h4 class="modal-title"></h4>
		      	</div>
		      	<!-- body (ajax??? ?????? ????????????) -->
		      	<div class="modal-body" style='margin-top: 30px;'></div>
		      	<!-- Footer -->
		      	<div class="modal-footer">
		        	<button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
		      	</div>
	    	</div>
  		</div>
	</div>
	
</div>

 
<script type="text/javascript">
	
	// == function declaration ==

	function EmployeePerformanceInfo(year,month){
		//????????? ????????? ?????? ????????? ????????? ????????? ?????????	
		// 1) ????????? ???????????? 6?????? ????????? ?????? ????????? ???????????? => ?????????????????? 5?????? ????????? ?????? ?????? ??? ?????? ?????? ????????? ????????? ?????? 0 ?????? 	
		$.ajax({
		
			url:"<%=ctxPath%>/t1/getEmployeePerformance.tw", 
			type:"POST",
			data:{"year":year,"month":month,"employeeid":"${loginuser.employeeid}"},
			dataType: "JSON",
			success: function(json){
				
				// ????????? ????????? ?????? ??????
				var xAxisArr= [];
				var perfCntArr= [];
				var clientCntArr= [];
				
				// ???????????? ?????? ??? ?????????
				var html= "<tr class='tableTop'>"+
							  "<th></th>"+
							  "<th style='height: 30px;'>?????? ?????? ??? ???</th>"+
							  "<th>?????? ?????? ???</th>"+
							  "<th>?????? ??????</th>"+
						  "</tr>";
				
				// 3) 6?????? ?????? ??? ?????? ?????? ?????? ?????? ??????
				var totalPerfCnt=0;
				// 4) 6?????? ?????? ??? ?????? ?????? ??? ?????? ??????
				var totalClientCnt=0;	
				
				$.each(json,function(index, item){
					
					// ????????? ????????? ????????? ??? ??????
					xAxisArr.push(item.specificDate);
					perfCntArr.push(Number(item.perfNumber));
					clientCntArr.push(Number(item.clienNumber));
					
					if(item.perfNumber!='-') totalPerfCnt+=Number(item.perfNumber);
					if(item.clienNumber!='-') totalClientCnt+=Number(item.clienNumber);
					
					// 2) ???????????? ????????? ??? ??????
					
					// ?????????????????? ????????? ????????? ????????? ??????
					if(index==5) html+= "<tr class='selectedTr'>";
					else html+= "<tr>";
							   
					html+= "<th>"+item.specificDate+"</th>";
							   
					if(item.perfNumber=='-' || item.clienNumber=='-'){
						html+="<td>"+item.perfNumber+"&nbsp;</td>"+
						   	  "<td>"+item.clienNumber+"&nbsp;</td>"+
						   	  "<td>-</td>";
					}
					else{
						html+=	"<td>"+item.perfNumber+"&nbsp;???</td>"+
					   	  	  	"<td>"+item.clienNumber+"&nbsp;???</td>"+
					   	  	  	"<td><span class='showPerfDetail' id='"+item.specificDate+"'>????????? ??????&nbsp;&nbsp;<span class='glyphicon glyphicon-search' ></span></span></td>"+
				          	"</tr>";	
					}
					
						 	  
				}); // end of $.each(json,function(index, item){----
		
				
				html+= "<tr class='tablebottom'>"+
						   "<th style='color: #0000e6;'>??????</th>"+
						   "<td style='color: #0000e6; font-weight:bold;'>"+totalPerfCnt+"&nbsp;???</td>"+
						   "<td style='color: #0000e6; font-weight:bold;'>"+totalClientCnt+"&nbsp;???</td>"+
						   "<td></td>"+
					   "</tr>";
					
				$("table#employeePerfTable").html(html);
				
					
				// ?????? ?????? ?????? (????????????) 
				Highcharts.chart('employeePerfChartContainer', {
				    chart: {
				        zoomType: 'xy'
				    },
				    title: {
				        text: '<span style="font-size: 15pt; font-weight: bold;">???????????? ?????????</span>'
				    },
				    xAxis: [{
				        categories: xAxisArr,
				        crosshair: true
				    }],
				    yAxis: [{ // Primary yAxis
				        labels: {
				            format: '{value}???',
				            style: {
				                color: Highcharts.getOptions().colors[1]
				            }
				        },
				        title: {
				            text: '?????? ?????? ???',
				            style: {
				                color: Highcharts.getOptions().colors[1]
				            }
				        }
				    }, { // Secondary yAxis
				        title: {
				            text: '?????? ?????? ??? ???',
				            style: {
				                color: Highcharts.getOptions().colors[0]
				            }
				        },
				        labels: {
				            format: '{value}???',
				            style: {
				                color: Highcharts.getOptions().colors[0]
				            }
				        },
				        opposite: true
				    }],
				    tooltip: {
				        shared: true
				    },
				    legend: {
				        layout: 'vertical',
				        align: 'left',
				        x: 120,
				        verticalAlign: 'top',
				        y: 50,
				        floating: true,
				        backgroundColor:
				            Highcharts.defaultOptions.legend.backgroundColor || // theme
				            'rgba(255,255,255,0.25)'
				    },
				    series: [{
				        name: '?????? ?????? ??? ???',
				        type: 'column',
				        yAxis: 1,
				        data: perfCntArr,
				        tooltip: {
				            valueSuffix: ' ???'
				        }
				
				    }, {
				        name: '?????? ?????? ???',
				        type: 'line',
				        data: clientCntArr,
				        tooltip: {
				            valueSuffix: ' ???'
				        }
				    }]
				}); // end of Highcharts.chart('employeePerfChartContainer', {--------
				
			},
			error: function(request, status, error){
		        alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		    }
				
		}); // end of $.ajax({-------------------------	
	} // end of function EmployeePerformanceInfo(year,month){---
</script>

