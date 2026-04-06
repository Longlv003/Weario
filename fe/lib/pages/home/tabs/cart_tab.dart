import 'package:flutter/material.dart';
import 'package:weario/common/widgets/common_app_bar.dart';

class CartTabPage extends StatelessWidget {
  const CartTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        showSearch: true,
        title: Text("Cart header"),
        rightIcon: Icons.notifications,
      ),
      body: Center(child: Text("Cart UI")),
    );
  }
}
