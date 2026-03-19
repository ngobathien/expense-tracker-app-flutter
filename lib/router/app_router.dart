import 'package:expense_tracker_app/models/category_model.dart';
import 'package:expense_tracker_app/models/transaction_model.dart';
import 'package:expense_tracker_app/views/category/add_edit_category_screen.dart';
import 'package:expense_tracker_app/views/category/category_list_screen.dart';
import 'package:expense_tracker_app/views/transactions/add_transaction_screen.dart';
import 'package:expense_tracker_app/views/widgets/main_screen.dart';
import 'package:flutter/material.dart';

// AUTH
import '../views/auth/login_screen.dart';
import '../views/auth/register_screen.dart';
// HOME
// import '../views/home/home_view.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case AppRoutes.dashboard:
        return MaterialPageRoute(builder: (_) => const MainScreen());

      // 👉 TODO sau này thêm màn hình
      case AppRoutes.forgotPassword:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Forgot Password'))),
        );

      case AppRoutes.verifyOtp:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Verify OTP'))),
        );

      case AppRoutes.categories:
        return MaterialPageRoute(builder: (_) => const CategoryListScreen());

      case AppRoutes.addEditTransaction:
        final args = settings.arguments;

        if (args is TransactionModel) {
          return MaterialPageRoute(
            builder: (_) => AddEditTransactionScreen(transaction: args),
          );
        }

        return MaterialPageRoute(
          builder: (_) => const AddEditTransactionScreen(),
        );

      case AppRoutes.addEditCategory:
        final args = settings.arguments;

        if (args is CategoryModel) {
          return MaterialPageRoute(
            builder: (_) => AddEditCategoryScreen(category: args),
          );
        } else if (args is String) {
          return MaterialPageRoute(
            builder: (_) => AddEditCategoryScreen(type: args),
          );
        }

        return MaterialPageRoute(builder: (_) => const AddEditCategoryScreen());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
