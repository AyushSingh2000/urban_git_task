import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:urban_git_task/models/model.dart';

class GitHubRepoViewModel extends ChangeNotifier {
  final String token = dotenv.env["API_KEY"]!;

  final Dio _dio = Dio();
  List<GitHubRepo> repos = [];
  int currentPage = 1;
  final int pageSize = 10;
  bool fetchRepoApiLoading = false;
  bool newPageFetchApiLoading = false;

  Future<void> fetchRepos({bool newPageFetch = true}) async {
    try {
      if (newPageFetchApiLoading) return;
      if (newPageFetch) {
        newPageFetchApiLoading = true;
      } else {
        fetchRepoApiLoading = true;
      }
      notifyListeners();
      final response =
          await _dio.get('https://api.github.com/users/freeCodeCamp/repos',
//
              options: Options(headers: {'Authorization': 'Bearer $token'}),
//
              queryParameters: {'page': currentPage, 'per_page': pageSize});
      if (response.statusCode == 200) {
        final List<GitHubRepo> newRepos = (response.data as List)
            .map((repo) => GitHubRepo(
                  name: repo['name'],
                  description: repo['description'] ?? '',
                  lastCommitSha: '', // Initialize with empty values
                  lastCommitMessage: '',
                  lastCommitDate: '',
                ))
            .toList();
        repos.addAll(newRepos);
        currentPage++;
        if (newPageFetch) {
          newPageFetchApiLoading = false;
        } else {
          fetchRepoApiLoading = false;
        }

        // Fetch last commit information asynchronously
        fetchLastCommits();

        notifyListeners();
      } else {
        // Handle non-200 status code, log or throw an exception as needed
        log('Failed to fetch repos. Status code: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException &&
          e.response != null &&
          e.response!.statusCode == 403) {
        log('----------------------------------------------------------------------');
        final rateLimitRemaining = e.response!.headers['x-ratelimit-remaining'];
        if (rateLimitRemaining![0] == '0') {
          // Handle rate limit exceeded
          log('Rate limit exceeded. Please wait before making more requests.');
        } else {
          // Handle other errors
          log('Error fetching data: $e');
        }
      } else {
        // Handle other errors
        log('Error fetching data: $e');
      }
    }
  }

  Future<void> fetchLastCommits() async {
    for (final repo in repos) {
      if (repo.lastCommitSha.isNotEmpty) {
        continue; // Skip if last commit sha is already fetched
      }
      fetchLastCommit(repo);
    }
  }

  Future<void> fetchLastCommit(GitHubRepo repo) async {
    try {
      if (repo.lastCommitSha.isNotEmpty) {
        return; // Skip if last commit sha is already fetched
      }
      final commitResponse = await _dio.get(
        'https://api.github.com/repos/freeCodeCamp/${repo.name}/commits',

        //
        options: Options(headers: {'Authorization': 'Bearer  $token'}),
        //
      );
      final lastCommit = commitResponse.data[0];
      repo.lastCommitSha = lastCommit['sha'];
      repo.lastCommitMessage = lastCommit['commit']['message'];
      repo.lastCommitDate = lastCommit['commit']['author']['date'];
      log("Got Commitss For ${repo.name}");
      notifyListeners();
    } catch (e) {
      // Handle error fetching commit information
      log('Error fetching commit data for ${repo.name}: $e');
    }
  }
}
