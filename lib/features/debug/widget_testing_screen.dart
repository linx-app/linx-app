import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/common/buttons/linx_back_button.dart';
import 'package:linx/common/buttons/linx_text_button.dart';
import 'package:linx/common/buttons/rounded_button.dart';
import 'package:linx/common/linx_chip.dart';
import 'package:linx/common/rounded_border.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/app/core/ui/profile_modal_screen.dart';
import 'package:linx/features/app/core/ui/widgets/profile_bottom_sheet.dart';
import 'package:linx/features/app/core/ui/widgets/profile_card.dart';
import 'package:linx/features/app/core/ui/widgets/profile_modal_card.dart';
import 'package:linx/features/app/core/ui/widgets/small_profile_card.dart';
import 'package:linx/features/app/request/domain/model/request.dart';
import 'package:linx/features/app/request/ui/widgets/request_screen_widgets.dart';
import 'package:linx/features/app/core/domain/model/sponsorship_package.dart';
import 'package:linx/features/image_upload/ui/image_uploader.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/model/user_info.dart';
import 'package:linx/utils/ui_extensions.dart';

class WidgetTestingScreen extends ConsumerWidget {
  final _testUserInfo = const UserInfo(
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
    interests: {"Anything", "Test 1", "Test 2", 'Test 3', "Test 4"},
  );

  final _testPackage = SponsorshipPackage(
    packageId: "packageId",
    ownBenefit: "You get one of these",
    partnerBenefit: "I get one of these",
    name: "The best tier package",
    user: const UserInfo(uid: "id"),
  );

  final _testRequest = Request(
    sender: LinxUser(
      info: const UserInfo(uid: ""),
      packages: [],
      matchPercentage: 10,
    ),
    receiver: const UserInfo(uid: "id"),
    createdAt: DateTime.now(),
    message:
        "This is a sample pitch for sample and test reasons, nothing more. I need to fill this space. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna adipiscing elit eiusmod  dolore magna, Lorem ipsum dolor sit amet, consectetur adipiscing elit,",
  );

  LinxUser _fetchTestUser({
    UserInfo? userInfo,
    List<SponsorshipPackage>? packages,
    double? matchPercentage,
  }) {
    final info = userInfo ?? _testUserInfo;
    final sponsorshipPackages = packages ?? [_testPackage, _testPackage];
    final percentage = matchPercentage ?? 10;

    return LinxUser(
      info: info,
      packages: sponsorshipPackages,
      matchPercentage: percentage.toInt(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var chipSelectionState = StateProvider((ref) => true);

    return BaseScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: context.width(),
                alignment: Alignment.centerLeft,
                child: LinxBackButton(
                  onPressed: () => Navigator.of(context).pop(),
                )),
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
                onPressed: () => _openProfileModalScreen(context),
                style: greenButtonStyle(),
              ),
            ),
            _widgetContainer(
              ProfileCard(
                mainButtonText: "See details",
                mainText: _fetchTestUser().info.biography,
                onMainButtonPressed: () {},
                user: _fetchTestUser(),
              ),
            ),
            _widgetContainer(
              ProfileModalCard(
                user: _fetchTestUser(),
                mainButtonText: "See pitch",
              ),
            ),
            _widgetContainer(
              SmallProfileCard(
                data: SmallProfileCardData(
                  title: _testUserInfo.displayName,
                  line1Text: _testUserInfo.location,
                  line2Text: _testUserInfo.descriptors.first,
                  outlineText: "10% match",
                  imageUrl: _testUserInfo.profileImageUrls.first,
                  hasNewBadge: true,
                ),
                onPressed: () {
                  _openProfileBottomSheet(context, 70);
                },
              ),
            ),
            _widgetContainer(
              RoundedButton(
                style: greenButtonStyle(),
                onPressed: () => _showConfirmationSnackbar(context),
                text: "Show confirmation snackbar",
              ),
            ),
            _widgetContainer(
              ImageUploader((p0) {}),
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

  void _openProfileModalScreen(BuildContext context) {
    var screen = ProfileModalScreen(
      initialIndex: 0,
      users: [_fetchTestUser(), _fetchTestUser(), _fetchTestUser()],
      requests: [],
      isCurrentUserClub: true,
      onMainButtonPressed: (receiver) {},
    );

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => screen,
        opaque: false,
      ),
    );
  }

  void _openProfileBottomSheet(BuildContext context, int matchPercentage) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: context.height() * 0.80,
        child: ProfileBottomSheet(
          user: _fetchTestUser(),
          request: _testRequest,
          onXPressed: () => Navigator.maybePop(context),
          mainButtonText: "Send Pitch",
          onMainButtonPressed: () {},
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.60),
      shape: RoundedBorder.clockwise(10, 10, 0, 0),
    );
  }

  void _showConfirmationSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      buildMatchConfirmationSnackbar("William's"),
    );
  }
}
