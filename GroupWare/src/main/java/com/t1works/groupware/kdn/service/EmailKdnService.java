package com.t1works.groupware.kdn.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.t1works.groupware.common.FileManager;
import com.t1works.groupware.kdn.model.EmailKdnVO;
import com.t1works.groupware.kdn.model.InterEmailKdnDAO;

@Component
@Service
public class EmailKdnService implements InterEmailKdnService {

	@Autowired
	private InterEmailKdnDAO dao;
	
	@Autowired     // Type에 따라 알아서 Bean 을 주입해준다.
	private FileManager fileManager;
	
	// 이메일주소 자동완성을 위한 주소록 가져오기
	@Override
	public List<String> getEmailList() {
		List<String> emailList = dao.getEmailList();
		return emailList;
	}

	// 파일 첨부가 없는 이메일 쓰기
	@Override
	public int send(EmailKdnVO evo, String checkSaveSentMail) {
		
		if(evo.getParentSeq() == null || evo.getParentSeq().trim().isEmpty() ) {
			// 원글쓰기 이라면 groupno 컬럼의 값은 groupno 컬럼의 최대값(max)+1 로 해야 한다. 
			int groupno = dao.getGroupnoMax() + 1;
			evo.setGroupno(String.valueOf(groupno));
		}
		
		int newSeq = dao.getNewSeq();
		evo.setSeq(String.valueOf(newSeq));
		
		int n= 0, result=0;
		
		if(checkSaveSentMail.equals("1")) {
			n = dao.send(evo);	// tbl_mailinbox 테이블에 insert
			if(n==1) {
				result = dao.saveSentMail(evo); // tbl_sentmail 테이블에 insert
			}
		} else {
			result = dao.send(evo);
		}
		
		return result;
	}

	// 파일 첨부가 있는 이메일 쓰기
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public int sendWithFile(EmailKdnVO evo, String checkSaveSentMail) {
		
		// == 원글쓰기인지 , 답변글쓰기인지 구분하기 == 
		if(evo.getParentSeq() == null || evo.getParentSeq().trim().isEmpty() ) {
			// 원글쓰기 이라면 groupno 컬럼의 값은 groupno 컬럼의 최대값(max)+1 로 해야 한다. 
			int groupno = dao.getGroupnoMax() + 1;
			evo.setGroupno(String.valueOf(groupno));
		}
		
		int newSeq = dao.getNewSeq();
		evo.setSeq(String.valueOf(newSeq));
		
		int n= 0, result=0;
		
		if(checkSaveSentMail.equals("1")) {
			n = dao.sendWithFile(evo);	//첨부파일이 있는 경우. tbl_mailinbox 테이블에 insert
			if(n==1) {
				result = dao.saveSentMailwithAttach(evo); //첨부파일이 있는 경우. tbl_sentmail 테이블에 insert
			}
		} else {
			result = dao.sendWithFile(evo);
		}
		
		return result;
	}

	// 받은메일함 총 이메일 건수 구해오기
	@Override
	public int getTotalCount(Map<String, String> paraMap) {
		int n = dao.getTotalCount(paraMap);
		return n;
	}

	// 페이징 처리한 이메일목록 가져오기(검색어 유무 상관없이 모두 다 포함한것)
	@Override
	public List<EmailKdnVO> emailListSearchWithPaging(Map<String, String> paraMap) {
		List<EmailKdnVO> emailList = dao.emailListSearchWithPaging(paraMap);
		return emailList;
	}

	// 이메일 열람하기
	@Override
	public EmailKdnVO getView(Map<String, String> paraMap) {
		EmailKdnVO evo = dao.getView(paraMap);
		return evo;
	}

	// 보낸메일함 총 이메일 건수 구해오기
	@Override
	public int getMailSentTotalCount(Map<String, String> paraMap) {
		int n = dao.getMailSentTotalCount(paraMap);
		return n;
	}

	// 중요메일함 총 이메일 건수 구해오기
	@Override
	public int getMailImportantTotalCount(Map<String, String> paraMap) {
		int n = dao.getMailImportantTotalCount(paraMap);
		return n;
	}

	// 보낸메일함의 이메일 열람하기
	@Override
	public EmailKdnVO getSentMailView(Map<String, String> paraMap) {
		EmailKdnVO evo = dao.getSentMailView(paraMap);
		return evo;
	}

	// 중요메일함의 이메일 열람하기
	@Override
	public EmailKdnVO getImportantMailView(Map<String, String> paraMap) {
		EmailKdnVO evo = dao.getImportantMailView(paraMap);
		return evo;
	}

	// 보낸메일함 페이징 처리한 이메일목록 가져오기(검색어 유무 상관없이 모두 다 포함한것)
	@Override
	public List<EmailKdnVO> sentEmailListSearchWithPaging(Map<String, String> paraMap) {
		List<EmailKdnVO> emailList = dao.sentEmailListSearchWithPaging(paraMap);
		return emailList;
	}

	// 받은메일함의 메일을 휴지통 이동없이 완전삭제 완료하기 
	@Override
	public int delImmed(List<String> emailSeqList) {
		int n = dao.delImmed(emailSeqList);
		return n;
	}

	// 받은메일함의 메일을 삭제하기 
	@Override
	public int delSentMail(List<String> emailSeqList) {
		int n = dao.delSentMail(emailSeqList);
		return n;
	}

	// 중요메일함 메일 삭제(중요표시 해제), 받은메일함의 메일 중요표시해제
	@Override
	public int removeStar(List<String> emailSeqList) {
		int n = dao.removeStar(emailSeqList);
		return n;
	}

	// 받은메일함의 메일 중요표시하기
	@Override
	public int addStar(List<String> emailSeqList) {
		int n = dao.addStar(emailSeqList);
		return n;
	}

	// 받은메일함의 메일 휴지통으로 이동하기
	@Override
	public int moveToTrash(List<String> emailSeqList) {
		int n = dao.moveToTrash(emailSeqList);
		return n;
	}

	// 휴지통 총 이메일 건수 구해오기
	@Override
	public int getTrashTotalCount(Map<String, String> paraMap) {
		int n = dao.getTrashTotalCount(paraMap);
		return n;
	}

	// 휴지통 페이징 처리한 이메일목록 가져오기(검색어 유무 상관없이 모두 다 포함한것)
	@Override
	public List<EmailKdnVO> trashListSearchWithPaging(Map<String, String> paraMap) {
		List<EmailKdnVO> emailList = dao.trashListSearchWithPaging(paraMap);
		return emailList;
	}

	// 휴지통 메일을 받은메일함으로 이동시키기
	@Override
	public int moveToMailInbox(List<String> emailSeqList) {
		int n = dao.moveToMailInbox(emailSeqList);
		return n;
	}


}
