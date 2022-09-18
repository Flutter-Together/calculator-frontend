import 'dart:async';

import 'package:calculator_frontend/main.dart';
import 'package:calculator_frontend/widgets/HomePage/Desktop_HomePage.dart';
import 'package:calculator_frontend/widgets/HomePage/Tablet_HomePage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginWebView extends StatefulWidget {
  final String? token;
  const LoginWebView({Key? key, @required this.token}) : super(key: key);

  @override
  State<LoginWebView> createState() => _LoginWebViewState();
}

class _LoginWebViewState extends State<LoginWebView> {
  // late String? token;
  // late Uri? callback_url;
  // StreamSubscription? streamSubscription;
  //
  // launchLoginUrl() async {
  //   final Uri login_url = Uri.parse(
  //       'https://taxai.auth.ap-northeast-2.amazoncognito.com/login?client_id=165n75nfnnvlphe5vlom6lsu9q&response_type=token&scope=aws.cognito.signin.user.admin&redirect_uri=https://taxai.co.kr/callback');
  //   // 해당 url이 실행가능한지 확인
  //   if (!await canLaunchUrl(login_url)) {
  //     throw 'Could not launch $login_url';
  //   } else {
  //     // webOnlyWindowName : '_blank' => URL is loaded into a new window, or tab. This is the default
  //     // webOnlyWindowName: '_self' => URL replaces the current page
  //     // webOnlyWindowName: '_parent' => URL is loaded into the parent frame
  //     // _top	URL replaces any framesets that may be loaded
  //     // name	The name of the window (does not specify the title of the window)
  //     launchUrl(login_url,
  //         mode: LaunchMode.platformDefault, webOnlyWindowName: '_self');
  //     streamSubscription = uriLinkStream.listen((Uri? uri) {
  //       // mounted : initState를 호출하기 전 State를 BuildContext와 연결하여 State를 mount함
  //       // mounted가 false인 경우, setState를 호출하는 것은 error
  //       if (!mounted) return;
  //       setState(() {
  //         callback_url = uri;
  //       });
  //     });
  //   }
  //
  //   // https://api.flutter.dev/flutter/dart-core/Uri-class.html
  //   // final uri = Uri.parse(
  //   //     'https://dart.dev/guides/libraries/library-tour#utility-classes');
  //   // print(uri); // https://dart.dev
  //   // print(uri.isScheme('https')); // true
  //   // print(uri.origin); // https://dart.dev
  //   // print(uri.host); // dart.dev
  //   // print(uri.authority); // dart.dev
  //   // print(uri.port); // 443
  //   // print(uri.path); // guides/libraries/library-tour
  //   // print(uri.pathSegments); // [guides, libraries, library-tour]
  //   // print(uri.fragment); // utility-classes
  //   // print(uri.hasQuery); // false
  //   // print(uri.data); // null
  //
  //   var current_url = Uri.base.path;
  //   // import 'dart:html' as html;
  //   // html.window.location.href
  //
  //   if (current_url.contains('callback')) {
  //     // .* 모든 문자(\n 제외) 반복
  //     RegExp regExp = RegExp("access_token=(.*)");
  //     token = regExp.firstMatch(Uri.base.fragment)?.group(1).toString();
  //     MaterialPageRoute(
  //         builder: (context) => MyHomePage(
  //             TabletHomepage: TabletHomepage(),
  //             DesktopHomepage: DesktopHomepage()));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(widget.token == null ? "token is null" : "token = " + widget.token.toString())
            ],)
      ),
    );
  }
}
