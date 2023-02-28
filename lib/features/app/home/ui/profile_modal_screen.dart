import 'dart:math';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/app/home/domain/model/request.dart';
import 'package:linx/features/app/home/ui/widgets/home_business_widgets.dart';
import 'package:linx/features/app/home/ui/widgets/home_club_widgets.dart';
import 'package:linx/features/app/home/ui/widgets/profile_modal_card.dart';
import 'package:linx/features/core/domain/model/sponsorship_package.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/model/user_type.dart';
import 'package:linx/utils/ui_extensions.dart';

class ProfileModalScreen extends ConsumerWidget {
  final LinxUser currentUser;
  final int initialIndex;
  final List<LinxUser> users;
  final List<double> matchPercentages;
  final List<Request> requests;
  final List<List<SponsorshipPackage>> packages;
  final Function(
    LinxUser receiver,
    List<SponsorshipPackage> packages,
    Request? request,
  ) onMainButtonPressed;
  late StateProvider _profileModalCarouselSelectedIndexProvider;

  ProfileModalScreen({
    super.key,
    required this.initialIndex,
    required this.users,
    required this.requests,
    required this.matchPercentages,
    required this.packages,
    required this.currentUser,
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

    if (currentUser.type == UserType.club) {
      pages = buildMatchesModalCards(
        users: users,
        percentages: matchPercentages,
        packages: packages,
        onXPressed: () => _onXPressed(context),
        onMainButtonPressed: (index) {
          onMainButtonPressed(users[index], packages[index], null);
        },
      );
    } else {
      pages = buildRequestsModalCards(
        requests: requests,
        percentages: matchPercentages,
        packages: packages,
        onXPressed: () => _onXPressed(context),
        onMainButtonPressed: (index) {
          onMainButtonPressed(
            requests[index].sender,
            packages[index],
            requests[index],
          );
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
