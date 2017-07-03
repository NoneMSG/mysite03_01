<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>mysite</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/assets/css/guestbook-ajax.css"
	rel="stylesheet" type="text/css">
<link rel="stylesheet"
	href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<style type="text/css">
.ui-dialog .ui-dialog-buttonpane .ui-dialog-buttonset {
	float: none;
	text-align: center;
}

.ui-dialog .ui-dialog-buttonpane button {
	margin-left: 10px;
	margin-right: 1;
}

#dialog-message p {
	padding: 20px 0;
	font-weight: bold;
	font-size: 1.0em
}

#dialog-delete-form p {
	padding: 10px;
	font-weight: bold;
	font-size: 1.0em
}

#dialog-delete-form input[type="password"] {
	padding: 5px;
	border: 1px solid #888;
	outline: none;
	width: 180;
}

.validateTips error{
	color: 0ff;
}

</style>
<script type="text/javascript"
	src="${pageContext.request.contextPath }/assets/js/jquery/jquery-1.9.0.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script type="text/javascript">

var isEnd = false;

var MessageBox = function(title, message, callback){
	 $("#dialog-message").attr("title", title);
	 $("#dialog-message p ").text(message);
	 $( "#dialog-message" ).dialog({
		 modal:true,
		 buttons:{
			 Ok: function(){
				 $(this).dialog("close");
			 }
		 },
	 	close: callback || function(){}
	 });
}

var render =function(vo, mode){
	
	//정규표현식 /\n/gi :global ignore case
	//상용 app에선 templete 라이브러리 사용 ex) ejs 
	var html=
		"<li data-no='"+vo.no+"'>"+
		"<strong>"+ vo.name +"</strong>"+
		"<p>"+vo.message.replace( /\n/gi, "<br>")+"</p>"+
		"<a href='' data-no='"+vo.no+"'>삭제</a>"+
		"</li>";
		
		if( mode === true ) {
			$( "#list-guestbook" ).prepend( html );	
		} else {
			$( "#list-guestbook" ).append( html );
		}
}

