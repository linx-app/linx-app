import 'package:flutter/material.dart';
import 'package:linx/features/app/core/ui/widgets/app_title_bar.dart';
import 'package:linx/features/app/core/ui/widgets/small_profile_card.dart';
import 'package:linx/features/app/search/domain/model/user_search_page.dart';

class ResultsSearchPage extends StatelessWidget {
  final UserSearchPage page;
  final String subtitle;
  final Function(int) onSmallCardPressed;

  const ResultsSearchPage({
    super.key,
    required this.page,
    required this.subtitle,
    required this.onSmallCardPressed,
  });

  @override
  Widget build(BuildContext context) {
    return _buildResults();
  }

  Widget _buildResults() {
    final cards = <SmallProfileCard>[];

    for (var i = 0; i < page.users.length; i++) {
      cards.add(
        SmallProfileCard(
          data: SmallProfileCardData.fromLinxUser(page.users[i]),
          onPressed: () => onSmallCardPressed(i),
        ),
      );
    }

    final title = AppTitleBar(
      subtitle: subtitle,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [title, ...cards],
      ),
    );
  }
}
