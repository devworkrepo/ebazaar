import 'package:flutter/material.dart';

class AppBackgroundImage extends StatelessWidget {
  final Widget child;
  const AppBackgroundImage({Key? key,required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/image/login_background.png"))),
        child: child,
      );
  }
}
