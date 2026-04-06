import 'package:flutter/material.dart';

class NavItem extends StatelessWidget {
  final void Function() onTap;
  final String title;
  final Widget svgIconPath;
  final bool isSelected;

  const NavItem({
    super.key,
    required this.onTap,
    required this.svgIconPath,
    this.isSelected = false,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconTheme(
              data: IconThemeData(
                color: isSelected ? Colors.black : Colors.grey,
                size: 24,
              ),
              child: svgIconPath,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
