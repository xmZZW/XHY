<%@ WebHandler Language="C#" Class="ConfigPlanTree" %>
using System;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Web.SessionState;
using System.Collections.Generic;
using Util;
using System.Web.Security;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

public class ConfigPlanTree : IHttpHandler, IRequiresSessionState
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string Action = context.Request["Action"];
        string json = "";
        if (Action == "GetTree")
        {

            BLL.BLLBase bll = new BLL.BLLBase();
            DataTable dtUserModule = bll.FillDataTable("Security.SelectUserOperateModule", new DataParameter[] { new DataParameter("@UserName", HttpContext.Current.Session["G_user"].ToString()) });


           
            for (int j = 0; j < dtUserModule.Rows.Count; j++)
            {
                DataRow dr = dtUserModule.Rows[j];
                string areatree = GetSubModuleTree(dr["MenuCode"].ToString());
                if (j == 0)
                {
                    json += "[{\"id\":\"" + dr["ID"].ToString() + "\"";
                    json += ",\"text\":\"" + dr["MenuTitle"].ToString() + "\"";
                    if (dtUserModule.Rows.Count == 1)
                    {
                        if (areatree.Length > 0)
                            json += ",\"state\":\"open\"" + areatree + "}]}";
                        else
                            json += ",\"state\":\"open\" }]}";
                    }
                    else
                    {
                        if (areatree.Length > 0)
                            json += ",\"state\":\"open\"" + areatree + "}";
                        else
                            json += ",\"state\":\"open\"}";
                    }
                }

                else if (j > 0 && j < dtUserModule.Rows.Count - 1)
                {
                    json += ",{\"id\":\"" + dr["ID"].ToString() + "\"";
                    json += ",\"text\":\"" + dr["MenuTitle"].ToString() + "\"";

                    if (areatree.Length > 0)
                        json += ",\"state\":\"open\"" + areatree + "}";
                    else
                        json += ",\"state\":\"open\"}";
                }
                else
                {
                    json += ",{\"id\":\"" + dr["ID"].ToString() + "\"";
                    json += ",\"text\":\"" + dr["MenuTitle"].ToString() + "\"";

                    if (areatree.Length > 0)
                        json += ",\"state\":\"open\"" + areatree + "}";
                    else
                        json += ",\"state\":\"open\"}";
                }

            }

            json += "]";
        }
        else
        {
            JsonResult jr = new JsonResult();
            try
            {
                string sMemuID = context.Server.UrlDecode(context.Request["json"].ToString());
                string[] MenuID = sMemuID.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);

                List<string> comds = new List<string>();
                List<DataParameter[]> paras = new List<DataParameter[]>();
                comds.Add("Security.DeleteQuickDestop");
                paras.Add(new DataParameter[] { new DataParameter("@UserID", Convert.ToInt32(HttpContext.Current.Session["UserID"].ToString())) });

                for (int i = 0; i < MenuID.Length; i++)
                {
                    comds.Add("Security.InsertQuickDestop");

                    paras.Add(new DataParameter[] { new DataParameter("@UserID", Convert.ToInt32(HttpContext.Current.Session["UserID"].ToString())), new DataParameter("@ModuleID", MenuID[i]) });
                }
                BLL.BLLBase bll = new BLL.BLLBase();
                bll.ExecTran(comds.ToArray(), paras);

                jr.status = 1;
                jr.msg = "添加成功！";
            }
            catch (Exception ex)
            {
                jr.status = 0;
                jr.msg = ex.Message; 
            }
            json = JsonConvert.SerializeObject(jr);
            
            
        }
        context.Response.Clear();
        context.Response.ContentEncoding = System.Text.Encoding.UTF8;
        context.Response.ContentType = "application/json";
        //json = Newtonsoft.Json.JsonConvert.SerializeObject(json);
        context.Response.Write(json);
        context.Response.End();
    }



    private string GetSubModuleTree(string ModuleCode)
    {
        string json = "";
        BLL.BLLBase bll = new BLL.BLLBase();
        DataTable dtSubModules = bll.FillDataTable("Security.SelectUserOperateBySubModule", new DataParameter[] { new DataParameter("@UserName", HttpContext.Current.Session["G_user"].ToString()), new DataParameter("@ModuleCode", ModuleCode) });
        for (int j = 0; j < dtSubModules.Rows.Count; j++)
        {
            DataRow dr = dtSubModules.Rows[j];
            bool blnCheck = false;
            DataTable dtOP = bll.FillDataTable("Security.SelectUserQuickDesktopByMenuCode", new DataParameter[] { new DataParameter("@UserName", HttpContext.Current.Session["G_user"].ToString()), new DataParameter("@MenuCode", dr["SubModuleCode"].ToString()) });
            if (dtOP.Rows.Count > 0)
                blnCheck = true;
            
            
            if (j == 0)
            {
                json += ",\"children\":[{";
                json += "\"id\":\"" + dr["ID"].ToString() + "\"";
                json += ",\"text\":\"" + dr["MenuTitle"].ToString() + "\"";
                if (blnCheck)
                    json += ",\"checked\":\"" + blnCheck + "\"";
                if (dtSubModules.Rows.Count == 1)
                {
                    json += "}]";
                }
                else
                {
                    json += "}";
                }

            }
            else if (j > 0 && j < dtSubModules.Rows.Count - 1)
            {
                json += ",{\"id\":\"" + dr["ID"].ToString() + "\"";
                json += ",\"text\":\"" + dr["MenuTitle"].ToString() + "\"";
                if (blnCheck)
                    json += ",\"checked\":\"" + blnCheck + "\"";
                json += "}";
            }
            else
            {
                json += ",{\"id\":\"" + dr["ID"].ToString() + "\"";
                json += ",\"text\":\"" + dr["MenuTitle"].ToString() + "\"";
                if (blnCheck)
                    json += ",\"checked\":\"" + blnCheck + "\"";
                json += "}]";
            }


        }
        return json;
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }


}