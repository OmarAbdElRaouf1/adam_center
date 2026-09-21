import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension WidgetExtension on Widget {
  Widget addPadding() => Padding(padding: EdgeInsets.all(8.0.w), child: this);
}
