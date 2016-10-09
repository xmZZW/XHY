﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Products.aspx.cs" Inherits="WebUI_CMD_Products" %>

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
        var FormID = "Product";

        function getQueryParams(objname, queryParams) {
            if (objname == "dg") {
                var Where = "1=1 ";
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
                queryParams.Where = encodeURIComponent(Where);
            }
            else {

                var Where = "1=1 ";
                var FactoryID = $("#txtQueryFactoryID").textbox("getValue");
                var FactoryName = $("#txtQueryFactoryName").textbox("getValue");
                var LinkPerson = $("#txtQueryLinkPerson").textbox("getValue");

                if (FactoryID != "") {
                    Where += " and FactoryID like '%" + FactoryID + "%'";
                }
                if (FactoryName != "") {
                    Where += " and FactoryName like '%" + FactoryName + "%'";
                }
                if (LinkPerson != "") {
                    Where += " and LinkPerson like '%" + LinkPerson + "%'";
                }
                queryParams.Where = encodeURIComponent(Where);
            }
            //queryParams.t = new Date().getTime(); //使系统每次从后台执行动作，而不是使用缓存。
            return queryParams;

        }
        //添加管理员
        function Add() {
            if (SessionTimeOut(SessionUrl)) {
                return false;
            }
            if (!GetPermisionByFormID("Product", 0)) {
                alert("您没有新增权限！");
                return false;
            }
            $('#fm').form('clear');
            BindDropDownList();
            $('#AddWin').dialog('open').dialog('setTitle', '产品资料--新增');
            SetAutoCodeNewID('txtID', 'cmd_Product', 'ProductCode', '1=1');
            $('#txtPageState').val("Add");
            $("#txtID").textbox('readonly', false);
            $("#txtFactoryName").textbox("readonly", true);
            $('#ddlIsPick').combobox('setValue', '1');
            $('#ddlIsAbnormity').combobox('setValue', '0');
            $('#ddlStatus').combobox('setValue', '1');
            SetInitValue('<%=Session["G_user"] %>');
            SetInitColor();
            $("input", $("#txtFactory").next("span")).addClass("TextRead");
        }
        //修改管理员
        function Edit() {
            if (SessionTimeOut(SessionUrl)) {
                return false;
            }
            if (!GetPermisionByFormID("Product", 1)) {
                alert("您没有修改权限！");
                return false;
            }
            var row = $('#dg').datagrid('getSelected');
            if (row == null || row.length == 0) {
                $.messager.alert("提示", "请选择要修改的行！", "info");
                return false;
            }
            BindDropDownList();
            if (row) {
                var data = { Action: 'FillDataTable', Comd: 'cmd.SelectProduct', Where: "ProductCode='" + row.ProductCode + "'" };
                $.post(url, data, function (result) {
                    var Product = result.rows[0];
                    $('#AddWin').dialog('open').dialog('setTitle', '产品资料--编辑');
                    $('#fm').form('load', Product);

                }, 'json');
            }
            $('#txtPageState').val("Edit");
            $("#txtFactoryName").textbox("readonly", true);
            $("#txtID").textbox("readonly", true);
            SetInitColor();
            $("input", $("#txtFactory").next("span")).addClass("TextRead");
        }
        function BatchEdit() {
            if (SessionTimeOut(SessionUrl)) {
                return false;
            }
            var row = $('#dg').datagrid('getSelected');
            if (row==null || row.length == 0) {
                $.messager.alert("提示", "请选择要修改的行！", "info");
                return false;
            }

            if (row) {
                $('#BatchWin').dialog('open').dialog('setTitle', '批次变更');
                $("#txtBatchProductCode").textbox("setValue", row.ProductCode);
                $("#txtBatchNewProductCode").textbox("setValue", "");
            }
            $("input", $("#txtBatchProductCode").next("span")).addClass("TextRead");
        }
        //绑定下拉控件
        function BindDropDownList() {
            var data = { Action: 'FillDataTable', Comd: 'cmd.SelectProductCategory', Where: '1=1' };
            BindComboList(data, 'ddlCategoryCode', 'CategoryCode', 'CategoryName');
         
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
                if (HasExists('cmd_product', "ProductCode='" + $('#txtID').textbox('getValue') + "'", '产品编码已经存在，请重新修改！'))
                    return false;
                data = { Action: 'Add', Comd: 'cmd.InsertProduct', json: query };
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
                data = { Action: 'Edit', Comd: 'cmd.UpdateProduct', json: query };
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
        function BatchSave() {
            if (SessionTimeOut(SessionUrl)) {
                return false;
            }
            if (!$("#Batchfrm").form('validate')) {
                return false;
            }

            //判断单号是否存在
            if (HasExists('cmd_product', "ProductCode='" + $('#txtBatchNewProductCode').textbox('getValue') + "'", '产品编码已经存在，请重新修改！'))
                return false;
            var productcode = $('#txtBatchProductCode').textbox('getValue');
            var Newproductcode = $('#txtBatchNewProductCode').textbox('getValue');
            data = { Action: 'BatchChangeCode', ProductCode:productcode, NewProductCode: Newproductcode };
            $.post('../../Handler/OtherHandler.ashx', data, function (result) {
                if (result.status == 1) {
                    ReloadGrid('dg');
                    $('#BatchWin').window('close');
                } else {
                    $.messager.alert('错误', result.msg, 'error');
                }
            }, 'json');




        }
        //删除管理员
        function Delete() {
            if (SessionTimeOut(SessionUrl)) {
                return false;
            }
            if (!GetPermisionByFormID("Product", 2)) {
                alert("您没有删除权限！");
                return false;
            }
            var checkedItems = $('#dg').datagrid('getChecked');
            if (checkedItems.length==0) {
                $.messager.alert("提示", "请选择要删除的行！", "info");
                return false;
            }
            if (checkedItems) {
                $.messager.confirm('提示', '你确定要删除吗？', function (r) {
                    if (r) {
                        var deleteCode = [];
                        var blnUsed = false;
                        $.each(checkedItems, function (index, item) {
                            if (HasExists('VUsed_CMD_Product', "ProductCode='" + item.ProductCode + "'", "产品编码 "+item.ProductCode+" 已经被其它单据使用，无法删除！"))
                                blnUsed = true;
                            deleteCode.push(item.ProductCode);
                        });
                        if (blnUsed)
                            return false;
                        var data = { Action: 'Delete', FormID: FormID, Comd: 'cmd.DeleteProduct', json: "'" + deleteCode.join("','") + "'" };
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

        function DblClickRow(rowIndex, rowData) {
            DblSingleClickRow('', rowIndex, rowData);
        }

        function CheckRow(rowIndex, rowData) {
            CheckSelectRow('dg', rowIndex, rowData);
        }

        function AddRow(ObjName,RowData) {
            $('#txtFactoryID').val(RowData.FactoryID);
            $('#txtFactoryName').textbox('setValue', RowData.FactoryName);
            
        }
        function BindSelectUrl(objName) {
            $('#dgSelect').datagrid({
                url: '../../Handler/BaseHandler.ashx?Action=PageDate&FormID=Factory',
                pageNumber: 1,
                queryParams: { Where: encodeURIComponent("1=1") }
            });
        }
        
 </script> 
</head>
<body class="easyui-layout">
    <table id="dg"  class="easyui-datagrid" 
        data-options="loadMsg: '正在加载数据，请稍等...',fit:true, rownumbers:true,url:'../../Handler/BaseHandler.ashx?Action=PageDate&FormID='+FormID,
                     pagination:true,pageSize:15, pageList:[15, 20, 30, 50],method:'post',striped:true,fitcolumns:true,toolbar:'#tb',singleSelect:true,selectOnCheck:false,checkOnSelect:false,onCheck:CheckRow,onUncheck:CheckRow"> 
        <thead data-options="frozen:true">
			<tr>
				<th data-options="field:'',checkbox:true"></th> 
		        <th data-options="field:'ProductCode',width:80">产品编码</th>
                <th data-options="field:'ProductName',width:180">品名</th>
			</tr>
		</thead>
        <thead>
		    <tr>
                <th data-options="field:'CategoryName',width:80">产品类别</th>
                <th data-options="field:'ShortName',width:160">简称</th>
                <th data-options="field:'FactoryName',width:150">供应商</th>
                <th data-options="field:'Province',width:100">省份</th>
                <th data-options="field:'Unit',width:50">单位</th>
                <th data-options="field:'AbnormityDesc',width:50">异型</th>
                <th data-options="field:'PickDesc',width:50">分拣</th>
                <th data-options="field:'Barcode',width:120">产品条码</th>
                <th data-options="field:'BarcodePack',width:120">包装条码</th>
                <th data-options="field:'Length',width:100">长度</th>
                <th data-options="field:'Width',width:100">宽度</th>
                <th data-options="field:'Height',width:100">高度</th>
                <th data-options="field:'Creator',width:80">建单人员</th>
                <th data-options="field:'CreateDate',width:120">建单日期</th>
                <th data-options="field:'Updater',width:80">修改人员</th>
                <th data-options="field:'UpdateDate',width:120">修改日期</th>
		    </tr>
        </thead>
    </table>
    <div id="tb" style="padding: 5px; height: auto">  
    
        <table style="width:100%">
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
                    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="ReloadGrid('dg')">查询</a> 
                </td>
                <td  style="width:*"  align="right">
                     <a href="javascript:void(0)" onclick="Add()" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">新增</a>  
                     <a href="javascript:void(0)" onclick="Edit() " class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">修改</a>  
                     <a href="javascript:void(0)" onclick="Delete()" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true">删除</a>
                     <a href="javascript:void(0)" onclick="BatchEdit() " class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">批次变更</a>
                     <a href="javascript:void(0)" onclick="Exit()" class="easyui-linkbutton" data-options="iconCls:'icon-no',plain:true">离开</a>
                </td>
            </tr>
        </table>
   </div>
      <%-- 弹出操作框--%>
    <div id="AddWin" class="easyui-dialog" style="width: 800px; height: auto; padding: 5px 5px"
        data-options="closed:true,buttons:'#AddWinBtn'"> 
        <form id="fm" method="post">
              <table id="Table1" class="maintable"  width="100%" align="center">			
				<tr>
                    <td align="center" class="musttitle"style="width:90px">
                        产品类别 </td>
                    <td width="176px">
                        
                        &nbsp;<input id="ddlCategoryCode" name="CategoryCode" class="easyui-combobox" data-options="required:true,editable:false" style="width:160px"/> 
                        <input name="PageState" id="txtPageState" type="hidden" />
                        <input name="AreaCode" id="txtAreaCode" type="hidden" />
                    </td>
                    <td align="center" class="musttitle"style="width:90px">
                            产品编码
                    </td>
                    <td  width="176px">
                            &nbsp;<input id="txtID" name="ProductCode" 
                                class="easyui-textbox" data-options="required:true" maxlength="20" style="width:160px"/>
                    </td>
                    <td align="center" class="musttitle"style="width:90px"  >
                           简称
                    </td>
                    <td > 
                        &nbsp;<input id="txtShortName" name="ShortName" class="easyui-textbox" data-options="required:true" maxlength="50" style="width:160px"/>
                    </td>
                </tr>
                <tr>
                    
                    <td align="center" class="musttitle"style="width:90px"  >
                           名称 
                    </td>
                    <td  colspan="3">
                            &nbsp;<input id="txtProductName" name="ProductName" data-options="required:true" class="easyui-textbox" 
                                maxlength="100" style="width:430px"/>

                    </td>
                     
                    <td align="center" class="smalltitle" style="width:90px" >
                        计量单位
                    </td>
                    <td>
                     &nbsp;<input id="txtUnit" name="unit" class="easyui-textbox" maxlength="25" style="width:160px"/>
                    </td>
                     
                    
                </tr>
                <tr>
                    <td align="center" class="smalltitle"style="width:90px">
                            供应商</td>
                    <td  colspan="3">
                        <input name="FactoryID" id="txtFactoryID" type="hidden" />
                        &nbsp;<input id="txtFactoryName" name="FactoryName" 
                            class="easyui-textbox"  style="width:400px"/>
                            <input type="button" id="btnFactory" class="ButtonCss" onclick="SelectWinShow('SelectWin','供应商--选择')" value="..."/>
                         
                    </td>
                   
                    <td align="center" class="smalltitle">
                        状态</td>
                    <td>
                        &nbsp;<select id="ddlStatus" class="easyui-combobox" data-options="editable:false" name="Status" style="width:160px;">   
                                <option value="1" selected="selected">可用</option>   
                                <option  value="0">禁用</option>   
                            </select>  

                    </td>
                   
                    
                </tr>
                <tr>
                    <td align="center" class="smalltitle">
                        异型</td>
                    <td >
                         &nbsp;<select id="ddlIsAbnormity" class="easyui-combobox" data-options="editable:false" name="IsAbnormity" style="width:160px;">   
                                    <option value="1">是</option>   
                                    <option  value="0">否</option>   
                                </select>  
                    </td>
                    <td align="center" class="smalltitle">
                        分拣</td>
                    <td>
                         &nbsp;<select id="ddlIsPick" class="easyui-combobox" data-options="editable:false" name="IsPick" style="width:160px;">   
                                    <option value="1">是</option>   
                                    <option  value="0">否</option>   
                                </select>  
                    </td>
                    <td align="center" class="smalltitle">
                           省份
                    </td>
                    <td>
                         &nbsp;<input id="txtProvince" name="Province" class="easyui-textbox" maxlength="50" style="width:160px"/>
                    </td>
                </tr>
                <tr>
                    <td align="center" class="smalltitle"style="width:90px"  >
                            长度
                    </td>
                    <td  width="176px">
                     &nbsp;<input id="txtLength" name="Length" class="easyui-numberbox" data-options="min:0,precision:2" style="width:160px"/> 
                    </td>
                    <td align="center" class="smalltitle"style="width:90px"  >
                           宽度 
                    </td>
                    <td width="176px">
                        &nbsp;<input id="txtWidth" name="Width" class="easyui-numberbox" data-options="min:0,precision:2" style="width:160px"/> 
                    </td>
                    <td align="center" class="smalltitle"style="width:90px">
                        高度</td>
                    <td width="176px">
                        &nbsp;<input id="txtHeight" name="Height"class="easyui-numberbox" data-options="min:0,precision:2" style="width:160px"/> 
                    </td>
                </tr>
                 <tr>
                    <td align="center" class="smalltitle"style="width:90px"  >
                            产品条码</td>
                    <td  width="176px">
                         &nbsp;<input id="txtBarcode" name="Barcode" class="easyui-textbox" maxlength="32" style="width:160px"/>
                    </td>
                    <td align="center" class="smalltitle"style="width:90px"  >
                           包装条码</td>
                    <td width="176px">
                            &nbsp;<input id="txtBarcodePack" name="BarcodePack" class="easyui-textbox" maxlength="32" style="width:160px"/>
                    </td>
                     <td align="center" class="smalltitle"style="width:90px"  >
                    建单人员</td>
                    <td >
                           &nbsp;<input id="txtCreator" class="easyui-textbox" data-options="editable:false" 
                        name="Creator" style="width:160px" /></td>
                   
                    
                </tr>	
		   
          
              <tr>
                
                <td align="center" class="smalltitle"style="width:90px">
                    建单日期  
                </td>
                <td>
                    &nbsp;<input id="txtCreateDate" 
                        name="CreateDate" class="easyui-textbox" data-options="editable:false"  
                        style="width:160px"/>
                </td>
                <td align="center" class="smalltitle"style="width:90px">
                    修改人员
                </td>
                <td>
                        &nbsp;<input id="txtUpdater" name="Updater" 
                            class="easyui-textbox" data-options="editable:false"  style="width:160px"/>
                </td>
                <td align="center" class="smalltitle"style="width:90px">
                    修改日期
                </td>
                <td>
                        &nbsp;<input id="txtUpdateDate" name="UpdateDate" 
                            class="easyui-textbox" data-options="editable:false"  style="width:160px"/>
                </td>
             </tr>
             </table>
        </form>
    </div>
    <div id="AddWinBtn">
        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="Save()">保存</a>
        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="javascript:$('#AddWin').dialog('close')">关闭</a>
    </div>

    <%-- 单号批次变更 --%>
     <div id="BatchWin" class="easyui-dialog" style="width: 350px; height: auto; padding: 5px 5px"
        data-options="closed:true,buttons:'#BatchWinBtn'"> 
        <form id="Batchfrm" method="post">
              <table id="Table2" class="maintable"  width="100%" align="center">			
				<tr>
                    <td align="center" class="musttitle"style="width:90px">
                        产品编码 </td>
                    <td width="176px">
                        
                        &nbsp;<input id="txtBatchProductCode" name="ProductCode" class="easyui-textbox" 
                            data-options="required:true,editable:false" style="width:172px"/>&nbsp;
                       
                    </td>
                    
                </tr>
                <tr>
                    <td align="center" class="musttitle"style="width:90px">
                            新产品编码
                    </td>
                    <td  width="176px">
                            &nbsp;<input id="txtBatchNewProductCode" name="NewProductCode" 
                                class="easyui-textbox" data-options="required:true" maxlength="32" 
                                style="width:172px"/>
                    </td>
                     
                </tr>
                	
		   
          
             
             </table>
        </form>
    </div>
    <div id="BatchWinBtn">
        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="BatchSave()">保存</a>
        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="javascript:$('#BatchWin').dialog('close')">关闭</a>
    </div>


    <div  id="SelectWin" style="width:650px;height:300px">
             <table id="dgSelect"  class="easyui-datagrid" 
            data-options="loadMsg: '正在加载数据，请稍等...',fit:true, rownumbers:true,
                         pagination:true,pageSize:15, pageList:[15, 20, 30, 50],method:'post',striped:true,fitcolumns:true,toolbar:'#tbSelect',singleSelect:true,selectOnCheck:true,checkOnSelect:true,onCheck:SelectSingleCheckRow,onUncheck:SelectSingleUnCheckRow,onLoadSuccess:SelectLoadSelectSuccess,onDblClickRow:DblClickRow"> 
            <thead data-options="frozen:true">
			    <tr>
				    <th data-options="field:'',checkbox:true"></th> 
		            <th data-options="field:'FactoryID',width:100">供应商编码</th>
                    <th data-options="field:'FactoryName',width:100">名称</th>
			    </tr>
		    </thead>
            <thead>
		        <tr>
                    <th data-options="field:'LinkPerson',width:80">联系人</th>
                    <th data-options="field:'LinkPhone',width:100">联系电话</th>
                    <th data-options="field:'Fax',width:100">传真</th>
                    <th data-options="field:'Address',width:100">地址</th>
                     
		        </tr>
            </thead>
        </table>
        <div id="tbSelect" style="padding: 5px; height: auto">  
    
            <table >
                <tr>
                    <td>
                        供应商编码
                        <input id="txtQueryFactoryID" class ="easyui-textbox" style="width: 100px" />  
                        名称
                        <input id="txtQueryFactoryName" class="easyui-textbox" style="width: 100px" />   
                        联系人<input id="txtQueryLinkPerson" class="easyui-textbox"/>   
                         
                        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="ReloadGrid('dgSelect')">查询</a> 
                    </td>
                    <td>
                         <a href="javascript:void(0)" onclick="closeSelectWin('SelectWin')" class="easyui-linkbutton" data-options="iconCls:'icon-return'">取回</a>  
                    </td>
                </tr>
            </table>
        </div>
        
    </div>

</body>
</html>