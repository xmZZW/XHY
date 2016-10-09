using System;
using System.Collections.Generic;
using System.Text;
using MCP;
using System.Data;
using Util;
 

namespace App.Dispatching.Process
{
    public class ErpProcess : AbstractProcess
    {
        protected override void StateChanged(StateItem stateItem, IProcessDispatcher dispatcher)
        {
            try
            {
                string cmd = stateItem.ItemName;
                Dictionary<string, string> obj = (Dictionary<string, string>)stateItem.State;
                string IsUpErp = "1";
                string ErpMsg = obj["MSG"];
                if (obj["Result"].ToUpper() == "N")
                    IsUpErp = "0";
                string strTaskType = "";
                string Where = string.Format("SourceBillNo='{0}'", obj["BillNo"]);
                if (cmd.Trim() == "")
                {
                    Logger.Error("Erp回传内容为空！");
                    return;
 
                }
                switch (cmd)
                {
                    case "InStock":
                        strTaskType = "入库";
                        Where += " and TaskType=11";
                        break;
                    case "OutStock":
                        strTaskType = "出库";
                        Where += " and TaskType=12";
                        break;
                    case "CheckStock":
                        Where = string.Format("BillID='{0}'", obj["BillNo"]);
                        strTaskType = "盘点";
                        Where += " and TaskType=14 ";
                        break;
                }

                BLL.BLLBase bll = new BLL.BLLBase();
                DataTable dt = bll.FillDataTable("WCS.SelectWmsBillID", new DataParameter[] { new DataParameter("{0}", Where) });
                if (dt.Rows.Count > 0)
                {
                    bll.ExecNonQuery("WCS.UpdateBillUpErp", new DataParameter[] { new DataParameter("@IsUpERP", IsUpErp), new DataParameter("@ErpMSG", ErpMsg), new DataParameter("{0}", string.Format("BillID='{0}'", dt.Rows[0]["BillID"].ToString())) });
                    string InfoMesg = strTaskType + "单号：" + dt.Rows[0]["BillID"].ToString() + "返回值为：" + obj["Result"] + "," + obj["MSG"];
                    if (IsUpErp == "0")
                    {
                        Logger.Error(InfoMesg);
                    }
                    else
                    {
                        Logger.Info(InfoMesg);
                    }
                }
                else
                {
                    Logger.Error("Erp回传单号错误:" + obj["BillNo"]);

                }
            }
            catch (Exception ex)
            {
                Logger.Error("ErpProcess出错:" + ex.Message);
            }
        }
    }
}
