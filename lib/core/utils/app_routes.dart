import 'package:flutter/material.dart';

import '../../presentation/bloc/bloc_widget/qoute_page.dart';
import '../../presentation/cubit/qoute_page.dart';
import '../../presentation/custom_widget/dashboard_screen.dart';
import '../../presentation/getx/quotes_page.dart';
import '../../presentation/isolate/isolate_in_flutter.dart';
import '../../presentation/provider/quotes_page.dart';
import '../../presentation/riverpod/quotes_page.dart';
import '../../presentation/set_state/quotes_page_state.dart';

class AppRoutes {
  static const String dashboard = '/';
  static const String setState = '/set_state';
  static const String provider = '/provider';
  static const String bloc = '/bloc';
  static const String cubit = '/cubit';
  static const String riverpod = '/riverpod';
  static const String getx = '/getx';
  static const String isolateInFlutter = '/isolateInFlutter';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      dashboard: (context) => const DashboardScreen(),
      setState: (context) => const QuotesPageState(),
      provider: (context) => const ProviderQuotesPage(),
      bloc: (context) => const QuotesPage(),
      cubit: (context) => const CubitQuotesPage(),
      riverpod: (context) => const RiverpodQuotesPage(),
      getx: (context) => const GetXQuotesPage(),
      isolateInFlutter :(context) => const IsolateInFlutter(),
    };
  }
}
