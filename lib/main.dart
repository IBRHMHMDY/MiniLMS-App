import 'package:flutter/material.dart';
import 'injection/injection_container.dart' as di;
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة حقن الاعتماديات (Dependency Injection)
  await di.init();

  runApp(const MiniLmsApp());
}

class MiniLmsApp extends StatelessWidget {
  const MiniLmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mini LMS',
      debugShowCheckedModeBanner: false,

      // تطبيق الهوية البصرية ونظام التصميم
      theme: AppTheme.lightTheme,

      routerConfig: AppRouter.router,
    );
  }
}
