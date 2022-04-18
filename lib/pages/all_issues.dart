import 'package:flutter/material.dart';
import 'package:gsoc_application/classes/github_issue.dart';
import 'package:gsoc_application/classes/github_repo.dart';
import 'package:gsoc_application/components/issue_card.dart';

class AllIssues extends StatefulWidget {
  const AllIssues({ Key? key, required this.title, required this.allRepos, required this.prolonged }) : super(key: key);

  final String title;
  final List allRepos;
  final bool prolonged;

  @override
  State<AllIssues> createState() => _AllIssuesState();
}

class _AllIssuesState extends State<AllIssues> {
  List allIssues = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getIssues(widget.allRepos, widget.prolonged);
  }

  void _getIssues(allRepos, prolonged) {
    if(!prolonged) {
      for(var i=0; allRepos.length > i; i++) {
        GithubRepo repo = allRepos[i];
        for(var j=0; repo.fcIssues.length > j; j++) {
          GithubIssue issue = repo.fcIssues[j];
          allIssues.add(issue);
        }
      }
    } else {
      for(var i=0; allRepos.length > i; i++) {
        GithubRepo repo = allRepos[i];
        for(var j=0; repo.fcIssues.length > j; j++) {
          GithubIssue issue = repo.fcIssues[j];
          if(issue.over30Days) {
            allIssues.add(issue);
          }
        }
      }
    }

    setState(() {
      allIssues;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(itemCount: allIssues.length, itemBuilder: ((context, index) => IssueCard(issue: allIssues[index], addRepo: true,))),
    );
  }
}