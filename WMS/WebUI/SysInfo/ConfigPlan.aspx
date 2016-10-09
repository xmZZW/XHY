<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ConfigPlan.aspx.cs" Inherits="WebUI_SysInfo_ConfigPlan" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" type="text/css" href="~/Css/default.css" />
    <link rel="stylesheet" type="text/css" href="~/Css/icon.css" />
    <link rel="stylesheet" type="text/css" href="../../EasyUI/themes/default/easyui.css" />
    <link rel="stylesheet" type="text/css" href="../../EasyUI/themes/icon.css" />
    <script type="text/javascript" src="../../EasyUI/jquery.min.js"></script>
    <script type="text/javascript" src="../../EasyUI/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../../EasyUI/locale/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../../JScript/JsAjax.js" ></script>
    <script type="text/javascript">
        function Save() {
            var nodes = $('#whTree').tree('getChecked');
            var MenuCode = [];
            if (nodes) {
                $.each(nodes, function (index, item) {
                    if(typeof(item.children) == "undefined")
                        MenuCode.push(item.id);
                });
            }
            var data = { Action: 'UpdateQuickDestop', json: MenuCode.join(",") };
            $.post('ConfigPlanTree.ashx', data, function (result) {
                if (result.status == 1) {
                    $.messager.alert('提示', '数据保存成功！');
                } else {
                    $.messager.alert('错误', result.msg, 'error');
                }
            }, 'json');

        }
    </script>
</head>
<body>
   <div class="easyui-layout" data-options="fit:true">
       <div data-options="region:'north',split:true" style="height:40px;">
        <table style="width:100%">
            <tr>
                <td align="right">
                    <a href="javascript:void(0)" onclick="Save()" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true">保存</a>
                    <a href="javascript:void(0)" onclick="Exit()" class="easyui-linkbutton" data-options="iconCls:'icon-no',plain:true">离开</a>
                </td>
            </tr>
        </table>
        </div>   
        <div data-options="region:'center', split:true" >
            <ul id="whTree" class="easyui-tree" data-options="checkbox:true, url:'ConfigPlanTree.ashx?Action=GetTree'"></ul>  
        </div>
   </div>  
   
</body>
</html>
