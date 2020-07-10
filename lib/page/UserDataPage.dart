import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:isolate';
import 'package:http/http.dart' as http;
import 'package:web_demo/page/AddUser.dart';
import 'package:web_demo/util/ToastUtil.dart';
import 'package:web_demo/widget/my_taurus_footer.dart';
import 'package:web_demo/widget/my_taurus_header.dart';
import 'dart:html' as HTML;

import '../config/Constants.dart';

class UserDataPage extends StatefulWidget {
  UserDataPage({Key key}) : super(key: key);

  @override
  _UserDataPageState createState() => new _UserDataPageState();
}

class _UserDataPageState extends State<UserDataPage> {
  var page = 0;
  List widgets = [];
  TextEditingController passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: new AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: new Text("用户管理"),
        actions: <Widget>[
          IconButton(
            tooltip: "刷新",
            icon: Icon(Icons.update),
            onPressed: () {
              refresh();
            },
          ),
          IconButton(
            tooltip: "搜索",
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: getBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddUser()),
          ).then((value) => {
                //返回值,新增了用户数据就刷新
                if (value)
                  {refresh()}
              });
        },
        tooltip: '新增用户',
        child: Icon(Icons.add),
      ),
    );
  }

  showLoadingDialog() {
    if (widgets.length == 0) {
      return true;
    }
    return false;
  }

  getBody() {
    if (showLoadingDialog()) {
      return getProgressDialog();
    } else {
      return getGridView();
    }
  }

  //刷新
  refresh() async {
    setState(() {
      page = 0;
      widgets = [];
      loadData();
    });
  }

  //加载更多
  load() async {
    setState(() {
      page++;
      loadData();
    });
  }

  Widget getGridView() {
    return EasyRefresh(
      header: TaurusHeader(),
      footer: TaurusFooter(),
      onRefresh: () {
        refresh();
      },
      onLoad: () {
        load();
      },
      child: GridView.builder(
        itemCount: widgets.length,
        itemBuilder: (BuildContext context, int index) {
          return getItemContainer(widgets[index]);
        },
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            //单个子Widget的水平最大宽度
            maxCrossAxisExtent: 320,
            //水平单个子Widget之间间距
            mainAxisSpacing: 10.0,
            childAspectRatio: 0.8,
            //垂直单个子Widget之间间距
            crossAxisSpacing: 10.0),
      ),
    );
  }

  Widget getItemContainer(Map item) {
    return Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            flex: 11,
            child: InkWell(
              onTap: () {
                showdialogs(item);
              },
              child: Image.network(
                "${Constants.getbaseurl()}${Constants.getFile}${item["TemplateColorUrl"]}",
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Expanded(
              flex: 2,
              child: Center(
                child: Text("${item["name"]}\n${item["id_num"]}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white)),
              ))
        ],
      ),
//      color: Colors.blue,
    );
  }

  getProgressDialog() {
    return new Center(child: new CircularProgressIndicator());
  }

  //显示模板数据更多信息
  showdialogs(dynamic item) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return new SimpleDialog(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.network(
                    "${Constants.getbaseurl()}${Constants.getFile}${item["TemplateColorUrl"]}",
                    fit: BoxFit.cover,
                  ),
                  Text(
                    "姓名：${item["name"]}"
                    "\n证件号码：${item["id_num"]}"
                    "\nIC卡号：${item["ic_num"]}"
                    "\n出生日期：${item["birth_day"]}"
                    "\n地址：${item["address"]}"
                    "\n房间号：${item["roomNumber"]}"
                    "\n有效期类型${item["openDoorcount"]}"
                    "\n授权时间：${item["expiry_date"]} - ${item["expiry_date_start"]}",
                  ),
                ],
              ),
            ),
            SimpleDialogOption(
              child: IconButton(
                tooltip: "删除用户",
                icon: Icon(Icons.close),
              ),
              onPressed: () {
                deleteUsre(item);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((val) {
      print(val);
    });
  }

  deleteUsre(dynamic item) async {
    var url = Constants.getbaseurl() + Constants.deletUser;
    print("请求postUser =" + url);
    try {
      var response = await http.post(url, body: {
        'id': item["id"].toString(),
      });
      var decodedJson = jsonDecode(response.body);
      if (decodedJson[ResponesKey.ISSUCCESS]) {
        ToastUtil.showToast("删除成功");
        removeRefreshList(item); //刷新数据
      } else {
        ToastUtil.showToast("操作失败:${decodedJson[ResponesKey.MSG]}");
      }
    } catch (e) {
      ToastUtil.showToast("操作异常:$e");
    }
  }

  removeRefreshList(dynamic item) {
    setState(() {
      widgets.remove(item);
    });
  }

  loadData() async {
    var url = "${Constants.getbaseurl()}${Constants.getUser}$page";
    print("url:$url");
    try {
      var response = await http.get("$url");
      var decodedJson = jsonDecode(response.body);
      print("jsondata :$decodedJson");
      List<dynamic> ws = decodedJson["data"];
      if (ws.length == 0) {
        page--; //没有获取到数据，page返回
      } else {
        setState(() {
          widgets.addAll(decodedJson["data"]);
        });
      }
    } catch (e) {
      print("http erro :$e");
    }
  }
}
