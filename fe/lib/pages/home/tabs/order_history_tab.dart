import 'package:flutter/material.dart';
import 'package:weario/common/widgets/common_app_bar.dart';

class OrderHistoryTabPage extends StatelessWidget {
  const OrderHistoryTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        showSearch: true,
        title: Text("Order header"),
        rightIcon: Icons.notifications,
      ),
      body: Center(child: Text("Order UI")),
    );
  }
}
