import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final bool showSearch;
  final IconData rightIcon;
  final VoidCallback? onSearchTap;
  final VoidCallback? onRightTap;

  const CommonAppBar({
    super.key,
    required this.title,
    this.showSearch = true,
    required this.rightIcon,
    this.onSearchTap,
    this.onRightTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showSearch
          ? IconButton(
              icon: const Icon(Icons.search),
              onPressed: onSearchTap ?? () {},
            )
          : null,

      title: title,
      centerTitle: true,

      actions: [
        IconButton(icon: Icon(rightIcon), onPressed: onRightTap ?? () {}),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
