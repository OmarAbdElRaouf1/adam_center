import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final MobileScannerController controller;

  const ScannerAppBar({super.key, required this.controller});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      title: Text(
        'Scan Barcode'.tr(),
        style: const TextStyle(color: Colors.white),
      ),
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, state, child) {
            return IconButton(
              icon: Icon(
                state.torchState == TorchState.on
                    ? Icons.flash_on
                    : Icons.flash_off,
                color: Colors.white,
              ),
              onPressed: () => controller.toggleTorch(),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
          onPressed: () => controller.switchCamera(),
        ),
      ],
    );
  }
}
