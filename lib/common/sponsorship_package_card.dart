import 'package:flutter/material.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/core/domain/model/sponsorship_package.dart';

class SponsorshipPackageCard extends StatelessWidget {
  final SponsorshipPackage package;

  const SponsorshipPackageCard({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.only(left: 24),
      elevation: 10,
      child: Container(
        height: 250,
        width: 200,
        padding: EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleText(),
            SizedBox(height: 17),
            _buildSubtitleText("What you get"),
            SizedBox(height: 12),
            _buildDescriptionText(package.ownBenefit),
            SizedBox(height: 32),
            _buildSubtitleText("What your partner get"),
            SizedBox(height: 12),
            _buildDescriptionText(package.partnerBenefit),
          ],
        ),
      ),
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