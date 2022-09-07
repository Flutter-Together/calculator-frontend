import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

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
  const LoginWebview({Key? key}) : super(key: key);

  @override
  State<LoginWebview> createState() => _LoginWebviewState();
}

class _LoginWebviewState extends State<LoginWebview> {
  final webviewPlugin = FlutterWebviewPlugin();

  late StreamSubscription<String> _onUrlChanged;
  late StreamSubscription<WebViewStateChanged> _onStateChanged;
  late String? token;

  _launchUrl() async {
    final String login_url =
        'https://taxai.auth.ap-northeast-2.amazoncognito.com/login?client_id=165n75nfnnvlphe5vlom6lsu9q&response_type=token&scope=aws.cognito.signin.user.admin&redirect_uri=https://taxai.co.kr/callback';
    webviewPlugin.launch(login_url);
  }

  @override
  void initState() {
    super.initState();
    webviewPlugin.close();
    _onUrlChanged = webviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          if (url.startsWith('https://taxai.co.kr/')) {
            // .* 모든 문자(\n 제외) 반복
            RegExp regExp = RegExp("callback#access_token=(.*)");
            token = regExp.firstMatch(url)?.group(1);
            webviewPlugin.close();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    webviewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
