import 'package:flutter/material.dart';
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

class RequestScreen extends StatelessWidget {
  final RequestScreenUiState? _state;
  final RequestScreenController _controller;

  RequestScreen(this._state, this._controller, {super.key});

  @override
  Widget build(BuildContext context) {
    if (_state == null) {
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
              _buildRequestsCarousel(context),
              _buildRequestsList(context),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildRequestsCarousel(BuildContext context) {
    var pages = buildRequestsCarouselPages(
      context: context,
      requests: _state!.topRequests,
      onMainButtonPressed: (index) {
        _onProfileCardSeePitchPressed(context, index);
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

  Widget _buildRequestsList(BuildContext context) {
    var cards = buildRequestsList(
      requests: _state!.nextRequests,
      onPressed: (index) {
        _onSmallCardPressed(
          context: context,
          request: _state!.nextRequests[index],
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

  void _onProfileCardSeePitchPressed(BuildContext context, int initialIndex) {
    var screen = ProfileModalScreen(
      initialIndex: initialIndex,
      users: const [],
      requests: _state!.topRequests,
      onMainButtonPressed: (user) {
        _onImInterestedPressed(context, user);
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
  }) {
    var bottomSheet = SizedBox(
      height: context.height() * 0.80,
      child: ProfileBottomSheet(
        user: request.sender,
        request: request,
        mainButtonText: "Send pitch",
        onXPressed: () => Navigator.maybePop(context),
        onMainButtonPressed: () {
          _onImInterestedPressed(context, request.sender);
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

  void _onImInterestedPressed(BuildContext context, LinxUser club) {
    _controller.onImInterestedPressed(club: club.info);
    Navigator.of(context).pop();
  }
}
