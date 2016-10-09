<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UserList.aspx.cs" Inherits="WebUI_SysInfo_UserList" %>

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
        var SecurityUrl = "SecurityHandler.ashx";
        var SessionUrl = '<% =ResolveUrl("~/Login.aspx")%>';
        var FormID = "User";
        function getQueryParams(objname, queryParams) {
            var Where = "1=1 ";
            var UserName = $("#txtQueryUserName").textbox("getValue");
            var EmployeeCode = $("#txtQueryEmployeeCode").textbox("getValue");

            if (UserName != "") {
                Where += " and UserName like '%" + UserName + "%'";
            }
            if (EmployeeCode != "") {
                Where += " and EmployeeCode like '%" + EmployeeCode + "%'";
            }

            queryParams.Where = encodeURIComponent(Where);
            //queryParams.t = new Date().getTime(); //使系统每次从后台执行动作，而不是使用缓存。
            return queryParams;

        }
        //添加管理员
        function Add() {
            if (SessionTimeOut(SessionUrl)) {
                return false;
            }
            if (!GetPermisionByFormID("User", 0)) {
                alert("您没有新增权限！");
                return false;
            }
            $('#fm').form('clear');
            BindDropDownList();
            $('#AddWin').dialog('open').dialog('setTitle', '新增');
            
            $('#txtPageState').val("Add");
            $("#txtUserName").textbox('readonly', false);
            
        }
        //修改管理员
        function Edit() {
            if (SessionTimeOut(SessionUrl)) {
                return false;
            }
            if (!GetPermisionByFormID("User", 1)) {
                alert("您没有修改权限！");
                return false;
            }
            var row = $('#dg').datagrid('getSelected');
            if (row == null || row.length == 0) {
                $.messager.alert("提示", "请选择要修改的行！", "info");
                return false;
            }
            if (row.UserName == 'admin') {
                $.messager.alert("提示", "超级用户资料不能修改！", "info");
                return false;
            }
            BindDropDownList();
            if (row) {
                var data = { Action: 'FillDataTable', Comd: 'Security.SelectUser', Where: "UserID='" + row.UserID + "'" };
                $.post(url, data, function (result) {
                    var Product = result.rows[0];
                    $('#AddWin').dialog('open').dialog('setTitle', '编辑');
                    $('#fm').form('load', Product);

                }, 'json');
            }


            $('#txtPageState').val("Edit");
            if ($('#txtUserName').textbox('getValue') == "admin")
                $("#txtUserName").textbox("readonly", true);
        }
        //绑定下拉控件
        function BindDropDownList() {

        }

        //保存信息
        function Save() {
            if (SessionTimeOut(SessionUrl)) {
                return false;
            }
            if (!$("#fm").form('validate')) {
                return false;
            }
            var query = createParam();
            var test = $('#txtPageState').val();
            var data;
            if (test == "Add") {
                //判断单号是否存在
                if (HasExists('SYS_USERLIST', "UserName='" + $('#txtUserName').textbox('getValue') + "'", '用户账号已经存在，请重新修改！'))
                    return false;
                data = { Action: 'AddUser', UserName: $('#txtUserName').textbox('getValue'), EmployeeCode: $('#txtEmployeeCode').textbox('getValue'), Memo: $('#txtMemo').textbox('getValue') };
                $.post(SecurityUrl, data, function (result) {
                    if (result.status == 1) {
                        ReloadGrid('dg');
                        $('#AddWin').window('close');
                        
                    } else {
                        $.messager.alert('错误', result.msg, 'error');
                    }
                }, 'json');

            }
            else {
                if (HasExists('SYS_USERLIST', "UserName='" + $('#txtUserName').textbox('getValue') + "' and UserID<>"+ $('#txtUserID').val(), '用户账号已经存在，请重新修改！'))
                    return false;
                data = { Action: 'UpdateUser', UserName: $('#txtUserName').textbox('getValue'), EmployeeCode: $('#txtEmployeeCode').textbox('getValue'), Memo: $('#txtMemo').textbox('getValue'), UserID: $('#txtUserID').val() };
                $.post(SecurityUrl, data, function (result) {
                    if (result.status == 1) {
                        ReloadGrid('dg');
                        $('#AddWin').window('close');
                        
                    } else {
                        $.messager.alert('错误', result.msg, 'error');
                    }
                }, 'json');

            }
        }
        //删除管理员
        function Delete() {
            if (SessionTimeOut(SessionUrl)) {
                return false;
            }
            if (!GetPermisionByFormID("User", 2)) {
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
                        var blnUsed = false;
                        $.each(checkedItems, function (index, item) {
                            if (item.UserName == "admin") {
                                alert("管理员账号 admin不能删除！");
                                blnUsed = true;
                            }

                            deleteCode.push(item.UserID);
                        });
                        if (blnUsed)
                            return false;
                        var data = { Action: 'Delete', FormID: FormID, Comd: 'Security.DeleteUser', json: "'" + deleteCode.join("','") + "'" };
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
        function CheckRow(rowIndex, rowData) {
            if (rowData.UserName == 'admin') {
                $('#dg').datagrid('uncheckRow', rowIndex);
            }
            else {
                CheckSelectRow('dg', rowIndex, rowData);
            }
        }
        function UnCheckRow(rowIndex, rowData) {
            CheckSelectRow('dg', rowIndex, rowData);
        }
        function CheckAll(rows) {
            $.each(rows, function (rowIndex, rowData) {
                if (rowData.UserName == 'admin') {
                    $('#dg').datagrid('uncheckRow', rowIndex);
                }

            });
        }
 </script> 
</head>
<body class="easyui-layout">
    <table id="dg"  class="easyui-datagrid" 
        data-options="loadMsg: '正在加载数据，请稍等...',fit:true, rownumbers:true,url:'../../Handler/BaseHandler.ashx?Action=PageDate&FormID='+FormID,
                     pagination:true,pageSize:15, pageList:[15, 20, 30, 50],method:'post',striped:true,fitcolumns:true,toolbar:'#tb',singleSelect:true,selectOnCheck:false,checkOnSelect:false,onCheck:CheckRow,onUncheck:UnCheckRow,onCheckAll:CheckAll"> 
        <thead>
        <thead>
		    <tr>
                <th data-options="field:'',checkbox:true"></th> 
		        <th data-options="field:'UserName',width:80">用户账号</th>
                <th data-options="field:'EmployeeCode',width:100">用户姓名</th>
                <th data-options="field:'Memo',width:300">备注</th>
                
		    </tr>
        </thead>
    </table>
    <div id="tb" style="padding: 5px; height: auto">  
    
        <table style="width:100%" >
            <tr>
                <td>
                    用户账号
                    <input id="txtQueryUserName" class ="easyui-textbox" style="width: 100px" />  
                    用户姓名
                    <input id="txtQueryEmployeeCode" class="easyui-textbox" style="width: 100px" />&nbsp;&nbsp;
                    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="ReloadGrid('dg')">查询</a> 
                </td>
                <td style="width:*" align="right">
                     <a href="javascript:void(0)" onclick="Add()" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">新增</a>  
                     <a href="javascript:void(0)" onclick="Edit() " class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">修改</a>  
                     <a href="javascript:void(0)" onclick="Delete()" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true">删除</a>
                     <a href="javascript:void(0)" onclick="Exit()" class="easyui-linkbutton" data-options="iconCls:'icon-no',plain:true">离开</a>
                </td>
            </tr>
        </table>
   </div>
      <%-- 弹出操作框--%>
    <div id="AddWin" class="easyui-dialog" style="width: 500px; height: auto; padding: 5px 5px"
        data-options="closed:true,buttons:'#AddWinBtn'"> 
        <form id="fm" method="post">
              <table id="Table1" class="maintable"  width="100%" align="center">			
				<tr>
                    
                    <td align="center" class="musttitle"style="width:90px">
                            用户账号
                    </td>
                    <td  width="160px">
                            &nbsp;<input id="txtUserName" name="UserName" 
                                class="easyui-textbox" data-options="required:true" maxlength="20" style="width:130px"/>
                                <input name="PageState" id="txtPageState" type="hidden" />
                                <input name="UserID" id="txtUserID" type="hidden" />
                               
                    </td>
                    <td align="center" class="musttitle"style="width:90px"  >
                           用户姓名
                    </td>
                    <td width="160px"> 
                        &nbsp;<input id="txtEmployeeCode" name="EmployeeCode" class="easyui-textbox" data-options="required:true" maxlength="50" style="width:130px"/>
                    </td>
                </tr>
                <tr style=" height:80px">
                    <td align="center"  class="smalltitle" style="width:90px;height:80px;">
                        备注
                    </td>
                    <td colspan="3" style="height:80px;">
                       &nbsp;<input 
                            id="txtMemo" name="Memo" class="easyui-textbox" 
                            data-options="multiline:true" style="width:378px; height:72px"/>

                    </td>
                </tr>
		</table>
        </form>
    </div>
    <div id="AddWinBtn">
        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="Save()">保存</a>
        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="javascript:$('#AddWin').dialog('close')">关闭</a>
    </div>

</body>
</html>