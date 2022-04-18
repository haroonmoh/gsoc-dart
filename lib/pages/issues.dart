import 'package:flutter/material.dart';
import 'package:gsoc_application/classes/fc_info.dart';
import 'package:gsoc_application/classes/fc_user.dart';
import 'package:gsoc_application/components/issues_shimmer.dart';
import 'package:gsoc_application/components/issues_with_data.dart';

// ignore: must_be_immutable
class FlutterCommunityIssues extends StatefulWidget {
  FlutterCommunityIssues(
      {Key? key,
      required this.fcInfo, required this.fcAdminUser})
      : super(key: key);

  FCInfo fcInfo;
  final FCAdminUser fcAdminUser;

  @override
  State<FlutterCommunityIssues> createState() => _FlutterCommunityIssuesState();
}

class _FlutterCommunityIssuesState extends State<FlutterCommunityIssues> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Issues",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          (!widget.fcInfo.loaded)
              ? const IssuesWithShimmer()
              : IssuesWithData(
                  fcInfo: widget.fcInfo)
        ]),
      ),
    );
  }
}
