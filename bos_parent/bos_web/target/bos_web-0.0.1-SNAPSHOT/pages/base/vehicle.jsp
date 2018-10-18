<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta charset="UTF-8">
		<title>班车管理</title>
		<!-- 导入jquery核心类库 -->
		<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.8.3.js"></script>
		<!-- 导入easyui类库 -->
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/easyui/themes/default/easyui.css">
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/easyui/themes/icon.css">
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/easyui/ext/portal.css">
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/default.css">
		<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/jquery.easyui.min.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/ext/jquery.portal.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/ext/jquery.cookie.js"></script>
		<script src="${pageContext.request.contextPath}/js/easyui/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
		<script type="text/javascript">
			function doAdd(){
				$('#vehicleWindow').window('open');
			}
			$(function(){
				// 先将body隐藏，再显示，不会出现页面刷新效果
				$("body").css({visibility:"visible"});
				
				// 班车信息表格
				$('#grid').datagrid( {
					iconCls : 'icon-forward',
					fit : true,
					border : false,
					rownumbers : true,
					striped : true,
					pageList: [30,50,100],
					pagination : true,
					toolbar : toolbar,
					url : "${pageContext.request.contextPath}/vehicleAction_pageQuery.action",
					idField : 'id',
					columns : columns
				});
				// 添加取派员窗口
				$('#vehicleWindow').window({
			        title: '添加班车',
			        width: 800,
			        modal: true,
			        shadow: true,
			        closed: true,//将窗口设置为默认关闭
			        height: 400,
			        resizable:false
			    });
			});	
			
			//工具栏
			var toolbar = [
			   {
				id : 'button-add',
				text : '增加',
				iconCls : 'icon-add',
				handler : doAdd
			}, {
				id : 'button-edit',
				text : '修改',
				iconCls : 'icon-edit',
				handler : function(){
					//1.获取客户选中的数据
					var rows = $('#grid').datagrid('getSelections');
					if(rows.length == 0){
						//2.未选中或者选择了多条，提示客户只能选择一条
						$.messager.alert('提示信息','请选择一条数据！','warning');
					} 
					if(rows.length > 1){
						$.messager.alert('提示信息','一次只能修改一条数据','warning');
					}
					if(rows.length == 1){
						//3.选中一条，打开修改窗口
						$('#vehicleWindow').window('open');
						//4.回显要修改的数据
						$('#addVehicleForm').form('load',rows[0]);
					}
				}
			},{
				id : 'button-delete',
				text : '删除',
				iconCls : 'icon-cancel',
				handler : function(){
					var rows = $('#grid').datagrid('getSelections');
					if(rows.length==0){
						$.messager.alert('提示信息','请选择要删除的数据!','warning');
					}else{
						$.messager.confirm('确认信息','您确定要删除吗?',function(r){
							if(r){
								var array = new Array();
								for(var i=0;i<rows.length;i++){
									array.push(rows[i].id);
								}
								var ids = array.join(',');
								
								/* var array = new Array();
								for(var i=0; i<rows.length; i++){
									array.push(rows[i].id); 
								}
								var ids = array.join(',');//json可以实现数组内容自动拼接 */
								
								location.href='${pageContext.request.contextPath}/vehicleAction_delete.action?ids='+ids;
							}
						});
					}
				}
			} ];
			
			// 定义列
			var columns = [ [ {
				field : 'id',
				checkbox : true,
			},{
				field : 'routeType',
				title : '线路类型',
				width : 120,
				align : 'center'
			},{
				field : 'routeName',
				title : '线路名称',
				width : 120,
				align : 'center'
			}, {
				field : 'vehicleNum',
				title : '车牌号',
				width : 120,
				align : 'center'
			}, {
				field : 'shipper',
				title : '承运商',
				width : 120,
				align : 'center'
			}, {
				field : 'driver',
				title : '司机',
				width : 120,
				align : 'center'
			}, {
				field : 'telephone',
				title : '电话',
				width : 120,
				align : 'center'
			}, {
				field : 'vehicleType',
				title : '车型',
				width : 120,
				align : 'center'
			}, {
				field : 'ton',
				title : '吨控',
				width : 120,
				align : 'center'
			}, {
				field : 'remark',
				title : '备注',
				width : 120,
				align : 'center'
			} ] ];
		</script>
	</head>
	<body class="easyui-layout" style="visibility:hidden;">
		<div region="center" border="false">
			<table id="grid"></table>
		</div>
		<div class="easyui-window" title="对班车进行添加或者修改" id="vehicleWindow" collapsible="false" minimizable="false" maximizable="false" style="top:20px;left:200px">
			<div region="north" style="height:31px;overflow:hidden;" split="false" border="false">
				<div class="datagrid-toolbar">
					<a id="save" icon="icon-save" href="#" class="easyui-linkbutton" plain="true">保存</a>
					<script type="text/javascript">
					$(function(){
						$('#save').click(function(){
							var v = $('#addVehicleForm').form('validate');
							if(v){
								$('#addVehicleForm').submit();
							}
						});
					});
					</script>
				</div>
			</div>

			<div region="center" style="overflow:auto;padding:5px;" border="false">
				<script type="text/javascript">
				
					$(function() {
						var reg = /^1[3|4|5|7|8|9][0-9]{9}$/;
						$.extend($.fn.validatebox.defaults.rules, {
							phonenumber : {
								validator : function(value, param) {
									return reg.test(value);
								},
								message : '手机号输入有误！'
							}
						});
					});
				</script>
				<form id="addVehicleForm" method="post"
					action="${pageContext.request.contextPath}/vehicleAction_add.action">
					<table class="table-edit" width="80%" align="center">
						<tr class="title">
							<td colspan="4">班车信息</td>
							<!--提供隐藏域 装载id -->
							<input type="hidden" name="id" />
						</tr>
						<tr>
							<td>线路类型</td>
							<td>
								<input type="text" name="routeType" class="easyui-validatebox" required="true" />
							</td>
							<td>线路名称</td>
							<td>
								<input type="text" name="routeName" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>电话</td>
							<td>
								<input type="text" name="telephone" class="easyui-validatebox" required="true" data-options="validType:'phonenumber'" />
							</td>
						<td>承运商</td>
							<td>
								<input type="text" name="shipper" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>司机</td>
							<td>
								<input type="text" name="driver" class="easyui-validatebox" required="true" />
							</td>
							<td>车牌号</td>
							<td>
								<input type="text" name="vehicleNum" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>车型</td>
							<td>
								<input type="text" name="vehicleType" class="easyui-validatebox" required="true" />
							</td>
							<td>吨控</td>
							<td>
								<input type="text" name="ton" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>备注</td>
							<td>
								<input type="text" name="remark" />
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
	</body>
</html>