var fetchList = function(){
	if(isEnd===true){
		return;
	}
	var startNo = 
		$("#list-guestbook li").last().data("no") || 0; //data값이 null이라면 0으로 세팅하는 논리연산
		
		$.ajax({
			url: "${pageContext.request.contextPath}/guestbook/api/list?sno="+startNo,
			type:"get",
			dataType: "json",
			data:"",
			success : function(response){
				if(response.result==="fail"){
					console.error(response.message);
					return;
					}
				
					//detect end
					if(response.data.length < 5){
						isEnd=true;
						$("#btn-next").prop("disabled",true);
						$("#btn-next").hide();
					}
				
					//rendering
					$.each(response.data, function(index, vo){
						render( vo, false );
					});
				},
			 error : function(jqXHR,status,e){
					console.log(status+":"+e);
					}
		});
}
//DOM이 올라오고 나서 실행되는 자바스크립트
	$(function(){
		
		var dialogDelete = $( "#dialog-delete-form" ).dialog({
		      autoOpen: false,
		      height: 170,
		      width: 250,
		      modal: true,
		      buttons: {
		        
		    	  "Delete": function(){
		    		  
		        	var no = $("#delete-no").val();
		        	var password = $("#delete-password").val();
		        	
		        	//console.log(no+":"+password);
		        	
		        	
		        	//delete ajax 
		        	$.ajax({
		    			url: "${pageContext.request.contextPath}/guestbook/api/delete",
		    			type:"post",
		    			dataType: "json",
		    			data:"no="+no+"&"+
		    				"password="+password,
		    			success : function(response){
		    				if(response.result==="fail"){
		    					console.error(response.message);
		    					return;
		    					}
		    					console.log(response.data);
		    					
		    					//삭제실패
		    					if(response.data===-1){
		    						$("#dialog-delete-form .validateTips.normal").hide();
		    						$("#dialog-delete-form .validateTips.error").show();
		    						$("#delete-password").val("");
		    						return ;
		    					}	
		    					
		    					//삭제성공
		    					$( "#list-guestbook li[data-no='" + response.data + "']" ).remove();
		    					$("#delete-password").val("");
								dialogDelete.dialog( "close" );
		    					 
		    				},
		    				error : function(jqXHR,status,e){
		    					console.log(status+":"+e);
		    				}
		    		});
		        	
		        },
		   	    "Cancel" : function() {
		   	    	$("#delete-password").val("");
		   	    	$("#dialog-delete-form .validateTips.error").hide();
		   	    	$("#dialog-delete-form .validateTips.normal").show();
		   	    	dialogDelete.dialog( "close" );
		        }
		      },
		     close: function() {
			  }
	    });
		
		
		//live event,,, li a(삭제버튼)은 리스트를 불러오기 전에 생성되자 않기 때문에 후 처리를 해주어야함
		$(document).on("click", "#list-guestbook li a", function(event){
			event.preventDefault();
			var no = $(this).data("no");
			$("#delete-no").val(no);
			dialogDelete.dialog("open");
			//console.log( no );
		})
		
		$("#add-form").submit(function(event){
			//submit event 기본 동작 정지 posting을 막음
			event.preventDefault();
			
			var vo ={
				
			};
			
			//form data validation
			vo.name = $("#input-name").val();
			if(vo.name===""){
				MessageBox("방명록 글 입력","이름은 필수 입력항목",
						function(){
					$("#input-name").focus();
				});
				return ;
			}
			
			vo.password = $("#input-password").val();
			if(vo.password===""){
				MessageBox("메시지 입력","비밀번호는 필수 입력항목",
						function(){
					$("#input-password").focus();
				});
				return ;
			}
			
			vo.message = $("#ta-message").val();
			if(vo.message===""){
				MessageBox("메시지 입력","내용은 필수 입력항목",
						function(){
					$("#ta-message").focus();
				});
				return ;
			}
			
			//방명록 메시지 입력 ajax통신 
			console.log($.param(vo)); //query string
			console.log(JSON.stringify(vo));
			$.ajax( {
				url : "${pageContext.request.contextPath }/guestbook/api/add",
				type: "post",
				dataType: "json",
				//data: $.param(vo),
				data: JSON.stringify(vo),
				contentType: 'application/json', //JSON Type으로 데이터를 보낼 때,
				success: function( response ){
					if( response.result === "fail" ) {
						console.error( response.message );
						return;
					}
					
					// rendering
					render( response.data, true );
					
					// reset form
					$( "#add-form" )[0].reset();
				},
				error: function( jqXHR, status, e ){
					console.error( status + " : " + e );
				}
			} );		
		});
		
		$(window).scroll(function(){
			var $window =$(this);
			var scrollTop = $window.scrollTop();
			var windowHeight = $window.height();
			var documentHeight = $(document).height();
			
			//scrollbar thumb가 바닥전 10px 까지 왔을 때
			if(scrollTop+windowHeight+10>documentHeight){
				fetchList();
			}
		});
		
		//최초 리스트 가져오기
		fetchList();
		
		$("#btn-next").click(function(){
				fetchList();
			});
	});


	
</script>

</head>
<body>
	<div id="container">
		<c:import url="/WEB-INF/views/include/header.jsp" />
		<div id="content">
			<div id="dialog-message" title="방명록에 글 남기기" style="display: none">
				<p>빈 양식이 있습니다.</p>
			</div>
			<div id="guestbook">
				<h1>방명록</h1>
				<form id="add-form" action="#" method="post">
					<input type="text" id="input-name" placeholder="이름"> <input
						type="password" id="input-password" placeholder="비밀번호">
					<textarea id="ta-message" placeholder="내용을 입력해 주세요."></textarea>
					<input type="submit" value="보내기" />
				</form>
				<ul id="list-guestbook"></ul>
				<div style="margin: 15px 0; text-align: center">
					<button id="btn-next" style="padding: 10px 20px">next</button>
				</div>
			</div>

			<div id="dialog-delete-form" title="Message remove"
				style="display: none">
				<p class="validateTips normal">Input the password</p>
				<p class="validateTips error" style="display:none">비밀번호 틀림</p>
				<form>
					<input type="hidden" name="no" id="delete-no" value="" /> <input
						type="password" name="password" id="delete-password" value=""
						class="text ui-widget-content ui-corner-all">
					<!-- Allow form submission with keyboard without duplicating the dialog button -->
					<input type="submit" tabindex="-1"
						style="position: absolute; top: -1000px">
				</form>
			</div>

		</div>
		<c:import url="/WEB-INF/views/include/navigation.jsp">
			<c:param name="menu" value="guestbook-ajax" />
		</c:import>
		<c:import url="/WEB-INF/views/include/footer.jsp" />
	</div>
</body>
</html>