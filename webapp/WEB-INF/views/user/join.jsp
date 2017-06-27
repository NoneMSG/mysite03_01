<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!doctype html>
<html>
<head>
<title>mysite</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<link href="${pageContext.servletContext.contextPath }/assets/css/user.css" rel="stylesheet" type="text/css">
<script src="${pageContext.servletContext.contextPath }/assets/js/jquery/jquery-1.9.0.js"></script>
<script>

	window.addEventListener("load",function(){
			
		document.getElementById( "join-form" ).
		onsubmit = function(){
			
			
			
			//name check
			var inputName = document.getElementById( "name" );
			if(inputName.value === ""){
				alert("이름을 입력 하세요!");
				inputName.focus();
				return false;
			}
			//password check
			var passwordCheck = document.getElementById("password");
			if(passwordCheck.value===""){
				alert("비밀번호를 입력 하세요!");
				passwordCheck.focus();
				return false;
			}
			
			//email 체크
			var emailInput = document.getElementById("email");
			if(emailInput.value===""){
				alert("이메일을 입력하세요");
				emailInput.focuse();
				
				return false;
			}
			
			//email 중복 체크
			var emailValid = document.getElementById("check-button");
			if(emailValid.style.display===""){
				console.log(emailValid.style.display);
				alert("이메일 중복 체크를 하시오!");
				return false;
			}
			
			//사용자동의
			var agreeCheck = document.getElementById("agree-prov");
			if(agreeCheck.checked === false){
				alert("가입 약관에 동의 하세요!");
				agreeCheck.focus();
				return false;
			}
			
			
			return true;
		}
	
		var btnCheck = document.getElementById("check-button");
		
		btnCheck.addEventListener("click",function(){
			var email = $("#email").val();
			if(email==""){alert("email을 입력해라!");return ;}
			
			//ajax 통신 
			$.ajax( {
			    url : "/mysite03/user/api/checkemail?email="+email, //해당 페이지는 메일 체크하는 페이지에 get방식으로 데이터를 보낸다.
			    type: "get",
			    dataType: "json",
			    data: "",
			    success: function( response ){
			    		//console.log(response);
			    	if(response.data==true){
			    		alert("이미 존재하는 email 입니다.");
			    		
			    		//email 입력창에 focus
			    		document.getElementById("email").focus();
			    	}else{
			    		//alert("사용가능한 email입니다.")
			    		var img = document.getElementById("check-img");
			    		var checkbtn = document.getElementById("check-button");
			    		img.style.display="block";
			    		checkbtn.style.display="none";
			    		console.log("사용가능한 email");
			    	}
			    },
			    error: function( jqXHR, status, error ){
			       console.error( status + " : " + error );
			    }
			 });
		});
		
		
	});
	
		
</script>
</head>
<body>
	<div id="container">
		<jsp:include page="/WEB-INF/views/include/header.jsp" />
		<div id="content">
			<div id="user">
				<form:form 
				modelAttribute="userVo"
				id="join-form" 
				name="joinForm" 
				method="post" 
				action="${pageContext.servletContext.contextPath }/user/join">
				
					<label class="block-label" for="name"><spring:message code="name" text="이름" /></label>
					<input id="name" name="name" type="text" value="${userVo.name }">
					
					<spring:hasBindErrors name="userVo">
					   <c:if test="${errors.hasFieldErrors('name') }">
					  	 <p style="text-align:left; color:red">
					   		<strong>
								<spring:message 
	     						code="${errors.getFieldError( 'name' ).codes[0] }" 	
	     			     		text="${errors.getFieldError( 'name' ).defaultMessage }" />
							</strong>
					   	</p>
					   </c:if>
					</spring:hasBindErrors>

					<label class="block-label" for="email">이메일</label>
					<form:input path="email" />
					<img id="check-img" src="${pageContext.servletContext.contextPath }/assets/images/emailcheck.png" style="display:none" />
					<input id="check-button" type="button" value="id 중복체크" style="display:;" >
					<p style="color:red; padding:0; margin:0; text-align:left">
						<form:errors path="email" />
					 </p>
					
					
					<label class="block-label">패스워드</label>
					<input id="password" name="password" type="password" value="">
					
					<fieldset>
						<legend>성별</legend>
						<label>여</label> <input type="radio" name="gender" value="female" checked="checked">
						<label>남</label> <input type="radio" name="gender" value="male">
					</fieldset>
					
					<fieldset>
						<legend>약관동의</legend>
						<input id="agree-prov" type="checkbox" name="agreeProv" value="y">
						<label>서비스 약관에 동의합니다.</label>
					</fieldset>
					
					<input type="submit" value="가입하기">
					
				</form:form>
			</div>
		</div>
		<jsp:include page="/WEB-INF/views/include/navigation.jsp" />
		<jsp:include page="/WEB-INF/views/include/footer.jsp" />
	</div>
</body>
</html>