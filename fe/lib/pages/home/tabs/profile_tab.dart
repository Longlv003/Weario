import 'package:flutter/material.dart';
import 'package:weario/common/widgets/common_app_bar.dart';

class ProfileTabPage extends StatelessWidget {
  const ProfileTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        showSearch: false,
        title: Text("Profile header"),
        rightIcon: Icons.logout,
      ),
      body: Center(child: Text("Profile UI")),
    );
  }
}
