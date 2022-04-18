import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:gsoc_application/values/constants.dart' as constants;

class GithubLogin extends StatefulWidget {
  const GithubLogin({ Key? key, required this.url }) : super(key: key);

  final String url;

  @override
  State<GithubLogin> createState() => _GithubLoginState();
}

class _GithubLoginState extends State<GithubLogin> {

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login with Github"),
      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        // onWebViewCreated: (WebViewController controller) {
        //   controller.clearCache();
        //   CookieManager manager = CookieManager();
        //   manager.clearCookies();
        // },
        onPageFinished: (url) {
          if (url.contains("error=")) {
            Navigator.of(context).pop(
              Exception(Uri.parse(url).queryParameters["error"]),
            );
          } else if (url.startsWith(constants.redirectUrl)) {
            Navigator.of(context).pop(
                url.replaceFirst("${constants.redirectUrl}?code=", "").trim());
          }
        },
      ),
    );
  }
}