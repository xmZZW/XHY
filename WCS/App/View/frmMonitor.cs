using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Util;
using DataGridViewAutoFilter;
using MCP;

namespace App.View
{
    public partial class frmMonitor : BaseForm
    {
        private Point InitialP1;
        private Point InitialP2;

        float colDis = 20.75f;
        float rowDis = 54.4f;
        
        private System.Timers.Timer tmWorkTimer = new System.Timers.Timer();
        private System.Timers.Timer tmCrane1 = new System.Timers.Timer();
        BLL.BLLBase bll = new BLL.BLLBase();
        Dictionary<int, string> dicCraneFork = new Dictionary<int, string>();
        Dictionary<int, string> dicCraneState = new Dictionary<int, string>();
        Dictionary<int, string> dicCraneAction = new Dictionary<int, string>();
        Dictionary<int, string> dicCraneError = new Dictionary<int, string>();
        Dictionary<int, string> dicCraneOver = new Dictionary<int, string>();

        public frmMonitor()
        {
            InitializeComponent();
        }

        private void btnStop_Click(object sender, EventArgs e)
        {
            Point P2 = picCrane.Location;
            P2.X = P2.X - 90;

            this.picCrane.Location = P2;
        }

        private void frmMonitor_Load(object sender, EventArgs e)
        {
            MainData.OnTask += new TaskEventHandler(Data_OnTask);
            Cranes.OnCrane += new CraneEventHandler(Monitor_OnCrane);
            AddDicKeyValue();

            InitialP1 = picCrane.Location;
            picCrane.Parent = pictureBox1;
            picCrane.BackColor = Color.Transparent;
            
            InitialP2 = picCar.Location;
            picCar.Parent = pictureBox1;
            picCar.BackColor = Color.Transparent;

            this.BindData();
            for (int i = 0; i < this.dgvMain.Columns.Count - 1; i++)
                ((DataGridViewAutoFilterTextBoxColumn)this.dgvMain.Columns[i]).FilteringEnabled = true;

            tmWorkTimer.Interval = 3000;
            tmWorkTimer.Elapsed += new System.Timers.ElapsedEventHandler(tmWorker);
            tmWorkTimer.Start();

            tmCrane1.Interval = 3000;
            tmCrane1.Elapsed += new System.Timers.ElapsedEventHandler(tmCraneWorker1);
            tmCrane1.Start();
        }
        private void AddDicKeyValue()
        {
            dicCraneFork.Add(0, "非原点");
            dicCraneFork.Add(1, "原点");

            dicCraneState.Add(0, "空闲");
            dicCraneState.Add(1, "等待");
            dicCraneState.Add(2, "定位");
            dicCraneState.Add(3, "取货");
            dicCraneState.Add(4, "放货");
            dicCraneState.Add(98, "维修");

            dicCraneAction.Add(0, "非自动");
            dicCraneAction.Add(1, "自动");

            dicCraneError.Add(0, "");
            dicCraneError.Add(1, "行走极限开关动作");
            dicCraneError.Add(2, "载货台上极限开关动作");
            dicCraneError.Add(3, "载货台下极限开关动作");
            dicCraneError.Add(4, "电气柜门急停开关被按下");
            dicCraneError.Add(5, "外部急停按钮被按下");
            dicCraneError.Add(6, "载货台超速保护装置动作");
            dicCraneError.Add(7, "载货台安全夹紧装置动作");
            dicCraneError.Add(8, "相序保护开关未正常工作");
            dicCraneError.Add(9, "安全继电器未正常工作");
            dicCraneError.Add(10, "行走变频器故障");
            dicCraneError.Add(11, "起升变频器故障");
            dicCraneError.Add(12, "货叉变频器故障");
            dicCraneError.Add(13, "行走马达保护器故障");
            dicCraneError.Add(14, "起升马达保护器故障");
            dicCraneError.Add(15, "货叉马达保护器故障");
            dicCraneError.Add(16, "行走电机抱闸供电故障");
            dicCraneError.Add(17, "起升电机抱闸供电故障");
            dicCraneError.Add(18, "货叉电机抱闸供电故障");
            dicCraneError.Add(19, "220V 供电故障");
            dicCraneError.Add(20, "24V 供电故障");
            dicCraneError.Add(21, "货叉扭矩检测异常");
            dicCraneError.Add(22, "货叉电机运行超时");
            dicCraneError.Add(23, "行走电机运行超时");
            dicCraneError.Add(24, "输送机光栅触发");
            dicCraneError.Add(25, "起升电机抱闸供电故障");
            dicCraneError.Add(101, "行走激光丢失");
            dicCraneError.Add(102, "起升激光丢失");
            dicCraneError.Add(103, "货叉信号丢失");
            dicCraneError.Add(104, "Profibus总线通讯故障");
            dicCraneError.Add(105, "行走停准失败");
            dicCraneError.Add(106, "起升停准失败");
            dicCraneError.Add(107, "货叉停准失败");
            dicCraneError.Add(108, "载货台货物左超长");
            dicCraneError.Add(109, "载货台货物右超长");
            dicCraneError.Add(110, "载货台货物左前超宽");
            dicCraneError.Add(111, "载货台货物左后超差");
            dicCraneError.Add(112, "载货台货物右前超差");
            dicCraneError.Add(113, "载货台货物右后超差");
            dicCraneError.Add(114, "载货台货物左超高");
            dicCraneError.Add(115, "载货台货物右超高");

            dicCraneError.Add(116, "货叉位置错误");
            dicCraneError.Add(117, "货叉左侧极限");
            dicCraneError.Add(118, "货叉右侧极限");
            dicCraneError.Add(119, "上位机下达急停指令");
            dicCraneError.Add(120, "取货后载货台无货");
            dicCraneError.Add(121, "放货时目标货位有货");
            dicCraneError.Add(122, "放货后载货台有货");
            dicCraneError.Add(201, "放货或取货超时");
            dicCraneError.Add(202, "输送机不允许取货");
            dicCraneError.Add(203, "输送机不允许放货");
            dicCraneError.Add(301, "自动模式下无任务，载货台有货");
            dicCraneError.Add(302, "任务错误,任务地址错误");
            dicCraneError.Add(303, "任务错误,没有卸货任务");
            dicCraneError.Add(304, "任务错误,任务错误,载货台有货,有取货任务");
            dicCraneError.Add(305, "任务错误,任务错误,载货台无货,无取货任务");
            dicCraneError.Add(306, "任务错误,上一任务未完成");
        }
        void Data_OnTask(TaskEventArgs args)
        {
            if (InvokeRequired)
            {
                BeginInvoke(new TaskEventHandler(Data_OnTask), args);
            }
            else
            {
                lock (this.dgvMain)
                {
                    DataTable dt = args.datatTable;
                    this.bsMain.DataSource = dt;
                    for (int i = 0; i < this.dgvMain.Rows.Count; i++)
                    {
                        if (dgvMain.Rows[i].Cells["colErrCode"].Value.ToString() != "0")
                            this.dgvMain.Rows[i].DefaultCellStyle.BackColor = Color.Red;
                        else
                        {
                            if(i%2==0)
                                this.dgvMain.Rows[i].DefaultCellStyle.BackColor = Color.White;
                            else
                                this.dgvMain.Rows[i].DefaultCellStyle.BackColor = Color.FromArgb(192, 255, 192);

                        }
                    }
                }
            }
        }
        void Monitor_OnCrane(CraneEventArgs args)
        {
            if (InvokeRequired)
            {
                BeginInvoke(new CraneEventHandler(Monitor_OnCrane), args);
            }
            else
            {
                Crane crane = args.crane;
                TextBox txt = GetTextBox("txtTaskNo", crane.CraneNo);
                if (txt != null)
                    txt.Text = crane.TaskNo;

                txt = GetTextBox("txtState", crane.CraneNo);
                if (txt != null && dicCraneState.ContainsKey(crane.TaskType))
                    txt.Text = dicCraneState[crane.TaskType];

                txt = GetTextBox("txtCraneAction", crane.CraneNo);
                if (txt != null && dicCraneAction.ContainsKey(crane.Action))
                    txt.Text = dicCraneAction[crane.Action];

                txt = GetTextBox("txtRow", crane.CraneNo);
                if (txt != null)
                    txt.Text = crane.Row.ToString();

                txt = GetTextBox("txtColumn", crane.CraneNo);
                if (txt != null)
                    txt.Text = crane.Column.ToString();

                //堆垛机位置
                if (crane.CraneNo == 1)
                {
                    this.picCrane.Visible = true;
                    Point P1 = InitialP1;
                    if(crane.Column<46)
                        P1.X = P1.X + (int)((crane.Column-1) * colDis);
                    else
                        P1.X = picCar.Location.X+15;

                    P1.Y = P1.Y + (int)(rowDis * (crane.Row - 1));
                    this.picCrane.Location = P1;

                    Point P2 = InitialP2;
                    P2.Y = P2.Y + (int)(rowDis * (crane.Row - 1));
                    this.picCar.Location = P2;
                }                

                txt = GetTextBox("txtHeight", crane.CraneNo);
                if (txt != null)
                    txt.Text = crane.Height.ToString();

                txt = GetTextBox("txtForkStatus", crane.CraneNo);
                if (txt != null && dicCraneFork.ContainsKey(crane.ForkStatus))
                    txt.Text = dicCraneFork[crane.ForkStatus];
               

                txt = GetTextBox("txtErrorDesc", crane.CraneNo);
                if (txt != null && dicCraneError.ContainsKey(crane.ErrCode))
                    txt.Text = dicCraneError[crane.ErrCode];

                //更新错误代码、错误描述
                //更新任务状态为执行中
                //bll.ExecNonQuery("WCS.UpdateTaskError", new DataParameter[] { new DataParameter("@CraneErrCode", crane.ErrCode.ToString()), new DataParameter("@CraneErrDesc", dicCraneError[crane.ErrCode]), new DataParameter("@TaskNo", crane.TaskNo) });
                txt = GetTextBox("txtErrorNo", crane.CraneNo);
                if (txt != null)
                {
                    if (crane.ErrCode > 0)
                    {
                        DataParameter[] param = new DataParameter[] { new DataParameter("@TaskNo", crane.TaskNo), new DataParameter("@CraneErrCode", crane.ErrCode.ToString()), new DataParameter("@CraneErrDesc", dicCraneError[crane.ErrCode]) };
                        bll.ExecNonQueryTran("WCS.Sp_UpdateTaskError", param);
                        if (txt.Text.Trim() == "")
                            txt.Text = "0";
                        if (crane.ErrCode != int.Parse(txt.Text))
                            Logger.Error(crane.CraneNo.ToString() + "堆垛机执行时出现错误,代码:" + crane.ErrCode.ToString() + ",描述:" + dicCraneError[crane.ErrCode]);
                        txt.Text = crane.ErrCode.ToString();

                    }
                    else
                    {
                        txt.Text = "0";
                    }
                }
            }
        }
        TextBox GetTextBox(string name, int CraneNo)
        {
            Control[] ctl = this.Controls.Find(name + CraneNo.ToString(), true);
            if (ctl.Length > 0)
                return (TextBox)ctl[0];
            else
                return null;
        }
        
