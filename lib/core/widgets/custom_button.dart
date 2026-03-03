import 'package:flutter/material.dart';
import 'package:mini_lms_app/core/theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color? backgroundColor; // 👈 1. يجب أن يكون المتغير معرفاً هنا
  final bool isLoading;

  const CustomButton({
    super.key,
    this.onPressed,
    required this.text,
    this.backgroundColor, // 👈 2. وموجوداً في الـ Constructor
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        // 👈 3. هذا هو السطر المفقود! يجب إخبار الزر باستخدام اللون المرر، أو استخدام لون افتراضي إذا لم يُمرر
        backgroundColor: backgroundColor ?? AppColors.primary,
        // ... باقي تنسيقاتك مثل الحواف والحجم
      ),
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : Text(text),
    );
  }
}
