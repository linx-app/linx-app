import 'package:flutter/material.dart';
import 'package:linx/common/empty.dart';
import 'package:linx/common/separator_line.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/app/chat/ui/model/chat_item_data.dart';

class ChatItem extends StatelessWidget {
  final _nameTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: LinxColors.chipTextGrey,
  );
  final _messageTextStyle = const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: LinxColors.locationTextGrey,
  );

  final ChatItemData data;
  final VoidCallback? onPressed;

  const ChatItem({super.key, required this.data, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isNewBadge = data.isNew ? _buildNewBadge() : Empty();
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          const SeparatorLine(),
          Row(
            children: [
              isNewBadge,
              _buildProfileImage(),
              Expanded(child: _buildChatDetails()),
              Container(
                padding: const EdgeInsets.only(right: 24),
                child: const Icon(
                  Icons.chevron_right,
                  color: LinxColors.locationTextGrey,
                ),
              ),
            ],
          ),
          const SeparatorLine(),
        ],
      ),
    );
  }

  Container _buildNewBadge() {
    return Container(
      padding: const EdgeInsets.only(left: 12),
      child: const CircleAvatar(
        backgroundColor: LinxColors.green,
        radius: 4,
      ),
    );
  }

  Container _buildProfileImage() {
    final image = data.imageUrl != null ? NetworkImage(data.imageUrl!) : null;
    final leftPadding = data.isNew ? 12.0 : 24.0;
    return Container(
        padding: EdgeInsets.fromLTRB(leftPadding, 12, 0, 12),
        child: CircleAvatar(
          foregroundImage: image,
          backgroundColor: LinxColors.black,
          radius: 24,
        ));
  }

  Container _buildChatDetails() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _nameTextStyle,
          ),
          Text(
            data.lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _messageTextStyle,
          ),
        ],
      ),
    );
  }
}
