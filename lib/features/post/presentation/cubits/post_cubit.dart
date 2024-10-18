import 'dart:typed_data';

import 'package:abhiman_assignment/features/post/domain/entities/comment.dart';
import 'package:abhiman_assignment/features/post/domain/entities/post.dart';
import 'package:abhiman_assignment/features/post/domain/repos/post_repo.dart';
import 'package:abhiman_assignment/features/post/presentation/cubits/post_states.dart';
import 'package:abhiman_assignment/features/storage/domain/storage_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;

  PostCubit({required this.postRepo, required this.storageRepo})
      : super(PostsInitial());

  //create a new post
  Future<void> createPost(Post post,
      {String? imagePath, Uint8List? imageBytes}) async {
    String? imageUrl;

    try {
      //handle image upload for mobile platforms (using file path)

      if (imagePath != null) {
        emit(PostsUploading());
        imageUrl = await storageRepo.uploadPostImageMobile(imagePath, post.id);
      }

      //handle image upload for web platforms (using file bytes)
      else if (imageBytes != null) {
        emit(PostsUploading());
        imageUrl = await storageRepo.uploadPostImageWeb(imageBytes, post.id);
      }

      //give image url to post
      final newPost = post.copyWith(imageUrl: imageUrl);

      //create post in the backend
      postRepo.createPost(newPost);

      //refetch all post
      fetchAllPosts();
    } catch (e) {
      emit(PostsEror("Failed to create post: $e"));
    }
  }

  //fetch all posts
  Future<void> fetchAllPosts() async {
    try {
      emit(PostsLoading());
      final posts = await postRepo.fetchAllPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsEror("Failed to fetch posts: $e"));
    }
  }

  //delete a post
  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
    } catch (e) {}
  }

//toggle likes on post

  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      await postRepo.togglLikePost(postId, userId);
    } catch (e) {
      emit(PostsEror("Failed to toggle like: $e"));
    }
  }

//add a comment to post

  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepo.addComment(postId, comment);
      await fetchAllPosts();
    } catch (e) {
      emit(PostsEror("Failed to add comment: $e"));
    }
  }

//delete comment from a post
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepo.deleteComment(postId, commentId);
      await fetchAllPosts();
    } catch (e) {
      emit(PostsEror("failed to delete: $e"));
    }
  }
}
