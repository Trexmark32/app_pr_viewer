import 'dart:convert';

import 'package:github_pr_viewer/data/models/pr_model.dart';

List<PullRequest> parsePullRequests(String responseBody) {
  final List<dynamic> data = json.decode(responseBody);
  return data.map((e) => PullRequest.fromJson(e)).toList();
}
