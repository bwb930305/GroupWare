package com.t1works.groupware.hsy.model;

public class MemberHsyVO {

	private String employeeid;     // 사번
	private String fk_dcode; 	   // 부서코드
	private String fk_pcode;	   // 직급코드
	private String name;           // 직원명
	private String passwd;		   // 비밀번호
	private String email;   	   // 회사이메일
	private String mobile;   	   // 연락처
	private String cmobile;  	   // 회사연락처
	private String jubun;   	   // 주민번호
	private String hiredate;  	   // 입사일자
	private String status;  	   // 재직상태 (0:재직중 , 1:퇴사)
	private String managerid;  	   // 직속상사사번
	private String fileName;       // 직원이미지 업로드된 파일명
	
	
	// select용 변수 생성
	private String pname;         		// 직위명
	private String dname;         		// 부서명
	private String duty;          		// 직무
	private String salary;        		// 기본급
	private String commissionpercase; 	// 건당 성과금
	
	
	public String getEmployeeid() {
		return employeeid;
	}
	public void setEmployeeid(String employeeid) {
		this.employeeid = employeeid;
	}
	
	public String getFk_dcode() {
		return fk_dcode;
	}
	public void setFk_dcode(String fk_dcode) {
		this.fk_dcode = fk_dcode;
	}
	
	public String getFk_pcode() {
		return fk_pcode;
	}
	public void setFk_pcode(String fk_pcode) {
		this.fk_pcode = fk_pcode;
	}
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	public String getPasswd() {
		return passwd;
	}
	public void setPasswd(String passwd) {
		this.passwd = passwd;
	}
	
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	
	public String getMobile() {
		return mobile;
	}
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	
	public String getCmobile() {
		return cmobile;
	}
	public void setCmobile(String cmobile) {
		this.cmobile = cmobile;
	}
	
	public String getJubun() {
		return jubun;
	}
	public void setJubun(String jubun) {
		this.jubun = jubun;
	}
	
	public String getHiredate() {
		return hiredate;
	}
	public void setHiredate(String hiredate) {
		this.hiredate = hiredate;
	}
	
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	
	public String getManagerid() {
		return managerid;
	}
	public void setManagerid(String managerid) {
		this.managerid = managerid;
	}
	
	public String getPname() {
		return pname;
	}
	public void setPname(String pname) {
		this.pname = pname;
	}
	
	public String getDname() {
		return dname;
	}
	public void setDname(String dname) {
		this.dname = dname;
	}
	
	public String getDuty() {
		return duty;
	}
	public void setDuty(String duty) {
		this.duty = duty;
	}
	
	public String getSalary() {
		return salary;
	}
	public void setSalary(String salary) {
		this.salary = salary;
	}
	
	public String getCommissionpercase() {
		return commissionpercase;
	}
	public void setCommissionpercase(String commissionpercase) {
		this.commissionpercase = commissionpercase;
	}
	
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	
	
	
}
