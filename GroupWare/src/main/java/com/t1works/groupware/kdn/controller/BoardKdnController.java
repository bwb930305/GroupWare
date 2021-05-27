package com.t1works.groupware.kdn.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.t1works.groupware.kdn.model.BoardVOKdn;
import com.t1works.groupware.kdn.service.InterBoardServiceKdn;

@Controller
public class BoardKdnController {
	
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private InterBoardServiceKdn service;
	
	// === 게시판 글쓰기 폼 페이지 요청 하기 ===
	@RequestMapping(value="/t1/noticePostUpload.tw")
	public ModelAndView requiredLogin_noticePostUpload(HttpServletRequest request, HttpServletResponse response, Map<String,String> paraMap, BoardVOKdn boardvo, ModelAndView mav) {
		mav.setViewName("kdn/noticepostupload.gwTiles");
		return mav;
	}
	
	// === 게시판 글쓰기 완료 요청 ===
	@RequestMapping(value="/t1/uploadComplete.tw", method= {RequestMethod.POST})
	public ModelAndView addEnd(ModelAndView mav, BoardVOKdn boardvo) {
		System.out.println(boardvo.getFk_categnum());
		int n = service.noticePostUpload(boardvo);	// 파일첨부가 없는 글쓰기
		
		if(n==1) {	//글쓰기가 성공한 경우
			mav.setViewName("redirect:/t1/noticePostUpload.tw");
		} else {	//글쓰기가 실패한 경우
			mav.setViewName("kdn/error/uploadfail.gwTiles");
		}
		
		return mav;
	} 
	
	
	// === 공지사항게시판 글목록 보기 페이지 요청 ===
	@RequestMapping(value="/t1/employeeBoard.tw")
	public ModelAndView requiredLogin_viewNoticeBoard(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		List<BoardVOKdn> boardList = null;
		
		String searchType = request.getParameter("searchType");
		String searchWord = request.getParameter("searchWord");
		String str_currentShowPageNo = request.getParameter("currentShowPageNo");
		
		if(searchType == null || (!"subject".equals(searchType) && !"name".equals(searchType))) {
			searchType = "";
		}
		
		if(searchWord == null || "".equals(searchWord)|| searchWord.trim().isEmpty()) {
			searchWord = "";
		}
		
		Map<String, String> paraMap = new HashMap <>();
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);
		
		int totalCount = 0; // 총 게시물 건수
		//int sizePerPage = 10;       // 한 페이지당 보여줄 게시물 건수
		int sizePerPage = 2;       // 한 페이지당 보여줄 게시물 건수
		int currentShowPageNo = 0; // 현재 보여주는 페이지 번호로서, 초기치로는 1페이지로 설정함
		int totalPage = 0;          // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)  
		int startRno = 0;           // 시작 행번호
	    int endRno = 0;             // 끝 행번호 
		
	    totalCount = service.getTotalCount(paraMap);
	    totalPage = (int)Math.ceil((double)totalCount/sizePerPage);
	    
	    if(str_currentShowPageNo == null) {
			// 게시판에 보여지는 초기화면
			currentShowPageNo = 1;
		} else {
			try {
				currentShowPageNo = Integer.parseInt(str_currentShowPageNo);
				if(currentShowPageNo < 1 || currentShowPageNo > totalPage) {
					currentShowPageNo = 1;
				}
			} catch (NumberFormatException e) {
				currentShowPageNo = 1;
			}
		}
	    
	    startRno = ((currentShowPageNo - 1 ) * sizePerPage) + 1;
	    endRno = startRno + sizePerPage - 1;
		
	    paraMap.put("startRno", String.valueOf(startRno));
	    paraMap.put("endRno", String.valueOf(endRno));
	    
	    // 페이징 처리한 글목록 가져오기(검색어 유무 상관없이 모두 다 포함한것)
		boardList = service.noticeBoardListSearchWithPaging(paraMap);
		
		// 아래는 검색대상 컬럼과 검색어를 유지시키기 위한 것임.
		if(!"".equals(searchType) && !"".equals(searchWord)) {
			mav.addObject("paraMap", paraMap);
		}
		
		// 페이지바 만들기
		int blockSize = 3;
		int loop = 1;
		int pageNo = ((currentShowPageNo - 1)/blockSize) * blockSize + 1;
		
		String pageBar = "<ul style='list-style: none;'>";
		String url = "list.action";
		
		// === [맨처음][이전] 만들기 ===
		if(pageNo != 1) {
			pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+1+"'>[맨처음]</a></li>";
			pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+(pageNo-1)+"'>[이전]</a></li>";
		}
		
		
		while( !(loop > blockSize || pageNo > totalPage)) {
			
			if(pageNo == currentShowPageNo) {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt; border:solid 1px gray; color:red; padding:2px 4px;'>"+pageNo+"</li>";
			} else {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>";
			}
			
			
			loop++;
			pageNo++;
		}// end of while ----------
		
		// === [다음][마지막] 만들기 ===
		if(pageNo <= totalPage) {
			pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"'>[다음]</a></li>";
			pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+totalPage+"'>[마지막]</a></li>";
		}
		
		pageBar += "</ul>";
		
		mav.addObject("pageBar", pageBar);
		
		mav.addObject("boardList", boardList);
		mav.setViewName("kdn/noticeboard.gwTiles");
		
		return mav;
		
	}
	
	// === 건의사항게시판 글목록 보기 페이지 요청 ===
	@RequestMapping(value="/t1/suggestionBoard.tw")
	public ModelAndView view_suggestionBoard(ModelAndView mav) {
		
		List<BoardVOKdn> boardList = null;
		
		// == 페이징 처리를 안한 검색어가 없는 전체 글목록 보여주기 == //
		//boardList = service.boardListNoSearch();
		
		mav.addObject("boardList", boardList);
		mav.setViewName("kdn/suggestionboard.gwTiles");
		
		return mav;
		
	}

	
	// === 자유게시판 글목록 보기 페이지 요청 ===
	@RequestMapping(value="/t1/generalBoard.tw")
	public ModelAndView view_generalBoard(ModelAndView mav) {
		
		List<BoardVOKdn> boardList = null;
		
		// == 페이징 처리를 안한 검색어가 없는 전체 글목록 보여주기 == //
		//boardList = service.boardListNoSearch();
		
		mav.addObject("boardList", boardList);
		mav.setViewName("kdn/generalboard.gwTiles");
		
		return mav;
	}

	@RequestMapping(value="/t1/mydocu_receive.tw")
	public ModelAndView view_mydocureceive(ModelAndView mav) {
		
		// == 페이징 처리를 안한 검색어가 없는 전체 글목록 보여주기 == //
		//boardList = service.boardListNoSearch();
		
		mav.setViewName("kdn/mydocu_receive.gwTiles");
		
		return mav;
		
	}
	
	
	
	
	
	
}
