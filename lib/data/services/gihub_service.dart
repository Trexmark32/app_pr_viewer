import 'dart:convert';

import 'package:github_pr_viewer/data/models/pr_model.dart';
import 'package:http/http.dart' as http;

class GitHubService {
  final http.Client client;

  GitHubService(this.client);

  Future<List<PullRequest>> fetchPRs() async {
    final response = await client.get(
      Uri.parse('https://api.github.com/repos/<owner>/<repo>/pulls'),
    );

    if (response.statusCode == 200) {
      final List jsonData = json.decode(response.body);
      return jsonData.map((e) => PullRequest.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load PRs');
    }
  }
}
