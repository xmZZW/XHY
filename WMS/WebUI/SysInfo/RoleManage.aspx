<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RoleManage.aspx.cs" Inherits="WebUI_SysInfo_RoleManage" %>
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
        var FormID = "Power";
        var url = "../../Handler/BaseHandler.ashx";
        var SecurityUrl = "SecurityHandler.ashx";
        var SessionUrl = '<% =ResolveUrl("~/Login.aspx")%>';

        function getQueryParams(objName, queryParams) {
            return queryParams;
        }
        function getDetail(index, data) {
            var selectdata = data;
            if (selectdata) {

                $('#hdnGroupID').val(selectdata.GroupID);
                $('#hdnGroupName').val(selectdata.GroupName);
                
                $('#txtGroupName').html("<b>"+selectdata.GroupName + "--用户组权限设置</b>");
                $('#dgSub').datagrid({
                    url: '../../Handler/BaseHandler.ashx?Action=PageDate&Comd=Security.SelectGroupUser',
                    queryParams: { Where: encodeURIComponent("U.GroupID='" + selectdata.GroupID + "'") }
                });
                $('#btnSave').linkbutton('enable');
                if (selectdata.GroupName == "admin") {
                    $('#btnSave').linkbutton('disable');
                }


                $('#tt').tree({
                    checkbox:true,
                    url: SecurityUrl,
                    queryParams: { Action: 'GroupTree', GroupID: selectdata.GroupID }
                }); 


            }
        }
        function CheckRow(rowIndex, rowData) {
            CheckSelectRow('dg', rowIndex, rowData);
        }

        function Save() {
            var nodes = $('#tt').tree('getChecked');
            var MenuCode = [];
            if (nodes) {
                $.each(nodes, function (index, item) {
                    if (typeof (item.children) == "undefined")
                        MenuCode.push(item.id);
                });
            }
            var groupid = $('#hdnGroupID').val();
            var data = { Action: 'UpdateGroupOperation', GroupID: groupid, json: MenuCode.join(",") };
            $.post(SecurityUrl, data, function (result) {
                if (result.status == 1) {
                    $.messager.alert('提示', '数据保存成功！');
                } else {
                    $.messager.alert('错误', result.msg, 'error');
                }
            }, 'json');
        }


        var RMReturnValue = new Array();
        var unRMReturnValue = new Array();
        function ManageUser() {

            if (SessionTimeOut(SessionUrl)) {
                return false;
            }
            RMReturnValue = [];
            unRMReturnValue = [];
            var GroupID = $('#hdnGroupID').val();
            var GroupName = $('#hdnGroupName').val();  
            $('#dgSelect').datagrid({
                url: 'SecurityHandler.ashx?Action=SelectRoleManageUser',
                queryParams: { GroupID: GroupID }
            });
            $('#SelectWin').dialog('open').dialog('setTitle', '用户组 ' + GroupName + '--用户管理');
        }

        function LoadSelectSuccess(data) {
            var GroupID = $('#hdnGroupID').val();
            if (data) {
                $.each(data.rows, function (index, rowData) {
                    if (rowData.GroupID == GroupID) {
                        var bln = false;
                        for (var i = 0; i < unRMReturnValue.length; i++) {
                            if (isObjectValueEqual(unRMReturnValue[i], rowData)) {
                                bln = true;
                                break;
                            }
                        }
                        if (!bln) {
                            //设置选定，并添加到RM
                            $('#dgSelect').datagrid('checkRow', index);
                            bln = false;
                            for (var i = 0; i < RMReturnValue.length; i++) {
                                if (isObjectValueEqual(RMReturnValue[i], rowData)) {
                                    bln = true;
                                    break;
                                }
                            }
                            if (!bln) {
                                RMReturnValue.push(rowData);
                             }
                        }
                    }
                });
            }
        }
        

        function RMSelectCheckRow(rowIndex, rowData) {
            var bln = false;
            for (var i = 0; i < RMReturnValue.length; i++) {
                if (isObjectValueEqual(RMReturnValue[i], rowData)) {
                    bln = true;
                    break;
                }
            }
            if (!bln)
                RMReturnValue.push(rowData);

           
            for (var i = 0; i < unRMReturnValue.length; i++) {
                if (isObjectValueEqual(unRMReturnValue[i], rowData)) {
                    unRMReturnValue.splice(unRMReturnValue.indexOf(unRMReturnValue[i]), 1);
                    break;
                }
            }
             

        }
        function RMSelectUnCheckRow(rowIndex, rowData) {
            for (var i = 0; i < RMReturnValue.length; i++) {
                if (isObjectValueEqual(RMReturnValue[i], rowData)) {
                    RMReturnValue.splice(RMReturnValue.indexOf(ReturnValue[i]), 1);
                    break;
                }
            }
            var bln = false;
            for (var i = 0; i < unRMReturnValue.length; i++) {
                if (isObjectValueEqual(unRMReturnValue[i], rowData)) {
                    bln = true;
                    break;
                }
            }
            if (!bln)
                unRMReturnValue.push(rowData);

        }

        function RMSelectCheckRowAll(rows) {
            $.each(rows, function (index, rowData) {
                var bln = false;
                for (var i = 0; i < RMReturnValue.length; i++) {
                    if (isObjectValueEqual(RMReturnValue[i], rowData)) {
                        bln = true;
                        break;
                    }
                }
                if (!bln)
                    RMReturnValue.push(rowData);

                for (var i = 0; i < unRMReturnValue.length; i++) {
                    if (isObjectValueEqual(unRMReturnValue[i], rowData)) {
                        unRMReturnValue.splice(unRMReturnValue.indexOf(unRMReturnValue[i]), 1);
                        break;
                    }
                }
            });

        }
        function RMSelectUnCheckRowAll(rows) {
            $.each(rows, function (index, rowData) {
                var bln = false;
                for (var i = 0; i < unRMReturnValue.length; i++) {
                    if (isObjectValueEqual(unRMReturnValue[i], rowData)) {
                        bln = true;
                        break;
                    }
                }
                if (!bln)
                    unRMReturnValue.push(rowData);

                for (var i = 0; i < RMReturnValue.length; i++) {
                    if (isObjectValueEqual(RMReturnValue[i], rowData)) {
                        RMReturnValue.splice(RMReturnValue.indexOf(RMReturnValue[i]), 1);
                        break;
                    }
                }
            });

        }
        function SaveUser() {
            var UserCode = [];
              for (var i = 0; i < RMReturnValue.length; i++) {

                  UserCode.push(RMReturnValue[i].UserID);
              }
              var GroupID = $('#hdnGroupID').val();
            var data = { Action: 'UpdateUserGroup',GroupID:GroupID,  json: UserCode.join(",") };
            $.post(SecurityUrl, data, function (result) {
                if (result.status == 1) {
                    $('#SelectWin').window('close');
                    // ReloadGrid("dg");
                    $('#dgSub').datagrid('reload');  
                    $.messager.alert('提示', '数据保存成功！');

                } else {
                    $.messager.alert('错误', result.msg, 'error');
                }
            }, 'json');
                
        }


    </script>
