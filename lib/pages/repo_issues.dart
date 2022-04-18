import 'package:flutter/material.dart';
import 'package:gsoc_application/classes/github_repo.dart';
import 'package:gsoc_application/components/issue_card.dart';


class RepoIssues extends StatelessWidget {
  const RepoIssues({ Key? key, required this.repo }) : super(key: key);

  final GithubRepo repo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(repo.name),
      ),
      body: ListView.builder(itemCount: repo.fcIssues.length, itemBuilder: ((context, index) => IssueCard(issue: repo.fcIssues[index], addRepo: false,))),
    );
  }
}