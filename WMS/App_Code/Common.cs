using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Util;

/// <summary>
///Common 的摘要说明
/// </summary>
public class Common
{
	public Common()
	{
		 
	}

    public static void AddOperateLog(string UserName, string moduleName, string executeOperation)
    {

        BLL.BLLBase bll = new BLL.BLLBase();
        bll.ExecNonQuery("Security.InsertOperatorLog", new DataParameter[]{new DataParameter("@LoginUser",UserName),new DataParameter("@LoginTime",DateTime.Now),
                                                         new DataParameter("@LoginModule",moduleName),new DataParameter("@ExecuteOperator",executeOperation)});
    }

    public static void AddExceptionLog(string UserName, string moduleName, string executeOperation)
    {

        BLL.BLLBase bll = new BLL.BLLBase();
        bll.ExecNonQuery("Security.InsertOperatorLog", new DataParameter[]{new DataParameter("@LoginUser",UserName),new DataParameter("@LoginTime",DateTime.Now),
                                                         new DataParameter("@LoginModule",moduleName),new DataParameter("@ExecuteOperator",executeOperation)});
    }


    public static void SetPara(string Comd, System.Data.DataTable dt, ref  List<string> comds, ref  List<DataParameter[]> paras)
    {
        for (int j = 0; j < dt.Rows.Count; j++)
        {
            DataParameter[] AddPara = new DataParameter[dt.Columns.Count];
            for (int K = 0; K < dt.Columns.Count; K++)
            {
                if (dt.Columns[K].ColumnName.IndexOf("Date") > 0 && dt.Rows[j][K].ToString() == "")
                    AddPara[K] = new DataParameter("@" + dt.Columns[K].ColumnName, null);
                else
                    AddPara[K] = new DataParameter("@" + dt.Columns[K].ColumnName, dt.Rows[j][K]);
            }
            comds.Add(Comd);
            paras.Add(AddPara);
        }
    }
}