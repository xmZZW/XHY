<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OperationLog.aspx.cs" Inherits="WebUI_SysInfo_OperationLog" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
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
    <script type="text/javascript" language="javascript">

        //       $("input",$("#loginName").next("span")).blur(function(){  
        //            alert("登录名已存在");  
        //        })
        var url = "../../Handler/BaseHandler.ashx";
        var SessionUrl = '<% =ResolveUrl("~/Login.aspx")%>';
        var FormID = "OperateLog";
        function getQueryParams(objname, queryParams) {
            var Where = "1=1 ";
            var UserName = $("#txtQueryUserName").textbox("getValue");
            var Module = $("#txtQueryModule").textbox("getValue");
            var StartDate = $("#txtQueryStartDate").datebox('getValue');
            var EndDate = $("#txtQueryEndDate").datebox('getValue');

            if (UserName != "") {
                Where += " and LoginUser like '%" + LoginUser + "%'";
            }
            if (Module != "") {
                Where += " and LoginModule like '%" + LoginModule + "%'";
            }
            if (StartDate != "") {
                Where += " and CONVERT(nvarchar(10),logintime,120) >= '" + StartDate + "'";
            }
            if (EndDate != "") {
                Where += " and CONVERT(nvarchar(10),logintime,120) <= '" + EndDate + "'";
            }


            queryParams.Where = encodeURIComponent(Where);
            //queryParams.t = new Date().getTime(); //使系统每次从后台执行动作，而不是使用缓存。
            return queryParams;

        }



        //删除管理员
        function Delete() {
            if (SessionTimeOut(SessionUrl)) {
                return false;
            }
            if (!GetPermisionByFormID("OperateLog", 2)) {
                alert("您没有删除权限！");
                return false;
            }
            var checkedItems = $('#dg').datagrid('getChecked');
            if (checkedItems == null || checkedItems.length == 0) {
                $.messager.alert("提示", "请选择要删除的行！", "info");
                return false;
            }
            if (checkedItems) {
                $.messager.confirm('提示', '你确定要删除吗？', function (r) {
                    if (r) {
                        var deleteCode = [];
                        $.each(checkedItems, function (index, item) {
                            deleteCode.push(item.GroupID);
                        });
                        var data = { Action: 'Delete', FormID: FormID, Comd: 'Security.DeleteOperatorLog', json: "'" + deleteCode.join("','") + "'" };
                        $.post(url, data, function (result) {
                            if (result.status == 1) {
                                ReloadGrid('dg');

                                
                            } else {
                                $.messager.alert('错误', result.msg, 'error');
                            }
                        }, 'json');

                    }
                });
            }
        }

        function Clear() {
            if (SessionTimeOut(SessionUrl)) {
                return false;
            }
            if (!GetPermisionByFormID("OperateLog", 2)) {
                alert("您没有删除权限！");
                return false;
            }


            $.messager.confirm('提示', '你确定要删除吗？', function (r) {
                if (r) {
                    var data = { Action: 'Clear', FormID: 'OperateLog' };
                    $.post('../../Handler/OtherHandler.ashx', data, function (result) {
                        if (result.status == 1) {
                            ReloadGrid('dg');

                            
                        } else {
                            $.messager.alert('错误', result.msg, 'error');
                        }
                    }, 'json');

                }
            });

        }

        function CheckRow(rowIndex, rowData) {
            CheckSelectRow('dg', rowIndex, rowData);
        }
      
         
 </script> 
</head>
<body class="easyui-layout">
    <table id="dg"  class="easyui-datagrid" 
        data-options="loadMsg: '正在加载数据，请稍等...',fit:true, rownumbers:true,url:'../../Handler/BaseHandler.ashx?Action=PageDate&FormID='+FormID,
                     pagination:true,pageSize:15, pageList:[15, 20, 30, 50],method:'post',striped:true,fitcolumns:true,toolbar:'#tb',singleSelect:true,selectOnCheck:false,checkOnSelect:false,onCheck:CheckRow,onUncheck:CheckRow"> 
        <thead>
		    <tr>
                <th data-options="field:'',checkbox:true"></th> 
		        <th data-options="field:'LoginUser',width:120">操作用户</th>
                <th data-options="field:'LoginTime',width:150">操作时间</th>
                <th data-options="field:'LoginModule',width:150">操作模块</th>
                <th data-options="field:'ExecuteOperator',width:300">操作内容</th>
                
		    </tr>
        </thead>
    </table>
    <div id="tb" style="padding: 5px; height: auto">  
    
        <table style="width:100%" >
            <tr>
                <td>
                    用户账号
                    <input id="txtQueryUserName" class ="easyui-textbox" style="width: 100px" />  
                     操作模块
                    <input id="txtQueryModule" class ="easyui-textbox" style="width: 100px" />
                    日期从
                    <input id="txtQueryStartDate" class="easyui-datebox" style="width: 100px" />
                    至
                    <input id="txtQueryEndDate" class="easyui-datebox" style="width: 100px" />
                    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="ReloadGrid('dg')">查询</a> 
                </td>
                <td style="width:*" align="right">
                     
                     <a href="javascript:void(0)" onclick="Delete()" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true">删除</a>
                      <a href="javascript:void(0)" onclick="Clear()" class="easyui-linkbutton" data-options="iconCls:'icon-clear',plain:true">清空</a>
                     <a href="javascript:void(0)" onclick="Exit()" class="easyui-linkbutton" data-options="iconCls:'icon-no',plain:true">离开</a>
                </td>
            </tr>
        </table>
   </div>
    
 

</body>
</html>