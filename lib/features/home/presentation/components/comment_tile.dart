import 'package:abhiman_assignment/features/auth/domain/entities/app_user.dart';
import 'package:abhiman_assignment/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:abhiman_assignment/features/post/domain/entities/comment.dart';
import 'package:abhiman_assignment/features/post/presentation/cubits/post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;
  const CommentTile({super.key, required this.comment});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  AppUser? currentUser;
  bool isOwnPost = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.comment.userId == currentUser!.uid);
  }

  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Comment?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                context
                    .read<PostCubit>()
                    .deleteComment(widget.comment.postId, widget.comment.id);
                Navigator.of(context).pop();
              },
              child: const Text("Delete")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        // Use Column for better layout of multiple lines
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align to start of the column
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Username
              Text(
                widget.comment.userName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
            ],
          ),

          const SizedBox(height: 5),

          // Comment text that auto-wraps
          Text(
            widget.comment.text,
            style: const TextStyle(),
          ),
          // Delete button for own comments
          if (isOwnPost)
            GestureDetector(
              onTap: showOptions,
              child: const Icon(
                Icons.more_horiz,
                color: Colors.grey,
              ),
            ),
        ],
      ),
    );
  }
}
