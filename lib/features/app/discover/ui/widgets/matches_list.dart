import 'package:linx/features/app/core/ui/widgets/small_profile_card.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';

List<SmallProfileCard> buildMatchesList({
  required List<LinxUser> users,
  required Function(int) onPressed,
}) {
  if (users.isEmpty) return [];
  List<SmallProfileCard> cards = [];

  for (int i = 0; i < users.length; i++) {
    cards.add(
      SmallProfileCard(
        data: SmallProfileCardData.fromLinxUser(users[i]),
        onPressed: () => onPressed(i),
      ),
    );
  }

  return cards;
}
