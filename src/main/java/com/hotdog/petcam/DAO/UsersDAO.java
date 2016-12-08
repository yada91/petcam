package com.hotdog.petcam.DAO;

import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.hotdog.petcam.vo.Users;

@Repository
public class UsersDAO {

	@Autowired
	private SqlSession sqlSession;

	public void insert(Users users) {
		sqlSession.insert("users.insert", users);
	}

	// 로그인시
	public Users selectNo(String id, String password) {

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);
		map.put("password", password);
		Users users = sqlSession.selectOne("users.getByIdAndPassword", map);
		return users;

	}

	public Users selectNo(Long no) {
		Users users = sqlSession.selectOne("users.getByNo", no);
		return users;
	}

	public Users selectNo(String id) {
		Users users = sqlSession.selectOne("users.getById", id);
		return users;
	}

	public void update(Users users) {
		sqlSession.update("users.update", users);
	}
}
