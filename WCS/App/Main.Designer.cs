namespace App
{
    partial class Main
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.taskToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.inStockToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.OutStockToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.InventortoolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.MoveStockToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.UpERPToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.ToolStripMenuItem_Monitor = new System.Windows.Forms.ToolStripMenuItem();
            this.ToolStripMenuItem_Cell = new System.Windows.Forms.ToolStripMenuItem();
            this.ToolStripMenuItemSetup = new System.Windows.Forms.ToolStripMenuItem();
            this.ToolStripMenuItem_Param = new System.Windows.Forms.ToolStripMenuItem();
            this.pnlBottom = new System.Windows.Forms.Panel();
            this.lbLog = new System.Windows.Forms.ListView();
            this.columnHeader1 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader2 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader3 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.toolStrip1 = new System.Windows.Forms.ToolStrip();
            this.toolStripButton_Scan = new System.Windows.Forms.ToolStripButton();
            this.toolStripButton_InStockTask = new System.Windows.Forms.ToolStripButton();
            this.toolStripButton_OutStock = new System.Windows.Forms.ToolStripButton();
            this.toolStripButton_Inventor = new System.Windows.Forms.ToolStripButton();
            this.toolStripButton1 = new System.Windows.Forms.ToolStripButton();
            this.toolStripButton_CellMonitor = new System.Windows.Forms.ToolStripButton();
            this.toolStripButton_StartCrane = new System.Windows.Forms.ToolStripButton();
            this.toolStripButton_MoveStock = new System.Windows.Forms.ToolStripButton();
            this.toolStripButton_UpERP = new System.Windows.Forms.ToolStripButton();
            this.toolStripButton_Close = new System.Windows.Forms.ToolStripButton();
            this.pnlTab = new System.Windows.Forms.Panel();
            this.tabForm = new System.Windows.Forms.TabControl();
            this.menuStrip1.SuspendLayout();
            this.pnlBottom.SuspendLayout();
            this.toolStrip1.SuspendLayout();
            this.pnlTab.SuspendLayout();
            this.SuspendLayout();
            // 
            // menuStrip1
            // 
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.taskToolStripMenuItem,
            this.ToolStripMenuItem_Monitor,
            this.ToolStripMenuItemSetup});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(1284, 25);
            this.menuStrip1.TabIndex = 1;
            this.menuStrip1.Text = "menuStrip1";
            // 
            // taskToolStripMenuItem
            // 
            this.taskToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.inStockToolStripMenuItem,
            this.OutStockToolStripMenuItem,
            this.InventortoolStripMenuItem,
            this.MoveStockToolStripMenuItem,
            this.UpERPToolStripMenuItem});
            this.taskToolStripMenuItem.Name = "taskToolStripMenuItem";
            this.taskToolStripMenuItem.Size = new System.Drawing.Size(68, 21);
            this.taskToolStripMenuItem.Text = "任务操作";
            // 
            // inStockToolStripMenuItem
            // 
            this.inStockToolStripMenuItem.Name = "inStockToolStripMenuItem";
            this.inStockToolStripMenuItem.Size = new System.Drawing.Size(124, 22);
            this.inStockToolStripMenuItem.Text = "入库任务";
            this.inStockToolStripMenuItem.Click += new System.EventHandler(this.inStockToolStripMenuItem_Click);
            // 
            // OutStockToolStripMenuItem
            // 
            this.OutStockToolStripMenuItem.Name = "OutStockToolStripMenuItem";
            this.OutStockToolStripMenuItem.Size = new System.Drawing.Size(124, 22);
            this.OutStockToolStripMenuItem.Text = "出库任务";
            this.OutStockToolStripMenuItem.Click += new System.EventHandler(this.OutStockToolStripMenuItem_Click);
            // 
            // InventortoolStripMenuItem
            // 
            this.InventortoolStripMenuItem.Name = "InventortoolStripMenuItem";
            this.InventortoolStripMenuItem.Size = new System.Drawing.Size(124, 22);
            this.InventortoolStripMenuItem.Text = "盘点任务";
            this.InventortoolStripMenuItem.Click += new System.EventHandler(this.InventortoolStripMenuItem_Click);
            // 
            // MoveStockToolStripMenuItem
            // 
            this.MoveStockToolStripMenuItem.Name = "MoveStockToolStripMenuItem";
            this.MoveStockToolStripMenuItem.Size = new System.Drawing.Size(124, 22);
            this.MoveStockToolStripMenuItem.Text = "移库任务";
            this.MoveStockToolStripMenuItem.Click += new System.EventHandler(this.MoveStockToolStripMenuItem_Click);
            // 
            // UpERPToolStripMenuItem
            // 
            this.UpERPToolStripMenuItem.Name = "UpERPToolStripMenuItem";
            this.UpERPToolStripMenuItem.Size = new System.Drawing.Size(124, 22);
            this.UpERPToolStripMenuItem.Text = "上传ERP";
            this.UpERPToolStripMenuItem.Click += new System.EventHandler(this.toolStripButton_UpERP_Click);
            // 
            // ToolStripMenuItem_Monitor
            // 
            this.ToolStripMenuItem_Monitor.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.ToolStripMenuItem_Cell});
            this.ToolStripMenuItem_Monitor.Name = "ToolStripMenuItem_Monitor";
            this.ToolStripMenuItem_Monitor.Size = new System.Drawing.Size(68, 21);
            this.ToolStripMenuItem_Monitor.Text = "调度监控";
            // 
            // ToolStripMenuItem_Cell
            // 
            this.ToolStripMenuItem_Cell.Name = "ToolStripMenuItem_Cell";
            this.ToolStripMenuItem_Cell.Size = new System.Drawing.Size(124, 22);
            this.ToolStripMenuItem_Cell.Text = "货位监控";
            this.ToolStripMenuItem_Cell.Click += new System.EventHandler(this.ToolStripMenuItem_Cell_Click);
            // 
            // ToolStripMenuItemSetup
            // 
            this.ToolStripMenuItemSetup.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.ToolStripMenuItem_Param});
            this.ToolStripMenuItemSetup.Name = "ToolStripMenuItemSetup";
            this.ToolStripMenuItemSetup.Size = new System.Drawing.Size(44, 21);
            this.ToolStripMenuItemSetup.Text = "设定";
            // 
            // ToolStripMenuItem_Param
            // 
            this.ToolStripMenuItem_Param.Name = "ToolStripMenuItem_Param";
            this.ToolStripMenuItem_Param.Size = new System.Drawing.Size(124, 22);
            this.ToolStripMenuItem_Param.Text = "参数设定";
            this.ToolStripMenuItem_Param.Click += new System.EventHandler(this.ToolStripMenuItem_Param_Click);
            // 
            // pnlBottom
            // 
            this.pnlBottom.Controls.Add(this.lbLog);
            this.pnlBottom.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.pnlBottom.Location = new System.Drawing.Point(0, 387);
            this.pnlBottom.Name = "pnlBottom";
            this.pnlBottom.Size = new System.Drawing.Size(1284, 173);
            this.pnlBottom.TabIndex = 9;
            // 
            // lbLog
            // 
            this.lbLog.BackColor = System.Drawing.SystemColors.Window;
            this.lbLog.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.columnHeader1,
            this.columnHeader2,
            this.columnHeader3});
            this.lbLog.Dock = System.Windows.Forms.DockStyle.Fill;
            this.lbLog.Font = new System.Drawing.Font("微软雅黑", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.lbLog.FullRowSelect = true;
            this.lbLog.LabelWrap = false;
            this.lbLog.Location = new System.Drawing.Point(0, 0);
            this.lbLog.Name = "lbLog";
            this.lbLog.ShowGroups = false;
            this.lbLog.Size = new System.Drawing.Size(1284, 173);
            this.lbLog.TabIndex = 10;
            this.lbLog.UseCompatibleStateImageBehavior = false;
            this.lbLog.View = System.Windows.Forms.View.Details;
            // 
            // columnHeader1
            // 
            this.columnHeader1.Text = "Header";
            this.columnHeader1.Width = 80;
            // 
            // columnHeader2
            // 
            this.columnHeader2.Text = "DateTime";
            this.columnHeader2.Width = 150;
            // 
            // columnHeader3
            // 
            this.columnHeader3.Text = "Log";
            this.columnHeader3.Width = 800;
            // 
            // toolStrip1
            // 
            this.toolStrip1.AutoSize = false;
            this.toolStrip1.ImageScalingSize = new System.Drawing.Size(32, 32);
            this.toolStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripButton_Scan,
            this.toolStripButton_InStockTask,
            this.toolStripButton_OutStock,
            this.toolStripButton_Inventor,
            this.toolStripButton1,
            this.toolStripButton_CellMonitor,
            this.toolStripButton_StartCrane,
            this.toolStripButton_MoveStock,
            this.toolStripButton_UpERP,
            this.toolStripButton_Close});
            this.toolStrip1.Location = new System.Drawing.Point(0, 25);
            this.toolStrip1.Name = "toolStrip1";
            this.toolStrip1.Size = new System.Drawing.Size(1284, 52);
            this.toolStrip1.TabIndex = 13;
            this.toolStrip1.Text = "toolStrip1";
            // 
            // toolStripButton_Scan
            // 
            this.toolStripButton_Scan.AutoSize = false;
            this.toolStripButton_Scan.Image = global::App.Properties.Resources.Barcode_32;
            this.toolStripButton_Scan.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripButton_Scan.Name = "toolStripButton_Scan";
            this.toolStripButton_Scan.Size = new System.Drawing.Size(60, 50);
            this.toolStripButton_Scan.Text = "扫码入库";
            this.toolStripButton_Scan.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageAboveText;
            this.toolStripButton_Scan.Click += new System.EventHandler(this.toolStripButton_Scan_Click);
            // 
            // toolStripButton_InStockTask
            // 
            this.toolStripButton_InStockTask.AutoSize = false;
            this.toolStripButton_InStockTask.Image = global::App.Properties.Resources.down;
            this.toolStripButton_InStockTask.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripButton_InStockTask.Name = "toolStripButton_InStockTask";
            this.toolStripButton_InStockTask.Size = new System.Drawing.Size(60, 50);
            this.toolStripButton_InStockTask.Text = "入库任务";
            this.toolStripButton_InStockTask.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageAboveText;
            this.toolStripButton_InStockTask.Click += new System.EventHandler(this.toolStripButton_InStockTask_Click);
            // 
            // toolStripButton_OutStock
            // 
            this.toolStripButton_OutStock.AutoSize = false;
            this.toolStripButton_OutStock.Image = global::App.Properties.Resources.up;
            this.toolStripButton_OutStock.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripButton_OutStock.Name = "toolStripButton_OutStock";
            this.toolStripButton_OutStock.Size = new System.Drawing.Size(60, 50);
            this.toolStripButton_OutStock.Text = "出库任务";
            this.toolStripButton_OutStock.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageAboveText;
            this.toolStripButton_OutStock.Click += new System.EventHandler(this.toolStripButton_OutStock_Click);
            // 
            // toolStripButton_Inventor
            // 
            this.toolStripButton_Inventor.AutoSize = false;
            this.toolStripButton_Inventor.Image = global::App.Properties.Resources.calculator;
            this.toolStripButton_Inventor.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripButton_Inventor.Name = "toolStripButton_Inventor";
            this.toolStripButton_Inventor.Size = new System.Drawing.Size(60, 50);
            this.toolStripButton_Inventor.Text = "盘点任务";
            this.toolStripButton_Inventor.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageAboveText;
            this.toolStripButton_Inventor.Click += new System.EventHandler(this.toolStripButton_Inventor_Click);
            // 
            // toolStripButton1
            // 
            this.toolStripButton1.AutoSize = false;
            this.toolStripButton1.Image = global::App.Properties.Resources.process;
            this.toolStripButton1.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripButton1.Name = "toolStripButton1";
            this.toolStripButton1.Size = new System.Drawing.Size(60, 50);
            this.toolStripButton1.Text = "任务测试";
            this.toolStripButton1.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageAboveText;
            this.toolStripButton1.Click += new System.EventHandler(this.toolStripButton1_Click);
            // 
            // toolStripButton_CellMonitor
            // 
            this.toolStripButton_CellMonitor.AutoSize = false;
            this.toolStripButton_CellMonitor.Image = global::App.Properties.Resources.monitor;
            this.toolStripButton_CellMonitor.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripButton_CellMonitor.Name = "toolStripButton_CellMonitor";
            this.toolStripButton_CellMonitor.Size = new System.Drawing.Size(70, 50);
            this.toolStripButton_CellMonitor.Text = "货位监控";
            this.toolStripButton_CellMonitor.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageAboveText;
            this.toolStripButton_CellMonitor.Click += new System.EventHandler(this.toolStripButton_CellMonitor_Click);
            // 
            // toolStripButton_StartCrane
            // 
            this.toolStripButton_StartCrane.AutoSize = false;
            this.toolStripButton_StartCrane.Image = global::App.Properties.Resources.process_remove;
            this.toolStripButton_StartCrane.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripButton_StartCrane.Name = "toolStripButton_StartCrane";
            this.toolStripButton_StartCrane.Size = new System.Drawing.Size(70, 50);
            this.toolStripButton_StartCrane.Text = "堆垛机联机";
            this.toolStripButton_StartCrane.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageAboveText;
            this.toolStripButton_StartCrane.Click += new System.EventHandler(this.toolStripButton_StartCrane_Click);
            // 
            // toolStripButton_MoveStock
            // 
            this.toolStripButton_MoveStock.AutoSize = false;
            this.toolStripButton_MoveStock.Image = global::App.Properties.Resources.next;
            this.toolStripButton_MoveStock.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripButton_MoveStock.Name = "toolStripButton_MoveStock";
            this.toolStripButton_MoveStock.Size = new System.Drawing.Size(60, 50);
            this.toolStripButton_MoveStock.Text = "移库任务";
            this.toolStripButton_MoveStock.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageAboveText;
            this.toolStripButton_MoveStock.Click += new System.EventHandler(this.toolStripButton_MoveStock_Click);
            // 
            // toolStripButton_UpERP
            // 
            this.toolStripButton_UpERP.AutoSize = false;
            this.toolStripButton_UpERP.Image = global::App.Properties.Resources.database_accept;
            this.toolStripButton_UpERP.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripButton_UpERP.Name = "toolStripButton_UpERP";
            this.toolStripButton_UpERP.Size = new System.Drawing.Size(60, 50);
            this.toolStripButton_UpERP.Text = "上传ERP";
            this.toolStripButton_UpERP.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageAboveText;
            this.toolStripButton_UpERP.Click += new System.EventHandler(this.toolStripButton_UpERP_Click);
            // 
            // toolStripButton_Close
            // 
            this.toolStripButton_Close.AutoSize = false;
            this.toolStripButton_Close.Image = global::App.Properties.Resources.remove;
            this.toolStripButton_Close.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripButton_Close.Name = "toolStripButton_Close";
            this.toolStripButton_Close.Size = new System.Drawing.Size(60, 50);
            this.toolStripButton_Close.Text = "退出系统";
            this.toolStripButton_Close.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageAboveText;
            this.toolStripButton_Close.Click += new System.EventHandler(this.toolStripButton_Close_Click);
            // 
            // pnlTab
            // 
            this.pnlTab.BackColor = System.Drawing.SystemColors.Menu;
            this.pnlTab.Controls.Add(this.tabForm);
            this.pnlTab.Dock = System.Windows.Forms.DockStyle.Top;
            this.pnlTab.Location = new System.Drawing.Point(0, 77);
            this.pnlTab.Name = "pnlTab";
            this.pnlTab.Size = new System.Drawing.Size(1284, 23);
            this.pnlTab.TabIndex = 14;
            this.pnlTab.Visible = false;
            // 
            // tabForm
            // 
            this.tabForm.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tabForm.Font = new System.Drawing.Font("微软雅黑", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.tabForm.Location = new System.Drawing.Point(0, 0);
            this.tabForm.Name = "tabForm";
            this.tabForm.SelectedIndex = 0;
            this.tabForm.Size = new System.Drawing.Size(1284, 23);
            this.tabForm.TabIndex = 6;
            this.tabForm.SelectedIndexChanged += new System.EventHandler(this.tabForm_SelectedIndexChanged);
            // 
            // Main
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1284, 560);
            this.Controls.Add(this.pnlTab);
            this.Controls.Add(this.toolStrip1);
            this.Controls.Add(this.pnlBottom);
            this.Controls.Add(this.menuStrip1);
            this.IsMdiContainer = true;
            this.MainMenuStrip = this.menuStrip1;
            this.Name = "Main";
            this.Text = "仓储调度监控系统";
            this.WindowState = System.Windows.Forms.FormWindowState.Maximized;
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.Main_FormClosing);
            this.Load += new System.EventHandler(this.Main_Load);
            this.Shown += new System.EventHandler(this.Main_Shown);
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            this.pnlBottom.ResumeLayout(false);
            this.toolStrip1.ResumeLayout(false);
            this.toolStrip1.PerformLayout();
            this.pnlTab.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.ToolStripMenuItem taskToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem inStockToolStripMenuItem;
        private System.Windows.Forms.Panel pnlBottom;
        private System.Windows.Forms.ListView lbLog;
        private System.Windows.Forms.ColumnHeader columnHeader1;
        private System.Windows.Forms.ColumnHeader columnHeader2;
        private System.Windows.Forms.ColumnHeader columnHeader3;
        private System.Windows.Forms.ToolStripMenuItem ToolStripMenuItem_Monitor;
        private System.Windows.Forms.ToolStripMenuItem ToolStripMenuItem_Cell;
        private System.Windows.Forms.ToolStripMenuItem OutStockToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem MoveStockToolStripMenuItem;
        private System.Windows.Forms.ToolStrip toolStrip1;
        private System.Windows.Forms.ToolStripButton toolStripButton_InStockTask;
        private System.Windows.Forms.ToolStripButton toolStripButton_OutStock;
        private System.Windows.Forms.ToolStripButton toolStripButton_MoveStock;
        private System.Windows.Forms.ToolStripButton toolStripButton_Close;
        private System.Windows.Forms.Panel pnlTab;
        private System.Windows.Forms.TabControl tabForm;
        private System.Windows.Forms.ToolStripMenuItem InventortoolStripMenuItem;
        private System.Windows.Forms.ToolStripButton toolStripButton_Inventor;
        private System.Windows.Forms.ToolStripButton toolStripButton1;
        private System.Windows.Forms.ToolStripButton toolStripButton_StartCrane;
        private System.Windows.Forms.ToolStripButton toolStripButton_CellMonitor;
        private System.Windows.Forms.ToolStripMenuItem ToolStripMenuItemSetup;
        private System.Windows.Forms.ToolStripMenuItem ToolStripMenuItem_Param;
        private System.Windows.Forms.ToolStripButton toolStripButton_Scan;
        private System.Windows.Forms.ToolStripButton toolStripButton_UpERP;
        private System.Windows.Forms.ToolStripMenuItem UpERPToolStripMenuItem;
    }
}