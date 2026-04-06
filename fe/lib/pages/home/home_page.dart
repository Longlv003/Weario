import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weario/blocs/home/home_cubit.dart';
import 'package:weario/blocs/navBar/navbar_cubit.dart';
import 'package:weario/pages/home/tabs/cart_tab.dart';
import 'package:weario/pages/home/tabs/home_tab.dart';
import 'package:weario/pages/home/tabs/order_history_tab.dart';
import 'package:weario/pages/home/tabs/profile_tab.dart';
import 'package:weario/pages/home/widget/nav_bar.dart';
import 'package:weario/services/api_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NavModel> tabs = [
      NavModel(page: HomeTabPage(), navKey: GlobalKey<NavigatorState>()),
      NavModel(page: CartTabPage(), navKey: GlobalKey<NavigatorState>()),
      NavModel(
        page: OrderHistoryTabPage(),
        navKey: GlobalKey<NavigatorState>(),
      ),
      NavModel(page: ProfileTabPage(), navKey: GlobalKey<NavigatorState>()),
    ];
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavbarCubit()),
        BlocProvider(create: (_) => HomeCubit(ApiService())..refreshAll()),
      ],
      child: BlocBuilder<NavbarCubit, NavPage>(
        builder: (context, state) {
          final currentIndex = state.index;

          return Scaffold(
            body: Stack(
              children: [
                ...List.generate(tabs.length, (index) {
                  return Offstage(
                    offstage: currentIndex != index,
                    child: Navigator(
                      key: tabs[index].navKey,
                      onGenerateRoute: (settings) {
                        return MaterialPageRoute(
                          builder: (context) => tabs[index].page,
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
            bottomNavigationBar: NavBar(),
          );
        },
      ),
    );
  }
}
