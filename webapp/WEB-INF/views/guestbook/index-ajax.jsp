<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%> 
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>mysite</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="${pageContext.request.contextPath }/assets/css/guestbook-ajax.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script type="text/javascript" src="${pageContext.request.contextPath }/assets/js/jquery/jquery-1.9.0.js"></script>
<script type="text/javascript">

var render =function(vo){
	
	//정규표현식 /\n/gi :global ignore case
	//상용 app에선 templete 라이브러리 사용 ex) ejs 
	var html=
		"<li data-no='"+vo.no+"'>"+
		"<strong>"+ vo.name +"</strong>"+
		"<p>"+vo.message.replace( /\n/gi, "<br>")+"</p>"+
		"<a href='' data-no='"+vo.no+"'>삭제</a>"+
		"</li>";
		$("#list-guestbook").append(html);
}

	$(function(){
		
		$("#btn-next").click(function(){
				$.ajax({
					url: "${pageContext.request.contextPath}/guestbook/api/list?sno=0",
					type:"get",
					dataType: "json",
					data:"",
					success : function(response){
						if(response.result==="fail"){
							console.error(response.message);
							return;
							}
							//rendering
							$.each(response.data, function(index, vo){
								render(vo);
							});
						},
						error : function(jqXHR,status,e){
							console.log(status+":"+e);
							}
				});
			});
		});

	
</script>

</head>
<body>
	<div id="container">
		<c:import url="/WEB-INF/views/include/header.jsp" />
		<div id="content">
			<div id="guestbook">
				<h1>방명록</h1>
				<form id="add-form" action="#" method="post">
					<input type="text" id="input-name" placeholder="이름">
					<input type="password" id="input-password" placeholder="비밀번호">
					<textarea id="tx-content" placeholder="내용을 입력해 주세요."></textarea>
					<input type="submit" value="보내기" />
				</form>
				<ul id="list-guestbook">
				</ul>
					<div style="margin:15px 0; text-align: center">
						<button id="btn-next" style="padding:10px 20px; font-size: 1.5em">next</button>
					</div>
			</div>						
		</div>
		<c:import url="/WEB-INF/views/include/navigation.jsp">
			<c:param name="menu" value="guestbook-ajax"/>
		</c:import>
		<c:import url="/WEB-INF/views/include/footer.jsp" />
	</div>
</body>
</html>