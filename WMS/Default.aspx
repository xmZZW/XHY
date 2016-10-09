<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
   <title>自动化仓储管理系统</title>
   <link rel="stylesheet" type="text/css" href="Css/default.css" />
    <link rel="stylesheet" type="text/css" href="Css/icon.css" />
    <link rel="stylesheet" type="text/css" href="EasyUI/themes/default/easyui.css" />
    <link rel="stylesheet" type="text/css" href="EasyUI/themes/icon.css" />
    <script type="text/javascript" src="EasyUI/jquery.min.js"></script>
    <script type="text/javascript" src="EasyUI/jquery.easyui.min.js"></script>
    <script type="text/javascript">
        $(function () {
            tabClose();
            tabCloseEven();

            var _menus = {};
            //同步获取

            $.ajax({
                type: 'GET',
                url: 'LeftTreeJson.ashx',
                async: false, //同步
                dataType: 'text',
                success: function (json) {
                    _menus = eval(json);
                },
                error: function (xhr, status, error) {
                    alert("操作失败"); //xhr.responseText
                }
            });


            $('#css3menu a').click(function () {
                $('#css3menu a').removeClass('active');
                $(this).addClass('active');

                var d = _menus[$(this).attr('name')];
                Clearnav();
                addNav(d);
                InitLeftMenu();
            });

            // 导航菜单绑定初始化
            $("#wnav").accordion({
                animate: false
            });
            addNav(_menus);
            InitLeftMenu();
        });

       

        function Clearnav() {
            var pp = $('#wnav').accordion('panels');

            $.each(pp, function (i, n) {
                if (n) {
                    var t = n.panel('options').title;
                    $('#wnav').accordion('remove', t);
                }
            });

            pp = $('#wnav').accordion('getSelected');
            if (pp) {
                var title = pp.panel('options').title;
                $('#wnav').accordion('remove', title);
            }
        }

        function addNav(data) {

            $.each(data, function (i, sm) {
                var menulist = "";
                menulist += '<ul>';
                $.each(sm.menus, function (j, o) { 
                    menulist += '<li><div><a ref="' + o.menuid + '" href="#" rel="'
					+ o.url + '" icon="'+o.icon+'" ><span class="' + o.icon
					+ '" >&nbsp;</span><span class="nav">' + o.menuname
					+ '</span></a></div></li> ';
                });
                menulist += '</ul>';

                $('#wnav').accordion('add', {
                    title: sm.menuname,
                    content: menulist,
                    iconCls: sm.icon
                });

            });

            var pp = $('#wnav').accordion('panels');
            var t = pp[0].panel('options').title;
            $('#wnav').accordion('select', t);

        }

        // 初始化左侧
        function InitLeftMenu() {

            hoverMenuItem();

            $('#wnav li').on("click", "a", function () {
                var tabTitle = $(this).children('.nav').text();
                var url = $(this).attr("rel");
                var menuid = $(this).attr("ref");
                var icon = $(this).attr("icon");

                addTab(tabTitle, url, icon);
                $('#wnav li div').removeClass("selected");
                $(this).parent().addClass("selected");
            });

        }

        /**
        * 菜单项鼠标Hover
        */
        function hoverMenuItem() {
            $(".easyui-accordion").find('a').hover(function () {
                $(this).parent().addClass("hover");
            }, function () {
                $(this).parent().removeClass("hover");
            });
        }

        // 获取左侧导航的图标
        function getIcon(menuid) {
            var icon = 'icon ';
            $.each(_menus, function (i, n) {
                $.each(n, function (j, o) {
                    $.each(o.menus, function (k, m) {
                        if (m.menuid == menuid) {
                            icon += m.icon;
                            return false;
                        }
                    });
                });
            });
            return icon;
        }

        function addTab(subtitle, url, icon) {
            if (!$('#tabs').tabs('exists', subtitle)) {
                $('#tabs').tabs('add', {
                    title: subtitle,
                    content: createFrame(url),
                    closable: true,
                    icon: icon
                });
            } else {
                $('#tabs').tabs('select', subtitle);
                $('#mm-tabupdate').click();
            }
            tabClose();
        }

        function removetab() {
            var title = $('.tabs-selected').text();
            $('#tabs').tabs('close', title);
        }

        function createFrame(url) {
            var s = '<iframe scrolling="auto" frameborder="0"  src="' + url + '" style="width:100%;height:99%;"></iframe>';
            return s;
        }

        function tabClose() {
            /* 双击关闭TAB选项卡 */
            $(".tabs-inner").dblclick(function () {
                var subtitle = $(this).children(".tabs-closable").text();
                $('#tabs').tabs('close', subtitle);
            });
            /* 为选项卡绑定右键 */
            $(".tabs-inner:not(:contains('首页'))").bind('contextmenu', function (e) {
                $('#mm').menu('show', {
                    left: e.pageX,
                    top: e.pageY
                });

                var subtitle = $(this).children(".tabs-closable").text();

                $('#mm').data("currtab", subtitle);
                $('#tabs').tabs('select', subtitle);
                return false;
            });
        }
        // 绑定右键菜单事件
        function tabCloseEven() {
            // 刷新
            $('#mm-tabupdate').click(function () {
                
                var currTab = $('#tabs').tabs('getSelected');
                var url = $(currTab.panel('options').content).attr('src');
                $('#tabs').tabs('update', {
                    tab: currTab,
                    options: {
                        content: createFrame(url)
                    }
                });
            });
            // 关闭当前
            $('#mm-tabclose').click(function () {
                var currtab_title = $('#mm').data("currtab");
                if (currtab_title != "首页")
                    $('#tabs').tabs('close', currtab_title);
            });
            // 全部关闭
            $('#mm-tabcloseall').click(function () {
                $('.tabs-inner span').each(function (i, n) {
                    var t = $(n).text();
                    if (t != "首页")
                        $('#tabs').tabs('close', t);
                });
            });
            // 关闭除当前之外的TAB
            $('#mm-tabcloseother').click(function () {
                $('#mm-tabcloseright').click();
                $('#mm-tabcloseleft').click();
            });
            // 关闭当前右侧的TAB
            $('#mm-tabcloseright').click(function () {
                var nextall = $('.tabs-selected').nextAll();
                if (nextall.length != 0) {
                    nextall.each(function (i, n) {
                        var t = $('a:eq(0) span', $(n)).text();
                        if (t != "首页")
                            $('#tabs').tabs('close', t);
                    });
                }
                return false;
            });
            // 关闭当前左侧的TAB
            $('#mm-tabcloseleft').click(function () {
                var prevall = $('.tabs-selected').prevAll();
                if (prevall.length != 0) {
                    prevall.each(function (i, n) {
                        var t = $('a:eq(0) span', $(n)).text();
                        if (t != "首页")
                            $('#tabs').tabs('close', t);
                    });
                }
                return false;
            });

            // 退出
            $("#mm-exit").click(function () {
                $('#mm').menu('hide');
            });
        }
   </script>
   <style type="text/css">
	    #css3menu li{ float:left; list-style-type:none;}
        #css3menu li a{	color:#fff; padding-right:20px;}
        #css3menu li a.active{color:yellow;}
    </style>
