class GitHubRepo {
  final String name;
  final String description;
  String lastCommitSha; // Add fields related to the last commit
  String lastCommitMessage;
  String lastCommitDate;
  // Add other relevant fields

  GitHubRepo(
      {required this.name,
      required this.description,
      required this.lastCommitSha,
      required this.lastCommitMessage,
      required this.lastCommitDate});
}
