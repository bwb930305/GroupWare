package com.t1works.groupware.bwb.controller;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.t1works.groupware.bwb.model.MemberBwbVO;
import com.t1works.groupware.bwb.model.ProductBwbVO;
import com.t1works.groupware.bwb.service.InterHomepageBwbService;
import com.t1works.groupware.bwb.service.InterMemberBwbService;
import com.t1works.groupware.bwb.service.InterProductBwbService;
import com.t1works.groupware.common.AES256;
import com.t1works.groupware.common.Sha256;
import com.t1works.groupware.hsy.model.DepartmentHsyVO;
import com.t1works.groupware.hsy.model.MemberHsyVO;
import com.t1works.groupware.hsy.service.InterMemberHsyService;

@Controller
public class MemberBwbController {
	
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private InterMemberHsyService service;
	
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private InterMemberBwbService service2;
	
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
    private InterHomepageBwbService service3;
	
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private AES256 aes;
	
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private InterProductBwbService service4;
	 
	
	// 인사부장- 업무관리(인사관리) 매핑 주소
	@RequestMapping(value="/t1/personnelManage.tw")        // 로그인이 필요한 url
	public ModelAndView requiredLogin_employeeMap(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		// 주소록표기
		// 1) 모든 부서에 대한 정보 가져오기
		List<DepartmentHsyVO> departmentList= service.selectAllDepartment();
		mav.addObject("departmentList", departmentList);
		
		
		// 2) 모든 직원 정보 가져오기
		List<MemberHsyVO> employeeList= service.selectAllMember();
		mav.addObject("employeeList",employeeList);
		
		
		// 3) 페이징바 처리 직원정보 가져오기
		String currentShowPageNo= request.getParameter("currentShowPageNo");
		if(currentShowPageNo == null) currentShowPageNo = "1";
		
		// 4) 모든 직위 가져오기
		List<MemberBwbVO> positionList = service2.selectPositionList();
		mav.addObject("positionList", positionList);
		
		
		
		try {
			Integer.parseInt(currentShowPageNo);
		} catch(NumberFormatException e) {
			currentShowPageNo = "1"; 
		}
		
		String sizePerPage= "7"; // 5행씩 고정
		if(!"7".equals(sizePerPage)) sizePerPage = "7";
		
		String searchType= request.getParameter("searchType"); // name, dname, pname, email
		String searchWord= request.getParameter("searchWord");
		
		if(searchType!=null && !"".equals(searchType) && !("name".equalsIgnoreCase(searchType)||"dname".equalsIgnoreCase(searchType)||"pname".equalsIgnoreCase(searchType)||"email".equalsIgnoreCase(searchType))) {
			searchType="name";
		}
		
		if(searchType!=null && !"email".equalsIgnoreCase(searchType)) { // 대소문자 구분없이 검색가능하도록 설정
			searchWord=searchWord.toUpperCase();
		}
		else if("email".equalsIgnoreCase(searchType)) {
			searchWord=searchWord.toLowerCase();
		}
		
		Map<String,String> paraMap= new HashMap<>();
		paraMap.put("currentShowPageNo", currentShowPageNo);
		paraMap.put("sizePerPage", sizePerPage);
		paraMap.put("searchType", searchType);  // null인경우 존재
		paraMap.put("searchWord", searchWord);  // null인경우 존재 
		int totalPage = service.selectTotalPage(paraMap);
		
		if( Integer.parseInt(currentShowPageNo) > totalPage ) {
			currentShowPageNo = "1";
			paraMap.put("currentShowPageNo", currentShowPageNo);
		}
		
		List<MemberHsyVO> pagingEmployeeList= service.selectPagingMember(paraMap);
		mav.addObject("pagingEmployeeList", pagingEmployeeList);
		
		if(searchType!=null) searchType=searchType.toLowerCase(); // 대문자로 장난친 경우 소문자로 변경해서 넣어주기 위해 tolowerCase사용
		
		mav.addObject("searchType", searchType);  // view단에 값을 넣어주기 위한 용도 
		mav.addObject("searchWord", searchWord);  // view단에 값을 넣어주기 위한 용도
		
		// 4) 페이징바 생성
		String pageBar= "";
		int blockSize= 5;
		int loop=1;
		int pageNo=0;
		
		pageNo= ((Integer.parseInt(currentShowPageNo)-1)/blockSize) * blockSize + 1 ;
		if(searchType == null) searchType="";
		
		if(searchWord == null) searchWord="";
		
		if(pageNo != 1) {
			pageBar += "&nbsp;<a href='personnelManage.tw?currentShowPageNo=1&sizePerPage="+sizePerPage+"&searchType="+searchType+"&searchWord="+searchWord+"'>[맨처음]</a>&nbsp;"; 
			pageBar += "&nbsp;<a href='personnelManage.tw?currentShowPageNo="+(pageNo-1)+"&sizePerPage="+sizePerPage+"&searchType="+searchType+"&searchWord="+searchWord+"'>[이전]</a>&nbsp;";
		}
		
		while(!(loop>blockSize || pageNo > totalPage) ) {
			if(pageNo == Integer.parseInt(currentShowPageNo)) {
				pageBar += "&nbsp;<span style='color:#fff; background-color: #5e5e5e; font-weight:bold; padding:2px 4px;'>"+pageNo+"</span>&nbsp;";
			}
			else {
				pageBar += "&nbsp;<a href='personnelManage.tw?currentShowPageNo="+pageNo+"&sizePerPage="+sizePerPage+"&searchType="+searchType+"&searchWord="+searchWord+"'>"+pageNo+"</a>&nbsp;";
			}
			loop++;
			pageNo++;
		}// end of while-----------------------------
		
		if(pageNo <= totalPage) {
			pageBar += "&nbsp;<a href='personnelManage.tw?currentShowPageNo="+pageNo+"&sizePerPage="+sizePerPage+"&searchType="+searchType+"&searchWord="+searchWord+"'>[다음]</a>&nbsp";
			pageBar += "&nbsp;<a href='personnelManage.tw?currentShowPageNo="+totalPage+"&sizePerPage="+sizePerPage+"&searchType="+searchType+"&searchWord="+searchWord+"'>[마지막]</a>&nbsp";
		}
		
		mav.addObject("pageBar", pageBar);
		
		mav.setViewName("bwb/todo/personnelManage.gwTiles");
		return mav;
		
	} // end of public ModelAndView employeeMap(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {--------------------------------------------
	
	
	// 부서를 통해 직무내용 뽑아오기
	@ResponseBody
	@RequestMapping(value="/t1/selectDuty.tw",produces="text/plain;charset=UTF-8")
	public String requiredLogin_selectDuty(HttpServletRequest request,HttpServletResponse response) {
		
		String dname = request.getParameter("dname");
		
		String duty = service2.selectDuty(dname);
		
		JSONObject jsonObj = new JSONObject();
		
		jsonObj.put("duty", duty);
			
		return jsonObj.toString();
	}// end of public String requiredLogin_selectDuty(HttpServletRequest request,HttpServletResponse response) {
	
