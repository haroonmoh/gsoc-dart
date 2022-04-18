import 'package:flutter/material.dart';
import 'package:gsoc_application/classes/fc_info.dart';
import 'package:gsoc_application/classes/fc_user.dart';
import 'package:gsoc_application/components/dashboard_shimmer.dart';
import 'package:gsoc_application/components/dashboard_with_data.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class FlutterCommunityDashboard extends StatefulWidget {
  FlutterCommunityDashboard(
      {Key? key,
      required this.fcInfo, required this.fcAdminUser})
      : super(key: key);

  FCInfo fcInfo;
  final FCAdminUser fcAdminUser;

  @override
  State<FlutterCommunityDashboard> createState() =>
      _FlutterCommunityDashboardState();
}

class _FlutterCommunityDashboardState extends State<FlutterCommunityDashboard> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(children: [
          // Text(widget.fcAdminUser.oAuthToken ?? ""),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Dashboard",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          // Text(widget.fcAdminUser.oAuthToken ?? ""),
          (!widget.fcInfo.loaded)
              ? Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(0.5),
                  highlightColor: Colors.grey.withOpacity(0.3),
                  child: const DashboardShimmer(),
                ) : DashboardWithData(fcInfo: widget.fcInfo),
        ]),
      ),
    );
  }
}
