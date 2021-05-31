package com.t1works.groupware.sia.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.t1works.groupware.sia.model.ApprovalSiaVO;
import com.t1works.groupware.sia.service.InterMyDocumentSiaService;

@Component
@Controller
public class MyDocumentSiaController {
	
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private InterMyDocumentSiaService service;
	
	// 내문서함 클릭 시 수신함 일반결재문서로 이동!
	@RequestMapping(value="/t1/myDocument.tw")
	public String myDocument() {
		return "sia/myDocument/myDocuNorm_rec.gwTiles";
	}
	
	// 내문서함 - 수신함 - 일반결재문서 (기본으로 일반결재문서가 보여짐!)
	@RequestMapping(value="/t1/myDocuNorm_rec.tw")
	public String myDocuNorm_rec() {
		return "sia/myDocument/myDocuNorm_rec.gwTiles";		
	}
	
	// 내문서함 - 수신함 - 지출결재문서
	@RequestMapping(value="/t1/myDocuSpend_rec.tw")
	public String myDocuSpend_rec() {
		return "sia/myDocument/myDocuSpend_rec.gwTiles";		
	}
	
	// 내문서함 - 수신함 - 근태휴가결재문서
	@RequestMapping(value="/t1/myDocuVacation_rec.tw")
	public String myDocuVacation_rec() {
		return "sia/myDocument/myDocuVacation_rec.gwTiles";		
	}	
	
	
	// 내문서함 - 발신함 - 일반결재문서 (기본으로 일반결재문서가 보여짐!)
	@RequestMapping(value="/t1/myDocuNorm_send.tw")
	public String myDocuNorm_send() {
		return "sia/myDocument/myDocuNorm_send.gwTiles";		
	}
	
	// 내문서함 - 발신함 - 지출결재문서
	@RequestMapping(value="/t1/myDocuSpend_send.tw")
	public String myDocuSpend_send() {
		return "sia/myDocument/myDocuSpend_send.gwTiles";		
	}
	
	// 내문서함 - 발신함 - 근태휴가결재문서
	@RequestMapping(value="/t1/myDocuVacation_send.tw")
	public String myDocuVacation_send() {
		return "sia/myDocument/myDocuVacation_send.gwTiles";		
	}
	
	
	// 내문서함 - 임시저장함 - 일반결재문서 (기본으로 일반결재문서가 보여짐!)
	@RequestMapping(value="/t1/myDocuNorm_temp.tw")
	public String myDocuNorm_temp() {
		return "sia/myDocument/myDocuNorm_temp.gwTiles";		
	}
	
	// 내문서함 - 임시저장함 - 지출결재문서
	@RequestMapping(value="/t1/myDocuSpend_temp.tw")
	public String myDocuSpend_temp() {
		return "sia/myDocument/myDocuSpend_temp.gwTiles";		
	}
	
	// 내문서함 - 임시저장함 - 근태휴가결재문서
	@RequestMapping(value="/t1/myDocuVacation_temp.tw")
	public String myDocuVacation_temp() {
		return "sia/myDocument/myDocuVacation_temp.gwTiles";		
	}
	
	//////////////////////////////////////////////////////////////////////
	
	// 내문서함 - 수신함 - 일반결재문서에 해당하는 문서 조회하기
	@ResponseBody
	@RequestMapping(value="/t1/norm_reclist.tw", produces="text/plain;charset=UTF-8")
	public String norm_reclist(HttpServletRequest request) {
		
		String anocode = request.getParameter("anocode");
		String astatus = request.getParameter("astatus");
		String fromDate = request.getParameter("fromDate");
		String toDate = request.getParameter("toDate");
		String ncat = request.getParameter("ncat");
		String sort = request.getParameter("sort");
		String searchWord = request.getParameter("searchWord");
		
		if(astatus == null || (!"0".equals(astatus) && !"1".equals(astatus) && !"2".equals(astatus) && !"3".equals(astatus))) {
			astatus = "";
		}		
		
		if(fromDate == null || toDate == null) {
			fromDate = "";
			toDate = "";
		}
		
		if(sort == null || (!"atitle".equals(sort) && !"ano".equals(sort))) {
			sort = "";
		}
		
		if(searchWord == null || "".equals(searchWord) || searchWord.trim().isEmpty()) {
			searchWord = "";
		}
		
		String a = "";
		if(ncat.length() == 0) {
			a = "";
		}
		else {
			String[] ncatArr = ncat.split(","); // [2,3]
			int cnt = 0;
			for(int i=0; i<ncatArr.length; i++) {
				cnt++;
				
				if(cnt < ncatArr.length) {
					a += "'"+ncatArr[i]+"',";
				}
				else {
					a += "'"+ncatArr[i]+"'";
				}				
			}			
		}
		
				
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("anocode", anocode);  
		paraMap.put("astatus", astatus);
		paraMap.put("fromDate", fromDate);
		paraMap.put("toDate", toDate);
		paraMap.put("sort", sort);
		paraMap.put("searchWord", searchWord);
		paraMap.put("a", a);
		
		List<ApprovalSiaVO> approvalvo = service.getnorm_reclist(paraMap);
		
		JSONArray jsonArr = new JSONArray();
		
		if(approvalvo != null) {
			for(ApprovalSiaVO appvo : approvalvo) {
				JSONObject jsonObj = new JSONObject();			
				jsonObj.put("atitle", appvo.getAtitle());
				jsonObj.put("ano", appvo.getAno());
				jsonObj.put("ncatname", appvo.getNcatname());
				jsonObj.put("astatus", appvo.getAstatus());
				jsonObj.put("asdate", appvo.getAsdate());				
				
				jsonArr.put(jsonObj);
			}			
		}		
		return jsonArr.toString();
	}
	
	
	
	
	
}