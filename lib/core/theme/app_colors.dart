import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color dark;
  final Color card;
  final Color text;
  final Color lightText;
  final Color disabledText;
  final Color disabled;

  const AppColors({
    required this.dark,
    required this.card,
    required this.text,
    required this.lightText,
    required this.disabledText,
    required this.disabled,
  });

  @override
  AppColors copyWith({
    Color? dark,
    Color? card,
    Color? text,
    Color? lightText,
    Color? disabledText,
    Color? disabled,
  }) {
    return AppColors(
      dark: dark ?? this.dark,
      card: card ?? this.card,
      text: text ?? this.text,
      lightText: lightText ?? this.lightText,
      disabledText: disabledText ?? this.disabledText,
      disabled: disabled ?? this.disabled,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      dark: Color.lerp(dark, other.dark, t)!,
      card: Color.lerp(card, other.card, t)!,
      text: Color.lerp(text, other.text, t)!,
      lightText: Color.lerp(lightText, other.lightText, t)!,
      disabledText: Color.lerp(disabledText, other.disabledText, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
    );
  }
}
