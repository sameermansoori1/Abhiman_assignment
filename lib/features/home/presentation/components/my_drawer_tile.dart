import 'package:flutter/material.dart';

class MyDrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function()? ontap;

  const MyDrawerTile(
      {super.key,
      required this.title,
      required this.icon,
      required this.ontap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      leading: Icon(
        icon,
        size: 24,
        color: Colors.deepPurple,
      ),
      onTap: ontap,
    );
  }
}
