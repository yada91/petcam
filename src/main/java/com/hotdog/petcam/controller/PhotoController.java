package com.hotdog.petcam.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.hotdog.petcam.service.PhotoService;
import com.hotdog.petcam.vo.Photo;
import com.hotdog.petcam.vo.Users;
import com.hotdog.security.Auth;
import com.hotdog.security.AuthUser;

@Controller
@RequestMapping("/photo")
public class PhotoController {

	@Autowired
	private PhotoService photoService;

	@RequestMapping("")
	public String main(Model model) {
		List<Photo> list = photoService.selectAll();
		model.addAttribute("list", list);
		return "photo/index";
	}

	@Auth
	@RequestMapping(value = "/upload", method = RequestMethod.POST)
	public String upload(@RequestParam("file") MultipartFile file, @RequestParam("comments") String comments,
			Model model, @AuthUser Users authUser) {
		System.out.println(authUser);
		photoService.restore(file, comments, authUser.getNo());
		return "redirect:/photo";
	}

	@RequestMapping("/view")
	public String view(@RequestParam("no") Long no, Model model) {
		Photo vo = photoService.selectByNo(no);
		model.addAttribute("vo", vo);
		return "photo/view";
	}

	@RequestMapping("/delete")
	public String delete(@ModelAttribute Photo vo, Model model) {
		photoService.delete(vo);
		return "redirect:/photo";
	}

}
