<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Batchs.aspx.cs" Inherits="WebUI_Stock_Batchs" %>

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
        var Orderurl = "OrderHandler.ashx";

        function getQueryParams(objname, queryParams) {
            var Where = "1=1 ";
            var BatchNo = $("#txtQueryBatchNo").textbox("getValue");
            var ExecuteUser = $("#txtQueryExecuteUser").textbox("getValue");

            if (BatchNo != "") {
                Where += " and BatchNo like '%" + BatchNo + "%'";
            }
            if (ExecuteUser != "") {
                Where += " and ExecuteUser like '%" + ExecuteUser + "%'";
            }

            queryParams.Where = encodeURIComponent(Where);
            //queryParams.t = new Date().getTime(); //使系统每次从后台执行动作，而不是使用缓存。
            return queryParams;

        }

        //修改管理员
        function Edit() {
            if (SessionTimeOut(SessionUrl)) {
                return false;
            }
            if (!GetPermisionByFormID("Batch", 1)) {
                alert("您没有修改权限！");
                return false;
            }
            var row = $('#dg').datagrid('getSelected');
            if (row == null || row.length == 0) {
                $.messager.alert("提示", "请选择要修改的行！", "info");
                return false;
            }

            if (row) {
                var Batch;
                var bln = false;
                var data = { Action: 'FillDataTable', Comd: 'cmd.SelectBatch', Where: "BatchNo='" + row.BatchNo + "'" };
                $.ajax({
                    type: "post",
                    url: url,
                    data: data,
                    dataType: "text",
                    async: false,
                    success: function (result) {
                        var rs = eval('[' + result + ']');
                        if (rs[0].total != 0) {
                            Batch = rs[0].rows[0];
                            bln = true;
                        }
                        else {
                            alert("没有找到该批次资料！");
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
                if (Batch.IsValid == '0') {
                    alert("该批次还未优化，不能重新优化！");
                    return false;
                }

                if (Batch.BeginSortTime != '' && Batch.EndSortTime == "") {
                    alert("该批次正在分拣中，不能重新优化！");
                    return false;

                }
                data = { Action: 'UpdateBatch', BatchNo: Batch.BatchNo };
                $.post(Orderurl, data, function (result) {
                    if (result.status == 1) {
                        ReloadGrid('dg');
                        
                    } else {
                        $.messager.alert('错误', result.msg, 'error');
                    }
                }, 'json');




            }
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

            var data;

            data = { Action: 'Edit', Comd: 'cmd.UpdateLine', json: query };
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
 </script> 
</head>
<body class="easyui-layout">
    <table id="dg"  class="easyui-datagrid" 
        data-options="loadMsg: '正在加载数据，请稍等...',fit:true, rownumbers:true,url:'../../Handler/BaseHandler.ashx?Action=PageDate&FormID=Batch',
                     pagination:true,pageSize:15, pageList:[15, 20, 30, 50],method:'post',striped:true,fitcolumns:true,toolbar:'#tb',singleSelect:true"> 
        <thead>
		    <tr>
		        <th data-options="field:'BatchNo',width:100">批次编码</th>
                 <th data-options="field:'ScDate',width:140">创建时间</th>
                <th data-options="field:'OrderDate',width:100">订单日期</th>
                <th data-options="field:'ValidDesc',width:100">状态</th>
                <th data-options="field:'ExecuteUser',width:100">优化用户</th>
                <th data-options="field:'ExecuteIP',width:80">优化IP</th>
                <th data-options="field:'ValidTime',width:140">优化时间</th>
                <th data-options="field:'BeginSortTime',width:140">分拣开始时间</th>
                <th data-options="field:'EndSortTime',width:140">分拣结束时间</th>
		    </tr>
        </thead>
    </table>
    <div id="tb" style="padding: 5px; height: auto">  
    
        <table style="width:100%" >
            <tr>
                <td>
                    批次编号
                    <input id="txtQueryBatchNo" class ="easyui-textbox" style="width: 100px" />  
                    优化用户
                    <input id="txtQueryExecuteUser" class="easyui-textbox" style="width: 100px" />&nbsp;&nbsp;
                    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="ReloadGrid('dg')">查询</a> 
                </td>
                <td style="width:*" align="right">
                     <a href="javascript:void(0)" onclick="Edit() " class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">重新优化</a>  
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
                    
                    <td align="center" class="musttitle" style="width:90px">
                            批次编码
                    </td>
                    <td  width="160px">
                            &nbsp;<input id="txtID" name="BatchNo" 
                                class="easyui-textbox" data-options="required:true" maxlength="20" style="width:150px"/> 
                    </td>
                    <td align="center" class="musttitle"style="width:90px"  >
                           订单日期
                    </td>
                    <td width="160px"> 
                        &nbsp;<input 
                            id="txtOrderDate" name="OrderDate" class="easyui-textbox" 
                            data-options="required:true" maxlength="50" style="width:150px"/>
                    </td>
                     
                </tr>
                <tr  >
                     <td align="center" class="musttitle"style="width:90px"  >
                           优化状态
                    </td>
                    <td width="160px"> 
                        &nbsp;<select id="ddlIsValid" class="easyui-combobox" data-options="required:true,editable:false" name="IsValid" style="width:150px;">   
                                <option value="1">已优化</option>   
                                <option value="0">未优化</option>   
                             </select>  
                    </td>
                     <td align="center" class="smalltitle"style="width:90px"  >
                           优化用户
                    </td>
                    <td width="160px"> 
                        &nbsp;<input id="txtExecuteUser" name="ExecuteUser" class="easyui-textbox"  style="width:150px"/>  
                    </td>
                     
                </tr>
               <tr> 
               
                     <td align="center" class="smalltitle"style="width:90px"  >
                           优化IP
                    </td>
                    <td width="160px"> 
                          &nbsp;<input id="txtExecuteIP" name="ExecuteIP" 
                                class="easyui-textbox"  maxlength="20" style="width:150px"/>  
                    </td>
                    <td align="center"  class="smalltitle"style="width:90px">
                        优化时间
                  </td> 
                  <td > 
                    &nbsp;<input id="txtValidTime" name="ValidTime" class="easyui-textbox" style="width:150px"/>
                  </td>
               </tr>
                 
                 <tr>
                  
                    <td align="center" class="smalltitle"style="width:90px">
                        分拣开始时间
                  </td> 
                  <td  >
                  &nbsp;<input id="txtBeginSortTime" name="BeginSortTime" class="easyui-datetimebox" data-options="showSeconds:true" style="width:150px"/>
                  </td>
                  <td align="center" class="smalltitle"style="width:90px">
                        分拣结束时间
                  </td> 
                  <td  >
                  &nbsp;<input id="txtEndSortTime" name="EndSortTime" class="easyui-datetimebox" data-options="showSeconds:true" style="width:150px"/>
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