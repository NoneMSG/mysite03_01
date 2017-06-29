package com.jx372.mysite.controller.api;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.jx372.mysite.dto.JsonResult;
import com.jx372.mysite.service.GuestBookService;
import com.jx372.mysite.vo.GuestbookVo;

@Controller("guestbookApiController")
@RequestMapping("/guestbook/api")
public class GuestbookController {
	
	@Autowired
	private GuestBookService guestbookService;
	
	@ResponseBody
	@RequestMapping("/list")
	public JsonResult list(@RequestParam(value="sno", required=true, defaultValue="0")Long startNo){
		List<GuestbookVo> list = guestbookService.getList(startNo);
		return JsonResult.success(list);
	}
}
