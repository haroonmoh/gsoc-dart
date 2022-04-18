import 'package:flutter/material.dart';
import 'package:gsoc_application/classes/github_issue.dart';
// import 'package:gsoc_application/pages/issue.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class IssueCard extends StatelessWidget {
  const IssueCard({ Key? key, required this.issue, required this.addRepo }) : super(key: key);

  final GithubIssue issue;
  final bool addRepo;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // Navigator.push(context, MaterialPageRoute(builder: (context) => Issue(issue: issue)));
        if (!await launch(issue.htmlUrl)) throw 'Could not launch ${issue.htmlUrl}';
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(issue.title, maxLines: 1, overflow: TextOverflow.ellipsis,),
              subtitle: Text("Updated "+DateFormat('LLL dd, yyy').format(issue.lastUpdated)),
            ),
            if(addRepo)
              Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 15),
                child: Text('Repo: ${issue.repo}'),
              )
          ],
        ),
      ),
    );
  }
}