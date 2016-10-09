using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using MCP;

namespace App
{
    public partial class Main : Form
    {
        private bool IsActiveForm = false;
        public bool IsActiveTab = false;
        private Context context = null;
        private System.Timers.Timer tmWorkTimer = new System.Timers.Timer();

        public Main()
        {
            InitializeComponent();
        }

        private void inStockToolStripMenuItem_Click(object sender, EventArgs e)
        {
            App.View.Task.frmInStock f = new View.Task.frmInStock();
            ShowForm(f);
        }

        private void Main_Shown(object sender, EventArgs e)
        {
            try
            {
                lbLog.Scrollable = true;
                Logger.OnLog += new LogEventHandler(Logger_OnLog);
                FormDialog.OnDialog += new DialogEventHandler(FormDialog_OnDialog);
                context = new Context();

                ContextInitialize initialize = new ContextInitialize();
                initialize.InitializeContext(context);

                if (BLL.Server.GetTaskTest() == "0")
                {
                    this.toolStripButton1.Visible = false;
                }


                View.frmMonitor f = new View.frmMonitor();
                ShowForm(f);

                //tmWorkTimer.Interval = 3000;
                //tmWorkTimer.Elapsed += new System.Timers.ElapsedEventHandler(tmWorker);
                //tmWorkTimer.Start();
                
            }
            catch (Exception ee)
            {
                Logger.Error("初始化处理失败请检查配置，原因：" + ee.Message);
            }
        }
        private void tmWorker(object sender, System.Timers.ElapsedEventArgs e)
        {
            try
            {
                tmWorkTimer.Stop();

                //Sorting.Dispatching.Dal.OrderDal orderDal = new Dispatching.Dal.OrderDal();
                //DataTable dt = orderDal.GetSortingOrder().Tables[0];
                //for (int i = 0; i < dt.Rows.Count; i++)
                //{
                //    string requestNo = (i + 1).ToString();
                //    string batchNo = dt.Rows[i]["BATCHNO"].ToString();
                //    string SortNo = dt.Rows[i]["SORTNO"].ToString();
                //    DataSet ds = orderDal.GetOrder(batchNo, SortNo);
                //    Order.OrderInfo(requestNo, ds);
                //}
                //Logger.Debug("123");
                //Logger.Error("456");
            }
            finally
            {
                tmWorkTimer.Start();
            }
        }      
        void Logger_OnLog(MCP.LogEventArgs args)
        {
            if (InvokeRequired)
            {
                BeginInvoke(new LogEventHandler(Logger_OnLog), args);
            }
            else
            {
                lock (lbLog)
                {
                    string msg1 = string.Format("[{0}]", args.LogLevel);
                    string msg2 = string.Format("{0}", DateTime.Now);
                    string msg3 = string.Format("{0} ", args.Message);
                    this.lbLog.BeginUpdate();
                    ListViewItem item = new ListViewItem(new string[] { msg1, msg2, msg3 });
                    
                    if (msg1.Contains("[ERROR]"))
                    {
                        //item.ForeColor = Color.Red;
                        item.BackColor = Color.Red;
                    }
                    lbLog.Items.Insert(0, item);
                    this.lbLog.EndUpdate();
                    WriteLoggerFile(msg1 + msg2 + msg3);
                }
            }
        }

        private void CreateDirectory(string directoryName)
        {
            if (!System.IO.Directory.Exists(directoryName))
                System.IO.Directory.CreateDirectory(directoryName);
        }

        private void WriteLoggerFile(string text)
        {
            try
            {
                string path = "";
                CreateDirectory("日志");
                path = "日志";
                path = path + @"/" + DateTime.Now.ToString().Substring(0, 4).Trim();
                CreateDirectory(path);
                path = path + @"/" + DateTime.Now.ToString("yyyy-MM-dd").Substring(0, 7).Trim();
                path = path.TrimEnd(new char[] { '-' });
                CreateDirectory(path);
                path = path + @"/" + DateTime.Now.ToString("yyyy-MM-dd") + ".txt";
                System.IO.File.AppendAllText(path, string.Format("{0} {1}", DateTime.Now, text + "\r\n"));
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex.Message);
            }
        }
        string FormDialog_OnDialog(DialogEventArgs args)
        {
            string strValue = "";
            if (InvokeRequired)
            {
                return (string)this.Invoke(new DialogEventHandler(FormDialog_OnDialog), args);
            }
            else
            {
                if (args.Message[0] == "6")//盘点
                {
                    View.CheckScan frm = new View.CheckScan(int.Parse(args.Message[0]), args.dtInfo);
                    if (frm.ShowDialog() == DialogResult.OK)
                    {
                        strValue = frm.strValue;
                    }
                }
            }
            return strValue;
        }
        #region 公共方法
        /// <summary>
        /// 打开一个窗体

        /// </summary>
        /// <param name="frm"></param>
        private void ShowForm(Form frm)
        {
            if (OpenOnce(frm))
            {
                frm.MdiParent = this;
                ((View.BaseForm)frm).Context = context;
                frm.Show();
                frm.WindowState = FormWindowState.Maximized;
                AddTabPage(frm.Handle.ToString(), frm.Text);
            }
        }
        /// <summary>
        /// 判断窗体是否已打开
        /// </summary>
        /// <param name="frm"></param>
        /// <returns></returns>
        private bool OpenOnce(Form frm)
        {
            foreach (Form mdifrm in this.MdiChildren)
            {
                int index = mdifrm.Text.IndexOf(" ");
                if (index > 0)
                {
                    if (frm.Name == mdifrm.Name && frm.Text == mdifrm.Text.Substring(0, index))
                    {
                        mdifrm.Activate();
                        return false;
                    }
                }
                else
                {
                    if (frm.Name == mdifrm.Name && frm.Text == mdifrm.Text)
                    {
                        mdifrm.Activate();
                        return false;
                    }
                }
            }
            return true;

        }
        
