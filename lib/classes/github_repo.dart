class GithubRepo {
  GithubRepo({
    required this.name,
    required this.fullName,
    required this.description,
    required this.url,
    required this.openIssues,
    this.forksCount,
    this.stargazersCount,
    this.watchersCount,
    this.language,
    this.createdAt,
    this.lastUpdated,
    this.lastPush,
    required this.fcIssues,
    this.commitsThisWeek=0,
    this.commitsThisYear=0
  });

  String name;
  String fullName;
  String description;
  String url;
  int openIssues;
  int? forksCount;
  int? stargazersCount;
  int? watchersCount;
  String? language;
  DateTime? createdAt;
  DateTime? lastUpdated;
  DateTime? lastPush;
  List fcIssues;
  int commitsThisWeek;
  int commitsThisYear;
}