	// 인사관리를 통해 조직원 정보 업데이트하기
	@ResponseBody
	@RequestMapping(value="/t1/updateOneInfo.tw")
	public String updateOneInfo(MemberBwbVO mvo) {
		
		// serialize()한 데이터값 뽑아오기
		String pname = mvo.getPname();
		String dname = mvo.getDname();
		String cmobile = mvo.getCmobile();
		String mobile = mvo.getMobile();
		
		Map<String,String> paraMap = new HashMap<>();
		
		paraMap.put("pname", pname);
		paraMap.put("dname", dname);
		
		// pname과 dname을 통해 pcode,dcode 가져오기.
		Map<String,String> PDMap  = service2.selectPDcode(paraMap);
		mvo.setFk_pcode(PDMap.get("fk_pcode")); 
		mvo.setFk_dcode(PDMap.get("fk_dcode"));
		
		String[] cmobileArr = cmobile.split("-");
		String[] mobileArr = mobile.split("-");
		
		cmobile = "";
		mobile = "";
		
		for(String scmobile:cmobileArr){
			cmobile += scmobile;
		}
		mvo.setCmobile(cmobile);
		
		for(String smobile:mobileArr){
			mobile += smobile;
		}

		mvo.setMobile(mobile);
		
		// 회원정보 업데이트하기
		int n = service2.updateOneInfo(mvo);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		
		return jsonObj.toString();
	}
	
	
	// 인사부장- 업무관리(신입사원 등록) 매핑 주소
	@RequestMapping(value="/t1/registerNewEmployee.tw")
	public ModelAndView requiredLogin_registerNewEmployee(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) { // 로그인이 필요한 url AOP사용
		
		// 1) 모든 부서명 가저오기
		List<DepartmentHsyVO> departmentList= service.selectAllDepartment();
		mav.addObject("departmentList", departmentList);
		
		// 2) 모든 직위 가져오기
		List<MemberBwbVO> positionList = service2.selectPositionList();
		mav.addObject("positionList", positionList);
		
		
		mav.setViewName("bwb/todo/registerNewEmployee.gwTiles");
		
		return mav;

	}
	
