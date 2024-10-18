import 'dart:io';
import 'dart:typed_data';
import 'package:abhiman_assignment/features/auth/presentation/components/bottom_button.dart';
import 'package:abhiman_assignment/features/auth/presentation/components/my_textfield.dart';
import 'package:abhiman_assignment/features/post/domain/entities/post.dart';
import 'package:abhiman_assignment/features/post/presentation/cubits/post_cubit.dart';
import 'package:abhiman_assignment/features/post/presentation/cubits/post_states.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:abhiman_assignment/features/auth/domain/entities/app_user.dart';
import 'package:abhiman_assignment/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  //mobile image pick
  PlatformFile? imagePickedFile;

  //web image pick
  Uint8List? webImage;

  //text controller
  final textController = TextEditingController();

  //current user
  AppUser? currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  //select image
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );
    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;

        if (kIsWeb) {
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }

  //create upload the post
  void uploadPost() {
    if (imagePickedFile == null || textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Both image and caption are required')));
      return;
    }
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: textController.text,
      imageUrl: '',
      timestamp: DateTime.now(),
      likes: [],
      comments: [],
    );

    final postCubit = context.read<PostCubit>();

    //web upload
    if (kIsWeb) {
      postCubit.createPost(newPost, imageBytes: imagePickedFile?.bytes);
    } else {
      postCubit.createPost(newPost, imagePath: imagePickedFile?.path);
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      builder: (context, state) {
        print(state);
        //loading or uploading...
        if (state is PostsLoading || state is PostsUploading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        //build upload page
        return buildUploadPage();
      },
      listener: (context, state) {
        if (state is PostsLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildUploadPage() {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: uploadPost, icon: const Icon(Icons.upload))
        ],
        title: const Text(
          "Create Post",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color.fromARGB(255, 159, 129, 243),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              //image preview for web
              if (kIsWeb && webImage != null)
                Image.memory(
                  webImage!,
                ),

              //image preview of mobile
              if (!kIsWeb && imagePickedFile != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(
                    File(imagePickedFile!.path!),
                    height: 300,
                    width: double.infinity,
                  ),
                ),

              //pick image button
              BottomButton(
                onPressed: pickImage,
                title: "Upload Post",
              ),
              MyTextfield(
                  controller: textController,
                  hintText: "Content",
                  obscureText: false)
            ],
          ),
        ),
      ),
    );
  }
}
