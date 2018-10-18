<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta charset="UTF-8">
		<title>区域设置</title>
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
		<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.ocupload-1.1.2.js"></script>
		<script type="text/javascript">
			function doAdd(){
				$('#addWindow').window("open");
			}
			
			function doView(){
				var rows = $('#grid').datagrid('getSelections');
				if(rows.length==0){
					$.messager.alert('提示信息','请选择要修改的数据','warning');
				}
				if(rows.length>1){
					$.messager.alert('提示信息','一次只能修改一条','warning');
				}
				if(rows.length==1){
					$('#addWindow').window('open');
					$('#addWindow').form('load',rows[0]);
				}
			}
			
			function doDelete(){
				var rows = $('#grid').datagrid('getSelections');
				if(rows.length<1){
					$.messager.alert('提示信息','请选择要删除的数据','info');
				}else{
					$.messager.confirm('提示信息','确定要删除吗?',function(r){
						if(r){
							var array = new Array();
							for(var i=0;i<rows.length;i++){
								array.push(rows[i].id);
							}
							var ids = array.join(",");
							
							location.href="${pageContext.request.contextPath}/areaAction_delete.action?ids="+ids;
						}
					});
				}
			}
			
			//工具栏
			var toolbar = [ {
				id : 'button-edit',	
				text : '修改',
				iconCls : 'icon-edit',
				handler : doView
			}, {
				id : 'button-add',
				text : '增加',
				iconCls : 'icon-add',
				handler : doAdd
			}, {
				id : 'button-delete',
				text : '删除',
				iconCls : 'icon-cancel',
				handler : doDelete
			}, {
				id : 'button-import',
				text : '导入',
				iconCls : 'icon-redo'
			}, {
				id : 'button-search',
				text : '查询',
				iconCls : 'icon-search',
				handler:function(){
					$('#searchWindow').window('open');
				}
			}];
			// 定义列
			var columns = [ [ 
			                  {
				//field : 'id',
				checkbox : true,
				//title : '区域编号',
				//align : 'center'
			},{
				field : 'areanumber',
				//checkbox : true,
				title : '区域编号',
				align : 'center'
			},{
				field : 'province',
				title : '省',
				width : 120,
				align : 'center'
			},{
				field : 'city',
				title : '市',
				width : 120,
				align : 'center'
			}, {
				field : 'district',
				title : '区',
				width : 120,
				align : 'center'
			}, {
				field : 'postcode',
				title : '邮编',
				width : 120,
				align : 'center'
			}, {
				field : 'shortcode',
				title : '简码',
				width : 120,
				align : 'center'
			}, {
				field : 'citycode',
				title : '城市编码',
				width : 200,
				align : 'center'
			} ] ];
			
			$(function(){
				// 先将body隐藏，再显示，不会出现页面刷新效果
				$("body").css({visibility:"visible"});
				
				// 区域管理数据表格
				$('#grid').datagrid( {
					iconCls : 'icon-forward',
					fit : true,
					border : false,
					rownumbers : true,
					striped : true,
					pageList: [30,50,100],
					pagination : true,
					toolbar : toolbar,
					url : "${pageContext.request.contextPath}/areaAction_pageQuery.action",
					idField : 'id',
					columns : columns,
					onDblClickRow : doDblClickRow
				});
				
				// 添加、修改区域窗口
				$('#addWindow').window({
			        title: '添加修改区域',
			        width: 400,
			        modal: true,
			        shadow: true,
			        closed: true,
			        height: 400,
			        resizable:false
			    });
				
				/* $('#button-import').upload({
					 action:是处理文件上传的后台action路径
					   name:为上传文件定义一个名字,方便后台获取
					   onComplete:执行上传完毕的回调函数
					
					action:'${pageContext.request.contextPath}/areaAction_import.action',
					name:'areaFire',
					onComplete:function(data){
						if("1"==data){
							$.messager.alert('提示信息','上传成功','info');
						}else{
							$.messager.alert('提示信息','上传失败','error');
						}
					}
				});*/
				$('#button-import').upload({
					action:'${pageContext.request.contextPath}/areaAction_import.action',
					name:'areaFile',
					onComplete:function(data){
						if(data=='1'){
							$.messager.alert('提示信息','导入成功','info',function(r){
								if(!r){
									location.reload();
								}
							});
						}else{
							$.messager.alert('提示信息','导入失败','error');
						}
					}
				});
			
				function doDblClickRow(){
					alert("双击表格数据...");
				}
				
			}); 
			
		</script>
	</head>

	<body class="easyui-layout" style="visibility:hidden;">
		<div region="center" border="false">
			<table id="grid"></table>
		</div>
		<div class="easyui-window" title="区域添加修改" id="addWindow" collapsible="false" minimizable="false" maximizable="false" style="top:20px;left:200px">
			<div region="north" style="height:31px;overflow:hidden;" split="false" border="false">
				<div class="datagrid-toolbar">
					<a id="save" icon="icon-save" href="#" class="easyui-linkbutton" plain="true">保存</a>
					<script type="text/javascript">
					$(function(){
						$('#save').click(function(){
						var v = $('#addAreaForm').form('validate');
							if(v){
								$('#addAreaForm').submit();
							}
						});
					});
					</script>
				</div>
			</div>

			<div region="center" style="overflow:auto;padding:5px;" border="false">
				<form method="post" action="${pageContext.request.contextPath}/areaAction_save.action" id="addAreaForm">
					<table class="table-edit" width="80%" align="center">
						<tr class="title">
							<td colspan="2">区域信息</td>
							<input type="hidden" name="id" />
						</tr>
						<tr>
							<td>区域编号</td>
							<td>
								<input type="text" name="areanumber" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>省</td>
							<td>
								<input type="text" name="province" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>市</td>
							<td>
								<input type="text" name="city" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>区</td>
							<td>
								<input type="text" name="district" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>邮编</td>
							<td>
								<input type="text" name="postcode" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>简码</td>
							<td>
								<input type="text" name="shortcode" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>城市编码</td>
							<td>
								<input type="text" name="citycode" class="easyui-validatebox" required="true" />
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
		
		<!-- 查询区域-->
		<div class="easyui-window" title="查询区域窗口" closed="true" id="searchWindow" collapsible="false" minimizable="false" maximizable="false" style="width: 400px; top:40px;left:200px">
			<div style="overflow:auto;padding:5px;" border="false">
				<form id="searchForm">
					<table class="table-edit" width="80%" align="center">
						<tr class="title">
							<td colspan="2">查询条件</td>
						</tr>
						<tr>
							<td>省份</td>
							<td>
								<input type="text" name="province" />
							</td>
						</tr>
						<tr>
							<td>城市</td>
							<td>
								<input type="text" name="city" />
							</td>
						</tr>
						<tr>
							<td>区（县）</td>
							<td>
								<input type="text" name="district" />
							</td>
						</tr>
						<tr>
							<!-- <td colspan="2"><a id="searchBtn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a> </td> -->
							<td colspan="2"><a id="searchBtn" href="#" class="easyui-linkbutton"
							 data-options="iconCls:'icon-search'">查询</a>
							 	<script type="text/javascript">
							 	$(function(){
							 		//给form表单绑定了一个序列化成json对象的方法
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
							 			//1.调用表单的序列化方法，获取表单json对象
							 			var data = $('#searchForm').serializeJson();
							 			//2.通过datagrid的load方法提交查询条件
							 			$('#grid').datagrid('load',data);
							 			//3.关闭查询窗口
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
		<!-- <div class="easyui-window" title="查询快递员窗口" closed="true" id="searchWindow" collapsible="false" minimizable="false" maximizable="false" style="width: 400px; top:40px;left:200px">
			<div style="overflow:auto;padding:5px;" border="false">
				<form id="searchForm">
					<table class="table-edit" width="80%" align="center">
						<tr class="title">
							<td colspan="2">查询条件</td>
						</tr>
						<tr>
							<td>姓名</td>
							<td>
								<input type="text" name="name" />
							</td>
						</tr>
						<tr>
							<td>工号</td>
							<td>
								<input type="text" name="courierNum" />
							</td>
						</tr>
						<tr>
							<td>收派标准</td>
							<td>
								<input type="text" name="standard.namee" />
							</td>
						</tr>
						<tr>
							<td>所属单位</td>
							<td>
								<input type="text" name="company" />
							</td>
						</tr>
						<tr>
							<td>类型</td>
							<td>
								<input type="text" name="type" />
							</td>
						</tr>
						<tr>
							<td colspan="2"><a id="searchBtn" href="#" class="easyui-linkbutton"
							 data-options="iconCls:'icon-search'">查询</a>
							 	<script type="text/javascript">
							 	$(function(){
							 		//给form表单绑定了一个序列化成json对象的方法
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
							 			//1.调用表单的序列化方法，获取表单json对象
							 			var data = $('#searchForm').serializeJson();
							 			//2.通过datagrid的load方法提交查询条件
							 			$('#grid').datagrid('load',data);
							 			//3.关闭查询窗口
							 			$('#searchWindow').window('close');
							 		});
							 	});
							 	</script>
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div> -->
	</body>

</html>