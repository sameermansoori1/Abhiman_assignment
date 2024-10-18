import 'package:abhiman_assignment/features/home/presentation/Pages/feed_page.dart';
import 'package:abhiman_assignment/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:abhiman_assignment/features/auth/presentation/cubits/auth_state.dart';
import 'package:abhiman_assignment/features/auth/presentation/cubits/google_auth_cubit.dart';
import 'package:abhiman_assignment/features/auth/presentation/cubits/google_auth_state.dart';
import 'package:flutter/material.dart';
import 'package:abhiman_assignment/features/auth/presentation/components/my_textfield.dart';
import 'package:abhiman_assignment/features/auth/presentation/components/bottom_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPage extends StatefulWidget {
  final void Function()? onPress;
  const SignupPage({super.key, required this.onPress});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isChecked = false;
  bool isPasswordVisible = false;

  // Method to handle email/password signup
  void signup() {
    final String username = usernameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;

    final authCubit = context.read<AuthCubit>();

    if (email.isNotEmpty && username.isNotEmpty && password.isNotEmpty) {
      authCubit.signup(username, email, password);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please complete all fields")));
    }
  }

  // Method to handle Google Sign-In
  void loginWithGoogle() {
    final googleAuthCubit = context.read<GoogleAuthCubit>();
    googleAuthCubit.login();
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Listener for email/password authentication
        BlocListener<AuthCubit, AuthState>(
          listener: (context, authState) {
            if (authState is Authenticated) {
              Navigator.of(context).pop(
                MaterialPageRoute(builder: (context) => const FeedPage()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Login successful!")),
              );
            } else if (authState is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(authState.message)),
              );
            }
          },
        ),
        // Listener for Google authentication
        BlocListener<GoogleAuthCubit, GoogleAuthState>(
          listener: (context, state) {
            if (state is GoogleAuthSuccessState) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const FeedPage()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Google sign-in successful!")),
              );
            } else if (state is GoogleAuthFailedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text(
                        "Create an account",
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.waving_hand, color: Colors.amber),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Username",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  MyTextfield(
                    controller: usernameController,
                    hintText: "",
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Email",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  MyTextfield(
                    controller: emailController,
                    hintText: "",
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Password",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  MyTextfield(
                    controller: passwordController,
                    hintText: "",
                    obscureText: !isPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.deepPurpleAccent,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      const Text(
                        "Remember Me",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "OR",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  BottomButton(
                    onPressed: loginWithGoogle,
                    color: Colors.white,
                    childWidget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/google.png',
                          height: 24,
                          fit: BoxFit.fitHeight,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Continue with Google",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    textColor: Colors.black,
                  ),
                  const SizedBox(height: 20),
                  BottomButton(
                    onPressed: signup,
                    title: "SIGN UP",
                  ),
                  Center(
                    child: TextButton(
                      onPressed: widget.onPress,
                      child: const Text(
                        "Already have an account? Login now",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
