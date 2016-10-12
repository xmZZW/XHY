<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OutStocks.aspx.cs" Inherits="WebUI_OutStock_OutStocks" %>
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
        var BaseWhere = encodeURIComponent("BillID like 'IS%'");
        function getQueryParams(objName, queryParams) {
            var Where = "1=1";
            if (objName == "dg") {
                var BillID = $("#txtQueryBillID").textbox("getValue");
                var BillDate = $("#txtQueryBillDate").textbox("getValue");
                var SourceBillID = $("#txtQuerySourceBillID").textbox("getValue");

                if (BillID != "") {
                    Where += " and BillID like '%" + BillID + "%'";
                }
                if (BillDate != "") {
                    Where += " and CONVERT(nvarchar(10), BillDate,120) = '" + BillDate + "'";
                }
                if (SourceBillID != "") {
                    Where += " and SourceBillID like '%" + SourceBillID + "%'";
                }
                Where = BaseWhere + encodeURIComponent(" and " + Where);

            }
            else {

                var productcode = $("#txtQueryProductCode").textbox("getValue");
                var productname = $("#txtQueryProductName").textbox("getValue");
                var Spec = $("#txtQuerySpec").textbox("getValue");
                var ModelNo = $("#txtQueryModle").textbox("getValue");
                if (productcode != "") {
                    Where += " and productcode like '%" + productcode + "%'";
                }
                if (productname != "") {
                    Where += " and productname like '%" + productname + "%'";
                }
                if (Spec != "") {
                    Where += " and Spec like '%" + Spec + "%'";
                }
                if (ModelNo != "") {
                    Where += " and ModelNo like '%" + ModelNo + "%'";
                }
                Where = encodeURIComponent(Where);

            }

            queryParams.Where = Where;
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
            SetTextRead('txtSourceBillNo');
            SetTextRead('txtTotalQty');
            $('#txtBillDate').datebox('setValue', new Date().Format("yyyy/MM/dd"));
            $('#dgSubAdd').datagrid('loadData', { total: 0, rows: [] });
            $('#AddWin').dialog('open').dialog('setTitle', '新增');
            SetAutoCodeByTableName('txtID', 'IS', '1=1', 'WMS_BillMaster', $('#txtBillDate').datebox('getValue'));
            $('#txtPageState').val("Add");
            $("#txtID").textbox('readonly', false);
            $("#txtBillDate").datebox("readonly", false);
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
            SetTextRead('txtSourceBillNo');
            SetTextRead('txtSourceBillNo');
            SetTextRead('txtTotalQty');
            if (row) {
                //判断能否编辑


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
            $("#txtBillDate").datebox("readonly", true);
            SetInitColor();
        }
        //绑定下拉控件
        function BindDropDownList() {
            var data = { Action: 'FillDataTable', Comd: 'cmd.SelectBillType', Where: 'Flag=1' };
            BindComboList(data, 'ddlBillTypeCode', 'BillTypeCode', 'BillTypeName');
            data = { Action: 'FillDataTable', Comd: 'cmd.SelectFactory', Where: '1=1' };
            BindComboList(data, 'ddlFactory', 'FactoryID', 'FactoryName');
        }


        //保存信息
        function Save() {
            if (SessionTimeOut(SessionUrl)) {
                return false;
            }
            if (!$("#fm").form('validate')) {
                return false;
            }
            if ($('#dgSubAdd').datagrid('getRows').length == 0) {
                $.messager.alert('提示', '明细无资料!');
                return false;
            }
            if (!endEditing()) {
                return false;
            }
            var MainQuery = createParam();
            var SubQuery = createSubParam();
            var test = $('#txtPageState').val();
            var data;
            if (test == "Add") {
                //判断单号是否存在
                if (HasExists('cmd_product', "ProductCode='" + $('#txtID').textbox('getValue') + "'", '产品编码已经存在，请重新修改！'))
                    return false;
                data = { Action: 'AddMainDetail', MainComd: 'WMS.InsertInStockBill', SubComd: 'WMS.InsertInStockDetail', MainJson: MainQuery, SubJson: SubQuery };
                $.post(url, data, function (result) {
                    if (result.status == 1) {
                        ReloadGrid("dg");
                        $('#AddWin').window('close');
                        
                    } else {
                        $.messager.alert('错误', result.msg, 'error');
                    }
                }, 'json');

            }
            else {
                data = { Action: 'EditMainDetail', MainComd: 'WMS.UpdateInStock', SubDelComd: 'WMS.DeleteBillDetail', SubComd: 'WMS.InsertInStockDetail', MainJson: MainQuery, SubJson: SubQuery };
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
                            if (HasExists('VUsed_WMS_BillMaster', "BillID='" + item.BillID + "'", "入库单号 " + item.BillID + " 已经被其它单据使用，无法删除！"))
                                blnUsed = true;

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
        function getDetail(index, data) {
            var selectdata = data;
            if (selectdata) {
                $('#dgSub').datagrid({
                    url: '../../Handler/BaseHandler.ashx?Action=PageDate&Comd=WMS.SelectBillDetail',
                    queryParams: { Where: encodeURIComponent("BillID='" + selectdata.BillID + "'") }
                });
            }
        }


        function AddRow(RowData) {
            var j = { "RowID": $('#dgSubAdd').datagrid("getRows").length + 1, "ProductCode": RowData.ProductCode, "ProductName": RowData.ProductName,
                "Spec": RowData.Spec, "Barcode": RowData.Barcode, "Weight": "", "ModelNo": RowData.ModelNo, "Propertity": RowData.Propertity,
                "Unit": RowData.Unit, "StandardNo": RowData.StandardNo, "PartNo": RowData.PartNo, "Memo": "", "CellCode": "",
                "NewCellCode": "", "CategoryName": RowData.CategoryName, "BillID": $('#txtID').val(), "Quantity": 1
            };
            $('#dgSubAdd').datagrid('appendRow', j);
        }
        function BindSelectUrl() {
            $('#dgSelect').datagrid({
                url: '../../Handler/BaseHandler.ashx?Action=PageDate&Comd=CMD.SelectProduct',
                queryParams: { Where: encodeURIComponent("1=1") }
            });
        }
        function CheckRow(rowIndex, rowData) {
            CheckSelectRow('dg', rowIndex, rowData);
        }

        function UnCheckRow(rowIndex, rowData) {


        }
        function CheckRowAll(rows) {


        }
        function UnCheckRowAll(rows) {

        
        }
        function LoadSelectSuccess(data) { 
        
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
		                <th data-options="field:'BillID',width:100">入库单号</th>
                        <th data-options="field:'BillDate',width:100">日期</th>
                        <th data-options="field:'StateDesc',width:80">单据状态</th>
                    </tr>
                  </thead>
                  <thead>
                    <tr>
                        <th data-options="field:'BillTypeName',width:100">入库类型</th>
                        <th data-options="field:'SourceBillNo',width:100">来源单号</th>
                        <th data-options="field:'FactoryName',width:100">工厂</th>
                        <th data-options="field:'Memo',width:100">备注</th>
                        <th data-options="field:'Checker',width:50">审核人员</th>
                        <th data-options="field:'CheckDate',width:100">审核日期</th>
                        <th data-options="field:'Creator',width:80">建单人员</th>
                        <th data-options="field:'CreateDate',width:80">建单日期</th>
                        <th data-options="field:'Updater',width:80">修改人员</th>
                        <th data-options="field:'UpdateDate',width:80">修改日期</th>
		            </tr>
                </thead>
            </table>
        </div>   
        <div data-options="region:'center', split:true,title:'入库单明细',split:true" >
            <table id="dgSub"  class="easyui-datagrid" 
                data-options="loadMsg: '正在加载数据，请稍等...',fit:true, rownumbers:true,pagination:true,pageSize:15, pageList:[15, 20, 30, 50],method:'post',striped:true,fitcolumns:true"> 
                <thead>
		            <tr>
		                <th data-options="field:'RowID',width:100">序号</th>
                        <th data-options="field:'ProductCode',width:100">产品编号</th>
                        <th data-options="field:'ProductName',width:100">品名</th>
                        <th data-options="field:'Spec',width:100">规格</th>
                        <th data-options="field:'ModelNo',width:100">型号</th>
                         <th data-options="field:'Barcode',width:100">熔次卷号</th>
                        <th data-options="field:'Weight',width:80">重量</th>
                        <th data-options="field:'Propertity',width:100">牌号状态</th>
                        <th data-options="field:'Unit',width:50">单位</th>
                        <th data-options="field:'StandardNo',width:100">标准号</th>
                        <th data-options="field:'PartNo',width:100">部件号</th>
                        <th data-options="field:'Memo',width:80">备注</th>
		            </tr>
                </thead>
            </table>
        </div>   

    </div>
   
    <div id="tb" style="padding: 5px; height: auto">  
        <table style="width:100%" >
            <tr>
                <td>
                    单号
                    <input id="txtQueryBillID" class ="easyui-textbox" style="width: 100px" />  
                    日期
                    <input id="txtQueryBillDate" class="easyui-datebox" style="width: 100px" />   
                    来源单号  
                    <input id="txtQuerySourceBillID" class="easyui-textbox"/>   
                    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="ReloadGrid('dg')">查询</a> 
                </td>
                <td  style="width:*"  align="right">
                     <a href="javascript:void(0)" onclick="Add()" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">新增</a>  
                     <a href="javascript:void(0)" onclick="Edit() " class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">修改</a>  
                     <a href="javascript:void(0)" onclick="Delete()" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true">删除</a>
                     <a href="javascript:void(0)" onclick="Exit()" class="easyui-linkbutton" data-options="iconCls:'icon-no',plain:true">离开</a>
                </td>
            </tr>
        </table>
   </div>
      <%-- 弹出操作框--%>
    <div id="AddWin" class="easyui-dialog" style="width: 1000px; height: 520px; padding: 5px 5px"
        data-options="closed:true,buttons:'#AddWinBtn'">  
        <form id="fm" method="post">
            <div>
                    <table id="Table1" class="grid maintable" style="table-layout:fixed;"  width="100%" align="center">			
				    <tr> 
                        <td align="center" class="musttitle"style="width:9%">
                            入库日期 </td>
                        <td style="width:21%" >
                        
                            &nbsp;<input id="txtBillDate" name="BillDate" class="easyui-datebox" data-options="required:true,editable:false,onSelect:function(date){ SetAutoCodeByTableName('txtID', 'IS', '1=1', 'WMS_BillMaster', date.Format('yyyy/MM/dd'));}" style="width:160px"/> 
                            <input name="PageState" id="txtPageState" type="hidden" />
                        
                        </td>
                        <td align="center" class="musttitle"style="width:9%">
                                入库单号
                        </td>
                        <td  style="width:21%">
                                &nbsp;<input id="txtID" name="BillID" 
                                    class="easyui-textbox" data-options="required:true" maxlength="20" style="width:160px"/>
                        </td>
                        <td align="center" class="musttitle"style="width:9%"  >
                                入库类型
                        </td>
                        <td > 
                            &nbsp;<input 
                                id="ddlBillTypeCode" name="BillTypeCode" class="easyui-combobox" 
                                data-options="required:true" maxlength="50" style="width:274px"/>
                        </td>
                        
                    </tr>
                    <tr> 
                        <td align="center" class="musttitle"style="width:9%">
                            来源单号 </td>
                        <td style="width:21%">
                        
                            &nbsp;<input id="txtSourceBillNo" name="SourceBillNo" class="easyui-textbox" data-options="editable:false" style="width:160px"/> 
                            <input name="PageState" id="Hidden1" type="hidden" />
                        
                        </td>
                        <td align="center" class="musttitle"style="width:9%">
                                入库批次
                        </td>
                        <td  style="width:21%">
                                &nbsp;<input id="txtBatchNo" name="BatchNo" 
                                    class="easyui-textbox" maxlength="20" style="width:160px"/>
                        </td>
                        <td align="center" class="musttitle"style="width:9%"  >
                                工厂
                        </td>
                        <td > 
                            &nbsp;<input 
                                id="ddlFactory" name="FactoryID" class="easyui-textbox" 
                                data-options="required:true" maxlength="50" style="width:274px"/>
                        </td>
                        
                    </tr>
                    <tr style="height:40px;">
                        <td align="center"  class="smalltitle" style="width:9%;">
                            备注
                        </td>
                        <td colspan="5">
                            &nbsp;<input 
                                id="txtMemo" name="Memo" class="easyui-textbox" 
                                data-options="multiline:true" style="width:856px; height:32px"/>

                        </td>
                        </tr>
                        <tr>
                        <td colspan="6">
                                <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="SelectWinShow()">新增明细</a>
                                <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="DeleteSubDetail()">删除明细</a>
                        </td>
                        </tr>
		            </table>
            </div>
           
            <table id="dgSubAdd" class="easyui-datagrid" style="width:100%;height:272px;"
                data-options="loadMsg: '正在加载数据，请稍等...',rownumbers:true,pagination:false,method:'post',striped:true,fitcolumns:true,singleSelect:true,
                              selectOnCheck:false,checkOnSelect:false"> <!--onClickCell:ClickCell-->
               <thead data-options="frozen:true">
			        <tr>
                        <th data-options="field:'',checkbox:true"></th> 
		                <th data-options="field:'RowID',width:40">序号</th>
                        <th data-options="field:'ProductCode',width:65">产品编号</th>
                        <th data-options="field:'ProductName',width:100">品名</th>
                        <th data-options="field:'Spec',width:200">规格</th>
                        <th data-options="field:'Barcode',width:100,editor:{type:'textbox',options:{required:true}}">熔次卷号</th>
                        <th data-options="field:'Weight',width:65,editor:{type:'numberbox',options:{required:true,precision:2}}">重量</th>
                    </tr>
                <thead>
			        <tr>
                        <th data-options="field:'ModelNo',width:100">型号</th>
                        <th data-options="field:'Propertity',width:100">牌号状态</th>
                        <th data-options="field:'Unit',width:50">单位</th>
                        <th data-options="field:'StandardNo',width:100">标准号</th>
                        <th data-options="field:'PartNo',width:100">部件号</th>
                        <th data-options="field:'Memo',width:80">备注</th>
		            </tr>
                </thead>
            </table>
            <table class="grid maintable" style="table-layout:fixed; width:100%">
                <tr>
                     <td align="center"  style="width:8%;" class="smalltitle">
                            数量合计
                     </td>
                     <td style="width:12%">
                        &nbsp;<input id="txtTotalQty" name="TotalQty" class="easyui-textbox" data-options="editable:false" style="width:90%"/>
                     </td>
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

    <div  id="SelectWin">
             <table id="dgSelect"  class="easyui-datagrid" 
            data-options="loadMsg: '正在加载数据，请稍等...',fit:true, rownumbers:true,
                         pagination:true,pageSize:15, pageList:[15, 20, 30, 50],method:'post',striped:true,fitcolumns:true,toolbar:'#tbSelect',singleSelect:true,selectOnCheck:false,checkOnSelect:false,onCheck:CheckRow,onUncheck:UnCheckRow,onCheckAll:CheckRowAll,onUncheckAll:UnCheckRowAll,onLoadSuccess:LoadSelectSuccess"> 
            <thead data-options="frozen:true">
			    <tr>
				    <th data-options="field:'',checkbox:true"></th> 
		            <th data-options="field:'ProductCode',width:100">产品编号</th>
                    <th data-options="field:'ProductName',width:100">品名</th>
			    </tr>
		    </thead>
            <thead>
		        <tr>
                    <th data-options="field:'CategoryName',width:80">产品类别</th>
                    <th data-options="field:'ProductEName',width:100">英文品名</th>
                    <th data-options="field:'Spec',width:100">规格</th>
                    <th data-options="field:'ModelNo',width:100">型号</th>
                    <th data-options="field:'Propertity',width:100">属性</th>
                    <th data-options="field:'Unit',width:50">单位</th>
                    <th data-options="field:'FactoryName',width:100">供应商</th>
                    <th data-options="field:'Description',width:100">描述</th>
                    <th data-options="field:'Memo',width:100">备注</th>
                    <th data-options="field:'Creator',width:80">建单人员</th>
                    <th data-options="field:'CreateDate',width:80">建单日期</th>
                    <th data-options="field:'Updater',width:80">修改人员</th>
                    <th data-options="field:'UpdateDate',width:80">修改日期</th>
		        </tr>
            </thead>
        </table>
        <div id="tbSelect" style="padding: 5px; height: auto">  
    
            <table >
                <tr>
                    <td>
                        产品编码
                        <input id="txtQueryProductCode" class ="easyui-textbox" style="width: 100px" />  
                        品名
                        <input id="txtQueryProductName" class="easyui-textbox" style="width: 100px" />   
                        规格<input id="txtQuerySpec" class="easyui-textbox"/>   
                        型号
                         <input id="txtQueryModle" class="easyui-textbox"/>
                        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="ReloadGrid('dgSelect')">查询</a> 
                    </td>
                    <td>
                         <a href="javascript:void(0)" onclick="closeSelectWin()" class="easyui-linkbutton" data-options="iconCls:'icon-return'">取回</a>  
                    </td>
                </tr>
            </table>
        </div>
        
    </div>
</body>
</html>