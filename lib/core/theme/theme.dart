import 'package:flutter/material.dart';
import 'app_colors.dart';

extension ThemeOwn on BuildContext {
  static const AppColors _fallback = AppColors(
    dark: Color(0xFF061226),
    card: Color(0xFF00403D),
    text: Color(0xFFFFFFFF),
    lightText: Color(0x99FFFFFF),
    disabledText: Color(0x66FFFFFF),
    disabled: Color(0x66061226),
  );

  AppColors get appColors => Theme.of(this).extension<AppColors>() ?? _fallback;
}