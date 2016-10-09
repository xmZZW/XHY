<%@ WebHandler Language="C#" Class="SecurityHandler" %>


using System;
using System.Collections;
using System.Data;
using System.Web;
using System.Web.Services;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using System.Web.SessionState;
using Util;


public class SecurityHandler : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";

        string Action = context.Request["Action"];

        string strJson = "";
        switch (Action)
        {
            case "AddUser":
                strJson = AddUser(context);
                break;
            case "UpdateUser":
                strJson = UpdateUser(context);
                break;
            case "GroupTree":
                strJson = GetGroupMangerTree(context);
                break;

            case "UpdateGroupOperation":
                strJson = UpdateOperation(context);
                break;
            case "SelectRoleManageUser":
                strJson = SelectRoleManageUser(context);
                break;
            case "UpdateUserGroup":
                strJson = UpdateUserGroup(context);
                break;

        }
        context.Response.Clear();
        context.Response.ContentEncoding = System.Text.Encoding.UTF8;
        context.Response.ContentType = "application/json";
        context.Response.Write(strJson);
        context.Response.End();
    }

    private string AddUser(HttpContext context)
    {
        JsonResult jr = new JsonResult();

        try
        {
            string UserName = context.Request["UserName"].ToString();
            string EmployeeCode = context.Server.UrlDecode(context.Request["EmployeeCode"].ToString());
            string Memo = context.Server.UrlDecode(context.Request["Memo"].ToString());

            BLL.Security.UserBll bll = new BLL.Security.UserBll();
            bll.InsertUser(UserName, EmployeeCode, Memo);

            jr.status = 1;
            jr.msg = "添加成功！";
        }
        catch (Exception ex)
        {
            jr.status = 0;
            jr.msg = ex.Message;
        }

        string strJson = JsonConvert.SerializeObject(jr);
        return strJson;
    }


    private string UpdateUser(HttpContext context)
    {
        JsonResult jr = new JsonResult();

        try
        {
            string UserName = context.Request["UserName"].ToString();
            string EmployeeCode = context.Server.UrlDecode(context.Request["EmployeeCode"].ToString());
            string Memo = context.Server.UrlDecode(context.Request["Memo"].ToString());
            string UserID = context.Server.UrlDecode(context.Request["UserID"].ToString());

            BLL.Security.UserBll bll = new BLL.Security.UserBll();
            bll.UpdateUser(UserName, EmployeeCode, Memo, int.Parse(UserID));

            jr.status = 1;
            jr.msg = "修改成功！";
        }
        catch (Exception ex)
        {
            jr.status = 0;
            jr.msg = ex.Message;
        }

        string strJson = JsonConvert.SerializeObject(jr);
        return strJson;
    }

    private string GetGroupMangerTree(HttpContext context)
    {
        
        string GroupID = context.Request["GroupID"].ToString();
        BLL.BLLBase bll = new BLL.BLLBase();
        DataTable dtModules = bll.FillDataTable("Security.SelectSystemModules", new DataParameter[] { new DataParameter("@SystemName", "WMS") });
        DataTable dtSubModules = bll.FillDataTable("Security.SelectSystemSubModules", new DataParameter[] { new DataParameter("@SystemName", "WMS") });
        DataTable dtOperations = bll.FillDataTable("Security.SelectSystemOperations", new DataParameter[] { new DataParameter("@SystemName", "WMS") });
        DataTable dtOP = bll.FillDataTable("Security.SelectGroupOperation", new DataParameter[] { new DataParameter("@GroupID", GroupID) });


        string json = "";

        for (int j = 0; j < dtModules.Rows.Count; j++)
        {
            DataRow dr = dtModules.Rows[j];
            string areatree = GetSubModuleTree(dr["ModuleCode"].ToString(), dtSubModules, dtOperations, dtOP);
            if (j == 0)
            {
                json += "[{\"id\":\"" + dr["ModuleCode"].ToString() + "\"";
                json += ",\"text\":\"" + dr["MenuTitle"].ToString() + "\"";
                if (dtModules.Rows.Count == 1)
                {
                    if (areatree.Length > 0)
                        json += ",\"state\":\"open\"" + areatree + "}]";
                    else
                        json += ",\"state\":\"open\" }]";
                }
                else
                {
                    if (areatree.Length > 0)
                        json += ",\"state\":\"open\"" + areatree + "}";
                    else
                        json += ",\"state\":\"open\"}";
                }
            }

            else if (j > 0 && j < dtModules.Rows.Count - 1)
            {
                json += ",{\"id\":\"" + dr["ModuleCode"].ToString() + "\"";
                json += ",\"text\":\"" + dr["MenuTitle"].ToString() + "\"";

                if (areatree.Length > 0)
                    json += ",\"state\":\"open\"" + areatree + "}";
                else
                    json += ",\"state\":\"open\"}";
            }
            else
            {
                json += ",{\"id\":\"" + dr["ModuleCode"].ToString() + "\"";
                json += ",\"text\":\"" + dr["MenuTitle"].ToString() + "\"";

                if (areatree.Length > 0)
                    json += ",\"state\":\"open\"" + areatree + "}]";
                else
                    json += ",\"state\":\"open\"}]";
            }

        }

      
        
        
        
        
        
        
        
        
        return json;
    }

    private string GetSubModuleTree(string ModuleCode, DataTable dtSubModules, DataTable dtOperations,DataTable dtUserOp)
    {
        string json = "";
       

        DataRow[] drsSubModule = dtSubModules.Select(string.Format("ModuleCode='{0}'", ModuleCode));



        for (int j = 0; j < drsSubModule.Length; j++)
        {
            DataRow dr = drsSubModule[j];
            string SubModuleTree = GetSubModuleOpertionTree(dr["SubModuleCode"].ToString(), dtOperations, dtUserOp);
            if (j == 0)
            {
                json += ",\"children\":[{";
                json += "\"id\":\"" + dr["SubModuleCode"].ToString() + "\"";
                json += ",\"text\":\"" + dr["MenuTitle"].ToString() + "\"";
                
                if (drsSubModule.Length == 1)
                {
                    if (SubModuleTree.Length > 0)
                        json += ",\"state\":\"open\"" + SubModuleTree + "}]";
                    else
                        json += ",\"state\":\"open\" }]";
                    
                     
                }
                else
                {

                    if (SubModuleTree.Length > 0)
                        json += ",\"state\":\"open\"" + SubModuleTree + "}";
                    else
                        json += ",\"state\":\"open\" }";
                }

            }
            else if (j > 0 && j < drsSubModule.Length - 1)
            {
                json += ",{\"id\":\"" + dr["SubModuleCode"].ToString() + "\"";
                json += ",\"text\":\"" + dr["MenuTitle"].ToString() + "\"";

                if (SubModuleTree.Length > 0)
                    json += ",\"state\":\"open\"" + SubModuleTree + "}";
                else
                    json += ",\"state\":\"open\" }";
                
                
               
            }
            else
            {
                json += ",{\"id\":\"" + dr["SubModuleCode"].ToString() + "\"";
                json += ",\"text\":\"" + dr["MenuTitle"].ToString() + "\"";
                
                if (SubModuleTree.Length > 0)
                    json += ",\"state\":\"open\"" + SubModuleTree + "}]";
                else
                    json += ",\"state\":\"open\" }]";
                 
            }


        }
        return json;
    }

    private string GetSubModuleOpertionTree(string SubModuleCode, DataTable dtOperations, DataTable dtUserOp)
    {
        string json = "";
        DataRow[] drsSubModuleOption = dtOperations.Select(string.Format("SubModuleCode='{0}'", SubModuleCode));



        for (int j = 0; j < drsSubModuleOption.Length; j++)
        {
            DataRow dr = drsSubModuleOption[j];
            bool blnCheck = false;

            DataRow[] drsOP = dtUserOp.Select(string.Format("ModuleID='{0}'", dr["ModuleID"].ToString()));
            if (drsOP.Length > 0)
                blnCheck = true;
            if (j == 0)
            {
                json += ",\"children\":[{";
                json += "\"id\":\"" + dr["ModuleID"].ToString() + "\"";
                json += ",\"text\":\"" + dr["OperatorDescription"].ToString() + "\"";
                if (blnCheck)
                    json += ",\"checked\":\"" + blnCheck + "\"";
                if (drsSubModuleOption.Length == 1)
                {
                    json += "}]";
                }
                else
                {
                    json += "}";
                }

            }
            else if (j > 0 && j < drsSubModuleOption.Length - 1)
            {
                json += ",{\"id\":\"" + dr["ModuleID"].ToString() + "\"";
                json += ",\"text\":\"" + dr["OperatorDescription"].ToString() + "\"";
                if (blnCheck)
                    json += ",\"checked\":\"" + blnCheck + "\"";
                json += "}";
            }
            else
            {
                json += ",{\"id\":\"" + dr["ModuleID"].ToString() + "\"";
                json += ",\"text\":\"" + dr["OperatorDescription"].ToString() + "\"";
                if (blnCheck)
                    json += ",\"checked\":\"" + blnCheck + "\"";
                json += "}]";
            }


        }
        return json;
    }

    private string UpdateOperation(HttpContext context)
    {
        JsonResult jr = new JsonResult();
        try
        {
            string sMemuID = context.Server.UrlDecode(context.Request["json"].ToString());
            string GroupID = context.Server.UrlDecode(context.Request["GroupID"].ToString());
            string[] MenuID = sMemuID.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);

            List<string> comds = new List<string>();
            List<DataParameter[]> paras = new List<DataParameter[]>();
            comds.Add("Security.DeleteGroupOperation");
            paras.Add(new DataParameter[] { new DataParameter("@GroupID", GroupID), new DataParameter("@SystemName", "WMS") });
            for (int i = 0; i < MenuID.Length; i++)
            {
                comds.Add("Security.InsertGroupOperation");
                paras.Add(new DataParameter[] { new DataParameter("@GroupID", GroupID), new DataParameter("@ModuleID", MenuID[i]) });
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
       string json = JsonConvert.SerializeObject(jr);
       return json;
    }

    private string SelectRoleManageUser(HttpContext context)
    {
        string GroupID = context.Request["GroupID"].ToString();
        int intPageSize = int.Parse(context.Request["rows"].ToString());
        int intCurrentPage = int.Parse(context.Request["page"].ToString());

        BLL.BLLBase bll = new BLL.BLLBase();
        int totalCount = 0;
        int pageCount = 0;
        DataTable dtpage = bll.GetDataPage("Security.SelectRoleManageUser", intCurrentPage, intPageSize, out totalCount, out pageCount, new DataParameter[] { new DataParameter("@GroupID", GroupID) });


        return JsonHelper.Dtb2Json(dtpage, totalCount);
       
    }
    private string UpdateUserGroup(HttpContext context)
    {
        JsonResult jr = new JsonResult();
        try
        {
            string sMemuID = context.Server.UrlDecode(context.Request["json"].ToString());
            string GroupID = context.Server.UrlDecode(context.Request["GroupID"].ToString());
            if (sMemuID == "")
                sMemuID = "-1";

            List<string> comds = new List<string>();
            List<DataParameter[]> paras = new List<DataParameter[]>();
            comds.Add("Security.UpdateUserGroupNull");
            paras.Add(new DataParameter[] { new DataParameter("@GroupID", GroupID) });

            comds.Add("Security.UpdateUserGroup");
            paras.Add(new DataParameter[] { new DataParameter("@GroupID", GroupID), new DataParameter("{0}", sMemuID) });
            
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
        string json = JsonConvert.SerializeObject(jr);
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