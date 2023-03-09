import 'dart:math';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/app/core/ui/widgets/profile_modal_card.dart';
import 'package:linx/features/app/discover/ui/widgets/top_matches_modal_cards.dart';
import 'package:linx/features/app/request/domain/model/request.dart';
import 'package:linx/features/app/request/ui/widgets/request_screen_widgets.dart';
import 'package:linx/features/user/domain/model/display_user.dart';
import 'package:linx/utils/ui_extensions.dart';

class ProfileModalScreen extends ConsumerWidget {
  final bool isCurrentUserClub;
  final int initialIndex;
  final List<DisplayUser> users;
  final List<Request> requests;
  final Function(DisplayUser receiver) onMainButtonPressed;
  late StateProvider _profileModalCarouselSelectedIndexProvider;

  ProfileModalScreen({
    super.key,
    required this.initialIndex,
    required this.users,
    required this.requests,
    required this.isCurrentUserClub,
    required this.onMainButtonPressed,
  }) {
    _profileModalCarouselSelectedIndexProvider =
        StateProvider((ref) => initialIndex);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedIndex = ref.watch(_profileModalCarouselSelectedIndexProvider);

    return BaseScaffold(
      backgroundColor: LinxColors.black.withOpacity(0.65),
      body: Container(
        height: context.height(),
        width: context.height() * 0.95,
        alignment: Alignment.center,
        color: LinxColors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildProfileCardCarousel(context, ref),
            _buildDotIndicator(selectedIndex),
          ],
        ),
      ),
    );
  }

  SizedBox _buildProfileCardCarousel(BuildContext context, WidgetRef ref) {
    var pages = <ProfileModalCard>[];

    if (isCurrentUserClub) {
      pages = buildTopMatchesModalCards(
        users: users,
        onXPressed: () => _onXPressed(context),
        onMainButtonPressed: (index) => onMainButtonPressed(users[index]),
      );
    } else {
      pages = buildRequestsModalCards(
        requests: requests,
        onXPressed: () => _onXPressed(context),
        onMainButtonPressed: (index) {
          onMainButtonPressed(requests[index].sender);
        },
      );
    }

    var indexNotifier =
        ref.read(_profileModalCarouselSelectedIndexProvider.notifier);

    PageController controller = PageController(
      initialPage: initialIndex,
      viewportFraction: 0.95,
    );

    return SizedBox(
      height: context.height() * 0.75,
      child: PageView(
        controller: controller,
        children: pages,
        onPageChanged: (position) {
          indexNotifier.state = position;
        },
      ),
    );
  }

  Container _buildDotIndicator(int selectedIndex) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: DotsIndicator(
          decorator: DotsDecorator(
            color: LinxColors.white.withOpacity(0.5),
            activeColor: LinxColors.white,
            size: const Size(8, 8),
          ),
          dotsCount: max(users.length, requests.length),
          position: selectedIndex.toDouble()),
    );
  }

  void _onXPressed(BuildContext context) => Navigator.maybePop(context);
}
