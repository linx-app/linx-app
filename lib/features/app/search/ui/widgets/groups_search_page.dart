import 'package:flutter/material.dart';
import 'package:linx/features/app/core/ui/widgets/app_title_bar.dart';
import 'package:linx/features/app/search/domain/model/search_group.dart';
import 'package:linx/features/app/search/ui/widgets/search_category_card.dart';

class GroupSearchPage extends StatelessWidget {
  final List<SearchGroup> groups;
  final Function(SearchGroup) onGroupPressed;

  const GroupSearchPage({
    super.key,
    required this.groups,
    required this.onGroupPressed,
  });

  @override
  Widget build(BuildContext context) => _buildGroups();

  Widget _buildGroups() {
    final cards = groups.map((e) {
      return SearchCategoryCard(
        group: e,
        onPressed: () => onGroupPressed(e),
      );
    });

    final split = <List<SearchCategoryCard>>[];

    for (var card in cards) {
      if (split.isEmpty || split.last.length == 2) {
        split.add([card]);
      } else {
        split[split.length - 1].add(card);
      }
    }

    final rows = split.map((e) {
      return Row(children: [
        Expanded(child: e[0]),
        if (e.length > 1) Expanded(child: e[1]),
      ]);
    });

    const title = AppTitleBar(
      subtitle: "Groups",
      padding: EdgeInsets.symmetric(horizontal: 4),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(children: [title, ...rows, const SizedBox(height: 32)]),
    );
  }
}
