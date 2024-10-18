import 'package:abhiman_assignment/features/home/presentation/Pages/feed_page.dart';
import 'package:abhiman_assignment/features/auth/data/firebase_auth_repo.dart';
import 'package:abhiman_assignment/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:abhiman_assignment/features/auth/presentation/cubits/auth_state.dart';
import 'package:abhiman_assignment/features/auth/presentation/cubits/google_auth_cubit.dart';
import 'package:abhiman_assignment/features/auth/presentation/screens/onboardingScreen.dart';
import 'package:abhiman_assignment/features/post/data/firebase_post_repo.dart';
import 'package:abhiman_assignment/features/post/presentation/cubits/post_cubit.dart';
import 'package:abhiman_assignment/features/storage/data/firebase_storage_repo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //auth repo
  final authRepo = FirebaseAuthRepo();

  final firebaseStorageRepo = FirebaseStorageRepo();

  final firebasePostRepo = FirebasePostRepo();

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostCubit>(
            create: (context) => PostCubit(
                postRepo: firebasePostRepo, storageRepo: firebaseStorageRepo)),
        BlocProvider(
          create: (context) => AuthCubit(authRepo: authRepo)..checkAuth(),
        ),
        BlocProvider(
          create: (context) => GoogleAuthCubit(),
        ),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 118, 34, 228)),
            useMaterial3: true,
          ),
          home: BlocConsumer<AuthCubit, AuthState>(
            builder: (context, authState) {
              print(authState);
              //unauthenticated
              if (authState is Unauthenticated) {
                return const Onboarding();
              }
              if (authState is Authenticated) {
                return const FeedPage();
              }
              //
              else {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
            listener: (context, state) {
              if (state is AuthError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          )),
    );
  }
}
