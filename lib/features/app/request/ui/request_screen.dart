import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/common/empty.dart';
import 'package:linx/common/linx_loading_spinner.dart';
import 'package:linx/common/rounded_border.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/app/core/ui/widgets/app_title_bar.dart';
import 'package:linx/features/app/core/ui/widgets/home_app_bar.dart';
import 'package:linx/features/app/core/ui/widgets/profile_bottom_sheet.dart';
import 'package:linx/features/app/request/domain/model/request.dart';
import 'package:linx/features/app/core/ui/profile_modal_screen.dart';
import 'package:linx/features/app/request/presentation/request_screen_controller.dart';
import 'package:linx/features/app/request/ui/widgets/request_screen_widgets.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/utils/ui_extensions.dart';

class RequestScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(requestScreenControllerProvider);

    if (state == null) {
      return BaseScaffold(body: LinxLoadingSpinner());
    } else {
      return BaseScaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              HomeAppBar(),
              const AppTitleBar(
                title: "Requests",
                subtitle: "Review Today's Sponsorship Requests",
              ),
              _buildRequestsCarousel(context, ref, state),
              _buildRequestsList(context, ref, state),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildRequestsCarousel(
    BuildContext context,
    WidgetRef ref,
    RequestScreenUiState state,
  ) {
    var pages = buildRequestsCarouselPages(
      context: context,
      requests: state.topRequests,
      onMainButtonPressed: (index) {
        _onProfileCardSeePitchPressed(context, ref, index, state);
      },
    );

    if (pages.isEmpty) return Empty();

    return Column(
      children: [
        SizedBox(
          height: 360,
          child: PageView(
            padEnds: false,
            clipBehavior: Clip.none,
            controller: PageController(viewportFraction: 0.70),
            children: pages,
          ),
        )
      ],
    );
  }

  Widget _buildRequestsList(
    BuildContext context,
    WidgetRef ref,
    RequestScreenUiState state,
  ) {
    var cards = buildRequestsList(
      requests: state.nextRequests,
      onPressed: (index) {
        _onSmallCardPressed(
          context: context,
          request: state.nextRequests[index],
          ref: ref,
        );
      },
    );

    if (cards.isEmpty) return Empty();

    var titleBar = AppTitleBar(
      subtitle: "Other requests",
      icon: Image.asset(
        "assets/sort.png",
        color: LinxColors.subtitleGrey,
      ),
    );

    return Container(
      width: context.width(),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [titleBar, ...cards],
      ),
    );
  }

  void _onProfileCardSeePitchPressed(
    BuildContext context,
    WidgetRef ref,
    int initialIndex,
    RequestScreenUiState state,
  ) {
    var screen = ProfileModalScreen(
      initialIndex: initialIndex,
      users: const [],
      requests: state.topRequests,
      onMainButtonPressed: (user) {
        _onImInterestedPressed(context, ref, user);
      },
      isCurrentUserClub: false,
    );
    var builder = PageRouteBuilder(
      pageBuilder: (_, __, ___) => screen,
      opaque: false,
    );
    Navigator.of(context).push(builder);
  }

  void _onSmallCardPressed({
    required BuildContext context,
    required Request request,
    required WidgetRef ref,
  }) {
    var bottomSheet = SizedBox(
      height: context.height() * 0.80,
      child: ProfileBottomSheet(
        user: request.sender,
        request: request,
        mainButtonText: "Send pitch",
        onXPressed: () => Navigator.maybePop(context),
        onMainButtonPressed: () {
          _onImInterestedPressed(context, ref, request.sender);
        },
      ),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => bottomSheet,
      barrierColor: LinxColors.black.withOpacity(0.60),
      shape: RoundedBorder.clockwise(10, 10, 0, 0),
    );
  }

  void _onImInterestedPressed(
    BuildContext context,
    WidgetRef ref,
    LinxUser club,
  ) {
    var notifier = ref.read(requestScreenControllerProvider.notifier);
    notifier.onImInterestedPressed(club: club.info);
    Navigator.of(context).pop();
  }
}