        private void AddTabPage(string strKey, string strText)
        {
            IsActiveForm = true;
            TabPage tab = new TabPage();
            tab.Name = strKey.ToString();
            tab.Text = strText;
            tabForm.TabPages.Add(tab);
            tabForm.SelectedTab = tab;
            this.pnlTab.Visible = true;
            IsActiveForm = false;
        }
        
        public void SetActiveTab(string strKey, bool blnActive)
        {
            foreach (TabPage tab in this.tabForm.TabPages)
            {
                if (tab.Name == strKey)
                {
                    IsActiveForm = true;

                    if (blnActive)
                        tabForm.SelectedTab = tab;
                    else
                    {
                        tabForm.TabPages.Remove(tab);
                        if (this.MdiChildren.Length > 1)
                            this.pnlTab.Visible = true;
                        else
                            this.pnlTab.Visible = false;
                    }

                    IsActiveForm = false; ;
                }
            }
        }
        private void tabForm_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (IsActiveForm)
                return;
            foreach (Form mdifrm in this.MdiChildren)
            {
                if (mdifrm.Handle.ToInt32() == int.Parse(((TabControl)sender).SelectedTab.Name))
                {
                    IsActiveTab = true;
                    mdifrm.Activate();
                    IsActiveTab = false;
                }
            }
        }
        #endregion

        private void Main_Load(object sender, EventArgs e)
        {
            
        }

        private void ToolStripMenuItem_Cell_Click(object sender, EventArgs e)
        {
            App.View.Dispatcher.frmCellQuery f = new App.View.Dispatcher.frmCellQuery();
            ShowForm(f);
        }

        private void toolStripButton_Close_Click(object sender, EventArgs e)
        {
            if (DialogResult.Yes == MessageBox.Show("您确定要退出调度系统吗？", "询问", MessageBoxButtons.YesNo, MessageBoxIcon.Question))
            {
                Logger.Info("退出系统");
                System.Environment.Exit(0);
            }
        }

        private void toolStripButton_InStockTask_Click(object sender, EventArgs e)
        {
            App.View.Task.frmInStock f = new View.Task.frmInStock();
            ShowForm(f);
        }

        private void toolStripButton_OutStock_Click(object sender, EventArgs e)
        {
            App.View.Task.frmOutStock f = new View.Task.frmOutStock();
            ShowForm(f);
        }

        private void OutStockToolStripMenuItem_Click(object sender, EventArgs e)
        {
            App.View.Task.frmOutStock f = new View.Task.frmOutStock();
            ShowForm(f);
        }

        private void Main_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (DialogResult.Yes == MessageBox.Show("您确定要退出调度系统吗？", "询问", MessageBoxButtons.YesNo, MessageBoxIcon.Question))
            {
                Logger.Info("退出系统");
                System.Environment.Exit(0);
            }
            else
                e.Cancel = true;
        }

        private void MoveStockToolStripMenuItem_Click(object sender, EventArgs e)
        {
            App.View.Task.frmMoveStock f = new View.Task.frmMoveStock();
            ShowForm(f);
        }

        private void toolStripButton_MoveStock_Click(object sender, EventArgs e)
        {
            App.View.Task.frmMoveStock f = new View.Task.frmMoveStock();
            ShowForm(f);
        }

        private void toolStripButton1_Click(object sender, EventArgs e)
        {
            View.Task.frmCraneTask f = new View.Task.frmCraneTask();
            ShowForm(f);
        }

        private void toolStripButton_StartCrane_Click(object sender, EventArgs e)
        {
            if (this.toolStripButton_StartCrane.Text == "堆垛机联机")
            {
                context.ProcessDispatcher.WriteToProcess("CraneProcess", "Run", 1);
                this.toolStripButton_StartCrane.Image = App.Properties.Resources.process_accept;
                this.toolStripButton_StartCrane.Text = "堆垛机脱机";
            }
            else
            {
                context.ProcessDispatcher.WriteToProcess("CraneProcess", "Run", 0);
                this.toolStripButton_StartCrane.Image = App.Properties.Resources.process_remove;
                this.toolStripButton_StartCrane.Text = "堆垛机联机";
            }            
        }

        private void toolStripButton_Inventor_Click(object sender, EventArgs e)
        {
            App.View.Task.frmInventor f = new View.Task.frmInventor();
            ShowForm(f);
        }

        private void InventortoolStripMenuItem_Click(object sender, EventArgs e)
        {
            App.View.Task.frmInventor f = new View.Task.frmInventor();
            ShowForm(f);
        }

        private void toolStripButton_CellMonitor_Click(object sender, EventArgs e)
        {
            App.View.Dispatcher.frmCellQuery f = new App.View.Dispatcher.frmCellQuery();
            ShowForm(f);
        }

        private void ToolStripMenuItem_Param_Click(object sender, EventArgs e)
        {
            App.View.Param.ParameterForm f = new App.View.Param.ParameterForm();
            ShowForm(f);
        }

        private void toolStripButton_Scan_Click(object sender, EventArgs e)
        {
            App.View.Task.frmInStockTask f = new App.View.Task.frmInStockTask();
            f.ShowDialog();
        }

        private void toolStripButton_UpERP_Click(object sender, EventArgs e)
        {
            App.View.frmBillUpERP f = new App.View.frmBillUpERP();
            ShowForm(f);
        }

        
    }
}
