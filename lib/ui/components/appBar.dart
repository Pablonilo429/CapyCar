import 'package:capy_car/main.dart';
import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String greeting;
  final bool isPop;

  const CustomAppBar({super.key, required this.greeting, required this.isPop});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(48);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          widget.isPop
              ? IconButton(
                iconSize: 30.0,
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Routefly.navigate(routePaths.carona.caronaHome);
                },
              )
              : IconButton(
                iconSize: 30.0,
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.greeting,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
