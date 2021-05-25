package com.t1works.groupware.bwb.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.t1works.groupware.bwb.model.MemberBwbVO;
import com.t1works.groupware.bwb.service.InterMemberBwbService;
import com.t1works.groupware.hsy.model.DepartmentHsyVO;
import com.t1works.groupware.hsy.model.MemberHsyVO;
import com.t1works.groupware.hsy.service.InterMemberHsyService;

@Controller
public class MemberBwbController {
	
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private InterMemberHsyService service;
	
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private InterMemberBwbService service2;
	
	
	// 주소록(조직도) 매핑 주소
	@RequestMapping(value="/t1/toDo.tw")        // 로그인이 필요한 url
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
			pageBar += "&nbsp;<a href='toDo.tw?currentShowPageNo=1&sizePerPage="+sizePerPage+"&searchType="+searchType+"&searchWord="+searchWord+"'>[맨처음]</a>&nbsp;"; 
			pageBar += "&nbsp;<a href='toDo.tw?currentShowPageNo="+(pageNo-1)+"&sizePerPage="+sizePerPage+"&searchType="+searchType+"&searchWord="+searchWord+"'>[이전]</a>&nbsp;";
		}
		
		while(!(loop>blockSize || pageNo > totalPage) ) {
			if(pageNo == Integer.parseInt(currentShowPageNo)) {
				pageBar += "&nbsp;<span style='color:#fff; background-color: #5e5e5e; font-weight:bold; padding:2px 4px;'>"+pageNo+"</span>&nbsp;";
			}
			else {
				pageBar += "&nbsp;<a href='toDo.tw?currentShowPageNo="+pageNo+"&sizePerPage="+sizePerPage+"&searchType="+searchType+"&searchWord="+searchWord+"'>"+pageNo+"</a>&nbsp;";
			}
			loop++;
			pageNo++;
		}// end of while-----------------------------
		
		if(pageNo <= totalPage) {
			pageBar += "&nbsp;<a href='toDo.tw?currentShowPageNo="+pageNo+"&sizePerPage="+sizePerPage+"&searchType="+searchType+"&searchWord="+searchWord+"'>[다음]</a>&nbsp";
			pageBar += "&nbsp;<a href='toDo.tw?currentShowPageNo="+totalPage+"&sizePerPage="+sizePerPage+"&searchType="+searchType+"&searchWord="+searchWord+"'>[마지막]</a>&nbsp";
		}
		
		mav.addObject("pageBar", pageBar);
		
		mav.setViewName("bwb/todo/insabuzang.gwTiles");
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
	
	
}