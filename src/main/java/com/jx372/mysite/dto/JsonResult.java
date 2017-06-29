package com.jx372.mysite.dto;

public class JsonResult {
	private String result; // "success" , "fail"
	private String message; //result가 "fail"시 원인
	private Object data; //result가 "success"일 때 전달해야 할 데이터
	
	private JsonResult(String result, String message, Object data){
		this.result = result;
		this.message = message;
		this.data = data;
	}
	
	public static JsonResult error(String message){
		return new JsonResult("fail", message, null);
	}
	public static JsonResult success(Object data){
		return new JsonResult("success", null, data);
	}

	public final String getResult() {
		return result;
	}

	public final String getMessage() {
		return message;
	}

	public final Object getData() {
		return data;
	}
	
	
}
