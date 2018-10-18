<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta charset="UTF-8">
		<title>BOS管理系统 首页</title>
		<link href="favicon.ico" rel="icon" type="image/x-icon" />
		<!-- 导入jquery核心类库 -->
		<script type="text/javascript" src="./js/jquery-1.8.3.js"></script>
		<!-- 导入easyui类库 -->
		<link id="easyuiTheme" rel="stylesheet" type="text/css" href="./js/easyui/themes/default/easyui.css">
		<link rel="stylesheet" type="text/css" href="./js/easyui/themes/icon.css">
		<link rel="stylesheet" type="text/css" href="./css/default.css">
		<script type="text/javascript" src="./js/easyui/jquery.easyui.min.js"></script>
		<!-- 导入ztree类库 -->
		<link rel="stylesheet" href="./js/ztree/zTreeStyle.css" type="text/css" />
		<script src="./js/ztree/jquery.ztree.all-3.5.js" type="text/javascript"></script>
		<script src="./js/easyui/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
		<script type="text/javascript">
			$(function() {
				/** 
				   Ztree菜单通用配置 
				*/
				var setting = {
					data : {
						simpleData : { // 简单数据 
							enable : true
						}
					},
					callback : {
						onClick : onClick
					}
				};
				
				// 基本功能菜单加载
				$.post("./data/menu.json",function(data){
					$.fn.zTree.init($("#treeMenu"), setting, data);
				},"json");
				
				// 系统管理菜单加载
				$.post("./data/admin.json",function(data){
					$.fn.zTree.init($("#adminMenu"), setting, data);
				},"json");
				
				// 页面加载后 右下角 弹出窗口
				window.setTimeout(function(){
					$.messager.show({
						title:"消息提示",
						msg:'欢迎登录，超级管理员！ <a href="javascript:void" onclick="top.showAbout();">联系管理员</a>',
						timeout:5000
					});
				},3000);
				
				$("#btnCancel").click(function(){
					$('#editPwdWindow').window('close');
				});
				
				$("#btnEp").click(function(){
					alert("修改密码");
				});
				
				// 设置全局变量 保存当前正在右键的tabs 标题 
				var currentRightTitle  ;
				
				// 为选项卡，添加右键菜单 
				$('#tabs').tabs({
					onContextMenu : function(e,title,index){
						currentRightTitle = title ; 
						$('#mm').menu('show', { 
							left: e.pageX,
							top: e.pageY 
						});
						e.preventDefault(); // 禁用原来的右键效果 
					}
				});
				
				$('#mm').menu({ 
					onClick:function(item){ 
						if(item.name==='Close'){
							$('#tabs').tabs('close',currentRightTitle);
						}else if(item.name === 'CloseOthers'){
							var tabs = $('#tabs').tabs('tabs');
							$(tabs).each(function(){
								if($(this).panel('options').title != '消息中心' && $(this).panel('options').title != currentRightTitle){
									$('#tabs').tabs('close',$(this).panel('options').title);
								}
							});
						}else if(item.name === 'CloseAll'){
							var tabs = $('#tabs').tabs('tabs');
							$(tabs).each(function(){
								if($(this).panel('options').title != '消息中心'){
									$('#tabs').tabs('close',$(this).panel('options').title);
								}
							});
						}
					} 
				}); 
			});
			
			function onClick(event, treeId, treeNode, clickFlag) {
				// 判断树菜单节点是否含有 page属性
				if (treeNode.page!=undefined && treeNode.page!= "") {
					var content = '<div style="width:100%;height:100%;overflow:hidden;">'
								+ '<iframe src="'
								+ treeNode.page
								+ '" scrolling="auto" style="width:100%;height:100%;border:0;" ></iframe></div>';
					if ($("#tabs").tabs('exists', treeNode.name)) {// 判断tab是否存在
						$('#tabs').tabs('select', treeNode.name); // 切换tab
						var tab = $('#tabs').tabs('getSelected'); 
						$('#tabs').tabs('update', {
						    tab: tab,
						    options: {
						        title: treeNode.name,
						        content: content
						    }
						});
					} else {
						// 开启一个新的tab页面
						$('#tabs').tabs('add', {
							title : treeNode.name,
							content : content,
							closable : true,
							tools:[{ 
								iconCls:'icon-reload', // 刷新按钮
								handler : function(){
									var tab = $('#tabs').tabs('getTab',treeNode.name);
									$("iframe[src='"+treeNode.page+"']").get(0).contentWindow.location.reload(true);
								}
							}] 
						});
					}
				}
			}
		
			/*******顶部特效 *******/
			/**
			 * 更换EasyUI主题的方法
			 * @param themeName
			 * 主题名称
			 */
			changeTheme = function(themeName) {
				var $easyuiTheme = $('#easyuiTheme');
				var url = $easyuiTheme.attr('href');
				var href = url.substring(0, url.indexOf('themes')) + 'themes/'
						+ themeName + '/easyui.css';
				$easyuiTheme.attr('href', href);
				var $iframe = $('iframe');
				if ($iframe.length > 0) {
					for ( var i = 0; i < $iframe.length; i++) {
						var ifr = $iframe[i];
						$(ifr).contents().find('#easyuiTheme').attr('href', href);
					}
				}
			};
			// 退出登录
			function logoutFun() {
				$.messager
				.confirm('系统提示','您确定要退出本次登录吗?',function(isConfirm) {
					if (isConfirm) {
						location.href = './login.jsp';
					}
				});
			}
			// 修改密码
			function editPassword() {
				$('#editPwdWindow').window('open');
			}
			// 版权信息
			function showAbout(){
				$.messager.alert("bos v2.0综合物流管理平台","设计: 传智播客<br/> 管理员邮箱: itcast_search@163.com <br/>");
			}
		</script>
	</head>

	<body class="easyui-layout">
		<div data-options="region:'north',border:false" style="height:70px;padding:10px;">
			<div>
				<img src="./images/logo.png" border="0">
			</div>
			<div id="sessionInfoDiv" style="position: absolute;right: 5px;top:10px;">
				[<strong>超级管理员</strong>]，欢迎你！您使用[<strong>192.168.1.1</strong>]IP登录！
			</div>
			<div style="position: absolute; right: 5px; bottom: 10px; ">
				<a href="javascript:void(0);" class="easyui-menubutton" data-options="menu:'#layout_north_pfMenu',iconCls:'icon-ok'">更换皮肤</a>
				<a href="javascript:void(0);" class="easyui-menubutton" data-options="menu:'#layout_north_kzmbMenu',iconCls:'icon-help'">控制面板</a>
			</div>
			<div id="layout_north_pfMenu" style="width: 120px; display: none;">
				<div onclick="changeTheme('default');">default</div>
				<div onclick="changeTheme('gray');">gray</div>
				<div onclick="changeTheme('black');">black</div>
				<div onclick="changeTheme('bootstrap');">bootstrap</div>
				<div onclick="changeTheme('metro');">metro</div>
			</div>
			<div id="layout_north_kzmbMenu" style="width: 100px; display: none;">
				<div onclick="editPassword();">修改密码</div>
				<div onclick="showAbout();">联系管理员</div>
				<div class="menu-sep"></div>
				<div onclick="logoutFun();">退出系统</div>
			</div>
		</div>
		<div data-options="region:'west',split:true,title:'菜单导航'" style="width:200px">
			<div class="easyui-accordion" fit="true" border="false">
				<div title="基本功能" data-options="iconCls:'icon-mini-add'" style="overflow:auto">
					<ul id="treeMenu" class="ztree"></ul>
				</div>
				<div title="系统管理" data-options="iconCls:'icon-mini-add'" style="overflow:auto">
					<ul id="adminMenu" class="ztree"></ul>
				</div>
			</div>
		</div>
		<div data-options="region:'center'">
			<div id="tabs" fit="true" class="easyui-tabs" border="false">
				<div title="消息中心" id="subWarp" style="width:100%;height:100%;overflow:hidden">
					<iframe src="./home.jsp" style="width:100%;height:100%;border:0;"></iframe>
				</div>
			</div>
		</div>
		<div data-options="region:'south',border:false" style="height:50px;padding:10px;">
			<table style="width: 100%;">
				<tbody>
					<tr>
						<td style="width: 400px;">
							<div style="color: #999; font-size: 8pt;">
								BOSv2.0综合物流管理平台 | Powered by <a href="http://www.itcast.cn/">传智播客</a>
							</div>
						</td>
						<td style="width: *;" class="co1"><span id="online" style="background: url(./images/online.png) no-repeat left;padding-left:18px;margin-left:3px;font-size:8pt;color:#005590;">在线人数:1</span>
						</td>
					</tr>
				</tbody>
			</table>
		</div>

		<!--修改密码窗口-->
		<div id="editPwdWindow" class="easyui-window" title="修改密码" collapsible="false" minimizable="false" modal="true" closed="true" resizable="false" maximizable="false" icon="icon-save" style="width: 300px; height: 160px; padding: 5px;
        background: #fafafa">
			<div class="easyui-layout" fit="true">
				<div region="center" border="false" style="padding: 10px; background: #fff; border: 1px solid #ccc;">
					<table cellpadding=3>
						<tr>
							<td>新密码：</td>
							<td>
								<input id="txtNewPass" type="Password" class="txt01" />
							</td>
						</tr>
						<tr>
							<td>确认密码：</td>
							<td>
								<input id="txtRePass" type="Password" class="txt01" />
							</td>
						</tr>
					</table>
				</div>
				<div region="south" border="false" style="text-align: right; height: 30px; line-height: 30px;">
					<a id="btnEp" class="easyui-linkbutton" icon="icon-ok" href="javascript:void(0)">确定</a>
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:void(0)">取消</a>
				</div>
			</div>
		</div>

		<div id="mm" class="easyui-menu" style="width:120px;">
			<div data-options="name:'Close'">关闭当前窗口</div>
			<div data-options="name:'CloseOthers'">关闭其它窗口</div>
			<div class="menu-sep"></div>
			<div data-options="iconCls:'icon-cancel',name:'CloseAll'">关闭全部窗口</div>
		</div>

	</body>

</html>