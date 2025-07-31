import 'dart:developer' as console;

import 'package:flutter/material.dart';
import 'package:github_pr_viewer/core/constants/const.dart';
import 'package:github_pr_viewer/data/models/pr_model.dart';
import 'package:github_pr_viewer/data/services/gihub_service.dart';
import 'package:github_pr_viewer/features/auth/presentation/login_page.dart';
import 'package:github_pr_viewer/features/pr/presentation/widgets/pr_card.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ScrollController _scrollController;
  final githubService = GitHubService(http.Client());
  final List<PullRequest> _pullRequests = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _isInitialLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  String? _token;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _loadMorePRs();
    _loadToken();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      _loadMorePRs();
    }
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('token');
    });
    console.log('Token: $_token');
  }

  void _loadMorePRs() async {
    if (_isLoading) return;
    _isLoading = true;

    final isFirstLoad = _pullRequests.isEmpty;
    if (isFirstLoad) {
      setState(() => _isInitialLoading = true);
    }
    try {
      final newPRs = await githubService
          .fetchPRs(page: _currentPage)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              _handleError("Rate limit exceeded or request timed out.");
              throw Exception('Timeout');
            },
          );
      if (mounted) {
        setState(() {
          _pullRequests.addAll(newPRs);
          _currentPage++;
          _hasError = false;
        });
      }
      if (isFirstLoad) {
        // artificial delay
        await Future.delayed(const Duration(milliseconds: 500));
      }
      setState(() {});
    } catch (e) {
      console.log("Error loading PRs: $e");
      _handleError("No more PRs available.");
    } finally {
      _isLoading = false;
      _isInitialLoading = false;
    }
  }

  Future<void> _refreshPRs() async {
    console.log("Refreshing PRs...");
    _hasError = false;
    _errorMessage = '';
    _pullRequests.clear();
    _currentPage = 1;
    _loadMorePRs();
  }

  void _handleError(String message) {
    _hasError = true;
    _errorMessage = message;
    if (_currentPage > 1) _currentPage--;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _logout() {
    console.log("Logging out...");
    setState(() {
      _pullRequests.clear();
      _currentPage = 1;
      _isLoading = false;
      _isInitialLoading = true;
      _hasError = false;
      _errorMessage = '';
    });
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('token');
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(widget.title)),
                Text(
                  "Token: ${_token ?? "loading..."}",
                  style: const TextStyle(fontSize: 12, color: Colors.white60),
                ),

                GestureDetector(
                  onTap: _logout,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.logout, size: 18.0, color: Colors.white),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Owner: $owner /", style: TextStyle(fontSize: 16)),
                Text(" Repo: $repo", style: TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
      body: _hasError
          ? _buildErrorState()
          : RefreshIndicator(
              onRefresh: _refreshPRs,
              child: Skeletonizer(
                enabled: _isInitialLoading,
                enableSwitchAnimation: true,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount:
                      _pullRequests.length +
                      (_isLoading && !_isInitialLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < _pullRequests.length || _isInitialLoading) {
                      return PullRequestCard(
                        pr: _isInitialLoading ? mockPR() : _pullRequests[index],
                      );
                    } else {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
    );
  }

  Widget _buildErrorState() {
    console.log("Error state is built");
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _errorMessage,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _loadMorePRs,
                child: const Text("Retry"),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _refreshPRs,
                child: const Text("Refresh"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
