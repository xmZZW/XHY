var BaseUrl = "../../Handler/BaseHandler.ashx";

//绑定下拉控件
//data:数据源参数,CtlID:控件ID,FieldID:绑定控件值栏位,FieldName:绑定控制显示栏位
var BindComboList = function ( data, CtlID, FieldID, FieldName) {
    $.ajax({
        type: "post",
        url: BaseUrl,
        data: data,
        //contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (json) {
            $('#' + CtlID).combobox({
                data: json.rows,
                valueField: FieldID,
                textField: FieldName
            });
            if (json.rows.length > 0)
                $('#' + CtlID).combobox('select', eval('json.rows[0].' + FieldID));
        },
        error: function (msg) {
            alert(msg);
        }
    });
};
//判断表中是否存在
//Table:表名,Filter:判断条件,MsgInfo:提示内容,当满足条件且MsgInfo!=''时,提示MsgInfo内容.
var HasExists = function (Table, Filter, MsgInfo) {
    var data = { Action: 'HasExists', Where: Filter, TableName: Table };
    var has = true;
    $.ajax({
        type: "post",
        url: BaseUrl,
        data: data,
        // contentType: "application/json; charset=utf-8",
        dataType: "text",
        async: false,
        success: function (data) {
            if (data == "1") {
                if (MsgInfo != "")
                    alert(MsgInfo);
                has = true;
            }
            else
                has = false;
        },
        error: function (msg) {
            alert(msg);
            has = true;
        }
    });
    return has;
};

 
//根据日期，获取新编号
//ctrlName:单号控件名称， PreName:单号前缀，Filter：过滤条件，TableName：表名，ctrl_dateteime：日期控件
var SetAutoCodeByTableName = function (ctrlName, Pre, where, Table, ctrl_dateteime) {
    var data = { Action: 'AutoCodeByTableName', PreName: Pre, Filter: where, TableName: Table, dtTime: ctrl_dateteime };
    $.ajax({
        type: "post",
        url: BaseUrl,
        data: data,
        //contentType: "application/json; charset=utf-8",
        dataType: "text",
        async: false,
        success: function (data) {
            $('#' + ctrlName).textbox('setValue', data);
        },
        error: function (msg) {
            alert(msg);
        }
    });


};
//获取新编号
//TableName：表名，ColumnName：栏位，Filter：过滤条件
function SetAutoCodeNewID(ctrlName, Table, Column, where) {
    var url = "ProductHandler.ashx"
    var data = { Action: 'AutoCode', Filter: where, TableName: Table, ColumnName: Column };
    $.ajax({
        type: "post",
        url: BaseUrl,
        data: data,
        //contentType: "application/json; charset=utf-8",
        dataType: "text",
        async: false,
        success: function (data) {
            $('#' + ctrlName).textbox('setValue', data);
        },
        error: function (msg) {
            alert(msg);
        }
    });
}

