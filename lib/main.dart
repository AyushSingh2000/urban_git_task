import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_git_task/view/git_repo_view.dart';
import 'package:urban_git_task/view_model/view_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GitHubRepoViewModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GitHubRepoView(),
    );
  }
}
