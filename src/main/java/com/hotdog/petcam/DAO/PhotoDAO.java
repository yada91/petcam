package com.hotdog.petcam.DAO;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.hotdog.petcam.vo.Photo;

@Repository
public class PhotoDAO {

	@Autowired
	private SqlSession sqlSession;

	public void insert(Photo vo) {
		sqlSession.insert("photo.insert", vo);
	}

	public Photo selectByNo(Long no) {
		Photo vo = sqlSession.selectOne("photo.selectByNo", no);
		return vo;
	}

	public List<Photo> selectAll() {
		List<Photo> list = sqlSession.selectList("photo.selectAll");
		return list;
	}

	public void delete(Photo vo) {
		sqlSession.delete("photo.deleteByNo", vo);
	}
}