</head>
<body class="easyui-layout" style="overflow: hidden">
<noscript>
<div style=" position:absolute; z-index:100000; height:2046px;top:0px;left:0px; width:100%; background:white; text-align:center;">
    <img src="images/noscript.gif" alt='抱歉，请开启脚本支持！' />
</div></noscript>
    <div region="north" split="true" border="false" style="overflow: hidden; height: 83px;  background:url(Images/banner_1.jpg); color: #fff; font-family: Verdana, 微软雅黑,黑体">
         <span style="float:right; padding-right:20px;" class="head"><a href="Login.aspx" id="changeUser">切换用户</a><span>|</span><a href="javascript:void(0)" onclick="return ChangePassword();" id="changePassword">修改密码</a><span>|</span><a href="javascript:window.close();"/" id="loginOut">退出</a></span>   
    </div>
    <div region="south" split="false" style="height: 30px; background: #D2E0F2; ">
        <div style="border:1px solid #cbe4f3;line-height:25px;text-align: center;background:url(Images/bottom.jpg) repeat-x;"><a href="http://www.unitechnik.com.cn" target="_blank">罗伯泰克自动化科技（苏州）有限公司</a></div>
    </div>
    <div region="west" hide="true" split="true" title="导航菜单" style="width:180px;" id="west">
        <div id='wnav' class="easyui-accordion" fit="true" border="false">
		    <!--  导航内容 -->
	    </div>

    </div>
    <div id="mainPanle" region="center" style="background: #eee; overflow-y:hidden">
        <div id="tabs" class="easyui-tabs" data-options="closable:false,onBeforeClose: function(title){	return confirm('您确认想要关闭 ' + title); },fit:true" border="false" >
			<div title="首页" style="overflow:hidden;" id="home">
				<iframe scrolling="auto" frameborder="0"  src="Index\Main.aspx" style="width:100%;height:100%;"></iframe>
			</div>
		</div>
    </div>
    
	<div id="mm" class="easyui-menu" style="width:150px;">
		<div id="mm-tabupdate">刷新</div>
		<div class="menu-sep"></div>
		<div id="mm-tabclose">关闭</div>
		<div id="mm-tabcloseall">全部关闭</div>
		<div id="mm-tabcloseother">除此之外全部关闭</div>
		<div class="menu-sep"></div>
		<div id="mm-tabcloseright">当前页右侧全部关闭</div>
		<div id="mm-tabcloseleft">当前页左侧全部关闭</div>
		<div class="menu-sep"></div>
		<div id="mm-exit">退出</div>
	</div>


</body>
</html>