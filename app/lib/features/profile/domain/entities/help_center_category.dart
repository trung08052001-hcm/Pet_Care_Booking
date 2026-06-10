import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class HelpCenterCategory extends Equatable {
  const HelpCenterCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        icon,
      ];
}
