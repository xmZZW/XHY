<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Lines.aspx.cs" Inherits="WebUI_CMD_Lines" %>

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

        function getQueryParams(objname, queryParams) {
            var Where = "1=1 ";
            var LineCode = $("#txtQueryLineCode").textbox("getValue");
            var LineName = $("#txtQueryLineName").textbox("getValue");

            if (LineCode != "") {
                Where += " and LineCode like '%" + LineCode + "%'";
            }
            if (LineName != "") {
                Where += " and LineName like '%" + LineName + "%'";
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
            if (!GetPermisionByFormID("Line", 1)) {
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
                var data = { Action: 'FillDataTable', Comd: 'cmd.SelectLine', Where: "LineCode='" + row.LineCode + "'" };
                $.post(url, data, function (result) {
                    var Product = result.rows[0];
                    $('#AddWin').dialog('open').dialog('setTitle', '分拣线--编辑');
                    $('#fm').form('load', Product);

                }, 'json');
            }
           
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
        data-options="loadMsg: '正在加载数据，请稍等...',fit:true, rownumbers:true,url:'../../Handler/BaseHandler.ashx?Action=PageDate&FormID=Line',
                     pagination:true,pageSize:15, pageList:[15, 20, 30, 50],method:'post',striped:true,fitcolumns:true,toolbar:'#tb',singleSelect:true"> 
        <thead>
		    <tr>
		        <th data-options="field:'LineCode',width:80">分拣线编码</th>
                <th data-options="field:'LineName',width:100">名称</th>
                <th data-options="field:'LineTypeDesc',width:100">分拣类型</th>
                <th data-options="field:'StatusDesc',width:100">状态</th>
                <th data-options="field:'Ability',width:100">分拣能力</th>
                <th data-options="field:'ProductTotal',width:80">分拣种类</th>
                <th data-options="field:'PackCapacity',width:80">包装容量</th>
		    </tr>
        </thead>
    </table>
    <div id="tb" style="padding: 5px; height: auto">  
    
        <table style="width:100%" >
            <tr>
                <td>
                    分拣线编码
                    <input id="txtQueryLineCode" class ="easyui-textbox" style="width: 100px" />  
                    分拣线名称
                    <input id="txtQueryLineName" class="easyui-textbox" style="width: 100px" />&nbsp;&nbsp;
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
                            编码
                    </td>
                    <td  width="160px">
                            &nbsp;<input id="txtID" name="LineCode" 
                                class="easyui-textbox" data-options="required:true" maxlength="20" style="width:150px"/> 
                    </td>
                    <td align="center" class="musttitle"style="width:90px"  >
                           名称
                    </td>
                    <td width="160px"> 
                        &nbsp;<input 
                            id="txtLineName" name="LineName" class="easyui-textbox" 
                            data-options="required:true" maxlength="50" style="width:150px"/>
                    </td>
                     
                </tr>
                <tr  >
                     <td align="center" class="musttitle"style="width:90px"  >
                           分拣类型
                    </td>
                    <td width="160px"> 
                        &nbsp;<select id="ddlLineType" class="easyui-combobox" data-options="required:true,editable:false" name="LineType" style="width:150px;">   
                                <option value="0">手动</option>   
                                <option value="1">半自动</option> 
                                <option value="2">自动</option>   
                             </select>  
                    </td>

                     <td align="center" class="musttitle"style="width:90px"  >
                           状态
                    </td>
                    <td width="160px"> 
                        &nbsp;<select id="ddlStatus" class="easyui-combobox" data-options="required:true,editable:false" name="Status" style="width:150px;">   
                                <option value="1">启用</option>   
                                <option value="0">禁用</option>   
                             </select>  
                    </td>

                </tr>
                 
                 <tr>
                  <td align="center"  class="smalltitle"style="width:90px">
                        分拣能力
                  </td> 
                  <td > 
                    &nbsp;<input id="txtAbility" name="Ability" class="easyui-numberbox" data-options="min:0,precision:0" style="width:150px"/>
                  </td>
                    <td align="center" class="smalltitle"style="width:90px">
                        分拣种类
                  </td> 
                  <td  >
                  &nbsp;<input id="txtProductTotal" name="ProductTotal" class="easyui-numberbox" data-options="min:0,precision:0" style="width:150px"/>
                  </td>
                 </tr>
                 <tr>
                   
                  <td align="center"  class="smalltitle"style="width:90px">
                        包装容量
                  </td> 
                  <td   > 
                    &nbsp;<input id="txtPackCapacity" name="PackCapacity" class="easyui-numberbox" data-options="min:0,precision:0" style="width:150px"/>
                  </td>
                  <td align="center"  class="smalltitle"style="width:90px">
                        &nbsp;</td> 
                  <td >
                    &nbsp;
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