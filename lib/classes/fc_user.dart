import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gsoc_application/classes/main_functions.dart';
import 'package:gsoc_application/pages/githublogin.dart';
import 'package:gsoc_application/values/constants.dart' as constants;
import 'package:gsoc_application/values/secrets.dart' as secrets;
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:uuid/uuid.dart';

class FCAdminUser {
  FCAdminUser(
      {this.uid,
      this.oAuthToken,
      this.githubUsername,
      this.name,
      this.profileImage,
      this.email,
      this.htmlUrl,
      this.expiredToken});

  String? uid;
  String? oAuthToken;
  String? githubUsername;
  String? name;
  String? profileImage;
  String? email;
  String? htmlUrl;
  bool? expiredToken;

  factory FCAdminUser.fromJson(dynamic json) {
    var user = FCAdminUser(
      oAuthToken: json['oAuthToken'],
      githubUsername: json['githubUsername'],
      name: json['name'],
      profileImage: json['profileImage'],
      email: json['email'],
      htmlUrl: json['htmlUrl'],
    );
    return user;
  }

  Future<bool> resumeAuthentication(code, context) async {
    final postResponse = await http.get(
      Uri.parse(constants.herokuGatekeeperUrl+code),
      headers: {"Accept": "application/json"},
    );
    if (postResponse.statusCode == 200) {
      var body = json.decode(utf8.decode(postResponse.bodyBytes));
      if (body["token"] != null || body["token"] == "") {
        oAuthToken = body["token"];
        final githubAuthCredential =
            GithubAuthProvider.credential(oAuthToken ?? "");
        _showToast(context, "Received access token!");
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(githubAuthCredential);
        return await _setFCUser(userCredential, context);
      } else {
        _showToast(context, "Couldn't get the access token");
        return false;
      }
    } else {
      _showToast(context,
          "Unable to obtain token. Received: ${postResponse.statusCode}");
      return false;
    }
  }

  Future<bool> githubSignIn(BuildContext context) async {
    const String url =
        "${constants.githubAuthorizationUrl}?client_id=${secrets.githubClientId}&scope=read:user%20user:email";
    if (kIsWeb) {
      // GithubAuthProvider githubProvider = GithubAuthProvider();
      // UserCredential userCredential = await FirebaseAuth.instance.signInWithPopup(githubProvider);
      // return await _setFCUser(userCredential, context);
      String state = const Uuid().v4();
      bool setState =
          await FCMainFunctions().setSharedPreferences('state', state, 0);
      if (setState) {
        html.window.location.href = url +
            "&redirect_uri=https://fcdashboard-a0ce8.firebaseapp.com/?state=" +
            state;
        return true;
      }
      return false;
    } else {
      // get the webview response which is the access token
      final webViewResponse = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => const GithubLogin(url: url)));

      // check the response
      if (webViewResponse == null ||
          webViewResponse.toString().contains('access_denied')) {
        _showToast(context, 'Authorization not accepted');
        return false;
      } else if (webViewResponse is Exception) {
        _showToast(context, webViewResponse.toString());
        return false;
      }

      // post code to get user info
      String code = webViewResponse;
      final postResponse = await http.post(
        Uri.parse(constants.githubAccessTokenUrl),
        headers: {"Accept": "application/json"},
        body: {
          "client_id": secrets.githubClientId,
          "client_secret": secrets.githubClientSecret,
          "code": code
        },
      );
      if (postResponse.statusCode == 200) {
        var body = json.decode(utf8.decode(postResponse.bodyBytes));
        if (body["access_token"] != null || body["access_token"] == "") {
          oAuthToken = body["access_token"];
          print(oAuthToken);
          final githubAuthCredential =
              GithubAuthProvider.credential(oAuthToken ?? "");
          _showToast(context, "Received access token!");
          UserCredential userCredential = await FirebaseAuth.instance
              .signInWithCredential(githubAuthCredential);
          return await _setFCUser(userCredential, context);
        } else {
          _showToast(context, "Couldn't get the access token");
          return false;
        }
      } else {
        _showToast(context,
            "Unable to obtain token. Received: ${postResponse.statusCode}");
        return false;
      }
    }
  }

  void _showToast(BuildContext context, message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  Future<bool> _setFCUser(
      UserCredential userCredential, BuildContext context) async {
    // verify user is an FC admin
    if (await _accessLevelAuthorization(userCredential, context)) {
      //set values
      name = userCredential.user?.displayName;
      email = userCredential.user?.email;
      uid = userCredential.user?.uid;
      githubUsername = userCredential.additionalUserInfo?.username;
      htmlUrl = userCredential.additionalUserInfo?.profile?['html_url'];
      expiredToken = false;

      return true;
    }
    return false;
  }

  Future<bool> _accessLevelAuthorization(
      UserCredential userCredential, BuildContext context) async {
    // make call to FC repo to check user is admin
    // final response = await http.get(Uri.parse(constants.membershipUrl),
    //     headers: {"Authorization": "token $oAuthToken"});
    // if (response.statusCode == 200) {
    //   // has access
    //   var body = json.decode(utf8.decode(response.bodyBytes));
    //   print(body);
    //   return true;
    // } else if(response.statusCode == 403) {
    //   // does not have access to repo
    //   _showToast(context, 'You do not have access to this organization membership.');
    //   return false;
    // }
    // _showToast(context, 'Received a ${response.statusCode}');
    // return false;
    return true;
  }
}