	// pcode에 따른 연차수 가져오기
	@ResponseBody
	@RequestMapping(value="/t1/selectOffCnt.tw")
	public String requiredLogin_selectOffCnt(HttpServletRequest request,HttpServletResponse response) {
		
		String pcode = request.getParameter("fk_pcode");
		
		String offcnt = service2.selectOffCnt(pcode);
		
		JSONObject jsonObj = new JSONObject();
		
		jsonObj.put("offcnt", offcnt);
			
		return jsonObj.toString();
		
	}// end of public String requiredLogin_selectDuty(HttpServletRequest request,HttpServletResponse response) {
	
	// 직원정보등록하기 ==> 추후 ajax이용할때, 코드 변경예정...
	@ResponseBody
	@RequestMapping(value="/t1/registerOne.tw")
	public String registerOne(HttpServletRequest request, MemberBwbVO mvo) {
		
		
		String jubun1 = request.getParameter("jubun1");
		String jubun2 = request.getParameter("jubun2");
		
		String jubun = jubun1+jubun2;
		
		mvo.setJubun(jubun);
		mvo.setPasswd(jubun1);
		
		String mobile1 = request.getParameter("mobile1");
		String mobile2 = request.getParameter("mobile2");
		String mobile3 = request.getParameter("mobile3");
		
		String mobile = mobile1+mobile2+mobile3;
		mvo.setMobile(mobile);
		
		String cmobile1 = request.getParameter("cmobile1");
		String cmobile2 = request.getParameter("cmobile2");
		String cmobile3 = request.getParameter("cmobile3");
		
		String cmobile = cmobile1+cmobile2+cmobile3;
		mvo.setCmobile(cmobile);
		
		String dcode = request.getParameter("fk_dcode");
		// 등록한 직원의 fk_dcode를 통해 managerid 알아오기
		String managerid = service2.selectMangerid(dcode);
		mvo.setManagerid(managerid);
		

		
		int n = service2.registerOne(mvo);
		
		
		JSONObject jsonObj = new JSONObject();
		
		jsonObj.put("n", n);
			
		return jsonObj.toString();
		
	}
	
	// 마이페이지 맵핑
	@RequestMapping(value="/t1/mypage.tw")
	public ModelAndView requiredLogin_mypage(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		
		HttpSession session = request.getSession();
		MemberBwbVO loginuser = (MemberBwbVO)session.getAttribute("loginuser");
		
		String dcode = loginuser.getFk_dcode();
		String pcode = loginuser.getFk_pcode();
		
		// 부서명 가져오기
		String dname = service2.selectdname(dcode);
		
		// 직무 가져오기
		String duty = service2.selectDuty(dname);
		
		// 직위 가져오기
		String pname = service2.selectpname(pcode);
		
		String jubun="";
		
		try {
			
			if(loginuser.getJubun().length()>13) {
				jubun = aes.decrypt(loginuser.getJubun());
			}
			else {
				jubun = loginuser.getJubun();
			}
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		}
		
		String fJubun = jubun.substring(0,6);
		
		String passwd = loginuser.getPasswd();
		
		Map<String,String> paraMap = new HashMap<>();
		paraMap.put("dname", dname);
		paraMap.put("duty", duty);
		paraMap.put("pname", pname);
		paraMap.put("fJubun", fJubun);
		paraMap.put("passwd", passwd);
		
		mav.addObject("paraMap", paraMap);
		
		mav.setViewName("bwb/mypage/mypage.gwTiles");
		
		return mav;
	}

