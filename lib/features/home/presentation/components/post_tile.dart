import 'package:abhiman_assignment/features/auth/domain/entities/app_user.dart';
import 'package:abhiman_assignment/features/auth/presentation/components/my_textfield.dart';
import 'package:abhiman_assignment/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:abhiman_assignment/features/post/domain/entities/comment.dart';
import 'package:abhiman_assignment/features/post/domain/entities/post.dart';
import 'package:abhiman_assignment/features/post/presentation/cubits/post_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? onDeletePressed;

  const PostTile({
    super.key,
    required this.post,
    required this.onDeletePressed,
  });

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  late final postCubit = context.read<PostCubit>();
  bool isOwnPost = false;
  AppUser? currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = widget.post.userId == currentUser!.uid;
  }

  //likes

  //user tap at like button
  void toggleLikePost() {
    final isLiked = widget.post.likes.contains(currentUser!.uid);

    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.uid);
      } else {
        widget.post.likes.add(currentUser!.uid);
      }
    });
    //update likes
    postCubit
        .toggleLikePost(widget.post.id, currentUser!.uid)
        .catchError((error) {
      setState(() {
        if (isLiked) {
          widget.post.likes.add(currentUser!.uid);
        } else {
          widget.post.likes.remove(currentUser!.uid);
        }
      });
    });
  }

  //comment text controller
  final commentTextController = TextEditingController();

  //open comment box'
  void openNewCommentBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: MyTextfield(
                  controller: commentTextController,
                  hintText: "Type a comment",
                  obscureText: false),
              actions: [
                //cancel button
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Cancel")),
                TextButton(
                    onPressed: () {
                      addComment();
                      Navigator.of(context).pop();
                    },
                    child: const Text("Save")),
              ],
            ));
  }

  void addComment() {
    final newComment = Comment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        postId: widget.post.id,
        userId: widget.post.userId,
        userName: widget.post.userName,
        text: commentTextController.text,
        timestamp: DateTime.now());

    if (commentTextController.text.isNotEmpty) {
      postCubit.addComment(widget.post.id, newComment);
    }
  }

  @override
  void dispose() {
    commentTextController.dispose();
    super.dispose();
  }

  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete post?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                widget.onDeletePressed!();
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
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.deepPurple[100],
        elevation: 4, // Adjust the elevation for shadow effect
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding inside the card
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.person_3_rounded),
                  const SizedBox(width: 8), // Spacing between icon and text
                  Text(
                    widget.post.userName,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  if (isOwnPost)
                    IconButton(
                        onPressed: showOptions,
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        )),
                ],
              ),
              const SizedBox(height: 10), // Spacing between row and image
              CachedNetworkImage(
                imageUrl: widget.post.imageUrl,
                height: 400,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => const SizedBox(
                  height: 400,
                  child: Center(
                      child:
                          CircularProgressIndicator()), // Optional: loading indicator
                ),
                errorWidget: (context, url, error) {
                  print('Error loading image: $error');
                  return const Icon(Icons.error);
                },
              ),
              const SizedBox(
                height: 7,
              ),
              Row(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: toggleLikePost,
                        child: Icon(
                          widget.post.likes.contains(currentUser!.uid)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.post.likes.contains(currentUser!.uid)
                              ? Colors.redAccent
                              : Colors.black,
                        ),
                      ),
                      Text(widget.post.likes.length.toString()),
                    ],
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    child: Icon(Icons.comment),
                    onTap: openNewCommentBox,
                  ),
                  Text(widget.post.comments.length.toString()),
                  Spacer(),
                  Text(widget.post.timestamp.toString())
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
