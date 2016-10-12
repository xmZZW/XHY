<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Channels.aspx.cs" Inherits="WebUI_CMD_Channels" %>

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
        var FormID = "Channel";

        function getQueryParams(objname, queryParams) {
            if (objname == "dg") {
                var Where = "1=1 ";
                var ChannelCode = $("#txtQueryChannelCode").textbox("getValue");
                var ChannelName = $("#txtQueryChannelName").textbox("getValue");

                if (ChannelCode != "") {
                    Where += " and ChannelCode like '%" + ChannelCode + "%'";
                }
                if (ChannelName != "") {
                    Where += " and ChannelName like '%" + ChannelName + "%'";
                }

                queryParams.Where = encodeURIComponent(Where);
            }
            else {

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
            return queryParams;

        }
        
        //修改管理员
        function Edit() {
            if (SessionTimeOut(SessionUrl)) {
                return false;
            }
            if (!GetPermisionByFormID("Channel", 1)) {
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
                var data = { Action: 'FillDataTable', Comd: 'cmd.SelectChannel', Where: "ChannelCode='" + row.ChannelCode + "'" };
                $.post(url, data, function (result) {
                    var Product = result.rows[0];
                    $('#AddWin').dialog('open').dialog('setTitle', '货仓资料--编辑');
                    $('#fm').form('load', Product);

                }, 'json');
            }

            $("#txtID").textbox("readonly", true);
            SetInitColor();
        }
        //绑定下拉控件
        function BindDropDownList() {
            var data = { Action: 'FillDataTable', Comd: 'cmd.SelectLine', Where: '1=1' };
            BindComboList(data, 'ddlLineCode', 'LineCode', 'LineName');
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

            data = { Action: 'Edit', Comd: 'cmd.UpdateChannel', json: query };
            $.post(url, data, function (result) {
                if (result.status == 1) {
                    ReloadGrid('dg');
                    $('#AddWin').window('close');
                    
                } else {
                    $.messager.alert('错误', result.msg, 'error');
                }
            }, 'json');


        }

         

        function CheckRow(rowIndex, rowData) {
            CheckSelectRow('dg', rowIndex, rowData);
        }

        function BindSelectUrl(objName) {
            $('#dgSelect').datagrid({
                url: '../../Handler/BaseHandler.ashx?Action=PageDate&FormID=Product',
                pageNumber: 1,
                queryParams: { Where: encodeURIComponent("1=1") }
            });
        }

        function AddRow(objName,RowData) {
            $('#txtProductCode').textbox('setValue', RowData.ProductCode);
            $('#txtProductName').textbox('setValue', RowData.ProductName);

        }
 </script> 
</head>
<body class="easyui-layout">
    <table id="dg"  class="easyui-datagrid" 
        data-options="loadMsg: '正在加载数据，请稍等...',fit:true, rownumbers:true,url:'../../Handler/BaseHandler.ashx?Action=PageDate&FormID='+FormID,
                     pagination:true,pageSize:15, pageList:[15, 20, 30, 50],method:'post',striped:true,fitcolumns:true,toolbar:'#tb',singleSelect:true"> 
        <thead>
		    <tr>
		        <th data-options="field:'ChannelCode',width:80">货仓编码</th>
                <th data-options="field:'ChannelName',width:100">名称</th>
                <th data-options="field:'LineCode',width:80">分拣线</th>
                <th data-options="field:'ChannelTypeDesc',width:80">货仓类型</th>
                <th data-options="field:'ProductCode',width:80">产品编码</th>
                <th data-options="field:'ProductName',width:150">产品名称</th>
                <th data-options="field:'StatusDesc',width:80">状态</th>
                <th data-options="field:'ChannelOrder',width:60">排货顺序</th>
		    </tr>
        </thead>
    </table>
    <div id="tb" style="padding: 5px; height: auto">  
    
        <table style="width:100%" >
            <tr>
                <td>
                    货仓编码
                    <input id="txtQueryChannelCode" class ="easyui-textbox" style="width: 100px" />  
                    名称
                    <input id="txtQueryChannelName" class="easyui-textbox" style="width: 100px" /> &nbsp;&nbsp;
                    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="ReloadGrid('dg')">查询</a> 
                </td>
                <td style="width:*" align="right">
                     <a href="javascript:void(0)" onclick="Edit() " class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">修改</a>  
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
                            货仓编码
                    </td>
                    <td  width="160px">
                            &nbsp;<input id="txtID" name="ChannelCode" 
                                class="easyui-textbox" data-options="required:true" maxlength="20" style="width:150px"/> 
                    </td>
                    <td align="center" class="musttitle" style="width:90px" >
                           名称
                    </td>
                    <td width="160px"> 
                        &nbsp;<input 
                            id="txtChannelName" name="ChannelName" class="easyui-textbox" 
                            data-options="required:true" maxlength="50" style="width:150px"/>
                    </td>
                     
                </tr>
                <tr>
                    <td align="center" class="musttitle"style="width:90px"  >
                           状态
                    </td>
                    <td width="160px"> 
                        &nbsp;<select id="ddlStatus" class="easyui-combobox" 
                            data-options="required:true,editable:false" name="Status" style="width:150px;">   
                                <option value="1">启用</option>   
                                <option value="0">禁用</option>   
                             </select>  
                    </td>
                    <td align="center" class="musttitle" >
                        分拣线
                    </td>
                    <td style="width:160px">
                        &nbsp;<input id="ddlLineCode" name="LineCode" class="easyui-combobox" data-options="required:true,editable:false" style="width:150px"/>
                    </td>
                    
                     
                </tr> 
                <tr>
                    <td align="center" class="smalltitle"style="width:90px"  >
                           分拣产品
                    </td>
                    <td  colspan="3"> 
                        &nbsp;<input 
                            id="txtProductCode" name="ProductCode" class="easyui-textbox" maxlength="50" style="width:149px"/>
                            <input id="txtProductName" name="ProductName" class="easyui-textbox" 
                            maxlength="50" style="width:205px"/>
                            <input type="button" id="btnProduct" class="ButtonCss" onclick="SelectWinShow('SelectWin','产品资料--选择')" value="..."/></td>
                </tr>
                 
                 <tr>
                    <td align="center" class="smalltitle"style="width:90px"  >
                           排货顺序 
                    </td>
                    <td width="160px"> 
                       &nbsp;<input id="txtChannelOrder" name="ChannelOrder"  class="easyui-numberbox" data-options="min:0,precision:0"  style="width:150px"/> 
                    </td>
                    <td align="center" class=" smalltitle" >
                            货仓类型
                    </td>
                    <td  width="160px">
                           &nbsp;<select id="ddlChannelType" class="easyui-combobox" data-options="required:true,editable:false" name="ChannelType" style="width:150px;">   
                                <option value="2">立式机</option>   
                             </select>  
                    </td>
                    
                     
                </tr> 
                	
		</table>
        </form>
    </div>
    <div id="AddWinBtn">
        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="Save()">保存</a>
        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="javascript:$('#AddWin').dialog('close')">关闭</a>
    </div>

    <div  id="SelectWin" style="width:800px;height:500px">
             <table id="dgSelect"  class="easyui-datagrid" 
            data-options="loadMsg: '正在加载数据，请稍等...',fit:true, rownumbers:true,
                         pagination:true,pageSize:15, pageList:[15, 20, 30, 50],method:'post',striped:true,fitcolumns:true,toolbar:'#tbSelect',singleSelect:true,selectOnCheck:true,checkOnSelect:true,onCheck:SelectCheckRow,onUncheck:SelectUnCheckRow,onCheckAll:SelectCheckRowAll,onUncheckAll:SelectUnCheckRowAll,onLoadSuccess:SelectLoadSelectSuccess,onDblClickRow:DblClickRow"> 
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