        private void tmWorker(object sender, System.Timers.ElapsedEventArgs e)
        {
            try
            {
                tmWorkTimer.Stop();
                DataTable dt = GetMonitorData();
                MainData.TaskInfo(dt);
            }
            catch (Exception ex)
            {
                Logger.Error(ex.Message);
            }
            finally
            {
                tmWorkTimer.Start();
            }
        }
        private void tmCraneWorker1(object sender, System.Timers.ElapsedEventArgs e)
        {
            try
            {
                tmCrane1.Stop();
                string binary = Convert.ToString(255, 2).PadLeft(8, '0');

                string serviceName = "CranePLC1";
                string plcTaskNo = Util.ConvertStringChar.BytesToString(ObjectUtil.GetObjects(Context.ProcessDispatcher.WriteToService(serviceName, "CraneTaskNo")));

                string craneMode = ObjectUtil.GetObject(Context.ProcessDispatcher.WriteToService(serviceName, "CraneMode")).ToString();
                string craneFork = ObjectUtil.GetObject(Context.ProcessDispatcher.WriteToService(serviceName, "CraneFork")).ToString();
                object[] obj = ObjectUtil.GetObjects(Context.ProcessDispatcher.WriteToService(serviceName, "CraneAlarmCode"));

                Crane crane = new Crane();
                crane.CraneNo = 1;
                crane.Row = int.Parse(obj[4].ToString());
                crane.Column = int.Parse(obj[2].ToString());
                crane.Height = int.Parse(obj[3].ToString());
                crane.ForkStatus = int.Parse(craneFork);
                crane.Action = int.Parse(craneMode);
                crane.TaskType = int.Parse(obj[1].ToString());
                crane.ErrCode = int.Parse(obj[0].ToString());
                crane.PalletCode = "";
                crane.TaskNo = plcTaskNo;

                Cranes.CraneInfo(crane);
            }
            catch (Exception ex)
            {
                Logger.Error(ex.Message);
            }
            finally
            {
                tmCrane1.Start();
            }
        }        
        
