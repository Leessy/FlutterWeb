import 'dart:html' as HTML;

class Constants {
  static final String login = "/devices/login";
  static final String getRecorld = "/devices/getRecorld?page=";
  static final String getUser = "/devices/getUser?page=";
  static final String getFile = "/devices/getFile?file=";
  static final String reboot = "/devices/reboot";
  static final String postUser = "/devices/postUser";
  static final String deletRecorld = "/devices/deletRecorld";
  static final String deletUser = "/devices/deletUser";
  static final String getConfig = "/devices/getConfig";
  static final String setConfig = "/devices/setConfig";

  static String getbaseurl() {
    var url = Uri.parse(HTML.window.location.href);
    if (url.origin.contains("localhost")) {
      return "http://192.168.14.109:8080"; //本地编译环境测试地址
    }
    return url.origin;
  }
}

class ResponesKey {
  static final String MSG = "errorMsg";
  static final String CODE = "errorCode";
  static final String DATA = "data";
  static final String ISSUCCESS = "isSuccess";
}
