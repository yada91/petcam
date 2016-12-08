package com.hotdog.petcam.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.hotdog.petcam.DAO.UsersDAO;
import com.hotdog.petcam.vo.Users;

@Service
public class UsersService {

	@Autowired
	private UsersDAO usersDAO;

	public void join(Users vo) {
		usersDAO.insert(vo);
	}

	public Users login(String id, String password) {
		Users userVo = null;

		userVo = usersDAO.selectNo(id, password);

		return userVo;
	}

	public Users getUser(Long no) {
		Users userVo = usersDAO.selectNo(no);

		return userVo;
	}

	public void modify(Users vo) {
		usersDAO.update(vo);
	}

	public boolean idExists(String id) {

		return (usersDAO.selectNo(id) != null);

	}
}