//将jquery系列化后的值转为name:value的形式。
var convertArray = function (o) {
    var v = {};
    for (var i in o) {
        if (o[i].name != '__VIEWSTATE') {
            if (typeof (v[o[i].name]) == 'undefined')
                v[o[i].name] = o[i].value;
            else
                v[o[i].name] += "," + o[i].value;
        }
    }
    return v;
};
//将Json 转成String
var jsonToStr = function (o) {
    var arr = [];
    var fmt = function (s) {
        if (typeof s == 'object' && s != null) return jsonToStr(s);
        var r = "";
        if (/^(string)$/.test(typeof s)) {
            r = '"' + s.replace(/\"/g, ' ') + '"';
        }
        else {
            r = s;
        }
        return r;
        //return /^(string|number)$/.test(typeof s) ? "'" + s + "'" : s;
    }
    for (var i in o) arr.push('"' + i + '":' + fmt(o[i]));
    return '{' + arr.join(',') + '}';
};
//新增时,设置固定栏位(Creator,CreateDate,Updater,UpdateDate)的初始值.
var SetInitValue = function (User) {

    $("#txtCreator").textbox('setValue', User);
    $("#txtCreateDate").textbox('setValue', new Date().Format("yyyy/MM/dd"));
    $("#txtUpdater").textbox('setValue', User);
    $("#txtUpdateDate").textbox('setValue', new Date().Format("yyyy/MM/dd"));
};
//初始设置固定栏位(Creator,CreateDate,Updater,UpdateDate)为只读
var SetInitColor = function () {
    $("input", $("#txtCreator").next("span")).addClass("TextRead");
    $("input", $("#txtCreateDate").next("span")).addClass("TextRead");
    $("input", $("#txtUpdater").next("span")).addClass("TextRead");
    $("input", $("#txtUpdateDate").next("span")).addClass("TextRead");
};

//设置控件只读,
//ctlName 控件名称
var SetTextRead = function (ctlName) {
    $("input", $("#" + ctlName).next("span")).addClass("TextRead");
}

//判断a,b两个Object是否相等
function isObjectValueEqual(a, b) {
    var aProps = Object.getOwnPropertyNames(a);
    var bProps = Object.getOwnPropertyNames(b);

    // If number of properties is different,
    // objects are not equivalent
    if (aProps.length != bProps.length) {
        return false;
    }

    for (var i = 0; i < aProps.length; i++) {
        var propName = aProps[i];

        // If values of same property are not equal,
        // objects are not equivalent
        if (a[propName] !== b[propName]) {
            return false;
        }
    }

    // If we made it this far, objects
    // are considered equivalent
    return true;
}

var SelectWin; 
var ReturnValue = new Array();
var WinName; //弹出框名称

//单多选弹出框显示
//objName: 弹出窗口的DIV名称,title:弹出窗口标题
function SelectWinShow(objName, title) {
    if (SessionTimeOut(SessionUrl)) {
        return false;
    }
    WinName = objName;
    BindSelectUrl(WinName); //绑定单多选数据源.
    ReturnValue = [];
    SelectWin = $('#' + WinName).window({
        modal: true,
        title: title,
        minimizable: false,
        maximizable: false,
        collapsible: false,
        cache: false,
        shadow: false
    });
}
//弹出窗口关闭
function closeSelectWin() {
    SelectWin.window('close');
    for (var i = 0; i < ReturnValue.length; i++) {
        AddRow(WinName, ReturnValue[i]);
    }
    ReturnValue = [];
}
//选中某行
function SelectCheckRow(rowIndex, rowData) {
    var bln = false;
    for (var i = 0; i < ReturnValue.length; i++) {
        if (isObjectValueEqual(ReturnValue[i], rowData)) {
            bln = true;
            break;
        }
    }
    if (!bln)
        ReturnValue.push(rowData);
}
//取消选中
function SelectUnCheckRow(rowIndex, rowData) {
    for (var i = 0; i < ReturnValue.length; i++) {
        if (isObjectValueEqual(ReturnValue[i], rowData)) {
            ReturnValue.splice(ReturnValue.indexOf(ReturnValue[i]), 1);
            break;
        }
    }
}

//单选窗,双击行取回.
function DblClickRow(rowIndex, rowData) {
    ReturnValue = [];
    SelectWin.window('close');
    AddRow(WinName, rowData);
}
//单选窗,选中
function SelectSingleCheckRow(rowIndex, rowData) {
    ReturnValue = [];
    ReturnValue.push(rowData);

}
//单选窗,取消选中.
function SelectSingleUnCheckRow(rowIndex, rowData) {
    ReturnValue = [];
}
//选中所有行
function SelectCheckRowAll(rows) {
    $.each(rows, function (index, rowData) {
        var bln = false;
        for (var i = 0; i < ReturnValue.length; i++) {
            if (isObjectValueEqual(ReturnValue[i], rowData)) {
                bln = true;
                break;
            }
        }
        if (!bln)
            ReturnValue.push(rowData);
    });

}
//所有行取消选中
function SelectUnCheckRowAll(rows) {
    $.each(rows, function (index, rowData) {
        for (var i = 0; i < ReturnValue.length; i++) {
            if (isObjectValueEqual(ReturnValue[i], rowData)) {
                ReturnValue.splice(ReturnValue.indexOf(ReturnValue[i]), 1);
                break;
            }
        }
    });

}
//单多选界面中,Grid数据加载成功后,判断当前内容是否已经有值选中,主要是换页时,使用.
function SelectLoadSelectSuccess(data) {
    if (data) {
        if (ReturnValue.length > 0) {
            $.each(data.rows, function (index, rowData) {
                for (var i = 0; i < ReturnValue.length; i++) {
                    if (isObjectValueEqual(ReturnValue[i], rowData)) {
                        $('#dgSelect').datagrid('checkRow', index);
                        break;
                    }
                }
            });
        }
    }
}




//删除明细,objName:删除明细的控件名称
function DeleteSubDetail(objName) {
    var checkedItems = $('#' + objName).datagrid('getChecked');
    if (checkedItems.length > 0) {  
        var copyRows = [];
        for (var j = 0; j < checkedItems.length; j++) {
            copyRows.push(checkedItems[j]);
        }
        for (var i = 0; i < copyRows.length; i++) {
            var index = $('#' + objName).datagrid('getRowIndex', copyRows[i]);
            $('#' + objName).datagrid('deleteRow', index);
        }
    }
    //更新RowID
    var AddRows = $('#' + objName).datagrid('getRows');
    if (AddRows.length > 0) {
        $.each(AddRows, function (index, item) {
            item.RowID = index + 1;
            $('#' + objName).datagrid('refreshRow', index);
        });
        $('#' + objName).datagrid('acceptChanges');
    }
}

var editIndex = undefined;
// 编辑某行
function endEditing() {

    if (editIndex == undefined) { return true }
    if ($('#dgSubAdd').datagrid('validateRow', editIndex)) {
        $('#dgSubAdd').datagrid('endEdit', editIndex);
        $('#dgSubAdd').datagrid('acceptChanges');
        editIndex = undefined;
        return true;
    } else {
        $.messager.alert('提示', '请先填写完整明细资料!');
        return false;
    }
}

//刷新Grid控件
//objName:Grid控件名称
function ReloadGrid(objName) {
    if (SessionTimeOut(SessionUrl)) {
        return false;
    }
    var queryParams = $('#' + objName).datagrid('options').queryParams;
    getQueryParams(objName, queryParams);
    $('#' + objName).datagrid('options').queryParams = queryParams;
    $("#" + objName).datagrid('reload');
}
//将主表转成JSon格式
function createParam() {

    var query = $("#fm").serializeArray();
    query = convertArray(query);
    return "[" + encodeURIComponent(jsonToStr(query)) + "]";  // JSON.stringify(query);
};

//将明细转成JSon格式
function createSubParam() {
    var json = "";
    var rows = $('#dgSubAdd').datagrid('getRows'); // dgPI.datagrid('getChanges');
    for (var i = 0; i < rows.length; i++) {
        createSubParamRow(rows[i]);
        if (json == "")
            json = jsonToStr(rows[i]);
        else
            json = json + "," + jsonToStr(rows[i]);
    }
    json = "[" + json + "]";

    return encodeURIComponent(json);
}

//operatorcode,0:新增，1:修改，2：删除,3:打印；5：审核，6：作业
function GetPermisionByFormID(formid, operatorcode) {
    var data = { Action: 'GetPermisionByFormID', FormID: formid, OperatorCode: operatorcode };
    var has = true;
    $.ajax({
        type: "post",
        url: BaseUrl,
        data: data,
        // contentType: "application/json; charset=utf-8",
        dataType: "text",
        async: false,
        success: function (data) {
            if (data == "1") {
                has = true;
            }
            else
                has = false;
        },
        error: function (msg) {
            alert(msg);
            has = false;
        }
    });
    return has;

}
//判断Session是否过期,如果过期则跳转到登陆界面,Url:登陆界面连接
function SessionTimeOut(Url) {
    var data = { Action: 'SessionTimeOut' };
    var has = false;
    $.ajax({
        type: "post",
        url: BaseUrl,
        data: data,
        // contentType: "application/json; charset=utf-8",
        dataType: "text",
        async: false,
        success: function (data) {
            if (data == "1") {
                has = true;
            }
            else
                has = false;
        },
        error: function (msg) {
            alert(msg);
            has = false;
        }
    });
    if (has) {

        alert('对不起,操作时限已过,请重新登入！');
        window.top.location = Url; 
        return true;
        
    }

}
//栏位排序前判断是否过期
function BeforeSortColumn(sort, order) {
    if (SessionTimeOut(SessionUrl)) {
        return false;
    }
}

//勾选当前行时,当前行也选中
function CheckSelectRow(objname, rowIndex, rowData) {
    $('#' + objname).datagrid('unselectAll');
    $('#' + objname).datagrid('selectRow', rowIndex);
}

//Tab退出
function Exit() {
    window.parent.removetab();
    return false;
}



//            $.getJSON(url,data, function (json) {
//                $('#ddlCategoryCode').combobox({
//                    data: json.rows,
//                    valueField: 'CategoryCode',
//                    textField: 'CategoryName',
//                    required: 'true'
//                });
//            });

//            $.post(url, data, function (result) {
//                $('#ddlCategoryCode').combobox({
//                    data: result.rows,
//                    valueField: 'CategoryCode',
//                    textField: 'CategoryName',
//                    required: 'true'
//                });
//                if (result.rows.length > 0)
//                    $('#ddlCategoryCode').combobox('select', result.rows[0].CategoryCode);
//            }, 'json');



Date.prototype.Format = function (formatStr) {
    var str = formatStr;
    var Week = ['日', '一', '二', '三', '四', '五', '六'];

    str = str.replace(/yyyy|YYYY/, this.getFullYear());
    str = str.replace(/yy|YY/, (this.getYear() % 100) > 9 ? (this.getYear() % 100).toString() : '0' + (this.getYear() % 100));

    str = str.replace(/MM/, (this.getMonth() + 1) > 9 ? (this.getMonth() + 1).toString() : '0' + (this.getMonth() + 1));
    str = str.replace(/M/g, this.getMonth());

    str = str.replace(/w|W/g, Week[this.getDay()]);

    str = str.replace(/dd|DD/, this.getDate() > 9 ? this.getDate().toString() : '0' + this.getDate());
    str = str.replace(/d|D/g, this.getDate());

    str = str.replace(/hh|HH/, this.getHours() > 9 ? this.getHours().toString() : '0' + this.getHours());
    str = str.replace(/h|H/g, this.getHours());
    str = str.replace(/mm/, this.getMinutes() > 9 ? this.getMinutes().toString() : '0' + this.getMinutes());
    str = str.replace(/m/g, this.getMinutes());

    str = str.replace(/ss|SS/, this.getSeconds() > 9 ? this.getSeconds().toString() : '0' + this.getSeconds());
    str = str.replace(/s|S/g, this.getSeconds());

    return str;
}

$.fn.setCursorPosition = function (position) {
    if (this.lengh == 0)
        return this;
    return $(this).setSelection(position, position);
};

$.fn.setSelection = function (selectionStart, selectionEnd) {
    if (this.lengh == 0)
        return this;
    input = this[0];
    
    if (input.createTextRange) {
        var range = input.createTextRange();
        range.collapse(true);
        range.moveEnd('character', selectionEnd);
        range.moveStart('character', selectionStart);
        range.select();
    } else if (input.setSelectionRange) {
        input.focus();
       
        input.setSelectionRange(selectionStart, selectionEnd);
    }
    input.select();
    return this;
};

$.fn.focusEnd = function () {
    
    this.setCursorPosition(this.val().length);
};