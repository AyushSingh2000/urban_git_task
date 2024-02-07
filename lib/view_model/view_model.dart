import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:urban_git_task/models/model.dart';

class GitHubRepoViewModel extends ChangeNotifier {
  final Dio _dio = Dio();
  List<GitHubRepo> repos = [];
  int currentPage = 1;
  final int pageSize = 10;
  Future<void> fetchRepos() async {
    try {
      final response = await _dio.get(
          'https://api.github.com/users/freeCodeCamp/repos',
          queryParameters: {'page': currentPage, 'pageSize': pageSize});

      if (response.statusCode == 200) {
        final List<GitHubRepo> newRepos = (response.data as List)
            .map((repo) => GitHubRepo(
                  name: repo['name'],
                  description: repo['description'] ?? '',
                  lastCommitSha: '', // Initialize with empty values
                  lastCommitMessage: '',
                ))
            .toList();
        repos.addAll(newRepos);
        currentPage++;

        // Fetch last commit information asynchronously
        await fetchLastCommits();

        notifyListeners();
      } else {
        // Handle non-200 status code, log or throw an exception as needed
        print('Failed to fetch repos. Status code: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException &&
          e.response != null &&
          e.response!.statusCode == 403) {
        print(
            '----------------------------------------------------------------------');
        final rateLimitRemaining = e.response!.headers['x-ratelimit-remaining'];
        if (rateLimitRemaining == '0') {
          // Handle rate limit exceeded
          print(
              'Rate limit exceeded. Please wait before making more requests.');
        } else {
          // Handle other errors
          print('Error fetching data: $e');
        }
      } else {
        // Handle other errors
        print('Error fetching data: $e');
      }
    }
  }

  Future<void> fetchLastCommits() async {
    for (final repo in repos) {
      try {
        final commitResponse = await _dio.get(
            'https://api.github.com/repos/freeCodeCamp/${repo.name}/commits');
        final lastCommit = commitResponse.data[0];
        repo.lastCommitSha = lastCommit['sha'];
        repo.lastCommitMessage = lastCommit['commit']['message'];
      } catch (e) {
        // Handle error fetching commit information
        print('Error fetching commit data for ${repo.name}: $e');
      }
    }
  }

  Future<void> fetchLastCommit(GitHubRepo repo) async {
    try {
      final commitResponse = await _dio.get(
          'https://api.github.com/repos/freeCodeCamp/${repo.name}/commits');
      final lastCommit = commitResponse.data[0];
      repo.lastCommitSha = lastCommit['sha'];
      repo.lastCommitMessage = lastCommit['commit']['message'];
      notifyListeners();
    } catch (e) {
      // Handle error fetching commit information
      print('Error fetching commit data for ${repo.name}: $e');
    }
  }
}
