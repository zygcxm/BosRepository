<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

	<head>
		<meta charset="UTF-8">
		<title>取派标准</title>
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
			$(function(){
				// 先将body隐藏，再显示，不会出现页面刷新效果
				$("body").css({visibility:"visible"});
				
				// 收派标准信息表格
				$('#grid').datagrid( {
					fit : true,
					border : false,
					rownumbers : true,
					striped : true,
					pageList: [30,50,100],
					pagination : true,
					toolbar : toolbar,
					url : "${pageContext.request.contextPath}/standardAction_pageQuery.action",
					idField : 'id',
					columns : columns
				});
			});	
			
			//工具栏
			var toolbar = [ {
				id : 'button-add',
				text : '增加',
				iconCls : 'icon-add',
				handler : function(){
					//1.打开添加窗口
					$('#standardWindow').window('open');
				}
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
						$('#standardWindow').window('open');
						//4.回显要修改的数据
						$('#addStandardForm').form('load',rows[0]);
					}
				}
			},{
				id : 'button-delete',
				text : '删除',
				iconCls : 'icon-cancel',
				handler : doDelete
			},{
				id : 'button-search',
				text : '查询',
				iconCls : 'icon-search',
				handler : doSearch
			}];
			// 定义列
			var columns = [ [ {
				field : 'id',
				checkbox : true
			},{
				field : 'name',
				title : '标准名称',
				width : 120,
				align : 'center'
			}, {
				field : 'minWeight',
				title : '最小重量',
				width : 120,
				align : 'center'
			}, {
				field : 'maxWeight',
				title : '最大重量',
				width : 120,
				align : 'center'
			}, {
				field : 'minLength',
				title : '最小长度',
				width : 120,
				align : 'center'
			}, {
				field : 'maxLength',
				title : '最大长度',
				width : 120,
				align : 'center'
			}, {
				field : 'operator',
				title : '操作人',
				width : 120,
				align : 'center'
			}, {
				field : 'operatingTime',
				title : '操作时间',
				width : 120,
				align : 'center',
				formatter:function(value,row,index){
					return getDateTime(value.time);
				}
			}, {
				field : 'operatingCompany',
				title : '操作单位',
				width : 120,
				align : 'center'
			} ] ];
			
			function getDateTime(date) {
				var date=new Date(date);
				if(date==null){
					return "";
				}
				var year=date.getFullYear();
				var month=(date.getMonth()+1)<10?(0+""+(date.getMonth()+1)): (date.getMonth()+1);
				var day=(date.getDate())<10?(0+""+(date.getDate())): (date.getDate());
				//var hh=(date.getHours())<10?(0+""+(date.getHours())): (date.getHours());
				//var mm=(date.getMinutes())<10?(0+""+(date.getMinutes())): (date.getMinutes());
				//var ss=(date.getSeconds())<10?(0+""+(date.getSeconds())): (date.getSeconds());+" "+hh+":"+mm+":"+ss
				return year+"-"+month+"-"+day
			}
			
			function doSearch(){
				$('#searchWindow').window('open');
			}
			
			function doDelete(){
				//1.获取选中数据
				var rows = $('#grid').datagrid('getSelections');
				if(rows.length <= 0){
					//2.未选中，提示客户选择要删除的数据
					$.messager.alert('提示信息','请您选择要删除的数据！','warning');
				} else {
					//3.选中，让客户确认是否删除
					$.messager.confirm('确认信息','您确定要删除这么数据么？',function(r){
						if(r){
							//4.确认删除，通过请求将所有选中的快递员id发送到后台
							var array = new Array();
							for(var i=0; i<rows.length; i++){
								array.push(rows[i].id); 
							}
							var ids = array.join(',');//json可以实现数组内容自动拼接
							//通过请求将所有选中的快递员id发送到后台
							location.href='${pageContext.request.contextPath}/standardAction_delete.action?ids='+ids;
						}
					});
				}
			}
		</script>
	</head>

	<body class="easyui-layout" style="visibility:hidden;">
	
		<div region="center" border="false">
			<table id="grid"></table>
		</div>
		<!-- <div class="easyui-window" title="查询收派标准" id="searchWindow">
			
		</div> -->
		
		<div class="easyui-window" title="查询收派标准窗口" closed="true" id="searchWindow" collapsible="false" minimizable="false" maximizable="false" style="width: 400px; top:40px;left:200px">
			<div style="overflow:auto;padding:5px;" border="false">
				<form id="searchForm">
					<table class="table-edit" width="80%" align="center">
						<tr class="title">
							<td colspan="2">查询条件</td>
						</tr>
						<tr>
							<td>操作人</td>
							<td>
								<input type="text" name="operator" />
							</td>
						</tr>
						<tr>
							<td>标准名称</td>
							<td>
								<input type="text" name="name" />
							</td>
						</tr>
						<tr>
							<td>操作单位</td>
							<td>
								<input type="text" name="operatingCompany" />
							</td>
						</tr>
						<tr>
							<td colspan="2"><a id="searchBtn" href="#" class="easyui-linkbutton"
							 data-options="iconCls:'icon-search'">查询</a>
							 <script type="text/javascript">
							 	$(function(){
							 		$.fn.serializeJson=function(){  
							            var serializeObj={};  
							            var array=this.serializeArray();  
							            var str=this.serialize();  
							            $(array).each(function(){  
							                if(serializeObj[this.name]){  
							                    if($.isArray(serializeObj[this.name])){  
							                        serializeObj[this.name].push(this.value);  
							                    }else{  
							                        serializeObj[this.name]=[serializeObj[this.name],this.value];  
							                    }  
							                }else{  
							                    serializeObj[this.name]=this.value;   
							                }  
							            });  
							            return serializeObj;  
							        }; 
							 		$('#searchBtn').click(function(){
							 			//将表单序列化为json对象
							 			var data = $('#searchForm').serializeJson();
							 			//调用datagrid的load方法传递参数执行查询
							 			$('#grid').datagrid('load',data);
							 			//关闭查询窗口
							 			$('#searchWindow').window('close');
							 		});
							 	});
							 </script>
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
		
		<div class="easyui-window" title="对收派标准进行添加或者修改" id="standardWindow" collapsible="false" minimizable="false" maximizable="false" modal="true" closed="true" style="width:600px;top:50px;left:200px">
			<div region="north" style="height:31px;overflow:hidden;" split="false" border="false">
				<div class="datagrid-toolbar">
					<a id="save" icon="icon-save" href="#" class="easyui-linkbutton" plain="true">保存</a>
					<script type="text/javascript">
					$(function(){
						$('#save').click(function(){
							//1.校验表单数据是否合法
							var v = $('#addStandardForm').form('validate');
							if(v){
								//2.合法，提交表单
								$('#addStandardForm').submit();
							}
						});
					});
					</script>
				</div>
			</div>

			<div region="center" style="overflow:auto;padding:5px;" border="false">
				
				<form id="addStandardForm" method="post"
					action="${pageContext.request.contextPath}/standardAction_add.action">
					<table class="table-edit" width="80%" align="center">
						<tr class="title">
							<td colspan="2">收派标准信息
								<!--提供隐藏域 装载id -->
								<input type="hidden" name="id" />
							</td>
						</tr>
						<tr>
							<td>收派标准名称</td>
							<td>
								<input type="text" name="name" 
									class="easyui-validatebox" data-options="required:true" />
							</td>
						</tr>
						<tr>
							<td>最小重量</td>
							<td>
								<input type="text" name="minWeight" 
										class="easyui-numberbox" required="true" />
							</td>
						</tr>
						<tr>
							<td>最大重量</td>
							<td>
								<input type="text" name="maxWeight" class="easyui-numberbox" required="true" />
							</td>
						</tr>
						<tr>
							<td>最小长度</td>
							<td>
								<input type="text" name="minLength" class="easyui-numberbox" required="true" />
							</td>
						</tr>
						<tr>
							<td>最大长度</td>
							<td>
								<input type="text" name="maxLength" class="easyui-numberbox" required="true" />
							</td>
						</tr>
						<tr>
							<td>操作时间</td>
							<td>
								<input type="text" name="operatingTime" class="easyui-datetimebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>操作员</td>
							<td>
								<input type="text" name="operator" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>操作单位</td>
							<td>
								<input type="text" name="operatingCompany" class="easyui-validatebox" required="true" />
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
	</body>

</html>