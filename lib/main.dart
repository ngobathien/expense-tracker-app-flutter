import 'package:expense_tracker_app/viewmodels/stats_viewmodel.dart';
import 'package:expense_tracker_app/viewmodels/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // 👈 THÊM
import 'package:provider/provider.dart';

import 'router/app_router.dart';
import 'router/app_routes.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/category_viewmodel.dart';
import 'viewmodels/transaction_viewmodel.dart';

/// 👇 FIX QUAN TRỌNG
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('vi_VN', null); // 👈 FIX LỖI

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => TransactionViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
        ChangeNotifierProvider(create: (_) => StatsViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense Tracker',
        theme: ThemeData(
          primaryColor: const Color(0xFFFF7B00),
          scaffoldBackgroundColor: const Color(0xFFF8F9FB),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
        ),
        home: const AppStartup(),
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}

class AppStartup extends StatelessWidget {
  const AppStartup({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        context.read<AuthViewModel>().tryAutoLogin(),
        context.read<UserViewModel>().fetchProfile(),
      ]),
      builder: (context, snapshot) {
        /// loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final authVM = context.watch<AuthViewModel>();

        /// đã login
        if (authVM.accessToken != null) {
          return buildScreen(context, AppRoutes.dashboard);
        }

        /// chưa login
        return buildScreen(context, AppRoutes.login);
      },
    );
  }

  /// helper build screen từ router (KHÔNG dùng Navigator lồng)
  Widget buildScreen(BuildContext context, String routeName) {
    final route = AppRouter.generateRoute(RouteSettings(name: routeName));

    if (route is MaterialPageRoute) {
      return route.builder(context);
    }

    return const Scaffold(body: Center(child: Text("Route error")));
  }
}
