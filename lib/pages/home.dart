import 'package:flutter/material.dart';
import 'package:gsoc_application/classes/fc_info.dart';
import 'package:gsoc_application/classes/fc_user.dart';
import 'package:gsoc_application/classes/main_functions.dart';
import 'package:gsoc_application/pages/calendar.dart';
import 'package:gsoc_application/pages/dashboard.dart';
import 'package:gsoc_application/pages/issues.dart';

class FlutterCommunityHome extends StatefulWidget {
  const FlutterCommunityHome({ Key? key, required this.fcAdminUser, required this.selectedPage }) : super(key: key);

  final FCAdminUser fcAdminUser;
  final int selectedPage;

  @override
  State<FlutterCommunityHome> createState() => _FlutterCommunityHomeState();
}

class _FlutterCommunityHomeState extends State<FlutterCommunityHome> {

  FCMainFunctions fcMainFunctions = FCMainFunctions();
  FCInfo fcInfo = FCInfo(fcRepos: [], loaded: false);

  @override
  void initState() {
    super.initState();
    // get info from github
    _loadInfo();
  }

  void _loadInfo() async {
    fcInfo = await fcMainFunctions.loadFCInfo(context, widget.fcAdminUser.oAuthToken ?? "");
    setState(() {
      fcInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.selectedPage == 0) {
      return FlutterCommunityDashboard(fcInfo: fcInfo, fcAdminUser: widget.fcAdminUser);
    } else if (widget.selectedPage == 1) {
      return FlutterCommunityIssues(fcInfo: fcInfo, fcAdminUser: widget.fcAdminUser);
    } else {
      return FlutterCommunityCalendar(fcInfo: fcInfo, fcAdminUser: widget.fcAdminUser);
    }
  }
}