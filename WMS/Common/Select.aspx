<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Select.aspx.cs" Inherits="Common_Select" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <script type="text/javascript" language="javascript">
        function getQueryParams(queryParams) {
            var Where = "1=1 ";
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
            queryParams.Where = encodeURIComponent(Where);
            //queryParams.t = new Date().getTime(); //使系统每次从后台执行动作，而不是使用缓存。
            return queryParams;

        }
        //增加查询参数，重新加载表格
        function ReloadGrid() {
            var queryParams = $('#dg').datagrid('options').queryParams;
            getQueryParams(queryParams);
            $('#dg').datagrid('options').queryParams = queryParams;
            $("#dg").datagrid('reload');
        }

       
 </script> 
</head>
<body class="easyui-layout">
    <table id="dgSelect"  class="easyui-datagrid" 
        data-options="loadMsg: '正在加载数据，请稍等...',fit:true, rownumbers:true,url:'../../Handler/BaseHandler.ashx?Action=PageDate&Comd=CMD.SelectProduct',
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
                    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="ReloadGrid()">查询</a> 
                </td>
                <td>
                     <a href="javascript:void(0)" onclick="closeCustomWin()" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">取回</a>  
                </td>
            </tr>
        </table>
    </div>
</body>
</html>