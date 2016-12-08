package com.hotdog.petcam.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.hotdog.petcam.DTO.JSONResult;
import com.hotdog.petcam.service.PhotoService;
import com.hotdog.petcam.vo.Photo;
import com.hotdog.petcam.vo.Users;
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

	@ResponseBody
	@RequestMapping(value = "/upload", method = RequestMethod.POST)
	public JSONResult upload(@RequestParam("file") MultipartFile file, @RequestParam("comments") String comments,
			Model model, @AuthUser Users authUser) {
		String saveFileName = photoService.restore(file, comments, authUser.getNo());
		return JSONResult.success(saveFileName);
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
