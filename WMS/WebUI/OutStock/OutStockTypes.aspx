<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OutStockTypes.aspx.cs" Inherits="WebUI_OutStock_OutStockTypes" %>

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
        var BaseWhere = encodeURIComponent("Flag=2");
        var FormID = "OutStockType";

        function getQueryParams(objname, queryParams) {
            var Where = "1=1 ";
            var BillTypeCode = $("#txtQueryBillTypeCode").textbox("getValue");
            var BillTypeName = $("#txtQueryBillTypeName").textbox("getValue");

            if (BillTypeCode != "") {
                Where += " and BillTypeCode like '%" + BillTypeCode + "%'";
            }
            if (BillTypeName != "") {
                Where += " and BillTypeName like '%" + BillTypeName + "%'";
            }

            queryParams.Where = BaseWhere + encodeURIComponent(" and " + Where);
            //queryParams.t = new Date().getTime(); //使系统每次从后台执行动作，而不是使用缓存。
            return queryParams;

        }
        //添加管理员
        function Add() {
            if (SessionTimeOut(SessionUrl)) {
                return false;
            }

            $('#fm').form('clear');
            BindDropDownList();
            $('#AddWin').dialog('open').dialog('setTitle', '新增');
            SetAutoCodeNewID('txtID', 'CMD_BillType', 'BillTypeCode', BaseWhere);
            $('#txtPageState').val("Add");

            $('#txtFlag').val("2");
            $('#txtTaskType').val("12");
            $('#txtTaskLevel').val("3");
            $('#txtIsFixed').val("0");
            $("#txtID").textbox('readonly', false);

            SetInitValue('<%=Session["G_user"] %>');
            SetInitColor();
        }
        //修改管理员
        function Edit() {
            if (SessionTimeOut(SessionUrl)) {
                return false;
            }
            var row = $('#dg').datagrid('getSelected');
            if (row == null || row.length == 0) {
                $.messager.alert("提示", "请选择要修改的行！", "info");
                return false;
            }
            BindDropDownList();
            if (row) {
                var data = { Action: 'FillDataTable', Comd: 'cmd.SelectBillType', Where: "BillTypeCode='" + row.BillTypeCode + "'" };
                $.post(url, data, function (result) {
                    var Product = result.rows[0];
                    $('#AddWin').dialog('open').dialog('setTitle', '编辑');
                    $('#fm').form('load', Product);

                }, 'json');
            }
            $('#txtPageState').val("Edit");
            $('#txtFlag').val("2");
            $('#txtTaskType').val("12");
            $('#txtTaskLevel').val("3");
            $('#txtIsFixed').val("0");
            $("#txtID").textbox("readonly", true);
            SetInitColor();
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
                if (HasExists('CMD_BillType', "BillTypeCode='" + $('#txtID').textbox('getValue') + "'", '类型编码已经存在，请重新修改！'))
                    return false;
                data = { Action: 'Add', Comd: 'cmd.InsertBillType', json: query };
                $.post(url, data, function (result) {
                    if (result.status == 1) {
                        ReloadGrid('dg');
                        $('#AddWin').window('close');
                        
                    } else {
                        $.messager.alert('错误', result.msg, 'error');
                    }
                }, 'json');

            }
            else {
                data = { Action: 'Edit', Comd: 'cmd.UpdateBillType', json: query };
                $.post(url, data, function (result) {
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
                            if (HasExists('VUsed_CMD_BillType', "BillTypeCode='" + item.BillTypeCode + "'", "类型编码 " + item.BillTypeCode + " 已经被其它单据使用，无法删除！"))
                                blnUsed = true;
                            deleteCode.push(item.BillTypeCode);
                        });
                        if (blnUsed)
                            return false;
                        var data = { Action: 'Delete', FormID: FormID, Comd: 'cmd.DeleteBillType', json: "'" + deleteCode.join("','") + "'" };
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
            CheckSelectRow('dg', rowIndex, rowData);
        }
        
 </script> 
