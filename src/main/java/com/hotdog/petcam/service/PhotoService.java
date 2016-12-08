package com.hotdog.petcam.service;

import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Calendar;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.hotdog.petcam.DAO.PhotoDAO;
import com.hotdog.petcam.vo.Photo;

@Service
public class PhotoService {

	@Autowired
	private PhotoDAO photoDAO;

	private static final String SAVE_PATH = "c:\\upload";
	private static final String URL = "/photo/assets/";

	public void insert(Photo vo) {
		photoDAO.insert(vo);
	}

	public void delete(Photo vo) {
		photoDAO.delete(vo);
	}

	public List<Photo> selectAll() {

		List<Photo> list = photoDAO.selectAll();

		return list;
	}

	public Photo selectByNo(Long no) {

		Photo vo = photoDAO.selectByNo(no);

		return vo;
	}

	public String restore(MultipartFile file, String comments, Long usersNo) {
		String url = "";
		try {
			if (file.isEmpty() == true) {
				return url;
			}

			String orgFileName = file.getOriginalFilename();
			String extName = orgFileName.substring(orgFileName.lastIndexOf('.') + 1);
			String saveFileName = generateSaveFileName(extName);
			Long fileSize = file.getSize();

			Photo vo = new Photo();
			vo.setOrgFileName(orgFileName);
			vo.setSaveFileName(saveFileName);
			vo.setFileSize(fileSize);
			vo.setExtName(extName);
			vo.setComments(comments);
			vo.setUsersNo(usersNo);

			System.out.println(vo);
			insert(vo);

			writeFile(file, saveFileName);
			url = URL + saveFileName;
		} catch (IOException e) {

		}

		return url;
	}

	private String generateSaveFileName(String extName) {
		String fileName = "";
		Calendar calendar = Calendar.getInstance();
		fileName += calendar.get(Calendar.YEAR);
		fileName += calendar.get(Calendar.MONTH);
		fileName += calendar.get(Calendar.DATE);
		fileName += calendar.get(Calendar.HOUR);
		fileName += calendar.get(Calendar.MINUTE);
		fileName += calendar.get(Calendar.SECOND);
		fileName += calendar.get(Calendar.MILLISECOND);
		fileName += "." + extName;
		return fileName;
	}

	private void writeFile(MultipartFile file, String saveFileName) throws IOException {
		byte[] fileData = file.getBytes();
		FileOutputStream fos = new FileOutputStream(SAVE_PATH + "/" + saveFileName);
		fos.write(fileData);
		fos.close();
	}
}
