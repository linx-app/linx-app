import 'package:flutter/material.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/core/domain/model/sponsorship_package.dart';

class SponsorshipPackageCard extends StatelessWidget {
  final SponsorshipPackage package;

  const SponsorshipPackageCard({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        _buildTitleText(),
        _buildSubtitleText("What you get"),
        _buildDescriptionText(package.ownBenefit),
        _buildSubtitleText("What your partner get"),
        _buildDescriptionText(package.partnerBenefit),
      ]),
    );
  }

  Text _buildTitleText() => Text(package.name,
      style: const TextStyle(
        color: LinxColors.black,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ));

  Text _buildSubtitleText(String s) => Text(s,
      style: const TextStyle(
        color: LinxColors.chipTextGrey,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ));

  Text _buildDescriptionText(String s) => Text(s,
      style: const TextStyle(
        color: LinxColors.locationTextGrey,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ));
}
