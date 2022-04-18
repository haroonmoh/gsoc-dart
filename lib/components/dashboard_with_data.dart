import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gsoc_application/classes/fc_info.dart';
import 'package:gsoc_application/components/dashboard_grid.dart';
import 'package:gsoc_application/components/dashboard_ten_issues.dart';
import 'package:gsoc_application/pages/all_issues.dart';

class DashboardWithData extends StatefulWidget {
  const DashboardWithData({ Key? key, required this.fcInfo }) : super(key: key);

  final FCInfo fcInfo;

  @override
  State<DashboardWithData> createState() => _DashboardWithDataState();
}

class _DashboardWithDataState extends State<DashboardWithData> {

  int random = 0;
  List tenProlongedIssues = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      random = Random().nextInt(widget.fcInfo.fcRepos.length - 1);
    });
    _getProlongedIssues();
  }

  void _getProlongedIssues() {
    for(var i=0;i<widget.fcInfo.fcRepos[random].fcIssues.length;i++){
        if(widget.fcInfo.fcRepos[random].fcIssues[i].over30Days) {
          tenProlongedIssues.add(widget.fcInfo.fcRepos[random].fcIssues[i]);
          if(tenProlongedIssues.length >= 10) { break; }
        }
    }
    setState(() {
      tenProlongedIssues;
    });
  }

  void _viewAll() {
    Navigator.push(context, MaterialPageRoute(builder: ((context) => AllIssues(title: "All Issues", allRepos: widget.fcInfo.fcRepos, prolonged: false))));
  }

  void _viewProlonged() {
     Navigator.push(context, MaterialPageRoute(builder: ((context) => AllIssues(title: "All Prolonged Issues", allRepos: widget.fcInfo.fcRepos, prolonged: true))));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DashboardGrid(commitsThisWeek: widget.fcInfo.commitsThisWeek, issuesOver30Days: widget.fcInfo.issuesOver30Days, commitsThisYear: widget.fcInfo.commitsThisYear, totalIssues: widget.fcInfo.totalIssues,),

        const SizedBox(height: 5,),

        // last 10 issues 
        DashboardTenIssues(tenIssues: widget.fcInfo.fcRepos[random].fcIssues.take(10).toList(), sectionTitle: "All Issues", color: Colors.blueGrey.withOpacity(0.2), viewMore: () => _viewAll(),),

        const SizedBox(height: 5,),

        // last 10 inactive issues (>30 days)
        DashboardTenIssues(tenIssues: tenProlongedIssues, sectionTitle: "All Prolonged Issues", color: Colors.blueGrey.withOpacity(0.2), viewMore: () => _viewProlonged()),
      ],
    );
  }
}