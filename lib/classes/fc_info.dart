class FCInfo {
  FCInfo({
    required this.fcRepos,
    required this.loaded,
    this.totalIssues=0,
    this.commitsThisWeek=0,
    this.issuesOver30Days=0,
    this.commitsThisYear=0,

  });

  List fcRepos;
  bool loaded;
  int totalIssues;
  int commitsThisWeek;
  int issuesOver30Days;
  int commitsThisYear;
}