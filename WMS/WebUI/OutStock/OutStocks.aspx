<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OutStocks.aspx.cs" Inherits="WebUI_OutStock_OutStocks" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
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
        var url = "../../Handler/BaseHandler.ashx";
        var urlOther = "../../Handler/OtherHandler.ashx";
        var SessionUrl = '<% =ResolveUrl("~/Login.aspx")%>';
        var BaseWhere = encodeURIComponent("BillID like 'OS%'");

        //点击查询的时候参数设置。
        function getQueryParams(objName, queryParams) {
            var Where = " 1=1 ";
            if (objName == "dg") {
                var BillID = $("#txtQueryBillID").textbox("getValue");
                var BillDate = $("#txtQueryBillDate").textbox("getValue");
                if (BillID != "") {
                    Where += " and BillID like '%" + BillID + "%'";
                }
                if (BillDate!="") {
                    Where+= " and CONVERT(nvarchar(10), BillDate,120) = '" + BillDate + "'";
                }
                Where = BaseWhere + encodeURIComponent(" and" + Where);
            } else {
                var productcode = $("#txtQueryProductCode").textbox("getValue");
                var productname = $("#txtQueryProductName").textbox("getValue");
                if (productcode != "") {
                    Where += " and productcode like '%" + productcode + "%'";
                }
                if (productname != "") {
                    Where += " and productname like '%" + productname + "%'";
                }
                Where = encodeURIComponent(Where);

            }
                queryParams.Where = Where;
                return queryParams;
         }
         //选择表绑定数据
         function BindSelectUrl(objName) {

             var Comd = "CMD.SelectProductQty";
             $('#dgSelect').datagrid({
                 url: '../../Handler/BaseHandler.ashx?Action=PageDate&Comd=' + Comd,
                 pageNumber: 1,
                 queryParams: { Where: encodeURIComponent("1=1") }
             });
         }  
        function CheckRow(rowIndex, rowData) {
            CheckSelectRow('dg', rowIndex, rowData);
        }       
        function Add() {
            if (SessionTimeOut(SessionUrl)) {
                return false;
            }
            if (!GetPermisionByFormID("OutStock", 0)) {
                alert("您没有新增权限！");
                return false;
            }
            $('#fm').form('clear');
            BindDropDownList();
            $('#txtBillDate').datebox('setValue', new Date().Format("yyyy/MM/dd"));
            $('#dgSubAdd').datagrid('loadData', { total: 0, rows: [] });//下载本地数据。
            $('#AddWin').dialog('open').dialog('setTitle', '新增');
            SetAutoCodeByTableName('txtID', 'OS', '1=1', 'WMS_BillMaster', $('#txtBillDate').datebox('getValue'));
            $('#txtPageState').val("Add");
            $("#txtID").textbox('readonly', false);
            $("#txtBillDate").datebox("readonly", false);
            SetInitValue('<%=Session["G_user"] %>');
            SetInitColor();
        }
        //保存的时候，设置细表每行的数据。
        function createSubParamRow(RowData) {
            RowData.BillID = $('#txtID').textbox('getValue');
            RowData.Barcode = '0';
            RowData.CellCode = '';
            RowData.NewCellCode = '';
            RowData.ProductName = '';
            RowData.ProductNo = '';

        }

       function Save() {
           if (SessionTimeOut(SessionUrl)) {
               return false;
           }
           if (!$("#fm").form('validate')) {
               return false;
           }
            if ($('#dgSubAdd').datagrid('getRows').length==0) {
                $.messager.alert('提示','明细无资料');
                return false;
            }
            if (!endEditing()) {
                return false;
            }
            var MainQuery=createParam();
            var SubQuery=createSubParam();
            var test=$('#txtPageState').val();
            var data;
            if (test=="Add") {
                if (HasExists('WMS_BillMaster', "BillID='" + $('#txtID').textbox('getValue') + "'", '出库单号已经存在，请重新修改！'))
                    return false;
                data = { Action: 'AddMainDetail', MainComd: 'WMS.InsertOutStockBill', SubComd: 'WMS.InsertOutStockDetail', MainJson: MainQuery, SubJson: SubQuery };
                $.post(url, data, function (result) {
                    if (result.status == 1) {
                        ReloadGrid("dg");
                        $('#AddWin').window('close');
                        
                    } else {
                        $.messager.alert('错误', result.msg, 'error');
                    }
                }, 'json');
            }
            else {//修改
                data = { Action: 'EditMainDetail', MainComd: 'WMS.UpdateOutStock', SubDelComd: 'WMS.DeleteBillDetail', SubComd: 'WMS.InsertOutStockDetail', MainJson: MainQuery, SubJson: SubQuery };
                $.post(url, data, function (result) {
                    if (result.status == 1) {
                        ReloadGrid("dg");
                        $('#AddWin').window('close');
                        
                    } else {
                        $.messager.alert('错误', result.msg, 'error');
                    }
                }, 'json');
            }
         
         }
        function Edit() {
            if (SessionTimeOut(SessionUrl)) {
                return false;
            }
            if (!GetPermisionByFormID("OutStock", 1)) {
                alert("您没有修改权限！");
                return false;
            }
            var row = $('#dg').datagrid('getSelected');
            var StateDes = GetFieldValue("View_WMS_BillMaster", "StateDesc", "BillID='" +row.BillID + "'");
            if (HasExists('WMS_BillMaster', "BillID='" + row.BillID + "'and State!=0", "出库单号 " + row.BillID + "已" + StateDes + ",无法修改！"))
                return false;
            BindDropDownList();
            if (row) {
                var data = { Action: 'FillDataTable', Comd: 'WMS.SelectBillMaster', Where: "BillID='" + row.BillID + "'" };
                $.post(url, data, function (result) {
                    var Product = result.rows[0];
                    $('#AddWin').dialog('open').dialog('setTitle', '编辑');
                    $('#fm').form('load', Product);
                }, 'json');

                $('#dgSubAdd').datagrid({
                    url: '../../Handler/BaseHandler.ashx?Action=FillDataTable&Comd=WMS.SelectBillDetail',
                    queryParams: { Where: encodeURIComponent("BillID='" + row.BillID + "'") }
                });
            }
            $('#txtPageState').val("Edit");
            $("#txtID").textbox("readonly", true);
            SetInitColor();
        
         }
         function Delete() {
             if (SessionTimeOut(SessionUrl)) {
                 return false;
             }
             if (!GetPermisionByFormID("OutStock", 2)) {
                 alert("您没有删除权限！");
                 return false;
             }
             var checkedItems = $('#dg').datagrid('getChecked');
             if (checkedItems.length == 0) {
                 $.messager.alert("提示", "请选择要删除的行！", "info");  
                 return false;
             }

            if (checkedItems) {
                $.messager.confirm('提示', '你确定要删除吗？', function (r) {
                    if (r) {
                        var deleteCode = [];
                        var blnUsed = false;
                        $.each(checkedItems, function (index, item) {
                            var StateDes = GetFieldValue("View_WMS_BillMaster", "StateDesc", "BillID='" + item.BillID + "'");
                            if (HasExists('WMS_BillMaster', "BillID='" + item.BillID + "'and State!=0", "出库单号 " + item.BillID + "已" + StateDes + ",无法删除！")) {
                                  blnUsed = true;
                            } else {
                                if (HasExists('VUsed_WMS_BillMaster', "BillID='" + item.BillID + "'", "出库单号 " + item.BillID + " 已经被其它单据使用，无法删除！"))
                                        blnUsed = true;
                            }
                            deleteCode.push(item.BillID);
                        });
                        if (blnUsed)
                            return false;

                        var data = { Action: 'DelMainDetail', MainComd: 'WMS.DeleteBillMaster', SubComd: "WMS.DeleteBillDetail", json: "'" + deleteCode.join("','") + "'" };
                        $.post(url, data, function (result) {
                            if (result.status == 1) {
                                ReloadGrid("dg");


                            } else {
                                $.messager.alert('错误', result.msg, 'error');
                            }
                        }, 'json');
                    }
                });
            }
            }
         
        function CheckBill() {
            var checkRow = $('#dg').datagrid('getSelected');
            if (checkRow) {
                var BillID = checkRow.BillID;
                var state =GetFieldValue("WMS_BillMaster", "State", "BillID='" + BillID + "'");
                if ( state == 1) {
                    $.messager.alert("提示", BillID + "单号已审核!", "info");
                    return false;
                }
                if (state > 1) {
                    var StateDes = GetFieldValue("View_WMS_BillMaster", "StateDesc", "BillID='" + BillID + "'");
                    $.messager.alert("提示", BillID + "单号已" + StateDes + "，无法再审核!", "info");
                    return false;
                }
                var data = { Action: 'CheckTaskWork', Comd: "WMS.UpdateCheckBillMaster", Where: "BillID='" + BillID + "'" };
                $.post(urlOther, data, function (result) {
                    if (result.status == 1) {
                        $.messager.alert('成功', result.msg, 'info');
                        ReloadGrid("dg");
                    } else {
                        $.messager.alert('错误', result.msg, 'error');
                    }
                }, 'json');
            } else {
                $.messager.alert("提示", "请选择单据！", "info");
                return false;
            }

        }
        function OutWork() {
            var checkRow = $('#dg').datagrid('getSelected');
            if (checkRow) {
                var BillID = checkRow.BillID;
                var state = GetFieldValue("WMS_BillMaster", "State", "BillID='" + BillID + "'");
                if (state == 0) {
                    $.messager.alert("提示", BillID + "单号还未审核不能作业，请审核后，再进行出库作业。", "info");
                    return false;
                }
                if (state > 1) {
                    var StateDes = GetFieldValue("View_WMS_BillMaster", "StateDesc", "BillID='" + BillID + "'");
                    $.messager.alert("提示", BillID + "单号已"+StateDes+"，不能再进行出库作业。", "info");
                    return false;
                }
                var data = { Action: 'OutTaskWork', Comd: "WMS.SpOutStockTask", Where: BillID };
                $.post(urlOther, data, function (result) {
                    if (result.status == 1) {
                    $.messager.alert('成功', result.msg, 'info');
                    ReloadGrid("dg");
                    } else {
                        $.messager.alert('错误', result.msg, 'error');
                    }
               }, 'json');
            } else {
                $.messager.alert("提示", "请选择单据！", "info");
                return false;
            }
       }
        function CancelWork() {
            var checkRow = $('#dg').datagrid('getSelected');
            if (checkRow) {
                var BillID = checkRow.BillID;
                var state = GetFieldValue("WMS_BillMaster", "State", "BillID='" + BillID + "'");
                if (state > 2) {
                    var StateDes = GetFieldValue("View_WMS_BillMaster", "StateDesc", "BillID='" + BillID + "'");
                    $.messager.alert("提示", BillID + "单号已"+StateDes+"，不能再进行取消作业。", "info");
                    return false;
                }
                if (state<2) {
                    $.messager.alert("提示", BillID + "单号还未作业，不能进行取消作业。", "info");
                    return false;
                }
                var data = { Action: 'CancelTaskWork', Comd: "WMS.SpCancelOutstockTask", Where:  BillID };
                $.post(urlOther, data, function (result) {
                    if (result.status == 1) {
                        $.messager.alert('成功', result.msg, 'info');
                        ReloadGrid("dg");
                    } else {
                        $.messager.alert('错误', result.msg, 'error');
                    }
                }, 'json');
            } else {
                $.messager.alert("提示", "请选择单据！", "info");
                return false;
            }
        
         }
     
        //绑定下拉数据
        function BindDropDownList() {
            var data = { Action: 'FillDataTable', Comd: 'cmd.SelectBillType', Where: '1=1 and flag=2' };
            BindComboList(data, 'ddlBillTypeCode', 'BillTypeCode', 'BillTypeName');
        }
        //取回后给细表添加数据。
        function AddRow(ObjName, RowData) {
            var j = { "RowID": $('#dgSubAdd').datagrid('getRows').length + 1, "ProductCode": RowData.ProductCode, "Memo": "", "Quantity": 1, "ProductNo": RowData.ProductNo };
            $('#dgSubAdd').datagrid('appendRow', j);     
        }
        
        //绑定详细表
       function getDetail(index, data) {
            var selectdata = data;
            if (selectdata) {
                $('#dgSub').datagrid({
                    url: '../../Handler/BaseHandler.ashx?Action=PageDate&Comd=WMS.SelectBillDetail',
                    queryParams: { Where: encodeURIComponent("BillID='" + selectdata.BillID + "'") }
                });
            }
        }
    </script>
