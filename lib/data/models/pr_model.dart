class PullRequest {
  final String title;
  final String? body;
  final String author;
  final DateTime createdAt;

  PullRequest({
    required this.title,
    this.body,
    required this.author,
    required this.createdAt,
  });

  factory PullRequest.fromJson(Map<String, dynamic> json) {
    return PullRequest(
      title: json['title'],
      body: json['body'],
      author: json['user']['login'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
