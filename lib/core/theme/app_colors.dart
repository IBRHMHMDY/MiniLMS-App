import 'package:flutter/material.dart';

class AppColors {
  // الألوان الرئيسية
  static const Color primary = Color(0xFF2563EB); // أزرق ملكي
  static const Color secondary = Color(
    0xFF10B981,
  ); // أخضر زمردي (للنجاح والاشتراكات)

  // ألوان الخلفيات والأسطح
  static const Color background = Color(0xFFF3F4F6); // رمادي فاتح جداً للخلفية
  static const Color surface = Colors.white; // أبيض للبطاقات (Cards)

  // ألوان الحالات (Status Colors)
  static const Color error = Color(0xFFEF4444); // أحمر للأخطاء
  static const Color success = Color(0xFF10B981); // أخضر للنجاح
  static const Color warning = Color(0xFFF59E0B); // برتقالي للتنبيهات

  // ألوان النصوص
  static const Color textPrimary = Color(
    0xFF1F2937,
  ); // رمادي داكن للعناوين والنصوص الأساسية
  static const Color textSecondary = Color(
    0xFF6B7280,
  ); // رمادي متوسط للنصوص الفرعية

  // ألوان الحدود (Borders)
  static const Color border = Color(0xFFE5E7EB); // رمادي فاتح للحدود
}
