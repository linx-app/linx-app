import 'package:flutter/material.dart';
import 'package:linx/common/rounded_border.dart';
import 'package:linx/constants/colors.dart';

class MessageSuggestion extends StatelessWidget {
  final _titleStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: LinxColors.subtitleGrey,
  );

  final _regularStyle = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: LinxColors.subtitleGrey,
  );

  final _subtitleStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: LinxColors.subtitleGrey,
  );

  final bool isCurrentClub;

  const MessageSuggestion({super.key, required this.isCurrentClub});

  @override
  Widget build(BuildContext context) {
    final currentUserType = isCurrentClub ? "club" : "business";
    final otherUserType = isCurrentClub ? "business" : "club";

    return Card(
      shape: RoundedBorder.all(10),
      child: Container(
        padding: const EdgeInsets.only(bottom: 22),
        decoration: BoxDecoration(
          color: LinxColors.green.withOpacity(0.10),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: [
            _buildTitle(),
            _buildLine2(),
            _buildTipSuggestion(
              "Be specific",
              "Talk about why this $otherUserType in particular interests you",
            ),
            _buildTipSuggestion(
              "Be upfront",
              "Don’t waste their time - ask about how you can move the deal forward",
            ),
            _buildTipSuggestion(
              "Be personal",
              "Introduce yourself and the $currentUserType and get to know the $otherUserType",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 2),
      child: Text("Not sure what to say?", style: _titleStyle),
    );
  }

  Widget _buildLine2() {
    return Container(
      child: Text(
        "Here are some tips to help you get started",
        style: _regularStyle,
      ),
    );
  }

  Widget _buildTipSuggestion(
    String line1,
    String line2,
  ) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 40, top: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("lightbulb.png", height: 20, width: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(line1, style: _subtitleStyle),
                  ),
                  Text(line2, style: _regularStyle),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
