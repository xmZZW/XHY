using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using MCP.Config;
using Util;


namespace App.View.Param
{
    public partial class ParameterForm : View.BaseForm
    {
        private App.View.Param.Parameter parameter = new App.View.Param.Parameter();
        //private DBConfig config = new DBConfig();


        MCP.Service.TCP.Config.Configuration TcpConfg = new MCP.Service.TCP.Config.Configuration("Crane.xml");

        MCP.Service.Siemens.Config.Configuration PLC1 = new MCP.Service.Siemens.Config.Configuration("CranePLC1.xml");
       
        private Dictionary<string, string> attributes = null;

        public ParameterForm()
        {
            InitializeComponent();
            ReadParameter();
        }

        private void ReadParameter()
        {
            //�������ݿ����Ӳ���
            //parameter.ServerName = config.Parameters["server"].ToString();
            //parameter.DBUser = config.Parameters["uid"].ToString();
            //parameter.Password = config.Parameters["pwd"].ToString();


            //ɨ��ǹ--����ʹ��USB�ӿڣ�������
            //ConfigUtil configUtil = new ConfigUtil();
            //attributes = configUtil.GetAttribute();          

            //PLC1
            parameter.PLC1ServerName = PLC1.ProgID;
            parameter.PLC1ServerIP = PLC1.ServerName;
            parameter.PLC1GroupString = PLC1.GroupString;
            parameter.PLC1UpdateRate = PLC1.UpdateRate;
            
           
            propertyGrid.SelectedObject = parameter;
        }

        private void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                //���汾�����ݿ����Ӳ���
                //config.Parameters["server"] = parameter.ServerName;
                //config.Parameters["uid"] = parameter.DBUser;
                //config.Parameters["pwd"] = parameter.Password;
                //config.Save();


                //����ɨ��ǹʹ��USB�ӿڣ������Ρ�
                ////����Context����
                //attributes["ScanPortName"] = parameter.ScanPortName;
                //attributes["ScanBaudRate"] = parameter.ScanBaudRate;

                //attributes["IsOutOrder"] = parameter.IsOutOrder;
                //attributes["MesWebServiceUrl"] = parameter.MesWebServiceUrl;
                //ConfigUtil configUtil = new ConfigUtil();
                //configUtil.Save(attributes);

                //PLC1
                PLC1.GroupString = parameter.PLC1GroupString;
                PLC1.ProgID = parameter.PLC1ServerName;
                PLC1.UpdateRate = parameter.PLC1UpdateRate;
                PLC1.ServerName = parameter.PLC1ServerIP;
                PLC1.Save();
                 

                MessageBox.Show("ϵͳ��������ɹ���������������ϵͳ��", "��ʾ", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            catch (Exception exp)
            {
                MessageBox.Show("����ϵͳ���������г����쳣��ԭ��" + exp.Message, "����", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnExit_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}

