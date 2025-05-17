import 'package:flutter/material.dart';

class LoaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackgroundPadrao(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircleAvatar(
            radius: 100,
            backgroundImage: NetworkImage("https://res.cloudinary.com/ddemkhgt4/image/upload/v1746151975/logo_capy_car.png"),
            backgroundColor: Colors.white,
          ),
          SizedBox(height: 30),
          LinearProgressIndicator(
            backgroundColor: Colors.white24,
            color: Colors.white,
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}

class BackgroundPadrao extends StatelessWidget {
  final Widget child;

  const BackgroundPadrao({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(child.hashCode),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1974BF), Color(0xFF2B7422)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }
}