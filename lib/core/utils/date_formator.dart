String formatDate(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date).inDays;
  if (difference == 0) return 'Today';
  if (difference == 1) return 'Yesterday';
  return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}
