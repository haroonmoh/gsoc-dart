import 'package:flutter/material.dart';
import 'package:gsoc_application/classes/github_issue.dart';
import 'package:intl/intl.dart';

class DashboardTenIssues extends StatelessWidget {
  const DashboardTenIssues({Key? key, required this.tenIssues, required this.sectionTitle, required this.color, required this.viewMore}) : super(key: key);

  final List tenIssues;
  final String sectionTitle;
  final Color color;
  final Function viewMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(6))
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
            sectionTitle,
            style: const TextStyle(
              fontSize: 17, fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                horizontalMargin: 0,
                columns: const [
                  DataColumn(label: Text('Title')),
                  DataColumn(label: Text('Last Updated')),
                  DataColumn(label: Text('Created')),
                  DataColumn(label: Text('# of Comments')),
                  DataColumn(label: Text('State'))
                ],
                rows: [
                  for(final GithubIssue issue in tenIssues)
                    DataRow(
                      cells: [
                        DataCell(
                          Text(issue.title),
                        ),
                        DataCell(
                          Text(DateFormat('LLL dd, yyy').format(issue.lastUpdated)),
                        ),
                        DataCell(
                          Text(DateFormat('LLL dd, yyy').format(issue.lastUpdated))
                        ),
                        DataCell(
                          Text(issue.comments.toString())
                        ),
                        DataCell(
                          Text(issue.state)
                        )
                      ],
                    )
                ],
              ),
            ),
          ),
          TextButton(onPressed: () {
            viewMore();
          }, child: const Text('View All'))
        ]),
      ),
    );
  }
}
