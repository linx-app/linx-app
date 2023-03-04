import 'package:linx/features/app/core/ui/widgets/small_profile_card.dart';
import 'package:linx/features/core/domain/model/sponsorship_package.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';

List<SmallProfileCard> buildMatchesList({
  required List<LinxUser> users,
  required List<double> percentages,
  required List<List<SponsorshipPackage>> packages,
  required Function(int) onPressed,
}) {
  if (users.isEmpty || percentages.isEmpty) return [];
  List<SmallProfileCard> cards = [];

  for (int i = 0; i < users.length; i++) {
    var percentage = percentages[i].toInt();
    cards.add(
      SmallProfileCard(
        user: users[i],
        matchPercentage: percentage,
        onPressed: () => onPressed(i),
      ),
    );
  }

  return cards;
}
