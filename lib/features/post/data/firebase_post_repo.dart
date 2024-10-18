import 'package:abhiman_assignment/features/post/domain/entities/comment.dart';
import 'package:abhiman_assignment/features/post/domain/entities/post.dart';
import 'package:abhiman_assignment/features/post/domain/repos/post_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //store post in a collection called post

  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  // store the post in a collection called 'post

  @override
  Future<void> createPost(Post post) async {
    try {
      await postsCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception("Error creating post: $e");
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    await postsCollection.doc(postId).delete();
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      //get all post
      final postsSnapshot =
          await postsCollection.orderBy('timestamp', descending: true).get();

      //convert each firstroe doc from json-- list of post
      final List<Post> allPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return allPosts;
    } catch (e) {
      throw Exception("Error fetching posts: $e");
    }
  }

  @override
  Future<List<Post>> fetchPostsByUserId(String userId) async {
    try {
      //fetch posts snapshot with this uid

      final postSnapshot =
          await postsCollection.where('userId', isEqualTo: userId).get();

      //convert firestore doc from json to list of post

      final userPosts = postSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return userPosts;
    } catch (e) {
      throw Exception("Error fectihing post by user: $e");
    }
  }

  @override
  Future<void> togglLikePost(String postId, String userId) async {
    try {
      final postDoc = await postsCollection.doc(postId).get();

      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        //if user already like this post

        final hasLiked = post.likes.contains(userId);

        //update the likes list

        if (hasLiked) {
          post.likes.remove(userId);
        } else {
          post.likes.add(userId);
        }
        //update the document

        await postsCollection.doc(postId).update({'likes': post.likes});
      } else {
        throw Exception("Post not found");
      }
    } catch (e) {
      throw Exception("Error toggling likes: $e");
    }
  }

  @override
  Future<void> addComment(String postId, Comment comment) async {
    try {
      //get post doccument
      final postDoc = await postsCollection.doc(postId).get();

      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        post.comments.add(comment);

        await postsCollection.doc(postId).update({
          "comments": post.comments.map((comment) => comment.toJson()).toList()
        });
      } else {
        throw Exception("post not found");
      }
    } catch (e) {
      throw Exception("Error adding comment: $e");
    }
  }

  @override
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      //get post doccument
      final postDoc = await postsCollection.doc(postId).get();

      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        post.comments.removeWhere((comment) => comment.id == commentId);

        await postsCollection.doc(postId).update({
          "comments": post.comments.map((comment) => comment.toJson()).toList()
        });
      } else {
        throw Exception("post not found");
      }
    } catch (e) {
      throw Exception("Error deleting comment: $e");
    }
  }
}
