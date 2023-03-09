import 'package:flutter/material.dart';
import 'package:linx/common/empty.dart';
import 'package:linx/features/app/core/ui/widgets/app_title_bar.dart';
import 'package:linx/features/app/search/ui/widgets/recent_search_item.dart';

class RecentsSearchPage extends StatelessWidget {
  final List<String> recents;
  final Function(String) onRecentsPressed;

  const RecentsSearchPage({
    super.key,
    required this.recents,
    required this.onRecentsPressed,
  });

  @override
  Widget build(BuildContext context) => _buildRecentSearches();

  Widget _buildRecentSearches() {
    if (recents.isEmpty) return Empty();

    final recentsList = recents.map(
      (e) => RecentSearchItem(
        search: e,
        onPressed: () => onRecentsPressed(e),
      ),
    );

    const title = AppTitleBar(
      subtitle: "Recent searches",
      padding: EdgeInsets.symmetric(horizontal: 0),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(children: [title, ...recentsList]),
    );
  }
}
