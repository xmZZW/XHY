﻿<%@ WebHandler Language="C#" Class="LeftTreeJson" %>

using System;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Web.SessionState;
using Util;
 

public class LeftTreeJson : IHttpHandler, IRequiresSessionState
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";

        string UserName = context.Session["G_user"].ToString(); 
        BLL.BLLBase bll = new BLL.BLLBase();
        DataTable dtModules = bll.FillDataTable("Security.SelectUserOperateModule", new DataParameter[] { new DataParameter("@UserName", UserName) });
        DataTable dtSubModules = bll.FillDataTable("Security.SelectUserOperateSubModule", new DataParameter[] { new DataParameter("@UserName", UserName) });

        string json = "[{";
        for (int i = 0; i < dtModules.Rows.Count; i++)
        {
            if(i>0)
                json += ",{";

            json += "'menuid':'" + dtModules.Rows[i]["ID"].ToString() + "'";
            json += ",'menuname':'" + dtModules.Rows[i]["MenuTitle"].ToString() + "'";
            json += ",'icon': 'icon-nav'";
          
            
            string filter = string.Format("MenuParent='{0}'", dtModules.Rows[i]["MenuTitle"].ToString());
            DataRow[] dr = dtSubModules.Select(filter);
            if (dr.Length > 0)
            {
                for (int j = 0; j < dr.Length; j++)
                {
                    string formID = dr[j]["FormID"].ToString();
                    string SubModuleCode = dr[j]["SubModuleCode"].ToString();
                    string url = dr[j]["MenuUrl"].ToString() + "?FormID=" + formID;
                    string iconCls = dr[j]["IconCls"].ToString();
                    if (j == 0)
                    {
                        json += ",'menus':[{";
                        json += "'menuid':'" + dr[j]["ID"].ToString()+"'";
                        json += ",'menuname':'" + dr[j]["MenuTitle"].ToString() + "'";
                        json += ",'url':'" + url + "'";
                        json += ",'icon':'" + iconCls + "'";
                        json += "}";
                    }
                    else if (j > 0 && j < dr.Length - 1)
                    {
                        json += ",{'menuid':'" + dr[j]["ID"].ToString()+"'";
                        json += ",'menuname':'" + dr[j]["MenuTitle"].ToString() + "'";
                        json += ",'url':'" + url + "'";
                        json += ",'icon':'" + iconCls + "'";
                        json += "}";
                    }
                    else
                    {
                        json += ",{'menuid':'" + dr[j]["ID"].ToString()+"'";
                        json += ",'menuname':'" + dr[j]["MenuTitle"].ToString() + "'";
                        json += ",'url':'" + url + "'";
                        json += ",'icon':'" + iconCls + "'";
                        json += "}]}";
                    }
                }
            }
            else
            {
                json += "}";  
            }
        }
        json += "]";


       

        HttpContext.Current.Response.Write(json);

        HttpContext.Current.Response.End();
        
        
        
        
        //DataTable dt = getData();

        //string json = JsonHelper.Dtb2Json(dt);

        //json = "[{id:1,text:'我的导航',url:'',leaf:false,children:[{id:3,text:'入库单',url:'WebUI/Bill/InStockBill.aspx',leaf:true}," +
        //       "{id:4,text:'卷烟品牌',url:'WebUI/Base/Cigarette.aspx',leaf:true},{id:5,text:'二级(3)',url:'WebUI/Base/Cigarette.aspx',leaf:true}," +
        //       "{id:6,text:'二级(4)',url:'WebUI/Base/Cigarette.aspx',leaf:false,children:[{id:7,text:'三级(1)',url:'',leaf:true}," +
        //       "{id:8,text:'三级(2)',url:'WebUI/Base/Cigarette.aspx',leaf:true}]}]}," +
        //       "{id:2,text:'系统管理',url:'',leaf:false,children:[{id:9,text:'用户管理',url:'WebUI/Base/Cigarette.aspx',leaf:true}]}]";
       
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private DataTable getData()
    {
        SqlConnection cn = new SqlConnection("initial catalog=(local);database=SortSupplyDB;PASSWORD=a@1;USER ID=sa");
        SqlDataAdapter sda = new SqlDataAdapter("select * from AS_BI_CHANNEL", cn);
        DataSet ds = new DataSet();
        sda.Fill(ds);

        return ds.Tables[0];
    }
}