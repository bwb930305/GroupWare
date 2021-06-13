<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<% String ctxPath = request.getContextPath(); %>
<link href='<%=ctxPath %>/resources/fullcalendar/main.min.css' rel='stylesheet' />
<!-- Homepage.jsp CSS -->
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/resources/css/homepage.css"/>

<!-- full calendar에 관련된 script -->
<script src='<%=ctxPath %>/resources/fullcalendar/main.min.js'></script>
<script src='<%=ctxPath %>/resources/fullcalendar/ko.js'></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>

<!-- 퀵메뉴에 쓰이는 차트 script -->
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

<%-- 내통계에 쓰이는 차트 script --%>
<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/modules/data.js"></script>
<script src="https://code.highcharts.com/modules/exporting.js"></script>
<script src="https://code.highcharts.com/modules/accessibility.js"></script>
 
<%-- word Cloud 차트 script --%>
<script src="https://code.highcharts.com/modules/wordcloud.js"></script>
<script src="https://code.highcharts.com/modules/export-data.js"></script>

<script type="text/javascript">
   $(document).ready(function(){
      
	   window.innerWidth;
	   window.innerHeight;
	   console.log("브라우저 width: "+window.innerWidth);
	   console.log("브라우저 height: "+window.innerHeight);
	   
	   
	   displayNotice(); //공지사항 게시판
      // div#sidemenu와 div#content길이 맞추기
      // func_height1();
      
      // 시계 보여주기
      func_loopDate();
      
      $("div#vacation").hide();
      
      // 휴가정보 클릭시
      $("span#vacationInfo").click(function(){
         $("div#vacation").show();
         $("div#indolence").hide();
      });
      
      // 근태정보 클릭 시
      $("span#indolenceInfo").click(function(){
         $("div#vacation").hide();
         $("div#indolence").show();
      });
      
      
      var intime = $("span#intime").text();
      var todayDate = func_todayDate(); // 2020-01-01 hh24
     
      // 출근을 찍고 나서 다시 로그인을 했을때
      $.ajax({
        url:"<%=ctxPath %>/t1/selectIntime.tw",
        type:"get",
        data:{"fk_employeeid":"${loginuser.employeeid}",
             "gooutdate":todayDate},
        dataType:"json",
        success:function(json){
           
              if(json.intime != ""){
                 if(json.latenoTime=='1'){
                     $("span#intime").text(json.intime+'(지각)');
                  }
                  else{
                     $("span#intime").text(json.intime+'(정상출근)');
                  }
              }else{
                 $("span#intime").text("(미출근)");
              }
         },
         error: function(request, status, error){
               alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
           }
        
     });// end of ajax(insert)
      
      // 출근 버튼 클릭 시(출근을 안찍은 상황)
      $("span#intimeButton").click(function(){
         
         var intime = $("span#intime").text();
         if(intime=="(미출근)"){
         
            // 출퇴근기록 테이블에 insert하기
            $.ajax({
               url:"<%=ctxPath %>/t1/insertSelectIntime.tw",
               type:"post",
               data:{"fk_employeeid":"${loginuser.employeeid}",
                    "gooutdate":todayDate},
               dataType:"json",
               success:function(json){
                  
                     if(json.latenoTime=='1'){
                        $("span#intime").text(json.intime+'(지각)');
                     }
                     else{
                        $("span#intime").text(json.intime+'(정상출근)');
                     }
                  
               },
               error: function(request, status, error){
                     alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
                 }
               
            });// end of ajax(insert)
         }
         else{
            alert("이미 출근버튼을 클릭하셨습니다.");
         }
         
      }); // end of $("span#intime").click(function(){
      
         
         
      // 퇴근을 찍고 나서 다시 로그인을 했을때
       $.ajax({
        url:"<%=ctxPath %>/t1/selectOuttime.tw",
        type:"get",
        data:{"fk_employeeid":"${loginuser.employeeid}",
             "gooutdate":todayDate},
        dataType:"json",
        success:function(json){
           
              if(json.outtime != ""){
                 
                  $("span#outtime").text(json.outtime);

              }else{
                 $("span#outtime").text("(미퇴근)");
              }
         },
         error: function(request, status, error){
               alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
           }
        
     });// end of ajax(insert)     
         
         
      // 퇴근버튼을 클릭 했을때      
      $("span#outtimeButton").click(function(){   
         
      
         var intime = $("span#intime").text();
         var outtime = $("span#outtime").text();
         
         if(intime!="(미출근)"){ // 출근시간이 찍혀 있을때
            
            if(outtime=="(미퇴근)"){
   
               // 출퇴근기록 테이블에 insert하기
               $.ajax({
                  url:"<%=ctxPath %>/t1/insertSelectOuttime.tw",
                  type:"post",
                  data:{"fk_employeeid":"${loginuser.employeeid}",
                       "gooutdate":todayDate},
                  dataType:"json",
                  success:function(json){
                     
                        $("span#outtime").text(json.outtime); // 16:25:46
                        
                        var lateTime = json.outtime;
                        var lateHH = Number(lateTime.substring(0,2));
                        var lateMM = Number(lateTime.substring(3,5));
                        
                        if(lateHH == 19 && lateMM>=45){
 							location.href='<%= ctxPath%>/t1/salaryDetail.tw?from=homepage';
                        }
                        else if(lateHH>20){
                        	location.href='<%= ctxPath%>/t1/salaryDetail.tw?from=homepage';
                        }
                        
                  },
                  error: function(request, status, error){
                        alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
                    }
                  
               });// end of ajax(insert)
            }
            else{
               alert("이미 퇴근버튼을 클릭하셨습니다.");
            }
         }// end of if(intime!="(미출근)"){
         else{// 출근시간이 안 찍혀 있을때
            alert("출근버튼을  먼저 클릭하세요.");     
         }
      }); // end of $("span#outtime").click(function(){
      
      
    	<%--  달력 생성(오다윤)  --%>   
    	 var calendarEl = document.getElementById('calendar');
         var calendar = new FullCalendar.Calendar(calendarEl, {
           initialView: 'dayGridMonth',
           locale: 'ko',
           selectable: true,
 	       editable: false,
 	       headerToolbar: {
 	    	    left: 'prev',
 	    	    center: 'title',
 	    	    right: 'next' // today 추가?
 	       },
 	      dayMaxEventRows: true, // for all non-TimeGrid views
 	     	views: {
 	        	timeGrid: {
 	        		 dayMaxEventRows: 1// adjust to 6 only for timeGridWeek/timeGridDay
 	      		}
 	    	 },
 	       events:function(info, successCallback, failureCallback){
 	    	 
 	       
 			   $.ajax({
 			   		url: "<%= ctxPath%>/t1/showMyCalendarHome.tw",
 			   		data: {"employeeid":"${loginuser.employeeid}"},
 			   		type: "get",
 			   		dataType: "json",
 			   		success:function(json){
			   			var events =[];
			   			if(json!=null){
			   				$.each(json, function(index, item) {
			   				 var startdate=moment(item.startdate).format('YYYY-MM-DD HH:mm:ss');
			                 var enddate=moment(item.enddate).format('YYYY-MM-DD HH:mm:ss');
			   					
			                 events.push({
	 			   					id: item.sdno,
	 			   					title: item.subject,
	 			   					start: startdate,
	 			   					end: enddate,
	 			   					color: "#333333"
	                      		}); // events.push
	 			   		
	 			   			
			   				}); //each
			   			}
			   			console.log(events);     
			   			successCallback(events); 
 			   		}
 			   }); // end of $.ajax
 			   
 		   }, //events:function end	       	  
           dateClick: function(info) {
         	//  alert('Date: ' + info.dateStr);
         	    $(".fc-day").css('background','none'); // 현재 날짜 배경색 없애기
         	    info.dayEl.style.backgroundColor = '#fff';
         	    date=info.dateStr;
         	    showMyList(date); // 해당 날짜에 대한 캘린더 정보를 불러오는 함수 
           }
         });

         calendar.render();
         calendar.setOption('height', 450);
    	
         
         $("div#infoCalendar").hide();
         
    	 // 오늘 날짜와 관련된 일정 보여주기
         $.ajax({
 			url: "<%= ctxPath%>/t1/todayMyCal.tw",
 			data: {"employeeid": "${loginuser.employeeid}"},
 			type: "post",
 			dataType: "json",
 			success:function(json){
 				
 				var html ="";
 				
 				if(json.length==0){
 					html+="<tr><td>등록된 일정이 없습니다</td></tr>";
 				}
 				if(json.length>0){
 					
 					html="<table class='table'>";
 	   				$.each(json, function(index, item) {
 	   					html+="<tr><td>"+item.startdate+" ~ "+item.enddate+"</td>";
 	   					html+="<tr><td style='padding-left: 10px; font-size: 10pt; border-top: solid 0px;'>"+item.stime+"~"+item.etime+"<div class='circle' style='background-color:"+item.color+"'></div><a href='<%= ctxPath%>/t1/detailSchedule.tw?sdno="+item.sdno+"'>"+item.subject+"</a></td></tr>";
 	   				}); //each
 	   				hrml="</table>";
 				}
 				$("div#todayCal").html(html);
 				$("div#todayCal").show();
 				$("div#infoCalendar").hide();
 				
 			},
 			error: function(request, status, error){
                alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
            }
 		});  
    	
    	 
        <%-- 퀵메뉴에 쓰이는 차트 script 시작 한수연 ---%>
    	$.ajax({
    		url: "<%= ctxPath%>/t1/quickMenuInfo.tw",
 			data: {"employeeid": "${loginuser.employeeid}"},
 			type: "POST",
 			dataType: "JSON",
 			success:function(json){
 				
 				var emptyCnt=0;
 				
 				// 읽지않은 메일, 결재 진행 중 문서, 최근 결재완료 문서가 모두 0건인 경우에도 차트를 표시해 주기 
 				if(json.notReadCnt==0 && json.ingDocuCnt==0 && json.doneDocuCnt==0){
 					emptyCnt=1;
 				}
 				
 				// ========== 퀵메뉴 차트 코드 시작
 				google.charts.load("current", {packages:["corechart"]});
 		        google.charts.setOnLoadCallback(drawChart);
 		        function drawChart() {
	 		        var data = google.visualization.arrayToDataTable([
			 		             ['quickMenu', 'cnt'],
			 		             ['읽지 않은 메일', json.notReadCnt],
			 		             ['결재 진행 중 문서', json.ingDocuCnt],
			 		             ['최근 결재 완료 문서', json.doneDocuCnt],
			 		             ['해당 사항 없음', emptyCnt]
	 		          		   ]);
	
	 		        var options = {
				 		             pieHole: 0.4,
				 		             chartArea:{left:0,top:70,width:'100%',height:'70%'},
				 		             colors: ["#006680", "#00b8e6", "#0099ff","#c0bfbf"],
				 		             legend: 'none',
				 		             backgroundColor: "transparent"
	 		            		   };
	
	 		         var chart = new google.visualization.PieChart(document.getElementById('donutchart'));
	 		         chart.draw(data, options);
 		         }
 		     	// ========== 퀵메뉴 차트 코드 끝
 		     	
 		     	// legend에 각 값 넣어주기
 		     	$("span#notReadCnt").text(json.notReadCnt);
 		     	$("span#ingDocuCnt").text(json.ingDocuCnt);
 		     	$("span#doneDocuCnt").text(json.doneDocuCnt);
			 			
 			},
 			error: function(request, status, error){
                alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
            }
    	}); // end of $.ajax({-------------------------------- 
         
        <%-- 퀵메뉴에 쓰이는 차트 script 끝 한수연 ---%> 
    	 
    	<%-- 백원빈 내통계 작업시작 --%>
    	$("table#datatable").hide();
    	
        Highcharts.chart('container', {
            data: {
                table: 'datatable'
            },
            chart: {
                type: 'column'
            },
            title: {
                text: '<div style=color:red;><span id=spanData style=font-size:10pt;>내 근로시간 : 주 ${totalhour}/52시간</span></div>'
            },
            yAxis: {
                allowDecimals: false,
                title: {
                    text: '시간'
                },
                max:14,
                min:0
            },
            tooltip: {
                formatter: function () {
                    return '<b></b><br/>' +
                        this.point.y + '시간 ';
                }
            }
        });
        
        <%-- 백원빈 내통계 작업 끝 --%>
    	
        <%-- 백원빈 word-cloud 작업 시작 --%>
        var text = '${word}';
        console.log("${word}");
        var lines = text.split(/[,\. ]+/g),
            data = Highcharts.reduce(lines, function (arr, word) {
                var obj = Highcharts.find(arr, function (obj) {
                    return obj.name === word;
                });
                if (obj) {
                    obj.weight += 1;
                } else {
                    obj = {
                        name: word,
                        weight: 1
                    };
                    arr.push(obj);
                }
                return arr;
            }, []);

        Highcharts.chart('container2', {
            accessibility: {
                screenReaderSection: {
                    beforeChartFormat: '<h5>{chartTitle}</h5>' +
                        '<div>{chartSubtitle}</div>' +
                        '<div>{chartLongdesc}</div>' +
                        '<div>{viewTableButton}</div>'
                }
            },
            series: [{
                type: 'wordcloud',
                data: data,
                name: 'Occurrences'
            }],
            title: {
                text: '<span style=font-size:10pt;>T1works 검색어 현황</span>'
            }
        });
        
        
        <%-- 백원빈 word-cloud 작업 끝 --%>
        
        
        <%-- 오다윤 날씨 구현 시작 --%>
       
        	
        var todayw = new Date();
        var yesterday = new Date((new Date()).valueOf() - 1000*60*60*24);
        console.log("어제:"+yesterday);
        
        // 오늘 정보
    	var wyear = todayw.getFullYear();
    	var wmonth = todayw.getMonth()+1;
    	var wday = todayw.getDate();
    	var whour = todayw.getHours();
    	var wminutes = todayw.getMinutes();
    	
    	// 어제 정보
    	var ydyear = yesterday.getFullYear();
    	var ydmonth = yesterday.getMonth()+1;
    	var ydday = yesterday.getDate();
    
    	if(whour<10){
    		whour='0'+whour;
    	}
    	if(wmonth<10){
    		wmonth='0'+wmonth;
    	}
    	if(wday<10){
    		wday='0'+wday;
    	}
    
    	if(ydmonth<10){
    		ydmonth='0'+ydmonth;
    	}
    	if(ydday<10){
    		ydday='0'+ydday;
    	}
    	
    	var arr =[];
    	var harr = new Array('02','05','08','11','14','17','20','23');
    	
    	// sky,pop,pty 정보
    	for(var i=0;i<harr.length;i++){
    		var h=harr[i]-whour;
    		console.log("지금h"+h);
    		console.log(h);
    		if(whour!='00' || whour!='01'){
	    		if(h==-1 || h==0 || h==-2){
	    			var wnow=harr[i]+"00";
	    			wtoday = wyear+""+wmonth+""+wday;
	    			console.log("지금"+wnow);
	    		}
    		}
    		else if(whour=='00' || h==1){
    			wtoday = ydyear+""+ydmonth+""+ydday;
    			var wnow=harr[7]+"00";
    		}
    	}
    	
    	// 오늘 t1hh==0 ||
    	for(var i=0;i<harr.length;i++){
    		var hc=harr[i]-whour;
    		console.log("지금h"+h);
    		console.log(h);
    		if(whour!='00' || whour!='01'){
	    		if(hc==-1 || hc==-2){
	    			var wcnow=harr[i]+"00";
	    			wctoday = wyear+""+wmonth+""+wday;
	    			console.log("지금"+wnow);
	    		}
	    		else if(hc==0){
	    			
		    		if(wminutes<30){
		    			if( whour=='02'){
		    			var wcnow=harr[7]+"00";
		    			wctoday = ydyear+""+ydmonth+""+ydday;
		    			console.log("지금"+wcnow);
		    			}
		    			else{
		    				var wcnow=harr[i-1]+"00";
		    				wctoday = wyear+""+wmonth+""+wday;
			    			console.log("지금오늘1th"+wcnow);
		    			}
		    		}
		    		else{
		    			var wcnow=harr[i]+"00";
		    			wctoday = wyear+""+wmonth+""+wday;
		    		}
	    		}
    		}
    		else if(whour=='00' || h==1){
    			wtoday = ydyear+""+ydmonth+""+ydday;
    			var wnow=harr[7]+"00";
    		}
    	}
    	
    	
    	// 어제 t1h 정보
    	for(var i=0;i<harr.length;i++){
    		var hy=harr[i]-whour;
    		console.log("hy"+hy);
    		if(whour!='00' && whour!='23'){
	    		if(hy==-1 || hy==0 || hy==-2){
	    			yesterday = ydyear+""+ydmonth+""+ydday;
	    			var ytime=harr[(i+1)]+"00";
	    			console.log("시간"+ytime);
	    		}
    		}	
    		else if(whour=='23' || whour=='00'|| h>0){
    			var ytime=harr[0]+"00";
    			yesterday = ydyear+""+ydmonth+""+ydday;
    			console.log("시간00"+ytime);
    		}
    	}
    	console.log("오늘:"+wtoday);
    	console.log("진짜어제:"+yesterday);
    	
    	// 동네예보
    	$.ajax({
            url : "<%= ctxPath%>/t1/weatherhome.tw",
            type : "get",
            timeout: 30000,
            contentType: "application/json",
            data: {"today":wtoday, "now":wnow},
            dataType : "json",
            success : function(data, status, xhr) {
                let dataHeader = data.result.response.header.resultCode;
                let data1 = data.result.response.body.items.item;
                
                if (dataHeader == "00") {
                	for (var i = 0; i < data1.length; i++) {
                        var item = data1[i];
                        switch (item.category) {
                            case "SKY":
                                var sky = parseInt(item.fcstValue);
                                console.log("하늘:"+sky);
                                break;
                            case "POP":
                            	var pop =parseInt(item.fcstValue);
                                break;
                            case "PTY":
                            	var pty =parseInt(item.fcstValue);
                                break;
                        }
                	}
     			
                   console.log("강수확률:"+pop);
                   console.log("강수형태:"+pty);
                   console.log("하늘:"+sky);
                   $("#pop").html("강수확률:"+pop+"%");
                   
                   $("#pty").html(pty);
    				
                   var image="";
                   if(pty==0){
	                   if(sky==1){
	                	   image = "<%= ctxPath%>/resources/images/ody/pop1.png";
	                	   $("#sky").html("<img style='width: 110px; height: 110px;' src='"+ image +"'/>");
	                   }
	                   else if(sky==3){
	                	   image = "<%= ctxPath%>/resources/images/ody/pop2.png";
	                	   $("#sky").html("<img style='width: 110px; height: 110px;' src='"+ image +"'/>");
	                   }
	                   else if(sky==4){
	                	   image = "<%= ctxPath%>/resources/images/ody/pop3.png";
	                	   $("#sky").html("<img style='width: 110px; height: 110px;' src='"+ image +"'/>");
	                   }
                   }
                   else{
                	   if(pty==1 || pty==2 || pty==4 || pty==5 || pty==6){
                		   image = "<%= ctxPath%>/resources/images/ody/pty(rain).png";
	                	   $("#sky").html("<img style='width: 110px; height: 110px;' src='"+ image +"'/>");
                	   }
                	   else{
                		   image = "<%= ctxPath%>/resources/images/ody/pty(snow).png";
	                	   $("#sky").html("<img style='width: 110px; height: 110px;' src='"+ image +"'/>");
                	   }
                   }
                   // TMN : 아침최저기온
                   // TMX : 낮 최고기온
                   // T3H: 3시간 기온
                   // SKY: 하늘 상태  - 1: 맑음/ 3: 구름많음/ 4: 흐림
                   // POP: 강수확률 
                   // PTY: 강수 형태없음(0), 비(1), 비/눈(2), 눈(3), 소나기(4), 빗방울(5), 빗방울/눈날림(6), 눈날림(7)
    				// 여기서 비/눈은 비와 눈이 섞여 오는 것을 의미 (진눈개비)
                    //빗방울(5), 빗방울/눈날림(6), 눈날림(7)
                }
               
            },
            error : function(e, status, xhr, data) {
                console.log("error == >");
                console.log(e);
            }
        });
    	
    	
    	// 오늘 한시간 받기
    	$.ajax({
            url : "<%= ctxPath%>/t1/weathercurrent.tw",
            type : "get",
            timeout: 30000,
            contentType: "application/json",
            data: {"today":wctoday, "now":wcnow},
            dataType : "json",
            success : function(data, status, xhr) {

                let dataHeader = data.result.response.header.resultCode;
                
                if (dataHeader == "00") {

                	var t1h = parseFloat(data.result.response.body.items.item[3].obsrValue);
        
                   $("#t1h").html(t1h);
                   $("input#mt1h").val(t1h);
                }
                
             // 오늘 기온과 어제 기온 차이
            	$.ajax({
                    url : "<%= ctxPath%>/t1/weatheryesterday.tw",
                    type : "get",
                    timeout: 30000,
                    contentType: "application/json",
                    data: {"yesterday":yesterday, "ytime":ytime},
                    dataType : "json",
                    success : function(data, status, xhr) {

                        let dataHeader = data.result.response.header.resultCode;
                        
                        if (dataHeader == "00") {

                           var y1h =parseFloat(data.result.response.body.items.item[3].obsrValue);
                			console.log("어제온도:"+y1h);	
        					var gap = parseFloat(t1h-y1h).toFixed(2);
        	            	if(gap>=0){
        	        			$("#gap").html("어제보다 "+Math.abs(parseFloat(gap))+" º 높아요!"); 
        	        		}
        	        		else{
        	        			$("#gap").html("어제보다 "+Math.abs(parseFloat(gap))+" º 낮아요!"); 
        	        		}
        	        		
                        }
                    },
                    error : function(e, status, xhr, data) {
                        console.log("error == >");
                        console.log(e);
                    }
                });
            	
            },
            error : function(e, status, xhr, data) {
                console.log("error == >");
                console.log(e);
            }
        });
        
    	
    	$.ajax({
    		  type: "GET",
    		  url: "http://openapi.seoul.go.kr:8088/504543517764617936396d50484259/json/RealtimeCityAir/1/99",
    		  data: {},
    		  success: function(response){
    				// 마포구의 미세먼지 값만 가져와보기
    				let mapo = response["RealtimeCityAir"]["row"][5];
    				let guName = mapo['MSRSTE_NM'];
    				let guMise = mapo['PM10'];
    				let guchoMise = mapo['PM25'];
    				console.log(guName, guMise,guchoMise);
    				
    				var miseStatus="";
    				if(guMise<=30){
    					miseStatus="좋음" 
    				}
    				else if(guMise<=80){
    					miseStatus="보통"
    				}
    				else if(guMise<=150){
    					miseStatus="나쁨"
    				}
    				else{
    					miseStatus="매우나쁨"
    				}
    				
    				$("#miseStatus").html("미세먼지: "+miseStatus);
    				$("#mise").html("("+guMise+"㎍/m³)");
    				
    				var miseimage="";
    				var chomiseStatus="";
    				if(guchoMise<=15){
    					chomiseStatus="좋음" 
    					miseimage = "<%= ctxPath%>/resources/images/ody/good.png";
    				}
    				else if(guchoMise<=35){
    					chomiseStatus="보통"
    					miseimage = "<%= ctxPath%>/resources/images/ody/normal.png";
    				}
    				else if(guchoMise<=75){
    					chomiseStatus="나쁨"
    					miseimage = "<%= ctxPath%>/resources/images/ody/sad.png";
    				}
    				else{
    					chomiseStatus="매우나쁨"
    					miseimage = "<%= ctxPath%>/resources/images/ody/devil.png";
    				}
    				
    				$("#chomiseStatus").html("초미세먼지: "+chomiseStatus);
    				$("#chomise").html("("+guchoMise+"㎍/m³)");
    				$("#miseimg").html("<img style='width: 100px; height: 100px;' src='"+ miseimage +"'/>");
    		  }
    		})
        <%-- 오다윤 날씨 구현 끝 --%>
        
    <%-- 김다님 공지사항 게시판 시작 --%> 
    
   	function displayNotice(){
   		
   		$.ajax({
   			url:"<%=ctxPath%>/t1/recentNotice.tw",
   			type:"get",
   			dataType:"json",
   			success:function(json){
   				if(json.length > 0){
   			
   				$.each(json, function(index,item){
   					html = "";
   					
   					var categName = "";
   					if(item.fk_categnum == "1"){
   						categName = "전체공지";
   					} else if(item.fk_categnum == "2"){
   						categName = "총무공지";
   					} else {
   						categName = "경조사";
   					}
   					
   					regDate = item.regDate.substring(0,10);
   					
   					console.log("카테고리넘버:"+item.fk_categnum);
   					console.log(categName);
   					console.log(item.subject);
   					console.log(regDate);
   					console.log(index);
   					html += "<td style='height:30px;'>"+categName+"</td>";
   					html += "<td style='height:30px;'><a href='<%=ctxPath%>/t1/viewNotice.tw?seq="+item.seq+"'>"+item.subject+"</a></td>";
   					html += "<td style='height:30px;'>"+regDate+"</td>";
   					$("tr#row-"+index+"-content").html(html);
   				});
   				
   				} else {
   					html = "<td aling+'center'>등록된 게시글이 없습니다.</td>"
   						
   					$("tr#row-0-content").html(html);
   				}
   			},
   			error: function(request, status, error){
   	           alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
   	       }
   		
   		});   	
    	
   	}	
   		<%-- 김다님 공지사항 게시판 끝--%>
    	
   }); // end of $(document).ready(function(){
      
   // Function Declaration
   function func_currentDate(){
      
      var now = new Date();
      var year = now.getFullYear();
      var month = now.getMonth()+1;
      
      if(month<10){
          month = "0"+month;
       }
      
      var date = now.getDate();  // 현재일
      if(date<10){
    	  date = "0"+date;
       } 
      
       var hours = now.getHours(); // 현재시각
       
       if(hours<10){
          hours = "0"+hours;
       }
       
       var minutes = now.getMinutes(); // 현재분
       
       if(minutes<10){
          minutes = "0"+minutes;
       }
       
       var seconds = now.getSeconds(); // 현재초
       
       if(seconds<10){
          seconds = "0"+seconds;
       }
       
       var day = now.getDay(); // 현재요일명 (0~6)
         
       var dayName ="";
       
       switch (day) {
      case 0:
         dayName = "일요일"
         break;
         
      case 1:
         dayName = "월요일"
         break;
         
      case 2:
         dayName = "화요일"
         break;
         
      case 3:
         dayName = "수요일"
         break;
         
      case 4:
         dayName = "목요일"
         break;
         
      case 5:
         dayName = "금요일"
         break;
         
      case 6:
         dayName = "토요일"
         break;

      }
   
      var today = year+"-"+month+"-"+date+"&nbsp;&nbsp;&nbsp;"+dayName+"&nbsp;&nbsp;&nbsp;"+hours+":"+minutes+":"+seconds;
      
      return today;
   }// end of function func_currentDate(){
      
   function func_loopDate(){
          $("div#timer").html(func_currentDate());
          setTimeout('func_loopDate()',1000);
   }
   
   // 오늘 년도-월-일만 뽑아오는 함수
   function func_todayDate(){
      var now = new Date();
      var year = now.getFullYear();
      var month = now.getMonth()+1;
      
      if(month<10){
         month = "0"+month;
       }
      
      var date = now.getDate();  // 현재일

      var todayDate =  year+"-"+month+"-"+date;
      return todayDate;
   }
   
	// 달력에서 클릭한 날짜에 대한 캘린더 정보를 불러오는 함수 
   function showMyList(date){
	   $.ajax({
			url: "<%= ctxPath%>/t1/myCalendarInfo.tw",
			data: {"employeeid": "${loginuser.employeeid}"
				  ,"date":date},
			type: "post",
			dataType: "json",
			success:function(json){
				
				var html ="";
				
				if(json.length==0){
					html+="<tr><td>등록된 일정이 없습니다</td></tr>";
				}
				if(json.length>0){
					
					html="<table class='table'>";
	   				$.each(json, function(index, item) {
	   					html+="<tr><td>"+item.startdate+" ~ "+item.enddate+"</td>";
	   					html+="<tr><td style='padding-left: 10px; font-size: 10pt; border-top: solid 0px;'>"+item.stime+"~"+item.etime+"<div class='circle' style='background-color:"+item.color+"'></div><a href='<%= ctxPath%>/t1/detailSchedule.tw?sdno="+item.sdno+"'>"+item.subject+"</a></td></tr>";
	   				}); //each
	   				hrml="</table>";
				}
				$("div#todayCal").hide();	
 				$("div#infoCalendar").show();	
				$("div#infoCalendar").html(html);
				
			},
			error: function(request, status, error){
               alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
           }
		});
   }
	
