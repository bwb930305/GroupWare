package com.t1works.groupware.kdn.model;

import java.util.List;

public interface InterBoardDAOKdn {

	// === 공지사항 글쓰기 ===
	int noticePostUpload(BoardVOKdn boardvo);

	// 페이징 처리를 안한 검색어가 없는 전체 글목록 보여주기
	//List<BoardVOKdn> boardListNoSearch();

}