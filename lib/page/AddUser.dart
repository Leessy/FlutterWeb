import 'dart:convert';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:web_demo/config/Constants.dart';
import 'dart:html' as html;

import 'package:web_demo/util/ToastUtil.dart';

class AddUser extends StatefulWidget {
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  var imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            uploadData();
          },
          tooltip: '确定保存',
          child: Icon(Icons.cloud_upload),
        ),
        appBar: new AppBar(
          backgroundColor: Colors.blueGrey,
          centerTitle: true,
          title: new Text("新增用户"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.update),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                print('search');
              },
            ),
          ],
        ),
        body: getBody());
  }

  _selectFile() async {
    html.InputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = false;
    uploadInput.click();
    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      FileReader fr = FileReader();
      fr.readAsArrayBuffer(files[0]);
      fr.onLoadEnd.listen((event) {
        print("file 读取完成" + event.toString());
        print("file 读取完成" + event.type);
        print("file 读取完成" + event.path.toString());
        print("loaded: ${files[0].name}");
        print("runtimeType: ${fr.result.runtimeType}");
//        print("result: ${fr.result}");
        setState(() {
          imageFile = fr.result;
        });
      });
    });
  }

  Widget getFileImage() {
    if (imageFile == null) {
      return SizedBox(
        height: 400,
        width: 300,
        child: Image.asset("images/userbg.png"),
      );
    } else {
      return SizedBox(height: 400, width: 300, child: Image.memory(imageFile));
    }
  }

  Widget picker() => InkWell(
        hoverColor: Colors.blue[50],
        splashColor: Colors.blue[10],
        onTap: _selectFile,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.deepOrange),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          child: Text(
            '选择人脸图片',
            style: TextStyle(
                fontWeight: FontWeight.w900, fontSize: 14, color: Colors.white),
          ),
        ),
      );

  getBody() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 50, 0, 50),
                child: picker(),
              ),
              getFileImage(),
            ],
          ),
          Column(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              generaEditText(controName, "姓名", Icons.person),
              generaEditText(controIDnum, "证件号码", Icons.credit_card),
              generaEditText(controICnum, "IC卡号", Icons.style),
              generaEditText(controRoom, "房间", Icons.home),
            ],
          ),
        ],
      );

  var controName = TextEditingController();
  var controIDnum = TextEditingController();
  var controICnum = TextEditingController();
  var controRoom = TextEditingController();

  uploadData() async {
    var name = controName.text.toString();
    var idnum = controIDnum.text.toString();
    var icnum = controICnum.text.toString();
    var room = controRoom.text.toString();
    if (name.isEmpty || idnum.isEmpty) {
      ToastUtil.showToast("请输入姓名和证件号码");
      return;
    }
//    if (idnum.length != 18) {
//      ToastUtil.showToast("请输正确身份证号码");
//      return;
//    }
    if (imageFile == null) {
      ToastUtil.showToast("请选择人脸图");
      return;
    }
    var url = Constants.getbaseurl() + Constants.postUser;
    print("请求postUser =" + url);
    try {
      MultipartRequest request = http.MultipartRequest('POST', Uri.parse(url))
        ..fields['name'] = name
        ..fields['idnum'] = idnum
        ..fields['icnum'] = icnum
        ..fields['room'] = room
        ..files.add(await http.MultipartFile.fromBytes('image', imageFile,
            filename: "image",
            contentType: MediaType("file/*", "charset=UTF-8")));

      http.StreamedResponse response = await request.send();
      var body = await response.stream.bytesToString();
      var decodedJson = jsonDecode(body);
      if (decodedJson[ResponesKey.ISSUCCESS]) {
        ToastUtil.showToast('操作成功');
        Navigator.pop(context, true);
      } else {
        ToastUtil.showToast('操作失败：' + decodedJson[ResponesKey.MSG]);
      }
    } catch (e) {
      ToastUtil.showToast('操作异常：' + e);
      print("请求结果 错误：" + e);
    }
  }

  Widget generaEditText(
      TextEditingController controller, String labelText, IconData icon) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: SizedBox(
        width: 350,
        child: TextField(
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          controller: controller,
          decoration: InputDecoration(
            fillColor: Colors.white,
            labelText: labelText,
            labelStyle: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
            //设置输入框前面有一个电话的按钮 suffixIcon
            prefixIcon: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
