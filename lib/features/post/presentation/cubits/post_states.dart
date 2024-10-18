import 'package:abhiman_assignment/features/post/domain/entities/post.dart';

abstract class PostState {}

//intial
class PostsInitial extends PostState {}

//loading..
class PostsLoading extends PostState {}

//uploading..
class PostsUploading extends PostState {}

//error
class PostsEror extends PostState {
  final String message;
  PostsEror(this.message);
}

//loaded
class PostsLoaded extends PostState {
  final List<Post> post;
  PostsLoaded(this.post);
}
