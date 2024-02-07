import 'package:flutter/material.dart';

import '../models/model.dart';

class CommitDetailsPage extends StatelessWidget {
  final GitHubRepo repo;

  const CommitDetailsPage({super.key, required this.repo});

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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Last Commit SHA: ${repo.lastCommitSha}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Last Commit Message: ${repo.lastCommitMessage}',
              style: const TextStyle(fontSize: 16),
            ),
            // Add other relevant commit details
          ],
        ),
      ),
    );
  }
}
