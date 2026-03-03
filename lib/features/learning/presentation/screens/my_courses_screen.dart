import 'package:flutter/material.dart';

class MyCoursesScreen extends StatelessWidget {
  const MyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('دوراتي'),
        automaticallyImplyLeading: false, // لمنع ظهور زر العودة
      ),
      body: const Center(
        child: Text(
          'سيتم عرض الكورسات المشترك بها هنا قريباً.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
