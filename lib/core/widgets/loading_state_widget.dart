import 'package:flutter/material.dart';

import '../constant/app_colors.dart';

/// Generic "fetching data" placeholder — a centered spinner — used wherever
/// a bloc is in its loading state.
class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primaryColor),
    );
  }
}
