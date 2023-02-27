import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/app/home/domain/model/request.dart';
import 'package:linx/features/app/home/ui/send_a_pitch_screen.dart';
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
  late StateProvider _profileModalCarouselSelectedIndexProvider;

  ProfileModalScreen({
    super.key,
    required this.initialIndex,
    required this.users,
    required this.requests,
    required this.matchPercentages,
    required this.packages,
    required this.currentUser,
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

    for (int i = 0; i < users.length; i++) {
      pages.add(
        ProfileModalCard(
          user: users[i],
          request: requests.isEmpty ? null : requests[i],
          matchPercentage: matchPercentages[i].toInt(),
          packages: packages[i],
          onXPressed: () => _onXPressed(context),
          onMainButtonPressed: () {
            _onMainButtonPressed(
              receiver: users[i],
              request: requests.isEmpty ? null : requests[i],
              context: context,
              packages: packages[i],
            );
          },
        ),
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
          dotsCount: users.length,
          position: selectedIndex.toDouble()),
    );
  }

  void _onXPressed(BuildContext context) => Navigator.maybePop(context);

  void _onMainButtonPressed({
    required LinxUser receiver,
    Request? request,
    required List<SponsorshipPackage> packages,
    required BuildContext context,
  }) {
    if (currentUser.type == UserType.club) {
      var screen = SendAPitchScreen(
        receiver: receiver,
        sender: currentUser,
        packages: packages,
      );
      var builder = PageRouteBuilder(
        pageBuilder: (_, __, ___) => screen,
      );
      Navigator.of(context).push(builder);
    } else {}
  }
}
