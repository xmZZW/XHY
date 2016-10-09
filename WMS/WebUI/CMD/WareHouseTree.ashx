<%@ WebHandler Language="C#" Class="WareHouseTree" %>

using System;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Web.SessionState;
using Util;
using System.Web.Security;


public class WareHouseTree : IHttpHandler, IRequiresSessionState
{

    public void ProcessRequest(HttpContext context)
    {
        if (context.Session["G_user"] == null)
        {
            context.Response.Write("-1");
            return;
        }
        context.Response.ContentType = "text/plain";
        BLL.BLLBase bll = new BLL.BLLBase();
        DataTable dtWareHouse = bll.FillDataTable("Cmd.SelectWarehouse");
        string json = "[{\"id\":\"0\",\"text\":\"仓库资料\",\"state\":\"open\"";

        //仓库
        for (int j = 0; j < dtWareHouse.Rows.Count; j++)
        {
            DataRow dr = dtWareHouse.Rows[j];
            string areatree = GetWareHoseTree(dr["WareHouseCode"].ToString());
            if (j == 0)
            {
                json += ",\"children\":[{";
                json += "\"id\":\"" + dr["WareHouseCode"].ToString() + "\"";
                json += ",\"text\":\"" + dr["WareHouseName"].ToString() + "\"";
                if (dtWareHouse.Rows.Count == 1)
                {
                    if (areatree.Length > 0)
                        json += ",\"state\":\"closed\"" + areatree + "}]}";
                    else
                        json += ",\"state\":\"closed\" }]}";
                }
                else
                {
                    if (areatree.Length > 0)
                        json += ",\"state\":\"closed\"" + areatree + "}";
                    else
                        json += ",\"state\":\"closed\"}";
                }
            }

            else if (j > 0 && j < dtWareHouse.Rows.Count - 1)
            {
                json += ",{\"id\":\"" + dr["WareHouseCode"].ToString() + "\"";
                json += ",\"text\":\"" + dr["WareHouseName"].ToString() + "\"";

                if (areatree.Length > 0)
                    json += ",\"state\":\"closed\"" + areatree + "}";
                else
                    json += ",\"state\":\"closed\"}";
            }
            else
            {
                json += ",{\"id\":\"" + dr["WareHouseCode"].ToString() + "\"";
                json += ",\"text\":\"" + dr["WareHouseName"].ToString() + "\"";

                if (areatree.Length > 0)
                    json += ",\"state\":\"closed\"" + areatree + "}]}";
                else
                    json += ",\"state\":\"closed\"}]}";
            }

        }
        
        json += "]";
        context.Response.Clear();
        context.Response.ContentEncoding = System.Text.Encoding.UTF8;
        context.Response.ContentType = "application/json";
        //json = Newtonsoft.Json.JsonConvert.SerializeObject(json);
        context.Response.Write(json);
        context.Response.End();
    }
    private string GetWareHoseTree(string WareHouseCode)
    {
        string json = "";
        BLL.BLLBase bll = new BLL.BLLBase();
        DataTable dtArea = bll.FillDataTable("Cmd.SelectArea", new DataParameter[] { new DataParameter("{0}", string.Format("WarehouseCode='{0}'", WareHouseCode)) });
        for (int j = 0; j < dtArea.Rows.Count; j++)
        {
            DataRow dr = dtArea.Rows[j];
            string shelfTree = GetAreaTree(dr["AreaCode"].ToString());

            if (j == 0)
            {
                json += ",\"children\":[{";
                json += "\"id\":\"" + dr["AreaCode"].ToString() + "\"";
                json += ",\"text\":\"" + dr["AreaName"].ToString() + "\"";

                if (dtArea.Rows.Count == 1)
                {
                    if (shelfTree.Length > 0)
                        json += ",\"state\":\"closed\"" + shelfTree + "}]";
                    else
                        json += ",\"state\":\"closed\" }]";
                }
                else
                {
                    if (shelfTree.Length > 0)
                        json += ",\"state\":\"closed\"" + shelfTree + "}";
                    else
                        json += ",\"state\":\"closed\" }";
                }
            }
            else if (j > 0 && j < dtArea.Rows.Count - 1)
            {
                json += ",{\"id\":\"" + dr["AreaCode"].ToString() + "\"";
                json += ",\"text\":\"" + dr["AreaName"].ToString() + "\"";

                if (shelfTree.Length > 0)
                    json += ",\"state\":\"closed\"" + shelfTree + "}";
                else
                    json += ",\"state\":\"closed\"}";
            }
            else
            {
                json += ",{\"id\":\"" + dr["AreaCode"].ToString() + "\"";
                json += ",\"text\":\"" + dr["AreaName"].ToString() + "\"";

                if (shelfTree.Length > 0)
                    json += ",\"state\":\"closed\"" + shelfTree + "}]";
                else
                    json += ",\"state\":\"closed\"}]";
            }


        }



        return json;
        
    }

