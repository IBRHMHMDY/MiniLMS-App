import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatefulWidget {
  final Widget child; // الشاشة التي سيتم عرضها بناءً على التبويب الحالي

  const MainScreen({super.key, required this.child});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // دالة لتحديد الفهرس الحالي بناءً على المسار
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/my-courses')) {
      return 1;
    }
    if (location.startsWith('/profile')) {
      return 2;
    }
    return 0; // الافتراضي
  }

  // دالة للتعامل مع النقر على التبويبات
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        // سنقوم بإنشاء هذه الشاشة لاحقاً، حالياً سنوجهها لصفحة فارغة مؤقتة أو نتجاهلها
        context.go('/my-courses');
        break;
      case 2:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // الـ child هنا هو الشاشة الفعالة (Home أو Profile إلخ)
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'استكشف',
          ),
          NavigationDestination(
            icon: Icon(Icons.play_circle_outline),
            selectedIcon: Icon(Icons.play_circle_filled),
            label: 'دوراتي',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }
}
