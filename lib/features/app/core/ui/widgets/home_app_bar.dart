import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/core/presentation/app_bottom_nav_screen_controller.dart';

class HomeAppBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildHomeAppBar(context, ref);
  }

  Container _buildHomeAppBar(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildLogOutButton(ref),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_border_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person_outline_rounded),
          )
        ],
      ),
    );
  }

  Widget _buildLogOutButton(WidgetRef ref) {
    var notifier = ref.read(appBottomNavScreenControllerProvider.notifier);
    return IconButton(
      onPressed: () => notifier.logOut(),
      icon: const Icon(Icons.logout),
    );
  }
}