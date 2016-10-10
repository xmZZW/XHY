<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Orders.aspx.cs" Inherits="WebUI_Stock_Orders" %>
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
        var Orderurl = "OrderHandler.ashx";
        var SessionUrl = '<% =ResolveUrl("~/Login.aspx")%>';
        var BaseWhere = encodeURIComponent("BillID like 'IS%'");
        var oldBatchNo = "";
        var FormID = "Order";
        function getQueryParams(objName, queryParams) {
            var Where = "1=1";
            if (objName == "dg") {
                var OrderId = $("#txtQueryOrderId").textbox("getValue");
                var OrderDate = $("#txtQueryOrderDate").datebox("getValue");
                var CustomerName = $("#txtQueryCustName").textbox("getValue");
                var BatchNo = $("#txtQueryBatchNo").textbox("getValue");
                

                if (OrderId != "") {
                    Where += " and OrderId like '%" + OrderId + "%'";
                }
                if (BatchNo != "") {
                    Where += " and BatchNo like '%" + BatchNo + "%'";
                }
                if (OrderDate != "") {
                    Where += " and CONVERT(nvarchar(10), OrderDate,120) = '" + OrderDate + "'";
                }
                if (CustomerName != "") {
                    Where += " and CustomerName like '%" + CustomerName + "%'";
                }
              
            }
            else if (objName == "dgProduct") {

                var productcode = $("#txtQueryProductCode").textbox("getValue");
                var productname = $("#txtQueryProductName").textbox("getValue");
                var ShortName = $("#txtQueryShortName").textbox("getValue");
                var Barcode = $("#txtQueryBarcode").textbox("getValue");

                if (productcode != "") {
                    Where += " and productcode like '%" + productcode + "%'";
                }
                if (productname != "") {
                    Where += " and productname like '%" + productname + "%'";
                }
                if (ShortName != "") {
                    Where += " and ShortName like '%" + ShortName + "%'";
                }
                if (Barcode != "") {
                    Where += " and Barcode like '%" + Barcode + "%'";
                }
            }
            else {


                var CustomerCode = $("#txtQueryCustomerCode").textbox("getValue");
                var CustomerName = $("#txtQueryCustomerName").textbox("getValue");
                var RouteName = $("#txtQueryRouteName").textbox("getValue");
                var Address = $("#txtQueryAddress").textbox("getValue");
                if (CustomerCode != "") {
                    Where += " and CustomerCode like '%" + CustomerCode + "%'";
                }
                if (CustomerName != "") {
                    Where += " and CustomerName like '%" + CustomerName + "%'";
                }
                if (RouteName != "") {
                    Where += " and RouteName like '%" + RouteName + "%'";
                }
                if (Address != "") {
                    Where += " and Address like '%" + Address + "%'";
                }
            }
            Where = encodeURIComponent(Where);
            queryParams.Where = Where;
            return queryParams;

        }

        //添加管理员
        function Add() {
            if (SessionTimeOut(SessionUrl)) {
                return false;
            }
            if (!GetPermisionByFormID("Order", 0)) {
                alert("您没有新增权限！");
                return false;
            }
            $('#fm').form('clear');
            BindDropDownList();
            SetTextRead('txtCustomerCode');
            SetTextRead('txtCustomerName');
            SetTextRead('txtRouteCode');
            SetTextRead('txtRouteName');
            oldBatchNo = "";
            $('#txtOrderDate').datebox('setValue', new Date().Format("yyyy/MM/dd"));
            $('#dgSubAdd').datagrid('loadData', { total: 0, rows: [] });
            $('#AddWin').dialog('open').dialog('setTitle', '订单--新增');
            SetAutoCodeByTableName('txtID', 'O', '1=1', 'SC_I_ORDERMASTER', $('#txtOrderDate').datebox('getValue'));
            $('#txtDeliveryDate').datebox('setValue', new Date().Format("yyyy/MM/dd"));
            $('#txtPageState').val("Add");
            $("#txtID").textbox('readonly', false);
            $("#txtOrderDate").datebox("readonly", false);
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
            //判断能不能修改
            if (HasExists('CMD_Batch', "BatchNo='" + row.BatchNo + "' and BeginSortTime is not null ", '批次号已经开始分拣，不能修改该批次订单！'))
                return false;

            SetTextRead('txtCustomerCode');
            SetTextRead('txtCustomerName');
            SetTextRead('txtRouteCode');
            SetTextRead('txtRouteName');
            $("#txtID").textbox('readonly', true);
            $("#txtOrderDate").datebox("readonly", true);
            
            BindDropDownList();
            if (row) {
                //判断能否编辑
                var data = { Action: 'FillDataTable', Comd: 'WMS.SelectOrder', Where: "OrderID='" + row.OrderId + "'" };
                $.post(url, data, function (result) {
                    var Product = result.rows[0];
                    $('#AddWin').dialog('open').dialog('setTitle', '编辑');
                    $('#fm').form('load', Product);
                    oldBatchNo = Product.BatchNo;

                }, 'json');

                $('#dgSubAdd').datagrid({
                    url: '../../Handler/BaseHandler.ashx?Action=FillDataTable&Comd=WMS.SelectOrderDetail',
                    queryParams: { Where: encodeURIComponent("OrderId='" + row.OrderId + "'") }
                });
            }
            $('#txtPageState').val("Edit");
           
            SetInitColor();
        }
        //绑定下拉控件
        function BindDropDownList() {
            var data = { Action: 'FillDataTable', Comd: 'Cmd.SelectBatchBind', Where: '1=1' };
            BindComboList(data, 'ddlBatchNo', 'State', 'StateDesc');
        }

        function createSubParamRow(RowData) {
            RowData.OrderId = $('#txtID').textbox('getValue');
            RowData.OrderDate = $('#txtOrderDate').datebox('getValue');
            RowData.DeliveryDate = $('#txtDeliveryDate').datebox('getValue');
            RowData.BatchNo = new Date($('#txtOrderDate').datebox('getValue')).Format("yyMMdd") + $('#ddlBatchNo').combobox('getValue');

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

            var data;
            var BatchNo = new Date($('#txtOrderDate').datebox('getValue')).Format("yyMMdd") + $('#ddlBatchNo').combobox('getValue');
            $('#txtBatchNo').val(BatchNo);
            var MainQuery = createParam();
            var SubQuery = createSubParam();
            var test = $('#txtPageState').val();
           
            if (test == "Add") {
                //判断单号是否存在
                if (HasExists('SC_I_ORDERMASTER', "OrderId='" + $('#txtID').textbox('getValue') + "'", '订单单号已经存在，请重新修改！'))
                    return false;
                //判断批次号是否存在
                if (!HasExists("CMD_Batch", "BatchNo='" + BatchNo + "'", "")) {
                    var bln = true;
                    data = { Action: 'AddBatch', BatchNo: BatchNo, OrderDate: $('#txtOrderDate').datebox('getValue') };
                    $.ajax({
                        type: "post",
                        url: Orderurl,
                        data: data,
                        dataType: "text",
                        async: false,
                        success: function (result) {
                            var rs = eval('[' + result + ']');
                            if (rs[0].status != 1) {
                                $.messager.alert('错误', rs[0].msg, 'error');
                                bln = false;
                            }
                        },
                        error: function (msg) {
                            alert(msg);
                            bln = false;
                        }
                    });
                    if (!bln)
                        return false;

                }
                else {  //判断是否分拣
                    if (HasExists('CMD_Batch', "BatchNo='" + BatchNo + "' and BeginSortTime is not null ", '批次号已经开始分拣，不能新增该批次订单！'))
                        return false;
                }


                data = { Action: 'AddOrder', MainJson: MainQuery, SubJson: SubQuery };
                $.post(Orderurl, data, function (result) {
                    if (result.status == 1) {
                        ReloadGrid("dg");
                        $('#AddWin').window('close');
                    } else {
                        $.messager.alert('错误', result.msg, 'error');
                    }
                }, 'json');

            }
            else {

                if (oldBatchNo != BatchNo) {
                    //判断原有批次号是否分拣
                    if (HasExists('CMD_Batch', "BatchNo='" + oldBatchNo + "' and BeginSortTime is not null", '批次号已经开始分拣，不能修改该订单批次号！')) {
                        $('#ddlBatchNo').combobox('setValue', oldBatchNo.substring(6, 8));
                        return false;
                    }

                    if (!HasExists("CMD_Batch", "BatchNo='" + BatchNo + "'", "")) {
                        var bln = true;
                        data = { Action: 'AddBatch', BatchNo: BatchNo, OrderDate: $('#txtOrderDate').datebox('getValue') };
                        $.ajax({
                            type: "post",
                            url: Orderurl,
                            data: data,
                            dataType: "text",
                            async: false,
                            success: function (result) {
                                var rs = eval('[' + result + ']');
                                if (rs[0].status != 1) {
                                    $.messager.alert('错误', rs[0].msg, 'error');
                                    bln = false;
                                }
                            },
                            error: function (msg) {
                                alert(msg);
                                bln = false;
                            }
                        });
                        if (!bln)
                            return false;

                    }
                    else {  //判断是否分拣
                        if (HasExists('CMD_Batch', "BatchNo='" + BatchNo + "' and BeginSortTime is not null ", '批次号已经开始分拣，不能新增该批次订单！'))
                            return false;
                    }
                }
                else {

                    if (HasExists('CMD_Batch', "BatchNo='" + BatchNo + "' and BeginSortTime is not null", '批次号已经开始分拣，不能修改该批次订单！'))
                        return false;
                }
                data = { Action: 'EditOrder', MainJson: MainQuery, SubJson: SubQuery, OldBatchNo: oldBatchNo };
                $.post(Orderurl, data, function (result) {
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
                            if (HasExists('CMD_Batch', "BatchNo='" + item.BatchNo + "' and IsValid='1'", '批次号已经优化，不能修改该批次订单！'))
                                blnUsed = true;

                            deleteCode.push(item.OrderId);
                        });
                        if (blnUsed)
                            return false;
                        var data = { Action: 'DelMainDetail', MainComd: 'WMS.DeleteOrder', SubComd: "WMS.DeleteOrderDetail", json: "'" + deleteCode.join("','") + "'" };
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
                    url: '../../Handler/BaseHandler.ashx?Action=PageDate&Comd=WMS.SelectOrderDetail',
                    queryParams: { Where: encodeURIComponent("OrderId='" + selectdata.OrderId + "'") }
                });
            }
        }


        function AddRow(ObjName, RowData) {
            if (ObjName == "SelectProductWin") {

                var j = { "RowID": $('#dgSubAdd').datagrid("getRows").length + 1, "ProductCode": RowData.ProductCode, "ProductName": RowData.ProductName,
                     "Price": "0", "Amount": "0", "Memo": "","Quantity": 1};
                $('#dgSubAdd').datagrid('appendRow', j);
            }
            else {
                $('#txtCustomerCode').textbox('setValue', RowData.CustomerCode);
                $('#txtCustomerName').textbox('setValue', RowData.CustomerName);
                $('#txtRouteCode').textbox('setValue', RowData.RouteCode);
                $('#txtRouteName').textbox('setValue', RowData.RouteName);
                $('#txtDeliveryAdd').textbox('setValue', RowData.Address);
            }
        }

      

        function BindSelectUrl(objName) {

            var Comd = "Cmd.SelectCustomer";
            var gvName = "dgCust";
            var where = "1=1";
            if (objName == "SelectProductWin") {
                Comd = "CMD.SelectProduct";
                gvName = "dgProduct";
                //产品不重复。
                var AddRows = $('#dgSubAdd').datagrid('getRows');
                if (AddRows.length > 0) {
                    var Products = [-1];
                    $.each(AddRows, function (index, item) {
                        Products.push(item.ProductCode);
                    });
                    where = "ProductCode not in  ('" + Products.join("','") + "')";
                }
            }
            $('#' + gvName).datagrid({
                url: '../../Handler/BaseHandler.ashx?Action=PageDate&Comd=' + Comd,
                pageNumber: 1,
                queryParams: { Where: encodeURIComponent(where) }
            });
        }
        function CheckRow(rowIndex, rowData) {
            CheckSelectRow('dg', rowIndex, rowData);
        }

        var blnChange = true;
        function ClickCell(rowIndex, field, value) {
            if (field == "Quantity" || field == "Price" || field == "Memo") {
                if (editIndex != rowIndex) {
                    if (endEditing()) {
                        blnChange = false;
                        $('#dgSubAdd').datagrid('beginEdit', rowIndex);
                        blnChange = true;
                        var ed = $('#dgSubAdd').datagrid('getEditor', { index: rowIndex, field: field });
                        if (ed != null)
                            ($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focusEnd();
                        editIndex = rowIndex;
                    }
                }
                else {
                    $('#dgSubAdd').datagrid('selectRow', rowIndex);
                }
            }
            else {
                endEditing();
                $('#dgSubAdd').datagrid('selectRow', rowIndex);
            }
        }
        function Calculate(n, o) {
            if (!blnChange)
                return false;
            var QtyEdt = $('#dgSubAdd').datagrid('getEditor', { index: editIndex, field: 'Quantity' });            // 数量
            var PriceEdt = $('#dgSubAdd').datagrid('getEditor', { index: editIndex, field: 'Price' });    // 产品单价
            var QtyValue = $(QtyEdt.target).val();                // 数量 值
            var PriceValue = $(PriceEdt.target).val();        // 单价 值
            var AmtValue = QtyValue * PriceValue;            // 金额  值
            $('#dgSubAdd').datagrid('getRows')[editIndex]['Quantity'] = QtyValue;
            $('#dgSubAdd').datagrid('getRows')[editIndex]['Price'] = PriceValue;
            $('#dgSubAdd').datagrid('getRows')[editIndex]['Amount'] = AmtValue;
        }
        function TextFocus() {

        }
 </script> 
    </head>
<body>
    <div class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north',split:true" style="height:300px;">
             <table id="dg"  class="easyui-datagrid" 
                data-options="loadMsg: '正在加载数据，请稍等...',fit:true, rownumbers:true,url:'../../Handler/BaseHandler.ashx?Action=PageDate&FormID='+FormID,
                             pagination:true,pageSize:15, pageList:[15, 20, 30, 50],method:'post',striped:true,fitcolumns:true,toolbar:'#tb',onLoadSuccess: function(data){ 
                             $('#dg').datagrid('selectRow',0);},singleSelect:true,selectOnCheck:false,checkOnSelect:false,onSelect:getDetail,onCheck:CheckRow,onUncheck:CheckRow"> 
                  <thead data-options="frozen:true">
			        <tr>
                        <th data-options="field:'',checkbox:true"></th> 
		                <th data-options="field:'OrderId',width:100">订单单号</th>
                        <th data-options="field:'OrderDate',width:100">日期</th>
                        <th data-options="field:'DeliveryDate',width:80">送货日期</th>
                    </tr>
                  </thead>
                  <thead>
                    <tr>
                        <th data-options="field:'SubBatchNo',width:100">批次号</th>
                        <th data-options="field:'CustomerName',width:200">客户</th>
                          <th data-options="field:'RouteCode',width:100">路线编码</th>
                        <th data-options="field:'RouteName',width:150">路线</th>
                        <th data-options="field:'DeliveryAdd',width:180">送货地址</th>
                        <th data-options="field:'Creator',width:80">建单人员</th>
                        <th data-options="field:'CreateDate',width:120">建单日期</th>
                        <th data-options="field:'Updater',width:80">修改人员</th>
                        <th data-options="field:'UpdateDate',width:120">修改日期</th>
		            </tr>
                </thead>
            </table>
        </div>   
        <div data-options="region:'center', split:true,title:'订单明细',split:true" >
            <table id="dgSub"  class="easyui-datagrid" 
                data-options="loadMsg: '正在加载数据，请稍等...',fit:true, rownumbers:true,pagination:true,pageSize:15, pageList:[15, 20, 30, 50],method:'post',striped:true,fitcolumns:true"> 
                <thead>
		            <tr>
		                <th data-options="field:'RowID',width:100">序号</th>
                        <th data-options="field:'ProductCode',width:100">产品编号</th>
                        <th data-options="field:'ProductName',width:180">品名</th>
                        <th data-options="field:'Quantity',width:80">数量</th>
                        <th data-options="field:'Price',width:100">单价</th>
                        <th data-options="field:'Amount',width:150">金额</th>
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
                    <input id="txtQueryOrderId" class ="easyui-textbox" style="width: 100px" />  
                    日期
                    <input id="txtQueryOrderDate" class="easyui-datebox" style="width: 100px" />   
                    批次号  
                    <input id="txtQueryBatchNo" class="easyui-textbox"/>  
                    客户  
                    <input id="txtQueryCustName" class="easyui-textbox"/>  
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
                        <td align="center" class="musttitle" style="width:8%;">
                            订单日期 </td>
                        <td  style="width:17%;" >
                            &nbsp;<input id="txtOrderDate" name="OrderDate" class="easyui-datebox" 
                                data-options="required:true,editable:false,onSelect:function(date){ SetAutoCodeByTableName('txtID', 'O', '1=1', 'SC_I_ORDERMASTER', date.Format('yyyy/MM/dd'));}" 
                                style="width:150px"/> 
                            <input name="PageState" id="txtPageState" type="hidden" />
                        
                        </td>
                        <td align="center" class="musttitle" style="width:8%;">
                                订单单号
                        </td>
                        <td  style="width:17%;">
                                &nbsp;<input 
                                    id="txtID" name="OrderId" 
                                    class="easyui-textbox" data-options="required:true" maxlength="20" 
                                    style="width:157px"/>
                        </td>
                        
                         <td align="center" class="musttitle" style="width:8%;">
                            批次号 </td>
                        <td style="width:17%;">
                        
                            &nbsp;<input id="ddlBatchNo" name="SubBatchNo" class="easyui-combobox" data-options="required:true,editable:false" style="width:154px"/>  
                              <input name="BatchNo" id="txtBatchNo" type="hidden" />
                        
                        </td>
                        <td align="center" class="musttitle" style="width:8%;">
                                送货日期
                        </td>
                        <td style="width:17%;"> 
                            &nbsp;<input id="txtDeliveryDate" name="DeliveryDate" class="easyui-datebox" style="width:155px"/>
                        </td>
                        
                    </tr>
                    <tr> 
                       
                        <td align="center" class="musttitle" style="width:8%;">
                                客户
                        </td>
                        <td  colspan="3"  >
                           &nbsp;<input id="txtCustomerCode" name="CustomerCode" class="easyui-textbox" data-options="editable:false,required:true" style="width:116px"/>
                                <input id="txtCustomerName" name="CustomerName" class="easyui-textbox" data-options="editable:false,required:true" style="width:248px"/>
                                <input type="button" id="btnCust" class="ButtonCss" onclick="SelectWinShow('SelectCustWin','客户资料--选择')" value="..."/>
                        </td>
                        <td align="center" class="musttitle" style="width:8%;" >
                                路线
                        </td>
                        <td  colspan="3"> 
                            &nbsp;<input id="txtRouteCode" name="RouteCode" class="easyui-textbox" data-options="editable:false"  style="width:127px"/>
                                <input id="txtRouteName" name="RouteName" class="easyui-textbox" data-options="editable:false"  style="width:266px"/>
                        </td>
                        
                    </tr>
                    <tr  >
                        <td align="center"  class="smalltitle" style="width:8%;">
                            送货地址
                        </td>
                        <td colspan="7">
                            &nbsp;<input id="txtDeliveryAdd" name="DeliveryAdd" class="easyui-textbox" style="width:883px"/>

                        </td>
                    </tr>
                    <tr>
                    <td colspan="8">
                            <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="SelectWinShow('SelectProductWin','产品资料--选择')">新增明细</a>
                            <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="DeleteSubDetail('dgSubAdd')">删除明细</a>
                    </td>
                    </tr>
		        </table>
            </div>
           
            <table id="dgSubAdd" class="easyui-datagrid" style="width:100%;height:272px;"
                data-options="loadMsg: '正在加载数据，请稍等...',rownumbers:true,pagination:false,method:'post',striped:true,fitcolumns:true,singleSelect:true,
                              selectOnCheck:false,checkOnSelect:false,onClickCell:ClickCell "> 
               <thead data-options="frozen:true">
			        <tr>
                        <th data-options="field:'',checkbox:true"></th> 
		                <th data-options="field:'RowID',width:60">序号</th>
                        <th data-options="field:'ProductCode',width:90">产品编号</th>
                        <th data-options="field:'ProductName',width:160">品名</th>
                        <th data-options="field:'Quantity',width:70,editor:{type:'numberbox',options:{required:true,min:1,precision:0,onChange:Calculate}}">数量</th>
                        <th data-options="field:'Price',width:80,editor:{type:'numberbox',options:{min:0,precision:2,onChange:Calculate}}">单价</th>
                        <th data-options="field:'Amount',width:90">金额</th>
                        <th data-options="field:'Memo',width:150,editor:{type:'textbox'}">备注</th>
		            </tr>
                </thead>
            </table>
            <table class="grid maintable" style="table-layout:fixed; width:100%">
                <tr>
                     <td align="center"  class="smalltitle" style="width:8%;">
                            建单人员
                     </td> 
                    <td style="width:17%;">
                    &nbsp;<input id="txtCreator" name="Creator" class="easyui-textbox" data-options="editable:false" style="width:90%"/>
                    </td>
                    <td align="center" class="smalltitle" style="width:8%;">
                        建单日期
                    </td> 
                    <td style="width:17%;">
                    &nbsp;<input id="txtCreateDate" name="CreateDate" class="easyui-textbox" data-options="editable:false"  style="width:90%"/>
                    </td>
                    <td align="center"  class="smalltitle" style="width:8%;">
                        修改人员
                    </td> 
                    <td style="width:17%;">
                        &nbsp;<input id="txtUpdater" name="Updater" class="easyui-textbox" data-options="editable:false"  style="width:90%"/>
                    </td>
                    <td align="center"  class="smalltitle" style="width:8%;">
                        修改日期
                    </td> 
                    <td style="width:17%;">
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

    <div  id="SelectProductWin" style="width:800px;height:500px">
             <table id="dgProduct"  class="easyui-datagrid" 
            data-options="loadMsg: '正在加载数据，请稍等...',fit:true, rownumbers:true,
                         pagination:true,pageSize:15, pageList:[15, 20, 30, 50],method:'post',striped:true,fitcolumns:true,toolbar:'#tbSelect',singleSelect:true,selectOnCheck:false,checkOnSelect:false,onCheck:SelectCheckRow,onUncheck:SelectUnCheckRow,onCheckAll:SelectCheckRowAll,onUncheckAll:SelectUnCheckRowAll,onLoadSuccess:SelectLoadSelectSuccess"> 
              <thead data-options="frozen:true">
			    <tr>
				    <th data-options="field:'',checkbox:true"></th> 
		            <th data-options="field:'ProductCode',width:100">产品编码</th>
                    <th data-options="field:'ProductName',width:100">品名</th>
			    </tr>
		    </thead>
            <thead>
		        <tr>
                    <th data-options="field:'CategoryName',width:80">产品类别</th>
                    <th data-options="field:'ShortName',width:100">简称</th>
                    <th data-options="field:'FactoryName',width:100">供应商</th>
                    <th data-options="field:'Province',width:100">省份</th>
                    <th data-options="field:'Unit',width:50">单位</th>
                    <th data-options="field:'Barcode',width:100">产品条码</th>
                    <th data-options="field:'BarcodePack',width:100">包装条码</th>
                    <th data-options="field:'Length',width:100">长度</th>
                    <th data-options="field:'Width',width:100">宽度</th>
                    <th data-options="field:'Height',width:100">高度</th>
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
                        简称  
                        <input id="txtQueryShortName" class="easyui-textbox"/>   
                        产品条码
                         <input id="txtQueryBarcode" class="easyui-textbox"/>
                        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="ReloadGrid('dgProduct')">查询</a> 
                    </td>
                    <td>
                         <a href="javascript:void(0)" onclick="closeSelectWin()" class="easyui-linkbutton" data-options="iconCls:'icon-return'">取回</a>  
                    </td>
                </tr>
            </table>
        </div>
        
    </div>

    <div  id="SelectCustWin" style="width:800px;height:500px">
             <table id="dgCust"  class="easyui-datagrid" 
            data-options="loadMsg: '正在加载数据，请稍等...',fit:true, rownumbers:true,
                         pagination:true,pageSize:15, pageList:[15, 20, 30, 50],method:'post',striped:true,fitcolumns:true,toolbar:'#divCustBtn',singleSelect:true,selectOnCheck:true,checkOnSelect:true,onCheck:SelectSingleCheckRow,onUncheck:SelectSingleUnCheckRow,onLoadSuccess:SelectLoadSelectSuccess,onDblClickRow:DblClickRow"> 
             <thead>
		        <tr>
                    <th data-options="field:'',checkbox:true"></th> 
		            <th data-options="field:'CustomerCode',width:80">客户编码</th>
                    <th data-options="field:'CustomerName',width:120">名称</th>
                     <th data-options="field:'RouteName',width:120">路线</th>
                    <th data-options="field:'LicenseNo',width:80">许可证号</th>
                    <th data-options="field:'SortId',width:80">排序</th>
                    <th data-options="field:'TelNo',width:80">联系电话</th>
                    <th data-options="field:'Address',width:100">地址</th>
                    <th data-options="field:'CustomerDesc',width:100">客户描述</th>
		        </tr>
            </thead>
        </table>
        <div id="divCustBtn" style="padding: 5px; height: auto">  
    
            <table >
                <tr>
                    <td>
                        客户编码
                        <input id="txtQueryCustomerCode" class ="easyui-textbox" style="width: 100px" />  
                        名称
                        <input id="txtQueryCustomerName" class="easyui-textbox" style="width: 100px" /> 
                        路线
                        <input id="txtQueryRouteName" class="easyui-textbox" style="width: 100px" />
                         地址
                        <input id="txtQueryAddress" class="easyui-textbox" style="width: 100px" />
                        &nbsp;&nbsp;
                        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="ReloadGrid('tbCust')">查询</a> 
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