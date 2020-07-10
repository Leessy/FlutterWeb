import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_demo/page/SettingsPage.dart';
import 'package:web_demo/page/UserDataPage.dart';

import 'RecordDataPage.dart';

class HomePage extends StatefulWidget {
//  HomePage({Key key, this.title}) : super(key: key);
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
//      appBar: AppBar(
//        title: Text(widget.title),
//      ),
      body: Padding(
          padding: EdgeInsets.all(35),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  '智能门禁系统',
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
              ),
              Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: 250,
                          child: AspectRatio(
                              aspectRatio: 1,
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                color: Colors.green,
                                textColor: Colors.white,
                                child: Text(
                                  '用户管理',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserDataPage()),
                                  );
                                },
                              )),
                        )
                      ],
                    )),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: 250,
                          child: AspectRatio(
                              aspectRatio: 1,
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                color: Colors.amber,
                                textColor: Colors.white,
                                child: Text(
                                  '记录管理',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RecordDataPage()),
                                  );
                                },
                              )),
                        )
                      ],
                    )),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: 250,
                          child: AspectRatio(
                              aspectRatio: 1,
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                color: Colors.blue,
                                textColor: Colors.white,
                                child: Text(
                                  '系统设置',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SettingsPage()),
                                  );
                                },
                              )),
                        )
                      ],
                    )),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(""),
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.popAndPushNamed(context, "/"); //返回到登录页
//          Navigator.pushAndRemoveUntil(
//            context,
//            new MaterialPageRoute(builder: (context) => new MyHomePage()),
//            (route) => route == null,
//          );
        },
        tooltip: '退出登录',
        child: Icon(Icons.close),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