</head>
<body>
     <div id="cc" class="easyui-layout" data-options="fit:true">  
        <div data-options="region:'west',split:true" style="width:450px;">
            <div class="easyui-layout" data-options="fit:true"> 
                <div data-options="region:'north', split:true" style="height:260px;">
                    <table id="dg"  class="easyui-datagrid" data-options="loadMsg: '正在加载数据，请稍等...',fit:true, rownumbers:true,url:'../../Handler/BaseHandler.ashx?Action=PageDate&FormID='+FormID,
                             pagination:true,pageSize:15, pageList:[15, 20, 30, 50],method:'post',striped:true,fitcolumns:true,singleSelect:true,selectOnCheck:false,checkOnSelect:false,onLoadSuccess: function(data){$('#dg').datagrid('selectRow',0);},onSelect:getDetail"> 
                          <thead>
                            <tr>
                                <th data-options="field:'GroupID',width:100">用户组ID</th>
                                <th data-options="field:'GroupName',width:180">用户组名称</th>
		                    </tr>
                        </thead>
                    </table>      
                </div>   
                <div data-options="region:'center',title:'用户组成员',split:true">
                    <table id="dgSub" class="easyui-datagrid" data-options="loadMsg: '正在加载数据，请稍等...',fit:true, rownumbers:true,pagination:true,pageSize:15, pageList:[15, 20, 30, 50],method:'post',striped:true,fitcolumns:true"> 
                        <thead>
		                    <tr>
                                <th data-options="field:'UserID',width:100">用户ID</th>
                                <th data-options="field:'UserName',width:100">用户账号</th>
                                <th data-options="field:'GroupName',width:80">用户组</th>
		                    </tr>
                        </thead>
                    </table>
                </div>
            </div>
        </div>
        <div data-options="region:'center'">
             <div class="easyui-layout" data-options="fit:true">   
                <div data-options="region:'north'" style="height:35px">
                     <table style="width:100%">
                        <tr>
                            <td id="txtGroupName" align="left">
                               <b>用户组权限设置</b>
                            </td>
                            <td align="right" style="width:50%" >
                                <input type="hidden" id="hdnGroupID" />
                                <input type="hidden" id="hdnGroupName" />
                                <a id="btnSave" href="javascript:void(0)" onclick="Save()" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true">保存</a>
                                <a href="javascript:void(0)" onclick="ManageUser()" class="easyui-linkbutton" data-options="iconCls:'icon-man',plain:true">管理用户</a>
                                <a href="javascript:void(0)" onclick="Exit()" class="easyui-linkbutton" data-options="iconCls:'icon-no',plain:true">离开</a>
                            </td>
                        </tr>
                    </table>
                </div>
                <div data-options="region:'center'">
                     <ul id="tt"></ul> 
                </div>   
             </div> 
        </div>
         
    </div>

    <div  id="SelectWin" style="width:480px;height:450px" class="easyui-dialog" data-options="closed:true,buttons:'#SelectWinBtn'">
             <table id="dgSelect"  class="easyui-datagrid" data-options="loadMsg: '正在加载数据，请稍等...',fit:true, rownumbers:true,
                         pagination:true,pageSize:15, pageList:[15, 20, 30, 50],method:'post',striped:true,fitcolumns:true,toolbar:'#tbSelect',singleSelect:true,selectOnCheck:false,checkOnSelect:false,onCheck:RMSelectCheckRow,onUncheck:RMSelectUnCheckRow,onCheckAll:RMSelectCheckRowAll,onUncheckAll:RMSelectUnCheckRowAll,onLoadSuccess:LoadSelectSuccess"> 
                <thead>
		            <tr>
                    <th data-options="field:'chk',checkbox:true"></th> 
                    <th data-options="field:'UserName',width:100">用户账号</th>
                    <th data-options="field:'EmployeeCode',width:120">用户姓名</th>
                    <th data-options="field:'GroupName',width:120">用户组</th>
                   
		        </tr>
            </thead>
        </table>
        <div id="SelectWinBtn">
            <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="SaveUser()">确定</a>
            <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="javascript:$('#SelectWin').dialog('close')">关闭</a>
         </div>
         <div id="tbSelect" style="padding: 5px; height: auto">  
    
            <table >
                <tr>
                    <td>
                        用户组ID
                        <input id="txtSelectGroupID" class ="easyui-textbox" style="width: 100px" />  
                        用户组名称
                        <input id="txtSelectGroupName" class="easyui-textbox" style="width: 100px" />   
                        
                         
                    </td>
                     
                </tr>
            </table>
        </div>
    </div>
</body>
</html>
