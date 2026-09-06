import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'otp_box.dart';

class OtpBoxRow extends StatelessWidget {
  const OtpBoxRow({
    super.key,
    required this.length,
    required this.controllers,
    required this.focusNodes,
    required this.onChanged,
  });

  final int length;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final void Function(int index, String value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          length,
          (index) => OtpBox(
            controller: controllers[index],
            focusNode: focusNodes[index],
            isLast: index == length - 1,
            onChanged: (value) => onChanged(index, value),
          ),
        ),
      ),
    );
  }
}
