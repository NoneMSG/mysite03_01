package com.jx372.mysite.repository;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.util.StopWatch;

import com.jx372.mysite.vo.GuestbookVo;

@Repository
public class GuestbookDao {
	
	@Autowired
	private SqlSession sqlSession;
	
	//web
	public List<GuestbookVo> getList() {
		List<GuestbookVo> list = sqlSession.selectList("guestbook.getList");
	
		return list;
	}
	
	//ajax
	public List<GuestbookVo> getList(Long startNo) {
		List<GuestbookVo> list = sqlSession.selectList("guestbook.getListByNo",startNo);
		return list;
	}
	
	public int delete( GuestbookVo vo ) {
		int count = sqlSession.delete("guestbook.delete",vo); //객체를 하나밖에 넘길 수 없다.
		return count;
	}

	public int insert( GuestbookVo vo ) {
		
		return sqlSession.insert("guestbook.insert", vo);
	}
}