    private string GetAreaTree(string AreaCode)
    {
        string json = "";
        BLL.BLLBase bll = new BLL.BLLBase();
        DataTable dtShelf = bll.FillDataTable("Cmd.SelectCellShelf", new DataParameter[] { new DataParameter("{0}", string.Format("AreaCode='{0}'", AreaCode)) });
        for (int j = 0; j < dtShelf.Rows.Count; j++)
        {
            DataRow dr = dtShelf.Rows[j];
            string shelfTree = GetShelfTree(AreaCode, dr["ShelfCode"].ToString());
            if (j == 0)
            {
                json += ",\"children\":[{";
                json += "\"id\":\"" + dr["ShelfCode"].ToString() + "\"";
                json += ",\"text\":\"" + dr["ShelfName"].ToString() + "\"";

                if (dtShelf.Rows.Count == 1)
                {
                    if (shelfTree.Length > 0)
                        json += ",\"state\":\"closed\"" + shelfTree + "}]";
                    else
                        json += ",\"state\":\"closed\" }]";
                }
                else
                {
                    if (shelfTree.Length > 0)
                        json += ",\"state\":\"closed\"" + shelfTree + "}";
                    else
                        json += ",\"state\":\"closed\"}";
                }
            }
            else if (j > 0 && j < dtShelf.Rows.Count - 1)
            {
                json += ",{\"id\":\"" + dr["ShelfCode"].ToString() + "\"";
                json += ",\"text\":\"" + dr["ShelfName"].ToString() + "\"";

                if (shelfTree.Length > 0)
                    json += ",\"state\":\"closed\" " + shelfTree + "}";
                else
                    json += ",\"state\":\"closed\"}";
            }
            else
            {
                json += ",{\"id\":\"" + dr["ShelfCode"].ToString() + "\"";
                json += ",\"text\":\"" + dr["ShelfName"].ToString() + "\"";
                if (shelfTree.Length > 0)
                    json += ",\"state\":\"closed\" " + shelfTree + "}]";
                else
                    json += ",\"state\":\"closed\"}]";
            }


        }




        return json;
    }


    private string GetShelfTree(string AreaCode, string ShelfCode)
    {
        string json = "";
        BLL.BLLBase bll = new BLL.BLLBase();
        DataTable dtShelf = bll.FillDataTable("Cmd.SelectCell", new DataParameter[] { new DataParameter("{0}", string.Format("ShelfCode='{0}' and AreaCode='{1}'", ShelfCode, AreaCode)) });
        for (int j = 0; j < dtShelf.Rows.Count; j++)
        {
            DataRow dr = dtShelf.Rows[j];

            if (j == 0)
            {
                json += ",\"children\":[{";
                json += "\"id\":\"" + dr["CellCode"].ToString() + "\"";
                json += ",\"text\":\"" + dr["CellName"].ToString() + "\"";
                if (dtShelf.Rows.Count == 1)
                {
                    json += "}]";
                }
                else
                {
                    json += "}";
                }

            }
            else if (j > 0 && j < dtShelf.Rows.Count - 1)
            {
                json += ",{\"id\":\"" + dr["CellCode"].ToString() + "\"";
                json += ",\"text\":\"" + dr["CellName"].ToString() + "\"";
                json += "}";
            }
            else
            {
                json += ",{\"id\":\"" + dr["CellCode"].ToString() + "\"";
                json += ",\"text\":\"" + dr["CellName"].ToString() + "\"";
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