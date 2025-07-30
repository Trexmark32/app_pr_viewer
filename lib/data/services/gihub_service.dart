import 'dart:developer' as console;

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:github_pr_viewer/core/constants/const.dart';
import 'package:github_pr_viewer/core/utils/json_parser.dart';
import 'package:github_pr_viewer/data/models/pr_model.dart';
import 'package:http/http.dart' as http;

class GitHubService {
  final http.Client client;
  final int itemCount = 5; // Number of items per page

  GitHubService(this.client);

  Future<List<PullRequest>> fetchPRs({int page = 1}) async {
    final uri =
        "$baseUrl$owner/$repo/$pullRequestsEndpoint?per_page=$itemCount&page=$page";
    try {
      Map<String, String> headers = {};
      final accessToken = dotenv.env['GITHUB_ACCESS_TOKEN'];
      if (accessToken != null && accessToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $accessToken';
      }
      final response = await client.get(Uri.parse(uri), headers: headers);
      if (response.statusCode == 200) {
        return compute(parsePullRequests, response.body);
      } else {
        console.log('Failed :${response.body}');
        throw Exception('Failed :${response.body}');
      }
    } catch (e) {
      console.log('Error fetching PRs: $e');
      throw Exception('Failed :$e');
    }
  }
}
