import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_git_task/view/commit_page.dart';

import '../view_model/view_model.dart';

class GitHubRepoView extends StatefulWidget {
  @override
  State<GitHubRepoView> createState() => _GitHubRepoViewState();
}

class _GitHubRepoViewState extends State<GitHubRepoView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      Provider.of<GitHubRepoViewModel>(context, listen: false).fetchRepos();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<GitHubRepoViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('GitHub Repositories'),
      ),
      body: FutureBuilder(
        future: viewModel.fetchRepos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              controller: _scrollController,
              itemCount: viewModel.repos.length,
              itemBuilder: (context, index) {
                final repo = viewModel.repos[index];
                return Card(
                  child: GestureDetector(
                    onTap: () async {
                      if (repo.lastCommitSha.isEmpty) {
                        await viewModel.fetchLastCommit(repo);
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommitDetailsPage(
                            repo: repo,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            repo.name,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            repo.description,
                            style: TextStyle(fontSize: 14),
                          ),
                          // Add other relevant fields
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
