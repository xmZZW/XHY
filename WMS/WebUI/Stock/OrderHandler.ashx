 



<%@ WebHandler Language="C#" Class="OrderHandler" %>

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

public class OrderHandler : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        
        
        context.Response.ContentType = "text/plain";

        string Action = context.Request["Action"];

        string strJson = "";
        switch (Action)
        {
            case "AddBatch":
                strJson = AddBatch(context);
                break;
            case "AddOrder":
                strJson = AddOrder(context);
                break;
            case "EditOrder":
                strJson = EditOrder(context);
                break;
            case "UpdateBatch":
                strJson = UpdateBatch(context);
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


    private string AddBatch(HttpContext context)
    {
        JsonResult jr = new JsonResult();
        try
        {
            string Comd = "Cmd.InsertBatch";
            string BatchNo = context.Server.UrlDecode(context.Request["BatchNo"].ToString());
            string OrderDate = context.Server.UrlDecode(context.Request["OrderDate"].ToString());
            DataParameter[] para = new DataParameter[] { new DataParameter("@BatchNo", BatchNo), new DataParameter("@OrderDate", OrderDate) };
            BLL.BLLBase bll = new BLL.BLLBase();
            bll.ExecNonQuery(Comd, para);

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
    
    
    private string AddOrder(HttpContext context)
    {
        JsonResult jr = new JsonResult();

        try
        {
            string MainComd = "WMS.InsertOrder";
            string json = context.Server.UrlDecode(context.Request["MainJson"].ToString());
            DataTable dtMain = Util.JsonHelper.Json2Dtb(json);
            string BatchNo = dtMain.Rows[0]["BatchNo"].ToString();
            
            string SubComd = "WMS.InsertOrderDetail";
            string SubJson = context.Server.UrlDecode(context.Request["SubJson"].ToString());
            DataTable dtSub = Util.JsonHelper.Json2Dtb(SubJson);


            List<string> comds = new List<string>();
            List<DataParameter[]> paras = new List<DataParameter[]>();

            Common.SetPara(MainComd, dtMain, ref comds, ref paras);

            Common.SetPara(SubComd, dtSub, ref comds, ref paras);

            comds.Add("Cmd.UpdateBatchNotValid");
            paras.Add(new DataParameter[] { new DataParameter("@BatchNo", BatchNo) });

        

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

        string strJson = JsonConvert.SerializeObject(jr);
        return strJson;
    }
    private string EditOrder(HttpContext context)
    {
        JsonResult jr = new JsonResult();

        try
        {
            string MainComd = "WMS.UpdateOrder";
            string json = context.Server.UrlDecode(context.Request["MainJson"].ToString());
            DataTable dtMain = Util.JsonHelper.Json2Dtb(json);
            string BatchNo = dtMain.Rows[0]["BatchNo"].ToString();
            string SubDelComd = "WMS.DeleteOrderDetail";

            string SubComd = "WMS.InsertOrderDetail";
            string SubJson = context.Server.UrlDecode(context.Request["SubJson"].ToString());
            DataTable dtSub = Util.JsonHelper.Json2Dtb(SubJson);

            List<string> comds = new List<string>();
            List<DataParameter[]> paras = new List<DataParameter[]>();

            Common.SetPara(MainComd, dtMain, ref comds, ref paras);

            comds.Add(SubDelComd);
            paras.Add(new DataParameter[] { new DataParameter("{0}", "'"+dtMain.Rows[0]["OrderID"].ToString()+"'") });

            Common.SetPara(SubComd, dtSub, ref comds, ref paras);

           string oldBatchNo = context.Request["oldBatchNo"].ToString();
           if (BatchNo != oldBatchNo)
           {
               comds.Add("Cmd.UpdateBatchNotValid");
               paras.Add(new DataParameter[] { new DataParameter("@BatchNo", oldBatchNo) });
           }

            comds.Add("Cmd.UpdateBatchNotValid");
            paras.Add(new DataParameter[] { new DataParameter("@BatchNo", BatchNo) });
            
            BLL.BLLBase bll = new BLL.BLLBase();
            bll.ExecTran(comds.ToArray(), paras);

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

    private string UpdateBatch(HttpContext context)
    {
        JsonResult jr = new JsonResult();
        try
        {
            string BatchNo = context.Request["BatchNo"].ToString();

            BLL.BLLBase bll = new BLL.BLLBase();
            bll.ExecNonQuery("Cmd.UpdateBatchNotValid", new DataParameter[] { new DataParameter("@BatchNo", BatchNo) });
            
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