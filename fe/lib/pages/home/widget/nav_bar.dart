import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weario/blocs/home/home_cubit.dart';
import 'package:weario/blocs/navBar/navbar_cubit.dart';
import 'package:weario/pages/home/widget/nav_item.dart';

class NavModel {
  final Widget page;
  final GlobalKey<NavigatorState> navKey;

  NavModel({required this.page, required this.navKey});
}

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: BottomAppBar(
        elevation: 8,
        child: Row(
          children: [
            BlocBuilder<NavbarCubit, NavPage>(
              buildWhen: (prev, current) => prev != current,
              builder: (context, state) => NavItem(
                onTap: () {
                  final navCubit = context.read<NavbarCubit>();

                  if (navCubit.state == NavPage.homeTabPage) {
                    context.read<HomeCubit>().scrollToTop();
                    context.read<HomeCubit>().refreshAll();
                  } else {
                    navCubit.go(NavPage.homeTabPage);
                  }
                },
                isSelected: state == NavPage.homeTabPage,
                svgIconPath: Icon(Icons.home),
                title: 'Home',
              ),
            ),

            BlocBuilder<NavbarCubit, NavPage>(
              buildWhen: (prev, current) => prev != current,
              builder: (context, state) => NavItem(
                onTap: () =>
                    context.read<NavbarCubit>().go(NavPage.cartTabPage),
                isSelected: state == NavPage.cartTabPage,
                svgIconPath: Icon(Icons.shopping_cart),
                title: 'My Cart',
              ),
            ),

            BlocBuilder<NavbarCubit, NavPage>(
              buildWhen: (prev, current) => prev != current,
              builder: (context, state) => NavItem(
                onTap: () =>
                    context.read<NavbarCubit>().go(NavPage.orderHistoryTabPage),
                isSelected: state == NavPage.orderHistoryTabPage,
                svgIconPath: Icon(Icons.history),
                title: 'My Order',
              ),
            ),

            BlocBuilder<NavbarCubit, NavPage>(
              buildWhen: (prev, current) => prev != current,
              builder: (context, state) => NavItem(
                onTap: () =>
                    context.read<NavbarCubit>().go(NavPage.profileTabPage),
                isSelected: state == NavPage.profileTabPage,
                svgIconPath: Icon(Icons.account_box),
                title: 'My Profile',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
