import 'package:abhiman_assignment/features/home/presentation/components/my_drawer.dart';
import 'package:abhiman_assignment/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:abhiman_assignment/features/auth/presentation/screens/auth_page.dart';
import 'package:abhiman_assignment/features/home/presentation/components/post_tile.dart';
import 'package:abhiman_assignment/features/post/presentation/cubits/post_cubit.dart';
import 'package:abhiman_assignment/features/post/presentation/cubits/post_states.dart';
import 'package:abhiman_assignment/features/post/presentation/pages/upload_post_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late final postCubit = context.read<PostCubit>();

  @override
  void initState() {
    super.initState();
    fetchAllPosts();
  }

  void fetchAllPosts() {
    postCubit.fetchAllPosts();
  }

  void deletePosts(String postId) {
    postCubit.deletePost(postId);
    fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Feed Page",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color.fromARGB(255, 159, 129, 243),
        actions: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    context.read<AuthCubit>().logout();
                    GoogleSignIn().signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const AuthPage()),
                    );
                  },
                  icon: const Icon(Icons.logout)),
              IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UploadPostPage())),
                  icon: const Icon(Icons.post_add)),
            ],
          )
        ],
      ),
      drawer: const MyDrawer(),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          //loading
          if (state is PostsLoading && state is PostsUploading) {
            return const Center(child: CircularProgressIndicator());
          }

          //loaded
          else if (state is PostsLoaded) {
            final allPosts = state.post;
            if (allPosts.isEmpty) {
              return const Center(
                child: Text("No Post available"),
              );
            }
            return ListView.builder(
              itemCount: allPosts.length,
              itemBuilder: (context, index) {
                //get indvidual post
                final post = allPosts[index];

                if (post.imageUrl == null || post.imageUrl.isEmpty) {
                  return const Center(child: Text("Invalid image URL"));
                }

                return PostTile(
                    post: post, onDeletePressed: () => deletePosts(post.id));
              },
            );
          }
          //uploading

          //error
          else if (state is PostsEror) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
