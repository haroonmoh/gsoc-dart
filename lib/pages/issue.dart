// import 'package:flutter/material.dart';
// import 'package:gsoc_application/classes/github_issue.dart';
// import 'package:url_launcher/url_launcher.dart';

// class Issue extends StatelessWidget {
//   const Issue({ Key? key, required this.issue }) : super(key: key);

//   final GithubIssue issue;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(issue.title),
//         actions: [
//           IconButton(onPressed: () async {
//             if (!await launch(issue.htmlUrl)) throw 'Could not launch ${issue.htmlUrl}';
//           }, icon: const Icon(Icons.link))
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Column(children: [
//             const SizedBox(height: 15,),
//             Text(issue.title, style: Theme.of(context).textTheme.titleLarge,),
//             const SizedBox(height: 5,),
//             Text(issue.repo)
//           ]),
//         ),
//       ),
//     );
//   }
// }