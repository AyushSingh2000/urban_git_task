import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_git_task/view/commit_page.dart';

import '../view_model/view_model.dart';

class GitHubRepoView extends StatefulWidget {
  const GitHubRepoView({super.key});

  @override
  State<GitHubRepoView> createState() => _GitHubRepoViewState();
}

class _GitHubRepoViewState extends State<GitHubRepoView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GitHubRepoViewModel>(context, listen: false)
          .fetchRepos(newPageFetch: false);
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      Provider.of<GitHubRepoViewModel>(context, listen: false).fetchRepos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GitHubRepoViewModel>(
      builder: (context, viewModel, child) => Scaffold(
          appBar: AppBar(
            title: const Text('GitHub Repositories'),
          ),
          body: viewModel.fetchRepoApiLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: viewModel.newPageFetchApiLoading
                      ? viewModel.repos.length + 1
                      : viewModel.repos.length,
                  itemBuilder: (context, index) {
                    // when new page is being loaded
                    if (viewModel.newPageFetchApiLoading &&
                        index == viewModel.repos.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(child: Text("New Page Loading...")),
                      );
                    } else {
                      final repo = viewModel.repos[index];

                      return Card(
                        child: GestureDetector(
                          onTap: () async {
                            if (repo.lastCommitSha.isEmpty) {
                              await viewModel.fetchLastCommit(repo);
                            }

                            if (mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommitDetailsPage(
                                    repo: repo,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  repo.name,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  repo.description,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Last Commit Date:${repo.lastCommitDate}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                // Add other relevant fields
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                )),
    );
  }
}
