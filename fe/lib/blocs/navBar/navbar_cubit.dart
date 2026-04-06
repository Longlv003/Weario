import 'package:flutter_bloc/flutter_bloc.dart';

enum NavPage { homeTabPage, cartTabPage, orderHistoryTabPage, profileTabPage }

class NavbarCubit extends Cubit<NavPage> {
  NavbarCubit() : super(NavPage.homeTabPage);

  void go(NavPage page) => emit(page);
}
