import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:linx/constants/colors.dart';

class OnboardingProfileImageCarousel extends StatelessWidget {
  final EdgeInsets? padding;
  final PageController? controller;
  final Function(int) onPageChanged;
  final List<Widget> pages;
  final int dotPosition;

  const OnboardingProfileImageCarousel({
    super.key,
    this.padding,
    required this.onPageChanged,
    required this.pages,
    this.controller,
    this.dotPosition = 0,
  });

  @override
  Widget build(BuildContext context) {
    var length = pages.length;
    return Column(
      children: [
        Container(
          padding: padding,
          height: 250,
          child: PageView(
            controller: controller,
            onPageChanged: onPageChanged,
            children: [...pages],
          ),
        ),
        if (length > 1) _buildDotsIndicator(length),
      ],
    );
  }
  
  Center _buildDotsIndicator(int count) {
    return Center(
      child: DotsIndicator(
        dotsCount: count,
        position: dotPosition.toDouble(),
        decorator: DotsDecorator(
          activeColor: LinxColors.green
        ),
      ),
    );
  }
}