	// 비밀번호 변경하기
	@ResponseBody
	@RequestMapping(value="/t1/changePwd.tw", method= {RequestMethod.POST})
	public String changePwd(HttpServletRequest request) {
		
		
		String spasswd = request.getParameter("passwd");
		String employeeid = request.getParameter("employeeid");
				
		String passwd = Sha256.encrypt(spasswd);
		
		Map<String,String> paraMap = new HashMap<>();
		paraMap.put("employeeid", employeeid);
		paraMap.put("passwd", passwd);
		
		
		int n = service2.updatePasswd(paraMap);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		
		return jsonObj.toString();
	}
	
	
	// 비밀번호 검사하기
	@ResponseBody
	@RequestMapping(value="/t1/checkpasswd.tw", method= {RequestMethod.POST})
	public String checkpasswd(HttpServletRequest request) {
		
		
		String employeeid = request.getParameter("employeeid");
        String passwd = request.getParameter("lastpasswd");
				
        Map<String,String> paraMap = new HashMap<>();
        paraMap.put("employeeid", employeeid);
        paraMap.put("passwd", passwd);
		
     // 직원테이블에서 select해오기
        MemberBwbVO mvo = service3.selectMember(paraMap);
		
        JSONObject jsonObj = new JSONObject();
        
        int n =0;
        
		if(mvo==null) {
			n=1;
		}
		
		jsonObj.put("n", n);
		
		return jsonObj.toString();
	}
	
	
	// CS팀장 로그인시 업무관리 => 나의업무현황 => 미배정업무 보여주기
	@RequestMapping(value="/t1/leaderTodo.tw")
	public ModelAndView requiredLogin_leaderTodo_1(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		// 세션에 저장된 부장 loginuser 가져오기
		HttpSession session = request.getSession();
		MemberBwbVO loginuser = (MemberBwbVO)session.getAttribute("loginuser");
		
		// 부서장 정보가져오기
		String fk_dcode = loginuser.getFk_dcode();
		String employeeid = loginuser.getEmployeeid();
		
		
		Map<String,String> paraMap2 = new HashMap<>();
		paraMap2.put("fk_dcode", fk_dcode);
		paraMap2.put("employeeid", employeeid);
		
		// 부장의 해당부서팀의 직원들 가져오기
		List<MemberBwbVO> memberList = service4.selectMemberList(paraMap2);
		mav.addObject("memberList", memberList);
		

		// 페이지가 처음 로딩될때 currentshowPageNo가져오기
		String str_currentShowPageNo = request.getParameter("currentShowPageNo");
		

		int noAssignedProduct = 0;	    // 총 상품갯수
		int sizePerPage = 2;	    // 한페이지당 보여주는 갯수
		int currentShowPageNo = 0;  // 현제페이지 번호
		int totalPage = 0;          // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)
		int startRno = 0;           // 시작 행번호
	    int endRno = 0;             // 끝 행번호 
		
	    
	    // 미배정 상품 총 갯수 구해오기(noAssignedProduct)
	    noAssignedProduct = service4.selectNoAssignedProduct(employeeid);
	    mav.addObject("noAssignedProduct", noAssignedProduct);
	    
	    // 배정 상품 총 갯수 구해오기(assignedProduct)
	    int assignedProduct = service4.selectAssignedTotal(employeeid);
	    mav.addObject("assignedProduct", assignedProduct);
	    
	    totalPage = (int)Math.ceil(((double)noAssignedProduct/sizePerPage));
	    
	    
	    // currentShowPageNo 장난질 막기
	    if(str_currentShowPageNo == null) { // 맨처음 로딩될때는 null값
	    	currentShowPageNo = 1;
	    }
	    else { // currentShowPageNo가 1페이지 미만의 값, 또는 totalPage 값보다 큰값을 적을때
	    	
	    	try {
	    		currentShowPageNo = Integer.parseInt(str_currentShowPageNo);
		    	if(currentShowPageNo<1 || currentShowPageNo>totalPage) {
		    		currentShowPageNo=1;
		    	}
			} catch (NumberFormatException e) { // null이 아닌 문자열이 들어왔을때
				currentShowPageNo=1;
			}
	    	
	    }// end of else
	    
	    
	    startRno = ((currentShowPageNo - 1 ) * sizePerPage) + 1;
        endRno = startRno + sizePerPage - 1;
        
        Map<String,String> paraMap = new HashMap<>();
        
        paraMap.put("startRno", String.valueOf(startRno));
        paraMap.put("endRno", String.valueOf(endRno));
	    paraMap.put("fk_managerid",employeeid);
	    
	    // 미배정 상품정보 가져오기
 		List<ProductBwbVO> productList = service4.selectProudctList(paraMap);
 		
 		int blockSize = 3; // 페이지바의 한블록당 보여주는 갯수  1,2,3   4,5,6 ...
 		int loop = 1;      // 1씩 올라간다.
	    
 		int pageNo = ((currentShowPageNo - 1)/blockSize) * blockSize + 1;
 		
 		String pageBar = "<ul style='list-style:none;'>";
 		String url = "leaderTodo.tw";
 		
 		// [맨처음][이전] 만들기
 		if(pageNo != 1) {
			pageBar += "<li style='display:inline-block; width:70px; font-size:10pt;'><a href='"+url+"?currentShowPageNo=1'>[맨처음]</a></li>";
			pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?currentShowPageNo="+(pageNo-1)+"'>[이전]</a></li>";
		}
 		
 		while(!((loop>blockSize)||pageNo>totalPage)) {
			
			if(pageNo == currentShowPageNo) {
                pageBar += "<li style='display:inline-block; width:30px; font-size:10pt; border:solid 0px gray; color:red;'>"+pageNo+"</li>";
            }
			else {
				pageBar+="<li style='display:inline-block; width:30px; font-size:10pt;'><a href='"+url+"?currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>";
			}
			
			loop++;
			pageNo++;
		}// end of while() {
 		
 		
 		// === [다음][마지막] 만들기 ===
		if(pageNo <= totalPage) { // 마지막 페이지에서는 만들 필요가 없기때문에
			
			pageBar += "<li style='display:inline-block; width:50px; font-size:10pt;'><a href='"+url+"?currentShowPageNo="+pageNo+"'>[다음]</a></li>";
			pageBar += "<li style='display:inline-block; width:70px; font-size:10pt;'><a href='"+url+"?currentShowPageNo="+totalPage+"'>[마지막]</a></li>";
			
		}
		
		pageBar += "</ul>";
 		
		
		mav.addObject("productList", productList);
		mav.addObject("pageBar", pageBar);
		mav.setViewName("bwb/todo/leaderTodo_1.gwTiles");
		
		return mav;
		
	}// end of public ModelAndView requiredLogin_leaderTodo_1
	
