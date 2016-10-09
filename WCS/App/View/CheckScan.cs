﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO.Ports;
using System.Text.RegularExpressions;
using Util;

namespace App.View
{
    public partial class CheckScan : Form
    {
        /// <summary>
        /// 
        /// </summary>
        private int Flag;
        public string strValue;
        private DataTable dtProductInfo;
        BLL.BLLBase bll = new BLL.BLLBase();
        private string TaskNo;
        private string BillID;
        private int CheckCount = 0;
     
        StringBuilder builder = new StringBuilder();

        public CheckScan()
        {
            InitializeComponent();
        }
        public CheckScan(int flag, DataTable dtInfo)
        {
            InitializeComponent();
            Flag = flag;
            dtProductInfo = dtInfo;
            CheckCount = 0;
        }

        private void btnOK_Click(object sender, EventArgs e)
        {
            if (CheckCount == 0)
            {
                MCP.Logger.Error("请扫描条码后再确认！");
                return;
            }
            bool chk = true;
            for (int i = 0; i < dgvMain.Rows.Count; i++)
            {
                string BarCode = dgvMain.Rows[i].Cells["colBarCode"].Value.ToString();
                string TaskNo = dgvMain.Rows[i].Cells["colTaskNo"].Value.ToString();
                bool blnExists = false;
                for (int j = 0; j < dgvCheck.Rows.Count; j++)
                {
                    if ((BarCode + "#" + TaskNo).Equals(dgvCheck.Rows[j].Cells["colChkBarCode"].Value.ToString() + "#" + dgvCheck.Rows[j].Cells["colChkTaskNo"].Value.ToString()))
                    {
                        blnExists = true;
                        break;
                    }
                    
                }
                if (!blnExists)
                {
                    chk = false;
                    break;
                }
            }

            if (chk)
                strValue = "1";
            else
                strValue = "0";
            this.DialogResult = DialogResult.OK;

        }

        private void txtCode_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                if (this.txtCode.Text.Trim().Length == 0)
                    return;
                CheckCount++;

                bll.ExecNonQuery("WCS.updateCheckScanDetail", new DataParameter[] { new DataParameter("@BarCode", this.txtCode.Text.Trim()), new DataParameter("@TaskNo", TaskNo), new DataParameter("@BillID", BillID) });
                DataTable dt = bll.FillDataTable("WCS.SelectCheckScanDetail", new DataParameter[] { new DataParameter("@TaskNo", TaskNo) });
                this.bsCheck.DataSource = dt;
            }            
        }

        private void CheckScan_Load(object sender, EventArgs e)
        {
            DataRow dr = dtProductInfo.Rows[0];
            this.txtCellCode.Text = dr["CellCode"].ToString();
            BillID = dr["BillID"].ToString();
           
             
            TaskNo = dr["TaskNo"].ToString();

            DataTable dt = bll.FillDataTable("WCS.SelectCheckDetail", new DataParameter[] { new DataParameter("@TaskNo", TaskNo) });

            this.bsMain.DataSource = dt;



            //THOK.MCP.Config.Configuration conf = new MCP.Config.Configuration();
            //conf.Load("Config.xml");


            //comm.PortName = conf.Attributes["ScanPortName"];
            //comm.BaudRate = int.Parse(conf.Attributes["ScanBaudRate"]);
            //comm.NewLine = "\r\n";
            //comm.RtsEnable = true;//根据实际情况吧。

            ////添加事件注册
            //comm.DataReceived += comm_DataReceived;
            //try
            //{
            //    comm.Open();
            //}
            //catch (Exception ex)
            //{
            //    //捕获到异常信息，创建一个新的comm对象，之前的不能用了。
            //    comm = new SerialPort();
            //    //现实异常信息给客户。
            //    MessageBox.Show(ex.Message);
            //}
        }

        private void CheckScan_Activated(object sender, EventArgs e)
        {
            this.txtCode.SelectAll();
            this.txtCode.Focus();
        }

        //void comm_DataReceived(object sender, SerialDataReceivedEventArgs e)
        //{
        //    int n = comm.BytesToRead;//先记录下来，避免某种原因，人为的原因，操作几次之间时间长，缓存不一致
        //    byte[] buf = new byte[n];//声明一个临时数组存储当前来的串口数据
         
        //    comm.Read(buf, 0, n);//读取缓冲数据
        //    builder.Remove(0, builder.Length);//清除字符串构造器的内容
        //    //因为要访问ui资源，所以需要使用invoke方式同步ui。
        //    this.Invoke((EventHandler)(delegate
        //    {

        //        //直接按ASCII规则转换成字符串
        //        builder.Append(Encoding.ASCII.GetString(buf));

        //        //追加的形式添加到文本框末端，并滚动到最后。
        //        this.txtCode.AppendText(builder.ToString());
        //        if (this.txtCode.Text.IndexOf("\r\n") > 0)
        //        {
        //            this.txtCode.Text = txtCode.Text.Replace("\r\n", "");
        //            txtCode_KeyDown(sender, new KeyEventArgs(Keys.Enter));
        //        }

        //    }));
        //}
    }
}
