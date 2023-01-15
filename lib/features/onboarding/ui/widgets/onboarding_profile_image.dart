import 'package:flutter/material.dart';

class OnboardingProfileImage extends StatelessWidget {
  final String url;
  final Alignment? alignment;
  final Widget? child;

  const OnboardingProfileImage({
    super.key,
    required this.url,
    this.alignment,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      margin: const EdgeInsets.symmetric(horizontal: 7.5),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
