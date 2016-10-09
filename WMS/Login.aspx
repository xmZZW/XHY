<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html />
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>登录系统</title>
    <script language="javascript" type="text/javascript">
        if (self.location != top.location) {
            top.location.href = self.location.href;
        }
        function document.onkeydown() {
            if (event.keyCode == 13 && event.srcElement.type != 'button' && event.srcElement.type != 'submit' && event.srcElement.type != 'reset' && event.srcElement.type != 'textarea' && event.srcElement.type != '') {
                event.keyCode = 9;
                GotoLogin();
            }
        }
        function GotoLogin() {
            document.getElementById("btnLogin").click();
        }
 										 
   </script>
    <style type="text/css">
        label{
	        width:300px;
	        float:left;
	        font-size:20px;
	        font-weight:bold;
	        color:#999999;
	        line-height:50px;
	        margin-left:18px;
	        font-family:"微软雅黑";
        }
        .uid{
             background:url(images/login/ico-uid.png) no-repeat;
  	         background-position: left;
  	         padding-left: 35px;
	 
        }
        .pwd{
             background:url(images/login/ico-pwd.png) no-repeat;
  	         background-position: left;
  	         padding-left: 35px;
	 
        }
        input{
	        width:300px;
	        height:43px;
	        border:1px solid #e6e6e6;
	        float:left;
	        margin-left:18px;
	        margin-bottom:14px;	
	        font-size:14px;
	        color:#999;
	        line-height:43px;
        }
        .buttonLogin{
	        width:300px;
	        height:48px;
	        background:#149CDF;
	        font-size:18px;
	        font-weight:bold;
	        font-family:"微软雅黑";	
	        margin-left:18px;
	        border:0px;
	        color:#fff;	
	        cursor:hand;
	        margin-top:30px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"  />  
    <div>
     <table style="width:100%; height:100%;" border="0">
        <tr>
        <td valign="middle" align="center">

        <table style="width:100%; height:600px;" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td style="height:109px; background:#29ACF2" align="center">
	        <table style="width:80%; height:100%; background:url(images/login/headbg.png) no-repeat left;" border="0" cellspacing="0" cellpadding="0"  >
	          <tr>
		        <td><img alt="" src="images/login/logo.png" border="0" style="margin-left:85px;"/></td>
	          </tr>
	        </table>
	        </td>
          </tr>
          <tr>
            <td align="center">
	        <table style="width:80%;height:100%;background:url(images/login/mainbg.png) no-repeat left;"  border="0" cellspacing="0" cellpadding="0"  >
	          <tr>
		        <td width="55%">&nbsp;</td>
		        <td>
			        <div style="width:338px; height:291px; border:1px solid #E6E6E6; background:#fff;">
                        <table style="width:100%;height:100%;"  border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td><label>欢迎登录</label></td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:TextBox ID="txtUserName" class="uid" value="" placeholder="请输入帐号" autofocus runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                     <asp:TextBox ID="txtPassWord" class="pwd" TextMode="Password" value="" placeholder="请输入密码" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <font size="4" color="red"><asp:Literal ID="ltlMessage" Text="" runat="server"></asp:Literal></font>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                <asp:Button ID="btnLogin" CssClass="buttonLogin" runat="server" Text="立即登录" OnClick="btnLogin_Click" />		
                                </td>
                            </tr>
                        </table>
			        </div>
		        </td>
	          </tr>
	        </table>	
	        </td>
          </tr>
          <tr>
            <td style="height:66px; background:#1CABF1" align="center">
	        </td>
          </tr>
        </table>
        </td>
    </tr>
</table>
    </div>
    </form>
</body>
</html>