        private void BindData()
        {
            bsMain.DataSource = GetMonitorData();
        }
        private DataTable GetMonitorData()
        {
            DataTable dt = bll.FillDataTable("WCS.SelectTask", new DataParameter[] { new DataParameter("{0}", "(WCS_TASK.TaskType='11' and WCS_TASK.State in('1','2','3')) OR (WCS_TASK.TaskType in('12','13') and WCS_TASK.State in('2','3')) OR (WCS_TASK.TaskType in('14') and WCS_TASK.State in('2','3','4','5','6')) And WCS_TASK.AreaCode='" + BLL.Server.GetAreaCode() + "'") });
            return dt;
        }
        private void btnBack_Click(object sender, EventArgs e)
        {
            if (this.btnBack1.Text == "启动")
            {
                Context.ProcessDispatcher.WriteToProcess("CraneProcess", "Run", 1);
                this.btnBack1.Text = "停止";
            }
            else
            {
                Context.ProcessDispatcher.WriteToProcess("CraneProcess", "Run", 0);
                this.btnBack1.Text = "启动";
            }
        }

        private void btnBack1_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("是否要召回1号堆垛机到初始位置?", "提示", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == System.Windows.Forms.DialogResult.Yes)
            {
                PutCommand("1", 0);
                Logger.Info("1号堆垛机下发召回命令");
            }
        }
        private void PutCommand(string craneNo, byte TaskType)
        {
            string serviceName = "CranePLC" + craneNo;
            int[] cellAddr = new int[9];
            cellAddr[TaskType] = 1;            

            //cellAddr[3] = int.Parse(this.cbFromColumn.Text);
            //cellAddr[4] = int.Parse(this.cbFromHeight.Text);
            //cellAddr[5] = int.Parse(this.cbFromRow.Text.Substring(3, 3));
            //cellAddr[6] = int.Parse(this.cbToColumn.Text);
            //cellAddr[7] = int.Parse(this.cbToHeight.Text);
            //cellAddr[8] = int.Parse(this.cbToRow.Text.Substring(3, 3));

            Context.ProcessDispatcher.WriteToService(serviceName, "TaskAddress", cellAddr);
            Context.ProcessDispatcher.WriteToService(serviceName, "WriteFinished", 0);
        }