</head>
<body>
    <div class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north',split:true" style="height:300px;">
            <table id="dg"  class="easyui-datagrid" 
                             data-options="loadMsg: '正在加载数据，请稍等...',fit:true, rownumbers:true,url:'../../Handler/BaseHandler.ashx?Action=PageDate&Comd=WMS.SelectBillMaster',queryParams:{Where:BaseWhere},
                             pagination:true,pageSize:15, pageList:[15, 20, 30, 50],method:'post',striped:true,fitcolumns:true,toolbar:'#tb',onLoadSuccess: function(data){ 
                             $('#dg').datagrid('selectRow',0);},singleSelect:true,selectOnCheck:false,checkOnSelect:false,onSelect:getDetail,onCheck:CheckRow,onUncheck:CheckRow"> 
                 <thead data-options="frozen:true">
			        <tr>
                        <th data-options="field:'',checkbox:true"></th> 
		                <th data-options="field:'BillID',width:150">出库单号</th>
                        <th data-options="field:'BillDate',width:150">日期</th>
                        <th data-options="field:'StateDesc',width:100">状态</th>
                        <th data-options="field:'Memo',width:100">备注</th>
                    </tr>
                  </thead>
                  <thead>
                    <tr>
                        <th data-options="field:'Creator',width:80">建单人员</th>
                        <th data-options="field:'CreateDate',width:130">建单日期</th>
                        <th data-options="field:'Updater',width:80">修改人员</th>
                        <th data-options="field:'UpdateDate',width:130">修改日期</th>
		            </tr>
                </thead>
            </table>
        </div>
        <div data-options="region:'center',split:true,title:'出库单明细'">
            <table id="dgSub" data-options="loadMsg: '正在加载数据，请稍等...',fit:true, rownumbers:true,pagination:true,pageSize:15, pageList:[15, 20, 30, 50],method:'post',striped:true,fitcolumns:true">
                 <thead>
			        <tr>
                        <th data-options="field:'RowID',width:100">序号</th>
                        <th data-options="field:'ProductCode',width:100">模具编号</th>
                        <th data-options="field:'ProductName',width:150">品名</th>
                        <th data-options="field:'ProductNo',width:130">产品编号</th>
                        <th data-options="field:'Quantity',width:100">数量</th>
                        <th data-options="field:'Memo',width:80">备注</th>
                    </tr>                
                </table>
        </div>
   </div>
    <div id="tb" style="height:auto;padding:5px">
        <table style="width:100%">
            <tr>
                <td>
                    单号
                    <input id="txtQueryBillID" class="easyui-textbox" style="width:150px" />
                    日期
                    <input id="txtQueryBillDate" class="easyui-datebox" style="width:150px"/>
                    <a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="ReloadGrid('dg')" >查询</a>
                </td>
                <td style="width:*" align="right">
                    <a href="javascript:void(0)" onclick="CheckBill()" class="easyui-linkbutton" data-options="iconCls:'icon-man',plain:true">审核</a> 
                    <a href="javascript:void(0)" onclick="OutWork()" class="easyui-linkbutton" data-options="iconCls:'icon-redo',plain:true">出库作业</a>
                    <a href="javascript:void(0)" onclick="CancelWork()" class="easyui-linkbutton" data-options="iconCls:'icon-clear',plain:true">取消作业</a>
                    <a href="javascript:void(0)" onclick="Add()"   class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">新增</a> 
                    <a href="javascript:void(0)" onclick="Edit()" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">修改</a>
                    <a href="javascript:void(0)" onclick="Delete()" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true">删除</a>
                    <a href="javascript:void(0)" onclick="Exit()"   class="easyui-linkbutton" data-options="iconCls:'icon-no',plain:true">离开</a>
                </td>           
            </tr>
        </table>
   </div>
    <div id="AddWin" class="easyui-dialog" style="width: 1000px; height: 490px; padding: 5px 5px" data-options="closed:true,buttons:'#AddWinBtn'">  
       <form id="fm" method="post">
            <div>
                <table id="Table1" width="100%" align="center" style="table-layout:fixed;" class="grid maintable" >
                    <tr> 
                            <td align="center" class="musttitle"style="width:9%">
                                出库日期 </td>
                            <td style="width:21%" >
                        
                                &nbsp;<input id="txtBillDate" name="BillDate" class="easyui-datebox" data-options="required:true,editable:false,onSelect:function(date){ SetAutoCodeByTableName('txtID', 'OS', '1=1', 'WMS_BillMaster', date.Format('yyyy/MM/dd'));}" style="width:160px"/> 
                            <input name="PageState" id="txtPageState" type="hidden" />
                        
                            </td>
                            <td align="center" class="musttitle"style="width:9%">
                                    出库单号
                            </td>
                            <td  style="width:21%">
                                    &nbsp;<input id="txtID" name="BillID" 
                                        class="easyui-textbox" data-options="required:true" maxlength="20" style="width:160px"/>
                            </td>
                            <td align="center" class="musttitle"style="width:9%">
                                    单号类型
                            </td>
                            <td > 
                                &nbsp;<input 
                                    id="ddlBillTypeCode" name="BillTypeCode" class="easyui-combobox" 
                                    data-options="required:true" maxlength="50" style="width:274px"/>
                            </td>
                    </tr>
                    <tr style="height:46px;">
                            <td align="center"  class="smalltitle" style="width:9%;">
                                备注
                            </td>
                            <td colspan="5">
                                &nbsp;<input 
                                    id="txtMemo" name="Memo" class="easyui-textbox" 
                                    data-options="multiline:true" style="width:858px; height:32px"/>

                            </td>
                    </tr>
                    <tr>
                        <td colspan="6">
                                <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="SelectWinShow('SelectWin','明细资料--选择')">新增明细</a>
                                <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="DeleteSubDetail('dgSubAdd')">删除明细</a>
                        </td>
                    </tr>
                </table>
            </div>
            <table id="dgSubAdd" class="easyui-datagrid" style="width:100%;height:272px" data-options="loadMsg: '正在加载数据，请稍等...',rownumbers:true,pagination:false,method:'post',striped:true,fitcolumns:true,singleSelect:true,
                              selectOnCheck:false,checkOnSelect:false">
                <thead>
                    <tr>
                        <th data-options="field:'',checkbox:true"></th> 
		                <th data-options="field:'RowID',width:60">序号</th>
                        <th data-options="field:'ProductCode',width:130">模具编号</th>
                        <th data-options="field:'Quantity',width:150">数量</th>
                        <th data-options="field:'ProductNo',width:130">产品编号</th>
                        <th data-options="field:'Memo',width:120">备注</th>
                    </tr>
                </thead>
            </table>
            <table class="grid maintable" style="table-layout:fixed;width:100%">
                <tr>
                     <td align="center"  class="smalltitle" style="width:8%;">
                            建单人员
                     </td> 
                    <td style="width:12%">
                    &nbsp;<input id="txtCreator" name="Creator" class="easyui-textbox" data-options="editable:false" style="width:90%"/>
                    </td>
                    <td align="center" class="smalltitle" style="width:8%;">
                        建单日期
                    </td> 
                    <td style="width:12%">
                    &nbsp;<input id="txtCreateDate" name="CreateDate" class="easyui-textbox" data-options="editable:false"  style="width:90%"/>
                    </td>
                    <td align="center"  class="smalltitle" style="width:8%;">
                        修改人员
                    </td> 
                    <td style="width:12%">
                        &nbsp;<input id="txtUpdater" name="Updater" class="easyui-textbox" data-options="editable:false"  style="width:90%"/>
                    </td>
                    <td align="center"  class="smalltitle" style="width:8%;">
                        修改日期
                    </td> 
                    <td style="width:12%">
                    &nbsp;<input id="txtUpdateDate" name="UpdateDate" class="easyui-textbox" data-options="editable:false"  style="width:90%"/>
                    </td>
                </tr>
            </table>
       </form>     
    </div>
    <div id="AddWinBtn">
        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="Save()">保存</a>
        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="javascript:$('#AddWin').dialog('close')">关闭</a>
    </div>
    <div id="SelectWin" style="width:600px;height:500px">
       <table id="dgSelect" class="easyui-datagrid"
            data-options="loadMsg:'正在加载数据，请稍等...',fit:true,rownumbers:true,
            pagination:true,pageSize:15,pageList:[15,20,30,50],toolbar:'#tbSelect',method:'post',striped:true,fitcolumns:true,
            singleSelect:true,selectOnCheck:true,checkOnSelect:true,onCheck:SelectSingleCheckRow,
            onUncheck:SelectSingleUnCheckRow,onLoadSuccess:SelectLoadSelectSuccess,onDblClickRow:DblClickRow">
            <thead>
                    <tr>
                        <th data-options="field:'',checkbox:true"></th> 
                        <th data-options="field:'ProductCode',width:130">模具编号</th>
                        <th data-options="field:'ProductName',width:150">品名</th>
                        <th data-options="field:'Memo',width:120">备注</th>
                    </tr>
            </thead>            
        </table>
        <div id="tbSelect" style="padding:5px;height:auto">
           <table>
                <tr>
                     <td>
                        模具编号
                        <input id="txtQueryProductCode" class ="easyui-textbox" style="width: 100px" />  
                        品名
                        <input id="txtQueryProductName" class="easyui-textbox" style="width: 100px" />   
                        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="ReloadGrid('dgSelect')">查询</a> 
                    </td>
                    <td>
                         <a href="javascript:void(0)"onclick="closeSelectWin()" class="easyui-linkbutton" data-options="iconCls:'icon-return'">取回</a>  
                    </td>
                </tr>          
           </table>
        </div>
    </div>
</body>
</html>
