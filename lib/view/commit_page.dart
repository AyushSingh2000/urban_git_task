import 'package:flutter/material.dart';

import '../models/model.dart';

class CommitDetailsPage extends StatelessWidget {
  final GitHubRepo repo;

  CommitDetailsPage({required this.repo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Commit Details - ${repo.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Repository: ${repo.name}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Last Commit SHA: ${repo.lastCommitSha}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Last Commit Message: ${repo.lastCommitMessage}',
              style: TextStyle(fontSize: 16),
            ),
            // Add other relevant commit details
          ],
        ),
      ),
    );
  }
}
