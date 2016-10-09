<%@ WebHandler Language="C#" Class="OtherHandler" %>

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

public class OtherHandler : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        
        
        context.Response.ContentType = "text/plain";

        string Action = context.Request["Action"];

        string strJson = "";
        switch (Action)
        {
            case "BatchChangeCode":
                strJson = BatchChangeCode(context);
                break;
            case "Clear":
                strJson = Clear(context);
                break;

        }
        context.Response.Clear();
        context.Response.ContentEncoding = System.Text.Encoding.UTF8;
        context.Response.ContentType = "application/json";
        context.Response.Write(strJson);
        context.Response.End();
    }

    private string BatchChangeCode(HttpContext context)
    {
        JsonResult jr = new JsonResult();
        try
        {
            string ProductCode = context.Request["ProductCode"].ToString();
            string NewProductCode = context.Request["NewProductCode"].ToString();
            BLL.BLLBase bll = new BLL.BLLBase();
            DataParameter[] para = new DataParameter[] { 
                                             new DataParameter("@ProductCode",ProductCode),
                                             new DataParameter("@ProductNewCode",NewProductCode),
                                             new DataParameter("@UserName", context.Session["G_user"].ToString()),
                                             };

            bll.ExecNonQueryTran("CMD.spBatchChangeProductNo", para);
            
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
    private string Clear(HttpContext context)
    {
        JsonResult jr = new JsonResult();
        try
        {
            string FormID = context.Request["FormID"].ToString();
            string comd = "Security.DeleteAllOperatorLog";
            if (FormID == "OperateLog")
            {
                BLL.BLLBase bll = new BLL.BLLBase();
                bll.ExecNonQuery("Security.DeleteAllOperatorLog", null);
                Common.AddOperateLog(context.Session["G_user"].ToString(), "操作日志管理", "清空操作日志");
            }
            else
            {
                BLL.BLLBase bll = new BLL.BLLBase();
                bll.ExecNonQuery("Security.DeleteAllExceptionalLog", null);
                Common.AddOperateLog(context.Session["G_user"].ToString(), "异常日志管理", "清空异常日志");
            }
           

           

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

     

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }



}