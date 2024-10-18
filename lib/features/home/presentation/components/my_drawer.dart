import 'package:abhiman_assignment/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:abhiman_assignment/features/auth/presentation/screens/auth_page.dart';
import 'package:abhiman_assignment/features/home/presentation/components/my_drawer_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "Settings",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(
                    Icons.settings,
                    size: 25,
                    color: Colors.deepPurple,
                  ),
                ],
              ),
            ),
            MyDrawerTile(
              title: "Feed",
              icon: Icons.feed,
              ontap: () => Navigator.of(context).pop(),
            ),
            MyDrawerTile(
              title: "Logout",
              icon: Icons.logout,
              ontap: () {
                context.read<AuthCubit>().logout();
                GoogleSignIn().signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const AuthPage()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