        private void btnStop1_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("是否要急停1号堆垛机?", "提示", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == System.Windows.Forms.DialogResult.Yes)
            {
                PutCommand("1", 2);
                Logger.Info("1号堆垛机下发急停命令");
            }
        }       


        private void dgvMain_CellMouseClick(object sender, DataGridViewCellMouseEventArgs e)
        {
            if (e.Button == MouseButtons.Right)
            {
                if (e.RowIndex >= 0 && e.ColumnIndex >= 0)
                {
                    //若行已是选中状态就不再进行设置
                    if (dgvMain.Rows[e.RowIndex].Selected == false)
                    {
                        dgvMain.ClearSelection();
                        dgvMain.Rows[e.RowIndex].Selected = true;
                    }
                    //只选中一行时设置活动单元格
                    if (dgvMain.SelectedRows.Count == 1)
                    {
                        dgvMain.CurrentCell = dgvMain.Rows[e.RowIndex].Cells[e.ColumnIndex];
                    }
                    string TaskType = this.dgvMain.Rows[this.dgvMain.CurrentCell.RowIndex].Cells["colTaskType"].Value.ToString();
                    if (TaskType == "11")
                    {
                        this.ToolStripMenuItem11.Visible = true;
                        this.ToolStripMenuItem12.Visible = false;
                        this.ToolStripMenuItem13.Visible = true;
                        this.ToolStripMenuItem14.Visible = false;
                        this.ToolStripMenuItem15.Visible = false;
                        this.ToolStripMenuItem16.Visible = false;
                    }
                    else if (TaskType == "12" || TaskType == "13")
                    {
                        this.ToolStripMenuItem11.Visible = false;
                        this.ToolStripMenuItem12.Visible = false;
                        this.ToolStripMenuItem13.Visible = true;
                        this.ToolStripMenuItem14.Visible = false;
                        this.ToolStripMenuItem15.Visible = false;
                        this.ToolStripMenuItem16.Visible = false;
                    }
                    else if (TaskType == "14")
                    {
                        this.ToolStripMenuItem10.Visible = true;
                        this.ToolStripMenuItem11.Visible = false;
                        this.ToolStripMenuItem12.Visible = false;
                        this.ToolStripMenuItem13.Visible = true;
                        this.ToolStripMenuItem14.Visible = false;
                        this.ToolStripMenuItem15.Visible = true;
                        this.ToolStripMenuItem16.Visible = true;
                    }
                    //弹出操作菜单
                    contextMenuStrip1.Show(MousePosition.X, MousePosition.Y);
                }
            }
        }

        private void ToolStripMenuItemCellCode_Click(object sender, EventArgs e)
        {
            if (this.dgvMain.CurrentCell != null)
            {
                BLL.BLLBase bll = new BLL.BLLBase();
                string TaskNo = this.dgvMain.Rows[this.dgvMain.CurrentCell.RowIndex].Cells[0].Value.ToString();
                string TaskType = this.dgvMain.Rows[this.dgvMain.CurrentCell.RowIndex].Cells["colTaskType"].Value.ToString();
                string ErrCode = this.dgvMain.Rows[this.dgvMain.CurrentCell.RowIndex].Cells["colErrCode"].ToString();

                if (TaskType=="11")
                {
                    DataGridViewSelectedRowCollection rowColl = dgvMain.SelectedRows;
                    if (rowColl == null)
                        return;
                    DataRow dr = (rowColl[0].DataBoundItem as DataRowView).Row;
                    frmReassignEmptyCell f = new frmReassignEmptyCell(dr);
                    if (f.ShowDialog() == System.Windows.Forms.DialogResult.OK)
                        this.BindData(); 
                }
                else if (TaskType == "12" || TaskType == "14")
                {
                    DataGridViewSelectedRowCollection rowColl = dgvMain.SelectedRows;
                    if (rowColl == null)
                        return;
                    DataRow dr = (rowColl[0].DataBoundItem as DataRowView).Row;
                    frmReassign f = new frmReassign(dr);
                    if (f.ShowDialog() == System.Windows.Forms.DialogResult.OK)
                        this.BindData(); 
                }
                else if (TaskType == "13")
                {
                    DataGridViewSelectedRowCollection rowColl = dgvMain.SelectedRows;
                    if (rowColl == null)
                        return;
                    DataRow dr = (rowColl[0].DataBoundItem as DataRowView).Row;

                    frmReassignOption fo = new frmReassignOption();
                    if (fo.ShowDialog() == System.Windows.Forms.DialogResult.OK)
                    {
                        if (fo.option == 0)
                        {
                            frmReassign f = new frmReassign(dr);
                            if (f.ShowDialog() == System.Windows.Forms.DialogResult.OK)
                                this.BindData(); 
                        }
                        else
                        {
                            frmReassignEmptyCell fe = new frmReassignEmptyCell(dr);
                            if (fe.ShowDialog() == System.Windows.Forms.DialogResult.OK)
                                this.BindData(); 
                        }
                    }                    
                }
            }
        }

        private void ToolStripMenuItemReassign_Click(object sender, EventArgs e)
        {
            if (this.dgvMain.CurrentCell != null)
            {
                string serviceName = "CranePLC1";

                int[] cellAddr = new int[9];
                cellAddr[0] = 0;
                cellAddr[1] = 1;

                Context.ProcessDispatcher.WriteToService(serviceName, "TaskAddress", cellAddr);
                Context.ProcessDispatcher.WriteToService(serviceName, "WriteFinished", 0);

                DataRow dr = ((DataRowView)dgvMain.Rows[this.dgvMain.CurrentCell.RowIndex].DataBoundItem).Row;
                string TaskNo = dr["TaskNo"].ToString();
                string fromStation = dr["FromStation"].ToString();
                string toStation = dr["ToStation"].ToString();
                string CraneLoad = ObjectUtil.GetObject(Context.ProcessDispatcher.WriteToService(serviceName, "CraneLoad")).ToString();
               
                cellAddr[0] = 0;
                cellAddr[1] = 0;
                cellAddr[2] = 0;
                int Flag = 1;
                if (CraneLoad.Equals("0") || CraneLoad.Equals("False"))
                {
                    cellAddr[3] = byte.Parse(fromStation.Substring(3, 3));
                    cellAddr[4] = byte.Parse(fromStation.Substring(6, 3));
                    cellAddr[5] = byte.Parse(fromStation.Substring(0, 3));
                }
                else
                {
                    cellAddr[3] = 1;
                    cellAddr[4] = 1;
                    cellAddr[5] = 1;
                    Flag = 3;
                }
                cellAddr[6] = byte.Parse(toStation.Substring(3, 3));
                cellAddr[7] = byte.Parse(toStation.Substring(6, 3));
                cellAddr[8] = byte.Parse(toStation.Substring(0, 3));

                sbyte[] taskNo = new sbyte[10];
                Util.ConvertStringChar.stringToBytes(TaskNo, 10).CopyTo(taskNo, 0);

                Context.ProcessDispatcher.WriteToService(serviceName, "TaskAddress", cellAddr);
                Context.ProcessDispatcher.WriteToService(serviceName, "TaskNo", taskNo);
                if (Context.ProcessDispatcher.WriteToService(serviceName, "WriteFinished", Flag))
                {
                    Logger.Info(TaskNo + "重下堆垛机任务！");
                }
                //BLL.BLLBase bll = new BLL.BLLBase();
                //string TaskNo = this.dgvMain.Rows[this.dgvMain.CurrentCell.RowIndex].Cells[0].Value.ToString();
                //string TaskType = this.dgvMain.Rows[this.dgvMain.CurrentCell.RowIndex].Cells["colTaskType"].Value.ToString();

                //if (TaskType == "11")
                //    bll.ExecNonQuery("WCS.UpdateTaskStateByTaskNo", new DataParameter[] { new DataParameter("@State", 1), new DataParameter("@TaskNo", TaskNo) });
                //else if (TaskType == "12" || TaskType == "13")
                //    bll.ExecNonQuery("WCS.UpdateTaskStateByTaskNo", new DataParameter[] { new DataParameter("@State", 0), new DataParameter("@TaskNo", TaskNo) });
                //else if (TaskType == "14")
                //{
                //    frmTaskOption f = new frmTaskOption();
                //    if (f.ShowDialog() == System.Windows.Forms.DialogResult.OK)
                //    {
                //        if(f.option==0)
                //            bll.ExecNonQuery("WCS.UpdateTaskStateByTaskNo", new DataParameter[] { new DataParameter("@State", 1), new DataParameter("@TaskNo", TaskNo) });
                //        else
                //            bll.ExecNonQuery("WCS.UpdateTaskStateByTaskNo", new DataParameter[] { new DataParameter("@State", 5), new DataParameter("@TaskNo", TaskNo) });

                //    }
                //}
                //this.BindData();
            }
        }

        private void ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            string ItemName = ((ToolStripMenuItem)sender).Name;
            string State = ItemName.Substring(ItemName.Length-1, 1);

            if (this.dgvMain.CurrentCell != null)
            {
                BLL.BLLBase bll = new BLL.BLLBase();
                string TaskNo = this.dgvMain.Rows[this.dgvMain.CurrentCell.RowIndex].Cells[0].Value.ToString();

                DataParameter[] param = new DataParameter[] { new DataParameter("@TaskNo", TaskNo), new DataParameter("@State", State) };
                bll.ExecNonQueryTran("WCS.Sp_UpdateTaskState", param);
                
                //bll.ExecNonQuery("WCS.UpdateTaskStateByTaskNo", new DataParameter[] { new DataParameter("@State", State), new DataParameter("@TaskNo", TaskNo) });

                ////堆垛机完成执行
                //if (State == "7")
                //{
                //    DataParameter[] param = new DataParameter[] { new DataParameter("@TaskNo", TaskNo) };
                //    bll.ExecNonQueryTran("WCS.Sp_TaskProcess", param);
                //}
                BindData();
            }
        }

        private void ToolStripMenuItemDelCraneTask_Click(object sender, EventArgs e)
        {
            string serviceName = "CranePLC1";
            int[] cellAddr = new int[9];
            cellAddr[0] = 0;
            cellAddr[1] = 1;

            Context.ProcessDispatcher.WriteToService(serviceName, "TaskAddress", cellAddr);
            Context.ProcessDispatcher.WriteToService(serviceName, "WriteFinished", 0);

            MCP.Logger.Info("已给堆垛机下发取消任务指令");
        }

        private void btnClearAlarm_Click(object sender, EventArgs e)
        {
            Context.ProcessDispatcher.WriteToService("CranePLC1", "Reset", 1);
        }

        private void btnReset_Click(object sender, EventArgs e)
        {
            Context.ProcessDispatcher.WriteToService("CranePLC1", "Reset", 2);
        }        
    }
}
