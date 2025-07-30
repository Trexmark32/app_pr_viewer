class PullRequest {
  final String title;
  final String? body;
  final String author;
  final DateTime createdAt;
  final String fromBranch;
  final String toBranch;
  final String avatarUrl;

  PullRequest({
    required this.title,
    this.body,
    required this.author,
    required this.createdAt,
    required this.fromBranch,
    required this.toBranch,
    required this.avatarUrl,
  });

  factory PullRequest.fromJson(Map<String, dynamic> json) {
    return PullRequest(
      title: json['title'],
      body: json['body'],
      author: json['user']['login'],
      createdAt: DateTime.parse(json['created_at']),
      fromBranch: json['head']['ref'],
      toBranch: json['base']['ref'],
      avatarUrl: json['user']['avatar_url'],
    );
  }
}

// to load shimmer data
PullRequest mockPR() {
  return PullRequest(
    title: '',
    body: '',
    author: '',
    createdAt: DateTime.now(),
    fromBranch: '',
    toBranch: '',
    avatarUrl: '',
  );
}
