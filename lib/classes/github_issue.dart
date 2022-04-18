class GithubIssue {
  GithubIssue({
      required this.title,
      required this.url,
      required this.htmlUrl,
      required this.userLogin,
      required this.userUrl,
      required this.state,
      required this.createdAt,
      required this.lastUpdated,
      required this.timelineUrl,
      required this.over30Days,
      required this.comments,
      required this.repo});

  final String title;
  final String url;
  final String htmlUrl;
  final String userLogin;
  final String userUrl;
  final String state;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final String timelineUrl;
  final bool over30Days;
  final int comments;
  final String repo;
}
