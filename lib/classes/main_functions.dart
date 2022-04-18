import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gsoc_application/classes/fc_info.dart';
import 'package:gsoc_application/classes/github_issue.dart';
import 'package:gsoc_application/classes/github_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:gsoc_application/values/constants.dart' as constants;

class FCMainFunctions {
  Future<dynamic> getSharedPreferences(String name, int type) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    dynamic value = await _prefs.then((SharedPreferences prefs) {
      if (type == 0) {
        return prefs.getString(name);
      } else if (type == 1) {
        return prefs.getInt(name);
      } else if (type == 2) {
        return prefs.getBool(name);
      } else if (type == 3) {
        return prefs.getDouble(name);
      } else if (type == 4) {
        return prefs.getStringList(name);
      }
    });
    return value;
  }

  Future<bool> setSharedPreferences(
      String name, dynamic value, int type) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    bool set = await _prefs.then((SharedPreferences prefs) {
      if (type == 0) {
        prefs.setString(name, value);
        return true;
      } else if (type == 1) {
        prefs.setInt(name, value);
        return true;
      } else if (type == 2) {
        prefs.setBool(name, value);
        return true;
      } else if (type == 3) {
        prefs.setDouble(name, value);
        return true;
      } else if (type == 4) {
        prefs.setStringList(name, value);
        return true;
      }
      return false;
    });
    return set;
  }

  Future<List> _getRepos(BuildContext context, String oAuthToken) async {
    List allRepos = [];
    int totalIssues = 0;
    final response = await http.get(Uri.parse(constants.getReposUrl),
        headers: {"Accept": "application/json", "Authorization": "token $oAuthToken"});
    print(response.statusCode);
    if (response.statusCode == 200) {
      final repos = json.decode(utf8.decode(response.bodyBytes));
      for (final repo in repos) {
        totalIssues += repo['open_issues_count'] as int;
        allRepos.add(GithubRepo(
            name: repo['name'],
            fullName: repo['full_name'],
            description: repo['description'],
            url: repo['url'],
            openIssues: repo['open_issues_count'] as int,
            forksCount: repo['forks_count'] as int,
            stargazersCount: repo['stargazers_count'] as int,
            watchersCount: repo['watchers_count'] as int,
            language: repo['language'],
            createdAt: DateTime.parse(repo['created_at']),
            lastUpdated: DateTime.parse(repo['updated_at']),
            lastPush: DateTime.parse(repo['pushed_at']),
            fcIssues: []));
      }
      _showToast(context, 'Finished Grabbing Repos');
      return [allRepos, totalIssues];
    }
    _showToast(context, 'Could not get repos');
    return [];
  }

  Future<List> _loadIssuesFromGithub(BuildContext context, List fcRepos, String oAuthToken) async {
    int over30Issues = 0;
    // get first 100 issues from each repo
    for(GithubRepo repo in fcRepos) {
      for(var i=1; i < (repo.openIssues/100).ceil() + 1; i++) {
        final String issuesUrl = "https://api.github.com/repos/fluttercommunity/${repo.name}/issues?per_page=100&page=$i";
        final response = await http.get(Uri.parse(issuesUrl),
          headers: {"Accept": "application/json", "Authorization": "token $oAuthToken"});
        if (response.statusCode == 200) {
          final issues = json.decode(utf8.decode(response.bodyBytes));
          // add the issues
          for(final issue in issues) {
            bool over30 = DateTime.now().difference(DateTime.parse(issue['updated_at'])).inDays > 60;
            if(over30) { over30Issues += 1; }
            repo.fcIssues.add(GithubIssue(
              title: issue['title'],
              url: issue['url'],
              htmlUrl: issue['html_url'],
              userLogin: issue['user']['login'],
              userUrl: issue['user']['url'],
              state: issue['state'],
              createdAt: DateTime.parse(issue['created_at']),
              lastUpdated: DateTime.parse(issue['updated_at']),
              timelineUrl: issue['timeline_url'],
              over30Days: over30,
              comments: issue['comments'],
              repo: repo.name
            ));
          }
        } else {
          throw "Failed to get $issuesUrl";
        }
      }
    }
    _showToast(context, 'Finished Grabbing Issues');
    return [fcRepos, over30Issues];
  }

  Future<List> _loadMetricsFromGithub(BuildContext context, List fcRepos, String oAuthToken) async {
    int totalCommits = 0;
    int thisWeekCount = 0;
    for(GithubRepo repo in fcRepos) {
      final String metricsUrl = "https://api.github.com/repos/fluttercommunity/${repo.name}/stats/commit_activity";
      final response = await http.get(Uri.parse(metricsUrl),
          headers: {"Accept": "application/json", "Authorization": "token $oAuthToken"});
      if (response.statusCode == 200) {
        final metrics = json.decode(utf8.decode(response.bodyBytes));

        int thisWeekCommitCount = 0;
        for(var week in metrics) {
          totalCommits += week['total'] as int;
          repo.commitsThisYear += week['total'] as int;
          thisWeekCommitCount = week['total'] as int;
        }
        repo.commitsThisWeek = thisWeekCommitCount;
        thisWeekCount += thisWeekCommitCount;
      } else {
        throw "Failed to get $metricsUrl";
      }
    }
    _showToast(context, 'Finished Grabbing Metrics');
    return [fcRepos, totalCommits, thisWeekCount];
  }

  Future<FCInfo> loadFCInfo(BuildContext context, String oAuthToken) async {
    List fcRepos = await _getRepos(context, oAuthToken);
    int totalIssues = fcRepos[1];
    print("Done With Repos");
    fcRepos = await _loadIssuesFromGithub(context, fcRepos[0], oAuthToken);
    int over30Issues = fcRepos[1];
    fcRepos = fcRepos[0];
    print("Done With Issues");
    fcRepos = await _loadMetricsFromGithub(context, fcRepos, oAuthToken);
    int commitsThisYear = fcRepos[1];
    int commitsThisWeek = fcRepos[2];
    fcRepos = fcRepos[0];
    print("Done With Metrics");
    return FCInfo(fcRepos: fcRepos,loaded: true, totalIssues: totalIssues, commitsThisWeek: commitsThisWeek, commitsThisYear: commitsThisYear, issuesOver30Days: over30Issues);
  }

  void _showToast(BuildContext context, message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
