using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using Util;
/// <summary>
///EasyUIBasePage 的摘要说明
/// </summary>
public class EasyUIBasePage : System.Web.UI.Page
{
    protected void Page_PreInit(object sender, EventArgs e)
    {
        try
        {
            if (Session["G_user"] == null)
            {
                Response.Redirect(ResolveUrl("~/SessionTimeOut.aspx"));
                return;
            }



        }
        catch (Exception ex)
        {
        }
    }

    protected void Page_PreLoad(object sender, EventArgs e)
    {
        string FormID = Request.QueryString["FormID"];
        DataTable dtMenu = (DataTable)Session["DT_UserOperation"];

        DataRow[] drs = dtMenu.Select(string.Format("FormID='{0}'", FormID));
        if (drs.Length > 0)
        {
            Common.AddOperateLog(Session["G_user"].ToString(), drs[0]["MenuTitle"].ToString(), "浏览");
        }
    }
    /// <summary>
    /// 设置控件只读
    /// </summary>
    /// <param name="ctls"></param>
    public void SetTextReadOnly(params TextBox[] ctls)
    {
        for (int i = 0; i < ctls.Length; i++)
        {
            if (ctls[i] != null)
                ctls[i].Attributes.Add("ReadOnly", "true");
        }
    }
   
}