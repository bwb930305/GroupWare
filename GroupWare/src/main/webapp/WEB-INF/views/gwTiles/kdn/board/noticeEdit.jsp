<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<% String ctxPath = request.getContextPath(); %>    

<style type="text/css">

   table, th, td, input, textarea {border: solid gray 1px;}
   
   #table {border-collapse: collapse;
           width: 1024px;
          }
   #table th, #table td{padding: 5px;}
   #table th{width: 120px; background-color: #DDDDDD;}
   #table td{width: 880px;}
   .long {width: 470px;}
   .short {width: 120px;}

</style>

<script type="text/javascript">
   $(document).ready(function(){
	   var categnum = $("input[name=fk_categnum]").val();
	   $("select#category").val(categnum).prop("selected",true);
	   
	   $("select#category").change(function(){
		  $(this).prop('selected',true);
		  var changedCategnum = $(this).val();
		  $("input[name=fk_categnum]").val(changedCategnum);
	   console.log(typeof changedCategnum);
	   });
	   
	   
      <%-- === #167. 스마트 에디터 구현 시작 === --%>
       
       <%-- === 스마트 에디터 구현 끝 === --%>
      
      // 완료버튼
      $("button#btnUpdate").click(function(){
      
         <%-- === 스마트 에디터 구현 시작 === --%>
          
         <%-- === 스마트 에디터 구현 끝 === --%>
         
          // 글제목 유효성 검사
         var subjectVal = $("input#subject").val().trim();
         if(subjectVal == "") {
            alert("글제목을 입력하세요!!");
            return;
         }
         
         // 글내용 유효성 검사(스마트에디터 사용 안 할시)
         
         var contentVal = $("textarea#content").val().trim();
         if(contentVal == "") {
            alert("글내용을 입력하세요!!");
            return;
         }
        
         
         <%-- === 스마트에디터 구현 시작 === --%>
         //스마트에디터 사용시 무의미하게 생기는 p태그 제거
          
              
           
           
           // 스마트에디터 사용시 무의미하게 생기는 p태그 제거하기전에 먼저 유효성 검사를 하도록 한다.
           // 글내용 유효성 검사 
           
           
           // 스마트에디터 사용시 무의미하게 생기는 p태그 제거하기
           
       
          
        
        
       <%-- === 스마트에디터 구현 끝 === --%>
         
         // 글암호 유효성 검사
         var pwVal = $("input#pw").val().trim();
         if(pwVal == "") {
            alert("글암호를 입력하세요!!");
            return;
         }
         
         // 폼(form) 을 전송(submit)
         var frm = document.editFrm;
         frm.method = "POST";
         frm.action = "<%= ctxPath%>/t1/noticeEditEnd.tw";
         frm.submit();   
      });
           
   });// end of $(document).ready(function(){})----------------
</script>

<div style="padding-left: 10%;">
 <a href="javascript:location.href='employeeBoard.tw'" style="text-decoration:none; color: black;"><i class="fas fa-bullhorn fa-lg"></i>&nbsp;<span style="display: inline-block; font-size:22px;">공지사항</span></a>

 <form name="editFrm"> 
 
      <table id="table">
         <tr>
            <th>성명</th>
            <td>
                <input type="hidden" name="seq" value="${requestScope.boardvo.seq}" />
                ${sessionScope.loginuser.name}       
            </td>
         </tr>
         <tr>
            <th>구분</th>
            <td>
               <input type="text" name="fk_categnum" value="${requestScope.boardvo.fk_categnum}" />       
            	<select id="category">
            		<option value="">선택</option>
            		<option value="1">전체공지</option>
            		<option value="2">총무공지</option>
            		<option value="3">경조사</option>
            	</select>
            </td>
         </tr>
         <tr>
            <th>제목</th>
            <td>
               <input type="text" name="subject" id="subject" class="long" value="${requestScope.boardvo.subject}" />       
            </td>
         </tr>
         <tr>
            <th>내용</th>
            <td>
               <textarea rows="10" cols="100" style="width: 95%; height: 612px;" name="content" id="content">${requestScope.boardvo.content}</textarea>       
            </td>
         </tr>
         
         <%-- === #150. 파일첨부 타입 추가하기 === --%>
         
         
         <tr>
            <th>비밀번호</th>
            <td>
               <input type="password" name="pw" id="pw" class="short" />       
            </td>
         </tr>
      </table>
      
      <div style="margin: 20px;">
         <button type="button" id="btnUpdate">쓰기</button>
         <button type="button" onclick="javascript:history.back()">취소</button>
      </div>
      
      
         
   </form>
   
</div>    