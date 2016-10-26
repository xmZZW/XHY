<%@ WebHandler Language="C#" Class="BaseHandler" %>

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

public class BaseHandler : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        
        
        context.Response.ContentType = "text/plain";

        string Action = context.Request["Action"];

        string strJson = "";
        switch (Action)
        {
            case "PageDate":
                strJson = GetDataPage(context);
                break;
            case "GetPermisionByFormID":
                strJson = GetPermisionByFormID(context);
                break;
            case "FillDataTable":
                strJson = FillDataTable(context);
                break;
            case "Add":
                strJson = Add(context);
                break;
            case "AddMainDetail":
                strJson = AddMainDetail(context);
                break;
            case "Edit":
                strJson = Edit(context);
                break;
            case "EditMainDetail":
                strJson = EditMainDetail(context);
                break;
            case "Delete":
                strJson = Delete(context);
                break;
            case "DelMainDetail":
                strJson = DelMainDetail(context);
                break;
            case "AutoCode":
                strJson = AutoCode(context);
                break;
            case "AutoCodeByTableName":
                strJson = AutoCodeByTableName(context);
                break;
            case "HasExists":
                strJson = HasExists(context);
                break;
            case "GetFieldValue":
                strJson = GetFieldValue(context);
                break;
                
            case "SessionTimeOut":
                strJson = SessionTimeOut(context);
                break;
            case "OutTaskWork":
                strJson = OutTaskWork(context);
                break;
            case "CheckTaskWork":
                strJson = CheckTaskWork(context);
                    break;
            case "CancelTaskWork":
                strJson = CancelTaskWork(context);
                 break;
        }
        context.Response.Clear();
        context.Response.ContentEncoding = System.Text.Encoding.UTF8;
        context.Response.ContentType = "application/json";
        context.Response.Write(strJson);
        context.Response.End();
    }


    private string CancelTaskWork(HttpContext context)
    {
        JsonResult jr = new JsonResult();

        try
        {
            string Comd = context.Request["Comd"].ToString();
            string BillID = context.Server.UrlDecode(context.Request["Where"].ToString());
            BLL.BLLBase bll = new BLL.BLLBase();
            bll.ExecNonQueryTran(Comd, new DataParameter[] { new DataParameter("@BillID", BillID), new DataParameter("@UserName", context.Session["G_user"].ToString()) });
            jr.status = 1;
            jr.msg = "取消作业成功！";

        }
        catch (Exception ex)
        {
            jr.status = 0;
            jr.msg = ex.Message;
        }

        string strJson = JsonConvert.SerializeObject(jr);
        return strJson;
    }
    
    
    private string CheckTaskWork(HttpContext context) 
    {
        JsonResult jr = new JsonResult();
        try
        {
            string Comd = context.Request["Comd"].ToString();
            string where = context.Server.UrlDecode(context.Request["Where"].ToString());
            BLL.BLLBase bll = new BLL.BLLBase();
            bll.ExecNonQuery(Comd, new DataParameter[] { new DataParameter("{0}", where), new DataParameter("@Checker", context.Session["G_user"].ToString()) });
            jr.status = 1;
            jr.msg = "审核成功！";

        }
        catch (Exception ex)
        {
            jr.status = 0;
            jr.msg = ex.Message;
        }

        string strJson = JsonConvert.SerializeObject(jr);
        return strJson; 
    }
    
    
    private string OutTaskWork(HttpContext context)
    {
        JsonResult jr = new JsonResult();

        try
        {
           string Comd = context.Request["Comd"].ToString();
           string BillID = context.Server.UrlDecode(context.Request["Where"].ToString());
           BLL.BLLBase bll = new BLL.BLLBase();
           bll.ExecNonQueryTran(Comd, new DataParameter[] { new DataParameter("@BillID", BillID), new DataParameter("@UserName", context.Session["G_user"].ToString()) });
           jr.status = 1;
           jr.msg = "出库作业成功！";
            
        }
        catch (Exception ex)
        {
            jr.status = 0;
            jr.msg = ex.Message;
        }

        string strJson = JsonConvert.SerializeObject(jr);
        return strJson;
    }
    private string Add(HttpContext context)
    {
        JsonResult jr = new JsonResult();

        try
        {
            string Comd = context.Request["Comd"].ToString();
            string json = context.Server.UrlDecode(context.Request["json"].ToString());
            DataTable dt = Util.JsonHelper.Json2Dtb(json);


            List<string> comds = new List<string>();
            List<DataParameter[]> paras = new List<DataParameter[]>();

           Common.SetPara(Comd, dt, ref comds, ref paras);

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

    private string AddMainDetail(HttpContext context)
    {
        JsonResult jr = new JsonResult();

        try
        {
            string MainComd = context.Request["MainComd"].ToString();
            string json = context.Server.UrlDecode(context.Request["MainJson"].ToString());
            DataTable dtMain = Util.JsonHelper.Json2Dtb(json);

            string SubComd = context.Request["SubComd"].ToString();
            string SubJson = context.Server.UrlDecode(context.Request["SubJson"].ToString());
            DataTable dtSub = Util.JsonHelper.Json2Dtb(SubJson);


            List<string> comds = new List<string>();
            List<DataParameter[]> paras = new List<DataParameter[]>();

            Common.SetPara(MainComd, dtMain, ref comds, ref paras);

            Common.SetPara(SubComd, dtSub, ref comds, ref paras);
            

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

    private string Delete(HttpContext context)
    {
        JsonResult jr = new JsonResult();

        try
        {
            string FormID = context.Request["FormID"].ToString();
          
            DataTable dtMenu = (DataTable)context.Session["DT_UserOperation"];
            string Module = "";
            DataRow[] drs = dtMenu.Select(string.Format("FormID='{0}'", FormID));
            if (drs.Length > 0)
            {
                Module = drs[0]["MenuTitle"].ToString();
              
            }
            
            string Comd = context.Request["Comd"].ToString();
            string where = context.Server.UrlDecode(context.Request["json"].ToString());



            BLL.BLLBase bll = new BLL.BLLBase();
            bll.ExecNonQuery(Comd, new DataParameter[] { new DataParameter("{0}", where) });

            Common.AddOperateLog(context.Session["G_user"].ToString(), Module, "删除单号：" + where.Replace("'", ""));
            
            jr.status = 1;
            jr.msg = "删除成功！";
        }
        catch (Exception ex)
        {
            jr.status = 0;
            jr.msg = ex.Message;
        }

        string strJson = JsonConvert.SerializeObject(jr);
        return strJson;

    }
    private string DelMainDetail(HttpContext context)
    {
        JsonResult jr = new JsonResult();

        try
        {
            string MainComd = context.Request["MainComd"].ToString();
            string SubComd = context.Request["SubComd"].ToString();
            string where = context.Server.UrlDecode(context.Request["json"].ToString());

            List<string> comds = new List<string>();
            List<DataParameter[]> paras = new List<DataParameter[]>();
            comds.Add(MainComd);
            paras.Add(new DataParameter[] { new DataParameter("{0}", where) });

            comds.Add(SubComd);
            paras.Add(new DataParameter[] { new DataParameter("{0}", where) });

            BLL.BLLBase bll = new BLL.BLLBase();
            bll.ExecTran(comds.ToArray(), paras);

            jr.status = 1;
            jr.msg = "删除成功！";
        }
        catch (Exception ex)
        {
            jr.status = 0;
            jr.msg = ex.Message;
        }

        string strJson = JsonConvert.SerializeObject(jr);
        return strJson;

    }
    private string Edit(HttpContext context)
    {
        JsonResult jr = new JsonResult();

        try
        {
            string Comd = context.Request["Comd"].ToString();
            string json = context.Server.UrlDecode(context.Request["json"].ToString());
            DataTable dt = Util.JsonHelper.Json2Dtb(json);
            bool blnHasUpdater = false;
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                if (dt.Columns[i].ColumnName.ToLower() == "updater")
                {
                    blnHasUpdater = true;
                }
            }
            if (blnHasUpdater)
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    dt.Rows[i]["Updater"] = context.Session["G_user"].ToString();
                }
                dt.AcceptChanges();
            }


            List<string> comds = new List<string>();
            List<DataParameter[]> paras = new List<DataParameter[]>();

            Common.SetPara(Comd, dt, ref comds, ref paras);

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

    private string EditMainDetail(HttpContext context)//过程：主表更新数据，从表先删除再插入数据。
    {
        JsonResult jr = new JsonResult();

        try
        {
            string MainComd = context.Request["MainComd"].ToString();
            string json = context.Server.UrlDecode(context.Request["MainJson"].ToString());
            DataTable dtMain = Util.JsonHelper.Json2Dtb(json);

            string SubDelComd = context.Request["SubDelComd"].ToString();

            string SubComd = context.Request["SubComd"].ToString();
            string SubJson = context.Server.UrlDecode(context.Request["SubJson"].ToString());
            DataTable dtSub = Util.JsonHelper.Json2Dtb(SubJson);


            List<string> comds = new List<string>();
            List<DataParameter[]> paras = new List<DataParameter[]>();

            Common.SetPara(MainComd, dtMain, ref comds, ref paras);//把表格转为命令对应的参数，并把命令和参数加入对应的集合。
            
            
            //删除明细
            comds.Add(SubDelComd);
            paras.Add(new DataParameter[] { new DataParameter("{0}", string.Format("'{0}'", dtMain.Rows[0]["BillID"].ToString())) });
            Common.SetPara(SubComd, dtSub, ref comds, ref paras);


            BLL.BLLBase bll = new BLL.BLLBase();
            bll.ExecTran(comds.ToArray(), paras);//开启事务，执行一组命令。

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

    public string HasExists(HttpContext context)
    {
        string TableName = context.Request["TableName"].ToString();
        string Where = context.Server.UrlDecode(context.Request["Where"].ToString());
        BLL.BLLBase bll = new BLL.BLLBase();
        if (bll.GetRowCount(TableName, Where) > 0)//获取表中的行数
            return "1";
        else
            return "0";
    }

    public string GetFieldValue(HttpContext context)
    {
        string TableName = context.Request["TableName"].ToString();
        string Where = context.Server.UrlDecode(context.Request["Where"].ToString());
        string Field = context.Request["FieldName"].ToString();
        BLL.BLLBase bll = new BLL.BLLBase();
        return bll.GetFieldValue(TableName, Field, Where);
             
    }


    private string FillDataTable(HttpContext context)//执行查询
    {
        string Comd = context.Request["Comd"].ToString();
        string Where = context.Server.UrlDecode(context.Request["Where"].ToString());
        //分页属性

        BLL.BLLBase bll = new BLL.BLLBase();

        DataTable dt = bll.FillDataTable(Comd, new DataParameter[] { new DataParameter("{0}", Where), new DataParameter("{1}", "1") });


        return JsonHelper.Dtb2Json(dt, 1);
    }
    
    private string GetDataPage(HttpContext context)//分页查询
    {
        string FormID = "";
        if (context.Request["FormID"] != null)
            FormID = context.Request["FormID"].ToString();
        string strSort = "1";
        DataTable dtMenu = (DataTable)context.Session["DT_UserOperation"];
         string Comd="";
         if (context.Request["Comd"] != null)
             Comd = context.Request["Comd"].ToString();
         if (dtMenu != null)
         {
             DataRow[] drs = dtMenu.Select(string.Format("FormID='{0}'", FormID));
             if (drs.Length > 0)
             {
                 Comd = drs[0]["SqlCmdFlag"].ToString();
                 if (drs[0]["OrderText"].ToString().Length != 0)
                     strSort = drs[0]["OrderText"].ToString();
             }
         }

        int intPageSize = int.Parse(context.Request["rows"].ToString());
        int intCurrentPage = int.Parse(context.Request["page"].ToString());


        if (context.Request["sort"] != null)
        {
            strSort = context.Request["sort"].ToString() + " " + context.Request["order"].ToString();
        }
        string Where = "1=1";
        if (context.Request["Where"] != null)
            Where = context.Server.UrlDecode(context.Request["Where"].ToString());
        //分页属性

        BLL.BLLBase bll = new BLL.BLLBase();
        int totalCount = 0;
        int pageCount = 0;
        DataTable dtpage = bll.GetDataPage(Comd, intCurrentPage, intPageSize, out totalCount, out pageCount, new DataParameter[] { new DataParameter("{0}", Where), new DataParameter("{1}", strSort) });


        return JsonHelper.Dtb2Json(dtpage, totalCount);
    }

    private string GetPermisionByFormID(HttpContext context)
    {
        string strValue = "0";
        if (context.Session["DT_UserOperation"] != null)
        {
            DataTable dtOption = (DataTable)context.Session["DT_UserOperation"];
            string FormID = context.Request["FormID"].ToString();
            string OperatorCode = context.Request["OperatorCode"].ToString();


            DataRow[] drs = dtOption.Select(string.Format("FormID='{0}' and OperatorCode='{1}'", FormID, OperatorCode));
            if (drs.Length > 0)
                strValue = "1";

        }

        return strValue;
    }
    private string AutoCode(HttpContext context)
    {
        string TableName = context.Request["TableName"].ToString();
        string ColumnName = context.Request["ColumnName"].ToString();
        string Filter = context.Server.UrlDecode(context.Request["Filter"].ToString());
        BLL.BLLBase bll = new BLL.BLLBase();
        string strNewID = bll.GetNewID(TableName, ColumnName, Filter);
        return strNewID;
    }

    private string AutoCodeByTableName(HttpContext context)
    {
        string PreName = context.Request["PreName"].ToString();
        string TableName = context.Request["TableName"].ToString();
        DateTime dtTime = DateTime.Parse(context.Request["dtTime"].ToString());
        string Filter = context.Server.UrlDecode(context.Request["Filter"].ToString());
        BLL.BLLBase bll = new BLL.BLLBase();
        string strNewID = bll.GetAutoCodeByTableName(PreName, TableName, dtTime, Filter);



        return strNewID;
    }
    private string SessionTimeOut(HttpContext context)
    {
        string strNewID = "0";
        if (context.Session["G_user"] == null)
        {
            strNewID = "1"; 
        }
        return strNewID;
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }



}