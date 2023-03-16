import 'package:flutter/material.dart';
import 'package:linx/common/buttons/rounded_button.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/notifications/domain/model/fcm_notification.dart';

class NewMatchBottomSheet extends StatelessWidget {
  final NewMatchNotification notification;
  final VoidCallback onButtonPressed;

  const NewMatchBottomSheet({
    super.key,
    required this.notification,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _buildProfileImage(context),
          _buildTitleText(),
          _buildDescriptionText(),
          _buildSendMessageButton(),
        ],
      ),
    );
  }

  Container _buildProfileImage(BuildContext context) {
    return Container(
      height: 170,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      alignment: Alignment.topRight,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(notification.imageUrl),
          fit: BoxFit.cover,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
    );
  }

  Container _buildTitleText() {
    final title = "${notification.name} matched with you!";
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: LinxColors.subtitleGrey,
            fontWeight: FontWeight.w600,
            fontSize: 22.0,
          ),
        ),
      ),
    );
  }

  Container _buildDescriptionText() {
    const description =
        "Reach out to them now to see how to get your sponsorship started.";
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: const Text(
        description,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: LinxColors.locationTextGrey,
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
      ),
    );
  }

  Container _buildSendMessageButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: RoundedButton(
        style: greenButtonStyle(),
        onPressed: onButtonPressed,
        text: "Send a message",
      ),
    );
  }
}
