<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>easyui-messager-消息框</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/easyui/themes/icon.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.8.3.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/locale/easyui-lang-zh_CN.js"></script>
</head>
<body>
	<script type="text/javascript">
		//1.messager简单提示框：alert()
		//参数1：标题，参数2：提示内容，参数3：级别，info、warning、error
		/* $.messager.alert('提示信息','上课别走神儿！','error'); */
		//2.messager确认框：confirm()
		//参数1：标题，参数2：确认内容，参数3：回调函数，可以获取点击的按钮,r==true，点击确定；r==false，点击取消
		/* $.messager.confirm('确认信息','你确定要上课走神儿么？',function(r){
			alert(r);
		}); */
		//3.messager欢迎框：show()
		window.setTimeout(function(){
			$.messager.show({
				title:'欢迎框',
				msg:'欢迎某某登录系统！',
				timeout:3000,
				showType:'show'
			});
		},3000);
	</script>
</body>
</html>