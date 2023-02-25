import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/app/home/ui/widgets/profile_modal_card.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/utils/ui_extensions.dart';

class ProfileModalScreen extends ConsumerWidget {
  final int initialIndex;
  final List<LinxUser> users;
  final List<double> matchPercentages;
  late StateProvider _profileModalCarouselSelectedIndexProvider;

  ProfileModalScreen(this.initialIndex, this.users, this.matchPercentages) {
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

    for (int i = 0; i < users.length; i++) {
      pages.add(
        ProfileModalCard(
          user: users[i],
          matchPercentage: matchPercentages[i].toInt(),
        ),
      );
    }

    StateNotifier indexNotifier =
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
          dotsCount: users.length,
          position: selectedIndex.toDouble()),
    );
  }
}
