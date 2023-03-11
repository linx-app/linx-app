import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/common/linx_loading_spinner.dart';
import 'package:linx/common/rounded_border.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/app/core/ui/widgets/app_title_bar.dart';
import 'package:linx/features/app/core/ui/widgets/profile_bottom_sheet.dart';
import 'package:linx/features/app/core/ui/widgets/small_profile_card.dart';
import 'package:linx/features/app/match/presentation/matches_screen_controller.dart';
import 'package:linx/features/app/match/ui/model/matches_screen_state.dart';
import 'package:linx/features/app/match/domain/model/match.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/utils/ui_extensions.dart';

class MatchesScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(matchesScreenControllerProvider);
    Widget body = _buildBody(context, ref, uiState);

    return BaseScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: context.height() * 0.1),
            const AppTitleBar(title: "Matches"),
            body,
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    MatchesScreenUiState state,
  ) {
    switch (state.state) {
      case MatchesScreenState.loading:
        return SizedBox(
          height: context.height() * 0.5,
          child: LinxLoadingSpinner(),
        );
      case MatchesScreenState.results:
        return _buildMatchesList(context, state.matches);
    }
  }

  Widget _buildMatchesList(BuildContext context, List<Match> matches) {
    final cards = matches.map((e) {
      final data = SmallProfileCardData.fromMatch(e);
      return SmallProfileCard(
        data: data,
        onPressed: () => _onMatchPressed(context, e.user),
      );
    });

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(children: [...cards]),
    );
  }

  void _onMatchPressed(BuildContext context, LinxUser user) {
    final bottomSheet = SizedBox(
      height: context.height() * 0.80,
      child: ProfileBottomSheet(
        user: user,
        mainButtonText: "I'm interested",
        onXPressed: () => Navigator.maybePop(context),
        onMainButtonPressed: () {
          Navigator.maybePop(context);
          // TODO: Redirect to messages
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
}