<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PwdModify.aspx.cs" Inherits="WebUI_SysInfo_PwdModify" %>

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
    
    <script type="text/javascript" language="javascript">
            function AckPassword() {
                var txtNewPwd = document.getElementById("txtNewPwd").value;
                var txtAckPwd = document.getElementById("txtAckPwd").value;

                if (document.getElementById("txtNewPwd").value == document.getElementById("txtAckPwd").value) // txtNewP==txtAckPwd)
                {
                    return true;
                }
                else {
                    document.getElementById("labMessage").innerText = "密码不一致";
                    return false;
                }
            }
            function CancelModify() {
                document.getElementById("txtNewPwd").value = "";
                document.getElementById("txtAckPwd").value = "";
                document.getElementById("txtOldPwd").value = "";
                return false;
            }
            function Exit() {

                window.parent.removetab();
                return false;
            }

    </script>
</head>
<body style="text-align: left; width: 98%; height: 98%;">
    <form id="form1" runat="server" defaultfocus="txtOldPwd">  
        <div style="height:120px;"></div>
        <table id="ModifyPwd" border="0" cellpadding="3" cellspacing="0"  style="width:400px"  align="center">
            <tr>
              <td colspan="2"  style=" text-align:center; color:#1a70ad;height:55px; font-size:13pt;">
                  <span style=""> <strong>::: 用户密码修改 :::</strong></span>
              </td>
            </tr>
            <tr >
                <td   align="center" style=" width:20%;" >
                    用 户 名:</td>
                <td  >
                <asp:TextBox ID="txtUserName" runat="server" ReadOnly="True" CssClass="TextBox" 
                        Width="80%" ></asp:TextBox></td>
            </tr>
            <tr>
                <td   align="center" style=" width:20%;"> 旧 密 码:</td>
                <td>
                   <asp:TextBox ID="txtOldPwd" runat="server"  TextMode="Password" 
                        CssClass="TextBox" Width="80%"></asp:TextBox></td>
            </tr>
            <tr>
                 <td  align="center" style=" width:20%;">
                     新 密 码:</td>
                 <td>
                    <asp:TextBox ID="txtNewPwd" runat="server" TextMode="Password"  
                         CssClass="TextBox" Width="80%"></asp:TextBox></td>
            </tr>
             <tr  >
                <td   align="center" style=" width:20%;"> 确认密码:</td>
                <td>
                   <asp:TextBox ID="txtAckPwd" runat="server" TextMode="Password" 
                        CssClass="TextBox" Width="80%"></asp:TextBox></td>
            </tr>
            
            <tr >
                  <td colspan="2" style=" text-align :center; height: 35px; padding-top:5px;"> 
                         <asp:Button ID="Button1" runat="server" OnClientClick="return AckPassword();" OnClick="lbtnSave_Click"  CssClass="easyui-linkbutton" Text="保存"/>&nbsp;&nbsp;&nbsp;&nbsp;
                      <asp:Button ID="Button2" runat="server" OnClientClick="return Exit()"  CssClass="easyui-linkbutton"  Text="取消" /><br />
                        
                  </td> 
            </tr>
             <tr >
                  <td colspan="2" style=" text-align :center; height: 25px; "> 
                        <asp:Label ID="labMessage" runat="server" ForeColor="Red" Width="112px" ></asp:Label>  
                  </td> 
            </tr>

        </table>
    </form>
</body>
</html>

