package com.hotdog.petcam.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.hotdog.petcam.service.UsersService;
import com.hotdog.petcam.vo.Users;

@Controller
@RequestMapping("/users")
public class UsersController {
	@Autowired
	private UsersService usersService;

	@RequestMapping("/loginform")
	public String loginForm() {
		return "users/loginform";
	}

	@RequestMapping(value = "/join", method = RequestMethod.GET)
	public String join() {
		return "users/joinform";
	}

	@RequestMapping(value = "/join", method = RequestMethod.POST)
	public String join(@ModelAttribute Users vo) {
		usersService.join(vo);
		return "users/joinsuccess";
	}
}
