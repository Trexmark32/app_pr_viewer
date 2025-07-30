import 'package:flutter/material.dart';
import 'package:github_pr_viewer/core/utils/date_formator.dart';
import 'package:github_pr_viewer/data/models/pr_model.dart';

class PullRequestCard extends StatelessWidget {
  final PullRequest pr;

  const PullRequestCard({super.key, required this.pr});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///  Avatar
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: (pr.avatarUrl.isNotEmpty)
                      ? NetworkImage(pr.avatarUrl)
                      : null,
                  child: pr.avatarUrl.isEmpty ? const Icon(Icons.person) : null,
                ),
                const SizedBox(width: 12),

                /// Author & Created date
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pr.author,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Created: ${formatDate(pr.createdAt)}",
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            /// Branches
            Text(
              "Branches:",
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            Text("🔀 ${pr.fromBranch} → ${pr.toBranch}"),
            const SizedBox(height: 12),

            /// Title
            Text(
              "Title:",
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            Text(pr.title, style: Theme.of(context).textTheme.titleMedium),

            /// Body (optional)
            if (pr.body != null && pr.body!.isNotEmpty) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    "Description:",
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pr.body!.trim(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
