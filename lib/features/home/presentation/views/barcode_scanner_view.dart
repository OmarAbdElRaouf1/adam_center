import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:the_one_test/features/home/presentation/widgets/scanner_app_bar.dart';
import 'package:the_one_test/features/home/presentation/widgets/scanner_instructions_banner.dart';
import 'package:the_one_test/features/home/presentation/widgets/scanner_overlay_painter.dart';

// Pops with the scanned code as the route result — the caller (Home) is
// responsible for feeding it into its own search, matching how this app's
// search already lives inline on Home rather than as a separate screen.
class BarcodeScannerView extends StatefulWidget {
  const BarcodeScannerView({super.key});

  @override
  State<BarcodeScannerView> createState() => _BarcodeScannerViewState();
}

class _BarcodeScannerViewState extends State<BarcodeScannerView> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  bool _isProcessing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? code = barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;

    setState(() => _isProcessing = true);
    Navigator.pop(context, code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: ScannerAppBar(controller: _controller),
      body: Stack(
        children: [
          MobileScanner(controller: _controller, onDetect: _onBarcodeDetected),
          CustomPaint(
            painter: ScannerOverlay(),
            child: const SizedBox.expand(),
          ),
          const ScannerInstructionsBanner(),
        ],
      ),
    );
  }
}
