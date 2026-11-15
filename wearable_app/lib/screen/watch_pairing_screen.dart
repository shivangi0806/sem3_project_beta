
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../watch_pairing_service.dart';
import '../theme/theme.dart';

class WatchPairingScreen extends StatefulWidget {
  const WatchPairingScreen({super.key});

  @override
  State<WatchPairingScreen> createState() =>
      _WatchPairingScreenState();
}

class _WatchPairingScreenState
    extends State<WatchPairingScreen> {
  String? qrData;
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    generateQR();
  }

  Future<void> generateQR() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await WatchPairingService.registerWatch();
      final result =
          await WatchPairingService.generatePairingQR();

      if (!mounted) return;

      setState(() {
        qrData = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navyBlue,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'PAIR WATCH',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              if (isLoading)
                const SizedBox(
                  height: 90,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 10,
                    ),
                  ),
                )
              else if (qrData != null)
                QrImageView(
                  data: qrData!,
                  version: QrVersions.auto,
                  size: 100,
                  backgroundColor: Colors.white,
                ),

              const SizedBox(height: 6),

              if (!isLoading && errorMessage == null)
                GestureDetector(
                  onTap: generateQR,
                  child: const Text(
                    'REFRESH QR',
                    style: TextStyle(
                      color: accentBlue,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
