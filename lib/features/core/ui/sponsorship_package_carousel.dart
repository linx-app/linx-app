import 'package:flutter/material.dart';
import 'package:linx/common/sponsorship_package_card.dart';
import 'package:linx/features/core/domain/model/sponsorship_package.dart';

class SponsorshipPackageCarousel extends StatelessWidget {
  final List<SponsorshipPackage> packages;

  const SponsorshipPackageCarousel({super.key, required this.packages});

  @override
  Widget build(BuildContext context) {
    var packageCards = packages.map((e) => SponsorshipPackageCard(package: e));

    return SingleChildScrollView(
      clipBehavior: Clip.none,
      scrollDirection: Axis.horizontal,
      child: Row(children: [...packageCards]),
    );
  }
}