</head>
<body class="easyui-layout">
    <table id="dg"  class="easyui-datagrid" 
        data-options="loadMsg: '正在加载数据，请稍等...',fit:true, rownumbers:true,url:'../../Handler/BaseHandler.ashx?Action=PageDate&FormID='+FormID,queryParams:{Where:BaseWhere},
                     pagination:true,pageSize:15, pageList:[15, 20, 30, 50],method:'post',striped:true,fitcolumns:true,toolbar:'#tb',singleSelect:true,selectOnCheck:false,checkOnSelect:false,onCheck:CheckRow,onUncheck:CheckRow"> 
        <thead>
		    <tr>
                <th data-options="field:'',checkbox:true"></th> 
		        <th data-options="field:'BillTypeCode',width:80">类型编码</th>
                <th data-options="field:'BillTypeName',width:100">名称</th>
                <th data-options="field:'Memo',width:100">备注</th>
                <th data-options="field:'Creator',width:80">建单人员</th>
                <th data-options="field:'CreateDate',width:80">建单日期</th>
                <th data-options="field:'Updater',width:80">修改人员</th>
                <th data-options="field:'UpdateDate',width:80">修改日期</th>
		    </tr>
        </thead>
    </table>
    <div id="tb" style="padding: 5px; height: auto">  
    
        <table style="width:100%" >
            <tr>
                <td>
                    类型编码
                    <input id="txtQueryBillTypeCode" class ="easyui-textbox" style="width: 100px" />  
                    名称
                    <input id="txtQueryBillTypeName" class="easyui-textbox" style="width: 100px" />&nbsp;&nbsp;
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
    <div id="AddWin" class="easyui-dialog" style="width: 600px; height: auto; padding: 5px 5px"
        data-options="closed:true,buttons:'#AddWinBtn'"> 
        <form id="fm" method="post">
              <table id="Table1" class="maintable"  width="100%" align="center">			
				<tr>
                    
                    <td align="center" class="musttitle"style="width:90px">
                            类型编码
                    </td>
                    <td  width="210px">
                            &nbsp;<input id="txtID" name="BillTypeCode" 
                                class="easyui-textbox" data-options="required:true" maxlength="20" style="width:180px"/>
                                <input name="PageState" id="txtPageState" type="hidden" />
                                <input name="TaskType" id="txtTaskType" type="hidden" />
                                <input name="TaskLevel" id="txtTaskLevel" type="hidden" />
                                <input name="IsFixed" id="txtIsFixed" type="hidden" value="0" />
                                <input name="Flag" id="txtFlag" type="hidden" value="0" />
                    </td>
                    <td align="center" class="musttitle"style="width:90px"  >
                           名称
                    </td>
                    <td width="210px"> 
                        &nbsp;<input id="txtBillTypeName" name="BillTypeName" class="easyui-textbox" data-options="required:true" maxlength="50" style="width:180px"/>
                    </td>
                </tr>
                <tr style=" height:80px">
                    <td align="center"  class="smalltitle" style="width:90px;height:80px;">
                        备注
                    </td>
                    <td colspan="3" style="height:80px;">
                       &nbsp;<input 
                            id="txtMemo" name="Memo" class="easyui-textbox" 
                            data-options="multiline:true" style="width:478px; height:72px"/>

                    </td>
                </tr>
                 
                 <tr>
                  <td align="center"  class="smalltitle"style="width:90px">
                        修改人员
                  </td> 
                  <td   width="210px"> 
                    &nbsp;<input id="txtCreator" name="Creator" class="easyui-textbox" data-options="editable:false"  style="width:180px"/>
                  </td>
                    <td align="center" class="smalltitle"style="width:90px">
                        建单日期
                  </td> 
                  <td   width="210px">
                  &nbsp;<input id="txtCreateDate" name="CreateDate" class="easyui-textbox" data-options="editable:false"  style="width:180px"/>
                  </td>
                 </tr>
                 <tr>
                   
                  <td align="center"  class="smalltitle"style="width:90px">
                        修改人员
                  </td> 
                  <td   width="210px"> 
                    &nbsp;<input id="txtUpdater" name="Updater" class="easyui-textbox" data-options="editable:false"  style="width:180px"/>
                  </td>
                  <td align="center"  class="smalltitle"style="width:90px">
                        修改日期
                  </td> 
                  <td width="210px">
                    &nbsp;<input id="txtUpdateDate" name="UpdateDate" class="easyui-textbox" data-options="editable:false"  style="width:180px"/>
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