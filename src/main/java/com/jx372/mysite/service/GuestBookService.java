package com.jx372.mysite.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.jx372.mysite.repository.GuestbookDao;
import com.jx372.mysite.vo.GuestbookVo;

@Service
public class GuestBookService {
	
	@Autowired
	private GuestbookDao gbDao;
	
	public List<GuestbookVo> getList() {
		return gbDao.getList();
	}
	public List<GuestbookVo> getList(Long startNo) {
		return gbDao.getList(startNo);
	}
	public boolean delete(GuestbookVo gbVo){
		  
		return 1==gbDao.delete(gbVo);
	}
	
	public int writeMessage(GuestbookVo vo){
		int result = gbDao.insert(vo);
		System.out.println(vo);
		return result;
	}

}
