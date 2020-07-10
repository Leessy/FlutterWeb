import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:web_demo/config/Constants.dart';
import 'package:web_demo/util/ToastUtil.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPage createState() => new _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  Map configs = {};

  @override
  void initState() {
    super.initState();
    loadData();
  }

  //get设置参数
  loadData() async {
    var url = Constants.getbaseurl() + Constants.getConfig;
    print("请求地址：" + url);
    try {
      var response = await http.get(url);
      print("请求数据 body ：" + response.body);
      Map decodedJson = jsonDecode(response.body);
      Map m = decodedJson["data"];
      if (decodedJson[ResponesKey.ISSUCCESS]) {
        setState(() {
          configs = m;
          controller.text = configs["AiFaceReduced"].toString();
        });
      } else {
        ToastUtil.showToast(decodedJson[ResponesKey.MSG]);
      }
    } catch (e) {
      print("请求异常：" + e);
      ToastUtil.showToast("获取配置异常\n" + e.toString());
    }
  }

  savaConfig() async {
    var url = Constants.getbaseurl() + Constants.setConfig;
    print("请求地址：" + url);
    try {
      var response = await http.post(url, body: {
        'data': configs.toString(),
      });
      var decodedJson = jsonDecode(response.body);
      if (decodedJson[ResponesKey.ISSUCCESS]) {
        ToastUtil.showToast("保存成功");
      } else {
        ToastUtil.showToast(decodedJson[ResponesKey.MSG]);
      }
    } catch (e) {
      ToastUtil.showToast("操作异常\n" + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: new AppBar(
          backgroundColor: Colors.blueGrey,
          centerTitle: true,
          title: new Text("系统设置"),
        ),
//        floatingActionButton: FloatingActionButton(
//          onPressed: () {
//            savaConfig();
//          },
//          tooltip: '保存配置',
//          child: Icon(Icons.subdirectory_arrow_left),
//        ),
        body: getBody());
  }

  getProgressDialog() {
    return new Center(child: new CircularProgressIndicator());
  }

  getBody() {
    if (configs.isEmpty) {
      return getProgressDialog();
    } else {
      return getSettingsView();
    }
  }

  getConfigList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        generaSwitch("访客模式", "aiface_visitor_mode"),
        generaSwitch("活体检测", "livingsFun"),
        generaSwitch("红外镜头活体", "livingsFunIr"),
        generaSwitch("拆除报警开关", "lemolitionAlarm"),
        generaSwitch("待机熄屏", "isScreenOn"),
        generaSwitch("人体感应触发识别", "isinduction"),
        generaSwitch("tts语音提示开关", "tts"),
        generaSwitch("闲时重启", "terminalReboot"),
        generaSwitch("记录场景图剪裁", "recordImgClip"),
        generaSwitch("刷卡进行1:1对比", "aiface_11_switch"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              width: 250,
              child: Text("人脸校验值(75-100)",
                  style: TextStyle(fontSize: 14, color: Colors.white)),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: SizedBox(
                width: 70,
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (t) {
                    configs["AiFaceReduced"] = t;
                  },
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  controller: controller,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: MaterialButton(
            color: Colors.blue,
            textColor: Colors.white,
            child: new Text('立即重启设备',
                style: TextStyle(fontSize: 14, color: Colors.white)),
            onPressed: () {
//              reboot();
              showdialogs();
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: MaterialButton(
            color: Colors.blue,
            textColor: Colors.white,
            child: new Text('保存设置',
                style: TextStyle(fontSize: 14, color: Colors.white)),
            onPressed: () {
              savaConfig();
            },
          ),
        )
      ],
    );
  }

  var controller = new TextEditingController();

//生成设置条
  generaSwitch(String name, String key) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(
          width: 250,
          child:
              Text(name, style: TextStyle(fontSize: 14, color: Colors.white)),
        ),
        Switch(
            value: configs[key],
            activeColor: Colors.deepOrange, // 激活时原点颜色
            onChanged: (v) {
              setState(() {
                configs[key] = v;
              });
            })
      ],
    );
  }

  Widget getSettingsView() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[getConfigList()],
          ),
          Column(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
//            generaEditText(controName, "姓名", Icons.person),
//            generaEditText(controIDnum, "身份证号码", Icons.credit_card),
//            generaEditText(controICnum, "IC卡号", Icons.style),
//            generaEditText(controRoom, "房间", Icons.home),
            ],
          ),
        ],
      );

  reboot() async {
    var url = "${Constants.getbaseurl()}${Constants.reboot}";
    print("url:$url");
    try {
      var response = await http.get(url);
      var decodedJson = jsonDecode(response.body);
      print("jsondata :$decodedJson");
      print(decodedJson);
      if (decodedJson[ResponesKey.ISSUCCESS]) {
        ToastUtil.showToast("操作成功");
        Navigator.popAndPushNamed(context, "/"); //返回到登录页
      } else {
        ToastUtil.showToast("操作失败 code:${decodedJson[ResponesKey.CODE]}");
      }
    } catch (e) {
      ToastUtil.showToast("操作失败${e.toString()}");
    }
  }

  //显示模板数据更多信息
  showdialogs() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return new SimpleDialog(
          title: Text("提示"),
          children: <Widget>[
            SizedBox(
              height: 200,
              width: 200,
              child: Center(
                child: Text("设备将关机重启，确定立即重启设备？"),
              ),
            ),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('重启',
                  style: TextStyle(fontSize: 14, color: Colors.white)),
              onPressed: () {
                reboot();
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
}
