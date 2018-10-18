<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>easyui-datagrid-数据表格</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/easyui/themes/icon.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.8.3.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/locale/easyui-lang-zh_CN.js"></script>
</head>
<body>
	<h1>将简单的html的表格转换成datagrid</h1>
	<table class="easyui-datagrid">
		<thead>
			<tr>
				<th data-options="field:'id'">编号</th>
				<th data-options="field:'name'">姓名</th>
				<th data-options="field:'telephone'">电话</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>1</td>
				<td>马容</td>
				<td>13838389438</td>
			</tr>
			<tr>
				<td>2</td>
				<td>宋吉吉</td>
				<td>13838389438</td>
			</tr>
		</tbody>
	</table>
	<h1>基于ajax请求加载datagrid数据</h1>
	<table class="easyui-datagrid" data-options="url:'${pageContext.request.contextPath}/data/courier.json'">
		<thead>
			<tr>
				<th data-options="field:'id'">编号</th>
				<th data-options="field:'name'">姓名</th>
				<th data-options="field:'telephone'">电话</th>
			</tr>
		</thead>
	</table>
	<h1>基于api动态构建datagrid表格</h1>
	<table id="grid"></table>
	<script type="text/javascript">
	$(function(){
		$('#grid').datagrid({
			url:'${pageContext.request.contextPath}/data/courier.json',
			columns:[[
			         {title:'编号', field:'id', checkbox:true},
			         {title:'姓名', field:'name'},
			         {title:'电话', field:'telephone'}
			         ]],//列属性，二维数组
			toolbar:[
			         {text:'增加',iconCls:'icon-add',handler:function(){
			        	 alert(1);
			         }},
			         {text:'修改'},
			         {text:'作废'},
			         {text:'还原'}
			         ],//工具条，一位数组
			pagination:true,//开启分页查询条
			pageList:[10,50,100]//设置每页显示条数选项
		});
	});
	</script>
</body>
</html>