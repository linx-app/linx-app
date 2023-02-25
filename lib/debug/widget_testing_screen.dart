import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/common/buttons/linx_text_button.dart';
import 'package:linx/common/buttons/rounded_button.dart';
import 'package:linx/common/linx_chip.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/app/home/ui/profile_modal_screen.dart';
import 'package:linx/features/app/home/ui/widgets/profile_card.dart';
import 'package:linx/features/app/home/ui/widgets/profile_modal_card.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/utils/ui_extensions.dart';

class WidgetTestingScreen extends ConsumerWidget {
  final _testUser = LinxUser(
    uid: "id",
    displayName: "Williams Fresh Cafe",
    location: "Waterloo, ON",
    biography:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna adipiscing elit eiusmod  dolore magna, Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna adipiscing elit eiusmod  dolore magna",
    profileImageUrls: [
      "https://picsum.photos/500/300",
      "https://picsum.photos/400/300"
    ],
    descriptors: {
      "Food",
      "Beverage",
      "Waterloo Alumni",
      "Dank food",
      "Overpriced shit coffee"
    },
    interests: {
      "Anything",
      "Test 1",
      "Test 2",
      'Test 3',
      "Test 4"
    }
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var chipSelectionState = StateProvider((ref) => true);

    return BaseScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: context.width()),
            // Example usage:
            _widgetContainer(
              LinxChip(
                label: "LinxChip",
                onChipSelected: (label) {
                  var currentState = ref.read(chipSelectionState);
                  ref.read(chipSelectionState.notifier).state = !currentState;
                },
                isSelected: ref.read(chipSelectionState),
              ),
            ),
            _widgetContainer(
              LinxTextButton(
                label: "LinxTextButton",
                onPressed: () {
                  _onAction(context, "LinxTextButton");
                },
                tint: LinxColors.green,
              ),
            ),
            _widgetContainer(
              RoundedButton(
                text: "Open profile modal",
                onPressed: () {
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => ProfileModalScreen(
                        0,
                        [_testUser, _testUser, _testUser],
                        const [10, 10, 10],
                      ),
                      opaque: false));
                },
                style: greenButtonStyle(),
              ),
            ),
            _widgetContainer(
              ProfileCard(
                matchPercentage: 10,
                user: _testUser,
              ),
            ),
            _widgetContainer(
              ProfileModalCard(
                user: _testUser,
                matchPercentage: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _widgetContainer(Widget widget) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: widget,
    );
  }

  void _onAction(BuildContext context, String name) {
    var snackBar = SnackBar(content: Text("Something happened with $name!"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
