package com.jx372.mysite.exception;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jx372.mysite.dto.JsonResult;


@ControllerAdvice
public class GlobalExceptionHandler {

	@ExceptionHandler(Exception.class )
	public void handleException(
			HttpServletRequest  request,
			HttpServletResponse response,
			Exception e)throws IOException, ServletException{
		
		//1.로깅
		StringWriter errors = new StringWriter();
		e.printStackTrace(new PrintWriter(errors));
		
		//2. 요청 종류 알아내기
		String accept = request.getHeader("accept");
		System.out.println(accept);
		
		//3.응답
		if(accept.matches(".*application/json.*")==true ){
			//json 요청(Ajax request, xmlHttpRequest)
			response.setStatus(HttpServletResponse.SC_OK);
			
			JsonResult jsonResult = JsonResult.error(errors.toString());
			
			String jsonString = new ObjectMapper().writeValueAsString(jsonResult);
			response.setContentType("application/json; charset=utf-8");
			PrintWriter out = response.getWriter();
			out.print(jsonString);
		}else{
			//web request(html, image, xml, js, css...)
			
//			ModelAndView mav = new ModelAndView();
//			mav.addObject( "uri", request.getRequestURI() );
//			mav.addObject( "exception", errors.toString() );
//			mav.setViewName( "error/exception" );
			
			//string이나 json등으로 리턴이 불가능하기 때문에 jsp로 직접응답 하는 함수를 사용한다.
			request.setAttribute("uri", request.getRequestURI());
			request.setAttribute("exception", errors.toString());
			request.getRequestDispatcher("/WEB-INF/views/error/exception.jsp").forward(request, response);//view resolver가 돌지 않는다.
		}
		
		
		
	}
}