</script>




<div id="content" style="width: 90%; border: solid 1px red;">
  
  <div id="myInfo" style="margin: 50px 0px 50px 50px; width: 380px; height: 820px; float:left;">
  	 <div style="padding-left:130px;"><img src="<%= ctxPath%>/resources/images/bwb/person.jpg" style="width:120px; height:120px;"></div>
     <div id="nameDep" style="border-bottom:solid 1px black; text-align:center; margin-top:10px; margin-bottom:10px;">
     <span id="name">${loginuser.name}
       <c:if test="${loginuser.fk_pcode eq 1}">
            사원님
       </c:if>
       <c:if test="${loginuser.fk_pcode eq 2}">
            대리님
       </c:if>
       <c:if test="${loginuser.fk_pcode eq 3}">
            부장님
       </c:if>
       <c:if test="${loginuser.fk_pcode eq 4}">
            사장님
       </c:if>
     </span>
     <span id="department">
        <c:if test="${loginuser.fk_dcode eq 1}">
            (CS1팀)
       </c:if>
       <c:if test="${loginuser.fk_dcode eq 2}">
            (CS2팀)
       </c:if>
       <c:if test="${loginuser.fk_dcode eq 3}">
            (CS3팀)
       </c:if>
       <c:if test="${loginuser.fk_dcode eq 4}">
             (인사팀)
       </c:if>
       <c:if test="${loginuser.fk_dcode eq 5}">
            (총무팀)
       </c:if>
     </span>
     </div>
     <div id="loginIp" style="font-size:10pt; text-align:center; margin-top:10px;">
        	접속IP : ${loginip}
     </div>
     <div id="timer" style="text-align:center; margin-top:15px;"></div>
     <div id="sebuMenu" style="border-bottom:solid 1px black; border-top:solid 1px black; height:50px; margin-top:20px; padding-top:10px;">
	     <span id="indolenceInfo" style="border-bottom:solid 1px black; font-size:15pt; margin-right:90px; margin-left:15px; ">근태정보</span>
	     <span id="vacationInfo"  style="border-bottom:solid 1px black; font-size:15pt;">휴가정보</span>
     </div>
     <div id="indolence">
        <div style="margin-top:10px; margin-left:7px;">출퇴근시간</div>
        <div id="buttonDiv" style="margin-top:15px; border-top:solid 1px black; border-bottom:solid 1px black; height:50px; font-size:16pt; padding-top:10px;">
	        <span id="intimeButton" style="background-color: #cce6ff; margin-left:15px;">출근</span> <span id="intime" style="margin-right:60px; font-size:12pt;"></span>
	        <span id="outtimeButton" style="background-color: #cce6ff;">퇴근</span> <span id="outtime" style="font-size:12pt;"></span>
        </div>
        <div style="margin-top:20px; border-top:solid 1px black; border-bottom:solid 1px black; padding-top:10px;">
           <span style="margin-left:15px; font-size:15pt;" onclick="location.href='<%= ctxPath%>/t1/myMonthIndolence.tw'">월별근태현황</span>
           <c:if test="${loginuser.fk_pcode eq 3}">
            <span style="margin-left:65px; font-size:15pt;" onclick="location.href='<%= ctxPath%>/t1/depMonthIndolence.tw'">부서근태현황</span>
           </c:if>
        </div>

     </div>
     <div id="vacation" style="margin-top:5px; border-bottom:solid 1px black;">
     	<ul id="vacationUl">
     		<li>입사일자 : ${fn:substring(loginuser.hiredate,0,4)}년 ${fn:substring(loginuser.hiredate,5,7)}월 ${fn:substring(loginuser.hiredate,8,10)}일</li>
     		<li>총 연차일수 : ${offMap.totalOffCnt}일</li>
     		<li>사용 연차 일수 : ${offMap.useOffCnt}일</li>
     		<li>남은 연차 일수 : ${offMap.leftOffCnt}일</li>
     	</ul>
     </div>
             <%-- word-cloud 차트  시작(백원빈) --%>
       	<figure class="highcharts-figure">
    	<div id="container2" style="width:360px; height:330px; overflow:hidden;"></div>
		</figure>
		<%-- word-cloud 차트 끝(백원빈) --%>
  </div><%-- end of div(myInfo) 백원빈 --%>
  
  
  
  <%-- =================== 백원빈 내통계 시작 =================== --%>
  <div id="myStatic" style="border: solid 1px green; float: left; margin: 50px 0px 40px 40px; width: 450px; height: 280px; ">
  	<figure class="highcharts-figure">
    <div id="container" style="height:250px"></div>

    <table id="datatable">
        <tbody>
            <tr>
                <th></th>
                <td>근무시간</td>
            </tr>
            <c:forEach var="hourMap" items="${hourList}">
            	<tr>
	                <th>${hourMap.gooutdate}</th>
	                <td>${hourMap.doneHour}</td>
           		</tr>	
            </c:forEach>  
        </tbody>
	    </table>
	</figure>

  </div>
  <%-- =================== 백원빈 내통계 끝 =================== --%>
  
  
  <%-- =================== 한수연 시작 =================== --%>
  <div id="quickMenu" style="border: solid 2px #bbc3c3; float: left; margin: 50px 0px 40px 40px; width: 600px; height: 280px;">
  	<div style="border: solid 2px #0071bd; background-color:#0071bd; color:#fff; font-size:15pt; width:200px; height:35px; text-align: center; padding-top: 2px; ">
  		My Quick Menu
  	</div>
  	<div id="donutchart" style="width: 300px; height: 280px; float:left; border: solid 0px red; position:relative; top:-40px;"></div>
	<div style='font-size:13pt; float:left; border: solid 0px red;'>
		<div style='margin-bottom: 18px;'>
			<button type="button" class='quickMenuBt' onclick='location.href="<%=ctxPath%>/t1/mail.tw"'>받은메일함</button>
			<button type="button" class='quickMenuBt' style='margin-left:20px;' onclick='location.href="<%=ctxPath%>/t1/myDocuNorm_send.tw"'>문서 발신함</button>
		</div>
		<div>
			<span style='color:#006680; font-size: 22pt; padding-left:5px;'>■</span>
			&nbsp;&nbsp;읽지 않은 메일 <span class="quickCnt" id="notReadCnt"></span>&nbsp;건
		</div>
		<div>
			<span style='color:#00b8e6; font-size: 22pt; padding-left:5px;'>■</span>
			&nbsp;&nbsp;결재 진행 중 문서 <span class="quickCnt" id="ingDocuCnt"></span>&nbsp;건
		</div>
		<div>
			<span style='color:#0099ff; font-size: 22pt; padding-left:5px;'>■</span>
			&nbsp;&nbsp;최근 결재 완료 문서 <span class="quickCnt" id="doneDocuCnt"></span>&nbsp;건
		</div>
	</div> 
  </div>
  <%-- =================== 한수연 끝 =================== --%>
  
  
  <%-- ============== 김다님 공지사항 게시판 시작 =============== --%>
  <%-- 위의 float에서 한칸 아래로 내려오기 위한 빈 div --%>
  <div style="float: left; width: 800px;"></div>
  
  <div id="simpleNotice" style="border: solid 1px gray; float: left; width: 580px; height: 230px; margin: 10px 0px 20px 40px;">
  	
  	<table id="recentNotice" class="table">
  		<tr>
  			<th>구분</th>
  			<th>제목</th>
  			<th>작성일시</th>
  		</tr>
  		<tr id="row-0-content"></tr>
  		<tr id="row-1-content"></tr>
  		<tr id="row-2-content"></tr>
  	</table>
  </div>
  
  <%-- ============== 김다님 공지사항 게시판 끝 =============== --%>
  
  
  
  
  <%-- =================== 오다윤 시작 =================== --%>
  						<%--  달력 시작 --%>
  <div id="calendarO" style="float: right;">
		<div id="calendar"></div>
		<div id="todayCal" style="margin-top:10px; padding-left: 10px;"></div>
		<div id="infoCalendar" style="margin-top:10px; padding-left: 10px;"></div>
  </div>
						<%--  달력 끝 --%>
 
 						<%--  날씨 시작 --%> 
  <div id="weather" style="border: solid 1px blue; float: left; margin: 10px 0px 50px 40px; width: 580px; height: 230px; ">
 	<div id="today-w" style="float: left; width: 50%; height: 100%; border-right: solid 1px blue;">
 	<span style="font-weight: bold;">오늘의 날씨</span><br><br>
 	<span  id="sky"></span>
 	<div style="padding-top: 30px; display: inline-block; float: right; margin-right: 20px;"><span id="t1h" style="font-size: 25pt; font-weight: bold; margin-left: 10px; "></span><span style="font-size: 25pt; font-weight: bold; ">ºC</span><br>
 	<span style="margin-left: 10px;" id="pop"></span><br><span id="gap"></span></div>
 	</div>
 	<div style="float: right; width: 50%; height: 100%; " >
 		<span style="text-align: left; font-weight: bold;">미세먼지 농도</span><br>
 		<div align="center" style="margin-top: 20px;">
 		<span id="miseimg"></span><br><br>
 		<span id="miseStatus" ></span><span id="mise"></span><br>
 		<span id="chomiseStatus"></span><span id="chomise"></span>
 		</div>
 	</div>
 	
  </div>
  						<%--  날씨 끝 --%> 
</div>