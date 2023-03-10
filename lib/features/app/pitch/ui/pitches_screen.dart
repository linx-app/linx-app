import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/common/buttons/linx_toggle_buttons.dart';
import 'package:linx/common/buttons/toggle_button.dart';
import 'package:linx/common/linx_loading_spinner.dart';
import 'package:linx/common/rounded_border.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/app/core/ui/widgets/app_title_bar.dart';
import 'package:linx/features/app/core/ui/widgets/profile_bottom_sheet.dart';
import 'package:linx/features/app/core/ui/widgets/small_profile_card.dart';
import 'package:linx/features/app/match/domain/model/match.dart';
import 'package:linx/features/app/pitch/presentation/pitches_screen_controller.dart';
import 'package:linx/features/app/pitch/ui/model/pitches_screen_state.dart';
import 'package:linx/features/app/request/domain/model/request.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/utils/ui_extensions.dart';

class PitchesScreen extends ConsumerWidget {
  final firstToggleButton = const ToggleButton(label: "Outgoing", index: 0);
  final secondToggleButton = const ToggleButton(label: "Incoming", index: 1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(pitchesScreenControllerProvider);

    Widget body = _buildBody(context, ref, uiState);

    return BaseScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: context.height() * 0.1),
            const AppTitleBar(title: "Pitches"),
            _buildToggleButtons(ref),
            body,
            SizedBox(height: context.height() * 0.05),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButtons(WidgetRef ref) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: LinxToggleButtons(
          firstButton: firstToggleButton,
          secondButton: secondToggleButton,
          onNewTogglePressed: (index) => _onTogglePressed(ref, index),
        ));
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    PitchesScreenUiState state,
  ) {
    switch (state.state) {
      case PitchesScreenState.loading:
        return SizedBox(height: context.height() * 0.5, child: LinxLoadingSpinner());
      case PitchesScreenState.outgoing:
        return _buildOutgoingRequestsList(context, state.outgoingPitches);
      case PitchesScreenState.incoming:
        return _buildIncomingMatchesList(context, state.incomingMatches);
    }
  }

  Widget _buildOutgoingRequestsList(
      BuildContext context, List<Request> outgoing) {
    final cards = outgoing.map((e) {
      final data = SmallProfileCardData.fromRequest(e);
      return SmallProfileCard(
        data: data,
        onPressed: () => _onOutgoingRequestPressed(context, e.receiver),
      );
    });

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(children: [...cards]),
    );
  }

  Widget _buildIncomingMatchesList(BuildContext context, List<Match> incoming) {
    final cards = incoming.map((e) {
      final data = SmallProfileCardData.fromMatch(e);
      return SmallProfileCard(
        data: data,
        onPressed: () => _onIncomingMatchPressed(context, e.user),
      );
    });

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(children: [...cards]),
    );
  }

  void _onOutgoingRequestPressed(BuildContext context, LinxUser user) {
    final bottomSheet = SizedBox(
      height: context.height() * 0.80,
      child: ProfileBottomSheet(
        user: user,
        mainButtonText: "Send pitch",
        onXPressed: () => Navigator.maybePop(context),
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

  void _onIncomingMatchPressed(BuildContext context, LinxUser user) {
    final bottomSheet = SizedBox(
      height: context.height() * 0.80,
      child: ProfileBottomSheet(
        user: user,
        mainButtonText: "Send message",
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

  void _onTogglePressed(WidgetRef ref, int index) {
    final notifier = ref.read(pitchesScreenControllerProvider.notifier);
    notifier.onTogglePressed(index);
  }
}
