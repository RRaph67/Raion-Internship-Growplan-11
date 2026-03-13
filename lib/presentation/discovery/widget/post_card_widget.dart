// File: lib/presentation/discovery/widget/post_card_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/discovery/widget/common_widget.dart';

class PostCard extends StatelessWidget {
  final String userId;
  final String userName;
  final String username;
  final String userAvatarUrl;
  final String postText;
  final List<String> postImages;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;

  const PostCard({
    super.key,
    required this.userId,
    required this.userName,
    required this.username,
    required this.userAvatarUrl,
    required this.postText,
    this.postImages = const [],
    this.onLike,
    this.onComment,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FeedSeparator(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserAvatar(imageUrl: userAvatarUrl),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          UserInfo(name: userName, username: username),
                          IconButton(
                            icon: const Icon(
                              Icons.more_horiz,
                              color: Color(0xFF4E4E4E),
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      PostContent(text: postText, images: postImages),
                      const SizedBox(height: 12),
                      PostActions(
                        onLike: onLike,
                        onComment: onComment,
                        onShare: onShare,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
