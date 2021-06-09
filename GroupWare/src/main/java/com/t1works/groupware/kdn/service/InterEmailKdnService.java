package com.t1works.groupware.kdn.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.t1works.groupware.kdn.model.EmailKdnVO;

@Repository
public interface InterEmailKdnService {

	List<String> getEmailList(); // 이메일주소 자동완성을 위한 주소록 가져오기

	int send(EmailKdnVO evo); // 파일 첨부가 없는 이메일 쓰기

	int sendWithFile(EmailKdnVO evo); // 파일 첨부가 있는 이메일 쓰기

	int getTotalCount(Map<String, String> paraMap); // 총 이메일 건수 구해오기

	List<EmailKdnVO> emailListSearchWithPaging(Map<String, String> paraMap); // 페이징 처리한 이메일목록 가져오기(검색어 유무 상관없이 모두 다 포함한것)

	EmailKdnVO getView(Map<String, String> paraMap); // 이메일 열람하기

}