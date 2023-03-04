import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/features/app/core/ui/widgets/app_title_bar.dart';
import 'package:linx/features/core/ui/search_bar.dart';
import 'package:linx/utils/ui_extensions.dart';

class SearchScreen extends ConsumerWidget {
  final TextEditingController _searchController = TextEditingController();
  final String _searchText = "Search for a business...";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: context.height() * 0.1),
            _buildTitle(),
            SearchBar(controller: _searchController, label: _searchText)
          ],
        ),
      ),
    );
  }

  AppTitleBar _buildTitle() {
    return const AppTitleBar(title: "Search", iconData: Icons.filter_list);
  }
}