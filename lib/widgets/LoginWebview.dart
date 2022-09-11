import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';

LoginCallback() {
  try {
    // 현재 url 가져오기
    String loginAccessUrl = Uri.base.toString();
    String? accessToken = Uri.base.queryParameters['callback#access_token'];
  } catch (error) {
    return ('Could not get login token $error');
  }
}

class LoginWebview extends StatefulWidget {
  final CookieManager? cookieManager;
  String? token;

  LoginWebview({Key? key, this.cookieManager, @required this.token}) : super(key: key);

  @override
  State<LoginWebview> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginWebview> {
  // A way to produce Future objects and to complete them later with a value or error.
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();


  late String? token;

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    final String login_url =
       'https://taxai.auth.ap-northeast-2.amazoncognito.com/login?client_id=165n75nfnnvlphe5vlom6lsu9q&response_type=token&scope=aws.cognito.signin.user.admin&redirect_uri=https://taxai.co.kr/callback';
    return SafeArea(
      child: Scaffold(
        body: WebView(
          initialUrl: login_url,
          userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.63 Safari/537.36',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith('https://taxai.co.kr/')) {
              // .* 모든 문자(\n 제외) 반복
              RegExp regExp = RegExp("callback#access_token=(.*)");
              token = regExp.firstMatch(request.url)?.group(1);
              // blocking navigation to $request
              // setState(() {
              //   showBottomSheet(
              //       context: context,
              //       shape: const RoundedRectangleBorder(
              //           borderRadius:
              //           BorderRadius.vertical(top: Radius.circular(20))),
              //       builder: (BuildContext context) {
              //         return Container(
              //           height: 60,
              //           width: double.maxFinite,
              //           child: Center(child: Text('로그인 되었습니다')),
              //         );
              //       });
              // });
              return NavigationDecision.prevent;
            }
            // allowing navigation to $request'
            return NavigationDecision.navigate;
          },
          // onPageFinished: (String url) {
          //   Navigator.of(context).pop();
          // },
          gestureNavigationEnabled: true,
        ),
      ),
    );
  }
}