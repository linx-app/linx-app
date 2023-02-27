import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/common/buttons/linx_back_button.dart';
import 'package:linx/common/buttons/rounded_button.dart';
import 'package:linx/common/linx_text_field.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/constants/text.dart';
import 'package:linx/features/app/home/presentation/send_a_pitch_screen_controller.dart';
import 'package:linx/features/core/domain/model/sponsorship_package.dart';
import 'package:linx/features/core/ui/sponsorship_package_carousel.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';

class SendAPitchScreen extends ConsumerWidget {
  final LinxUser sender;
  final LinxUser receiver;
  final List<SponsorshipPackage> packages;
  final TextEditingController _pitchMessageController = TextEditingController();

  SendAPitchScreen({
    super.key,
    required this.receiver,
    required this.packages,
    required this.sender,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(sendAPitchScreenControllerProvider);

    if (state == SendAPitchUiState.finished) {
      Navigator.of(context).pop();
    }

    return BaseScaffold(
      body: Column(
        children: [
          _buildBackButton(context),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                _buildTitleText(),
                _buildDisplayNameText(),
                _buildPitchMessageField(),
                _buildPackageSection(),
              ],
            ),
          ),
          _buildButtonRow(context, ref),
        ],
      ),
    );
  }

  Container _buildBackButton(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: LinxBackButton(onPressed: () => _onBackPressed(context)),
    );
  }

  Container _buildTitleText() {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: const Text(
        "Send a pitch",
        style: LinxTextStyles.title,
      ),
    );
  }

  Container _buildDisplayNameText() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        receiver.displayName,
        style: LinxTextStyles.subtitle,
      ),
    );
  }

  Container _buildPitchMessageField() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: LinxTextField(
        label: "Write a pitch about what you need and what you require...",
        controller: _pitchMessageController,
        minLines: 7,
        maxLines: 7,
      ),
    );
  }

  Container _buildPackageSection() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
            child: const Text(
              "Select a package (optional)",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: LinxColors.subtitleGrey,
              ),
            ),
          ),
          SponsorshipPackageCarousel(packages: packages),
        ],
      ),
    );
  }

  Container _buildButtonRow(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: RoundedButton(
        style: greenButtonStyle(),
        onPressed: () => _onSendPitchPressed(context, ref),
        text: "Send pitch",
      ),
    );
  }

  void _onBackPressed(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _onSendPitchPressed(BuildContext context, WidgetRef ref) {
    var notifier = ref.read(sendAPitchScreenControllerProvider.notifier);
    notifier.sendPitch(
      receiver: receiver,
      sender: sender,
      message: _pitchMessageController.text,
    );
  }
}
