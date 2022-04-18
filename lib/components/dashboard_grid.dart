import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gsoc_application/components/grid_item.dart';

class DashboardGrid extends StatelessWidget {
  const DashboardGrid({ Key? key, required this.totalIssues, required this.commitsThisYear, required this.commitsThisWeek, required this.issuesOver30Days }) : super(key: key);

  final int totalIssues;
  final int commitsThisYear;
  final int commitsThisWeek;
  final int issuesOver30Days;

  @override
  Widget build(BuildContext context) {
    if(kIsWeb) {
      return Row(children: [
        FCGridItem(color: Colors.blue, title: "Issues", subtitle: "Total Open Issues", amount: totalIssues,),
        const SizedBox(width: 5,),
        FCGridItem(color: Colors.green, title: "Commits", subtitle: "This Week", amount: commitsThisWeek,),
        const SizedBox(width: 5,),
        FCGridItem(color: Colors.purple, title: "Commits", subtitle: "This Year", amount: commitsThisYear,),
        const SizedBox(width: 5,),
        FCGridItem(color: Colors.red, title: "Issues", subtitle: "Issues Over 30 Days", amount: issuesOver30Days,),
      ],);
    } else {
      return Column(children: [
        Row(children:  [
          FCGridItem(color: Colors.blue, title: "Issues", subtitle: "Total Open Issues", amount: totalIssues,),
          const SizedBox(width: 5,),
          FCGridItem(color: Colors.green, title: "Commits", subtitle: "This Week", amount: commitsThisWeek,),
        ],),
        const SizedBox(height: 5,),
        Row(children: [
          FCGridItem(color: Colors.purple, title: "Commits", subtitle: "This Year", amount: commitsThisYear,),
          const SizedBox(width: 5,),
          FCGridItem(color: Colors.red, title: "Issues", subtitle: "Issues Over 30 Days", amount: issuesOver30Days,),
        ],),
      ],);
    }
  }
}