	// 배정하기 버튼 클릭시 ajax처리
	@ResponseBody
	@RequestMapping(value="/t1/goAssign.tw",method= {RequestMethod.POST})
	public String goAssign(HttpServletRequest request) {
		
		
		String pNo = request.getParameter("pNo");
		String hurryno = request.getParameter("hurryno");
		String employeeid = request.getParameter("employeeid");
		
		Map<String,String> paraMap = new HashMap<>();
		paraMap.put("pNo", pNo);
		paraMap.put("hurryno", hurryno);
		paraMap.put("employeeid", employeeid);
		
		// 업무테이블에서 배정자 update해주기
		int n = service4.goAssign(paraMap);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		
		return jsonObj.toString();
		
	} // end of public String goAssign(HttpServletRequest request) {
	
	
	
	
	// CS팀장 로그인시 업무관리 => 나의업무현황 => 배정된업무 보여주기
	@RequestMapping(value="/t1/leaderTodo2.tw")
	public ModelAndView requiredLogin_leaderTodo_2(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		// 세션에 저장된 부장 loginuser 가져오기
		HttpSession session = request.getSession();
		MemberBwbVO loginuser = (MemberBwbVO)session.getAttribute("loginuser");
		
		// 부서장 정보가져오기
		String fk_dcode = loginuser.getFk_dcode();
		String employeeid = loginuser.getEmployeeid();
		
		
		Map<String,String> paraMap2 = new HashMap<>();
		paraMap2.put("fk_dcode", fk_dcode);
		paraMap2.put("employeeid", employeeid);
		
		// 부장의 해당부서팀의 직원들 가져오기
		List<MemberBwbVO> memberList = service4.selectMemberList(paraMap2);
		mav.addObject("memberList", memberList);
		
		
		// 페이지가 처음 로딩될때 currentshowPageNo가져오기
		String str_currentShowPageNo = request.getParameter("currentShowPageNo");
		

		int assignedProduct = 0;	    // 총 배정된 상품갯수
		int sizePerPage = 2;	    // 한페이지당 보여주는 갯수
		int currentShowPageNo = 0;  // 현제페이지 번호
		int totalPage = 0;          // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)
		int startRno = 0;           // 시작 행번호
	    int endRno = 0;             // 끝 행번호 
		
	    
	    // 미배정 상품 총 갯수 구해오기(noAssignedProduct)
	    int noAssignedProduct = service4.selectNoAssignedProduct(employeeid);
	    mav.addObject("noAssignedProduct", noAssignedProduct);
	    
	    // 배정 상품 총 갯수 구해오기(assignedProduct)
	    assignedProduct = service4.selectAssignedTotal(employeeid);
	    mav.addObject("assignedProduct", assignedProduct);
	    
	    totalPage = (int)Math.ceil(((double)assignedProduct/sizePerPage));
	    
	    
	    // currentShowPageNo 장난질 막기
	    if(str_currentShowPageNo == null) { // 맨처음 로딩될때는 null값
	    	currentShowPageNo = 1;
	    }
	    else { // currentShowPageNo가 1페이지 미만의 값, 또는 totalPage 값보다 큰값을 적을때
	    	
	    	try {
	    		currentShowPageNo = Integer.parseInt(str_currentShowPageNo);
		    	if(currentShowPageNo<1 || currentShowPageNo>totalPage) {
		    		currentShowPageNo=1;
		    	}
			} catch (NumberFormatException e) { // null이 아닌 문자열이 들어왔을때
				currentShowPageNo=1;
			}
	    	
	    }// end of else
	    
	    
	    startRno = ((currentShowPageNo - 1 ) * sizePerPage) + 1;
        endRno = startRno + sizePerPage - 1;
        
        Map<String,String> paraMap = new HashMap<>();
        
        paraMap.put("startRno", String.valueOf(startRno));
        paraMap.put("endRno", String.valueOf(endRno));
	    paraMap.put("fk_managerid",employeeid);
	    
	    // 미배정 상품정보 가져오기
 		List<ProductBwbVO> productList = service4.selectAssignedList(paraMap);
 		
 		int blockSize = 3; // 페이지바의 한블록당 보여주는 갯수  1,2,3   4,5,6 ...
 		int loop = 1;      // 1씩 올라간다.
	    
 		int pageNo = ((currentShowPageNo - 1)/blockSize) * blockSize + 1;
 		
 		String pageBar = "<ul style='list-style:none;'>";
 		String url = "leaderTodo2.tw";
 		
 		// [맨처음][이전] 만들기
 		if(pageNo != 1) {
			pageBar += "<li style='display:inline-block; width:70px; font-size:10pt;'><a href='"+url+"?currentShowPageNo=1'>[맨처음]</a></li>";
			pageBar += "<li style='display:inline-block; width:50px; font-size:10pt;'><a href='"+url+"?currentShowPageNo="+(pageNo-1)+"'>[이전]</a></li>";
		}
 		
 		while(!((loop>blockSize)||pageNo>totalPage)) {
			
			if(pageNo == currentShowPageNo) {
                pageBar += "<li style='display:inline-block; width:30px; font-size:10pt; border:solid 0px gray; color:red;'>"+pageNo+"</li>";
            }
			else {
				pageBar+="<li style='display:inline-block; width:30px; font-size:10pt;'><a href='"+url+"?currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>";
			}
			
			loop++;
			pageNo++;
		}// end of while() {
 		
 		
 		// === [다음][마지막] 만들기 ===
		if(pageNo <= totalPage) { // 마지막 페이지에서는 만들 필요가 없기때문에
			
			pageBar += "<li style='display:inline-block; width:50px; font-size:10pt;'><a href='"+url+"?currentShowPageNo="+pageNo+"'>[다음]</a></li>";
			pageBar += "<li style='display:inline-block; width:70px; font-size:10pt;'><a href='"+url+"?currentShowPageNo="+totalPage+"'>[마지막]</a></li>";
			
		}
		
		pageBar += "</ul>";
 		
		
		mav.addObject("productList", productList);
		mav.addObject("pageBar", pageBar);
		mav.setViewName("bwb/todo/leaderTodo_2.gwTiles");
		
		return mav;
		
	}// end of public ModelAndView requiredLogin_leaderTodo_2
	
	
	
	// 배정하기 변경 버튼 클릭시 ajax처리
	@ResponseBody
	@RequestMapping(value="/t1/changeAssign.tw", method= {RequestMethod.POST})
	public String changeAssign(HttpServletRequest request) {
		
		
		String pNo = request.getParameter("pNo");
		String hurryno = request.getParameter("hurryno");
		String employeeid = request.getParameter("fk_employeeid");
		
		Map<String,String> paraMap = new HashMap<>();
		paraMap.put("pNo", pNo);
		paraMap.put("hurryno", hurryno);
		paraMap.put("employeeid", employeeid);
		
		// 업무테이블에서 배정자 update해주기
		int n = service4.goAssign(paraMap);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		
		return jsonObj.toString();
		
	} // end of public String changeAssign(HttpServletRequest request) {
	
}
