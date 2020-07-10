import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_demo/page/Home.dart';
import 'package:web_demo/page/RecordDataPage.dart';
import 'package:web_demo/page/SettingsPage.dart';
import 'package:web_demo/page/UserDataPage.dart';
import 'package:web_demo/util/ToastUtil.dart';

import 'config/Constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '智能门禁',
      initialRoute: '/',
      routes: {
        //        //浏览器page 正式环境可不让单独进入
//        '/RecordDataPage': (context) => RecordDataPage(),//调试需要找个地址，否则一直返回到登录页
//        '/SettingsPage': (context) => SettingsPage(),
//        '/UserDataPage': (context) => UserDataPage(),
//        '/Home': (context) => HomePage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: '智能门禁系统'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //密码的控制器
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
//      appBar: AppBar(
//        // Here we take the value from the MyHomePage object that was created by
//        // the App.build method, and use it to set our appbar title.
//        title: Text(widget.title),
//      ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text(
                        '智能门禁系统',
                        style: TextStyle(color: Colors.white, fontSize: 45),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: 300,
                            height: 100,
                            child: TextField(
                              onSubmitted: (v) {
                                if (v.length > 0) {
                                  login();
                                }
                              },
                              controller: passController,
                              obscureText: true,
                              decoration: InputDecoration(
                                fillColor: Colors.green,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(28), //边角为30
                                  ),
                                  borderSide: BorderSide(
                                    style: BorderStyle.solid,
                                    color: Colors.green, //边线颜色为黄色
                                    width: 3, //边线宽度为2
                                  ),
                                ),
                                labelText: '输入设备密码',
                                alignLabelWithHint: true,
                                //设置输入框前面有一个电话的按钮 suffixIcon
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.green,
                                ),
                                labelStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              width: 250,
                              height: 50,
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                color: Colors.blue,
                                textColor: Colors.white,
                                child: Text(
                                  '登录',
                                  style: TextStyle(
                                      color: Colors.amber, fontSize: 14),
                                ),
                                onPressed: () {
                                  login();
                                },
                              )),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  void login() async {
    var password = passController.text.toString();
    print({'输入 password:': password});
    if (password.length <= 0) {
      ToastUtil.showToast("输入设备密码");
    } else {
      var url = Constants.getbaseurl() + Constants.login;
      print("请求地址：" + url);
      try {
        var response = await http.post(url, body: {
          'password': password,
        });
        var decodedJson = jsonDecode(response.body);
        if (decodedJson[ResponesKey.ISSUCCESS]) {
          passController.clear(); //登录成功 清空密码
          //跳转并关闭当前页面
          Navigator.pushAndRemoveUntil(
            context,
            new MaterialPageRoute(builder: (context) => new HomePage()),
            (route) => route == null,
          );
//          Navigator.pushNamed(context, "/Home");

//          Navigator.pushReplacement(context,
//              new MaterialPageRoute(builder: (context) => new HomePage()));
        } else {
          ToastUtil.showToast(decodedJson[ResponesKey.MSG]);
        }
      } catch (e) {
        ToastUtil.showToast("登录失败\n" + e.toString());
      }
    }
  }
}
