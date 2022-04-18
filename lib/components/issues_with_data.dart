import 'package:flutter/material.dart';
import 'package:gsoc_application/classes/fc_info.dart';
import 'package:gsoc_application/classes/github_repo.dart';
import 'package:gsoc_application/pages/repo_issues.dart';
import 'package:intl/intl.dart';

class IssuesWithData extends StatefulWidget {
  const IssuesWithData({ Key? key, required this.fcInfo }) : super(key: key);

  final FCInfo fcInfo;

  @override
  State<IssuesWithData> createState() => _IssuesWithDataState();
}

class _IssuesWithDataState extends State<IssuesWithData> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(physics: const NeverScrollableScrollPhysics(), shrinkWrap: true, itemCount: widget.fcInfo.fcRepos.length, itemBuilder: ((context, index) => RepoCard(githubRepo: widget.fcInfo.fcRepos[index],)));
  }
}


class RepoCard extends StatelessWidget {
  const RepoCard({ Key? key, required this.githubRepo }) : super(key: key);

  final GithubRepo githubRepo;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: ((context) => RepoIssues(repo: githubRepo))));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(githubRepo.name, style: Theme.of(context).textTheme.titleLarge,),
              ),
              subtitle: Text(githubRepo.description, maxLines: 2, overflow: TextOverflow.ellipsis,),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text('${githubRepo.openIssues} Issues • Updated '+DateFormat('LLL dd, yyy').format(githubRepo.lastUpdated ?? DateTime.now()), style: Theme.of(context).textTheme.bodyMedium),
            )
          ]),
        ),
      ),
    );
  }
}