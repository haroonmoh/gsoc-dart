import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gsoc_application/classes/fc_user.dart';
import 'package:gsoc_application/classes/main_functions.dart';
import 'package:gsoc_application/pages/home.dart';
import 'package:gsoc_application/pages/login.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({ Key? key, this.code }) : super(key: key);

  final String? code;

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool _authenticated = false;
  FCMainFunctions fcMainFunctions = FCMainFunctions();
  FCAdminUser? fcAdminUser;
  int _selectedPage = 0;

  @override
  void initState() {
    super.initState();
    // check shared preferences
    _checkAuthenticatedStatus();
    // remove splash screen
    FlutterNativeSplash.remove();
  }

  void _checkAuthenticatedStatus() async {
    if(widget.code != null) {
      final FCAdminUser currentUser = FCAdminUser();
      bool authStatus = await currentUser.resumeAuthentication(widget.code, context);
      if(authStatus) {
        setState(() {
          _authenticated = authStatus;
          fcAdminUser = currentUser;
        });
      }
    } else {
      bool authStatus = await fcMainFunctions.getSharedPreferences('authenticated', 2) ?? false;
      String? fcUserJson = await fcMainFunctions.getSharedPreferences('FCUser', 0);
      if(authStatus) {
        setState(() {
          fcAdminUser = FCAdminUser.fromJson(fcUserJson);
          _authenticated = authStatus;
        });
      }
    }
  }

  void _bottomBarTap(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _authenticated ? AppBar(title: const Text("FC Dashboard"),) : null,
      body: _authenticated ? FlutterCommunityHome(fcAdminUser: fcAdminUser!, selectedPage: _selectedPage) : FlutterCommunityLogin(loginCallback: (bool authStatus, FCAdminUser currentUser) {
        setState(() {
          _authenticated = authStatus;
          fcAdminUser = currentUser;
        });
      },),
      bottomNavigationBar: _authenticated ? BottomNavigationBar(items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'Issues'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Calendar')
      ], onTap: _bottomBarTap, currentIndex: _selectedPage,) : null,
    );
  }
}