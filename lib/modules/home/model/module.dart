import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Module extends Equatable {
  const Module({
    required this.child,
    required this.label,
    required this.icon,
  });

  final Widget child;
  final String label;
  final IconData icon;

  @override
  List<Object?> get props => [child, label, icon];
}
