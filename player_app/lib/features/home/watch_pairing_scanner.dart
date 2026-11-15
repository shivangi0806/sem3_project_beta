
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:player_app/core/service/api_service.dart';

import '../../core/models/user.dart';

class WatchPairingScanner extends StatefulWidget {
  final UserSession session;

  const WatchPairingScanner({
    super.key,
    required this.session,
  });

  @override
  State<WatchPairingScanner> createState() =>
      _WatchPairingScannerState();
}

class _WatchPairingScannerState
    extends State<WatchPairingScanner> {
  final MobileScannerController _scannerController =
      MobileScannerController();

  final ApiService _apiService = ApiService();

  bool _isProcessing = false;
  String? _errorMessage;

  Future<void> _handleQRCode(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final rawValue = capture.barcodes.first.rawValue;

    if (rawValue == null || rawValue.isEmpty) return;

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      final decoded = jsonDecode(rawValue);

      if (decoded is! Map ||
          decoded['watchId'] == null ||
          decoded['pairingToken'] == null) {
        throw Exception('Invalid FitLink QR code.');
      }

      final watchId = decoded['watchId'].toString();
      final pairingToken = decoded['pairingToken'].toString();

      await _scannerController.stop();

      final result = await _apiService.verifyWatchPairing(
        watchId: watchId,
        pairingToken: pairingToken,
        accessToken: widget.session.accessToken,
      );

      if (result['success'] != true) {
        throw Exception(
          result['message'] ?? 'Watch pairing failed.',
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Watch paired successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString().replaceFirst(
          'Exception: ',
          '',
        );
        _isProcessing = false;
      });

      await _scannerController.start();
    }
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1929),
      appBar: AppBar(
        title: const Text('Pair Your Watch'),
        backgroundColor: const Color(0xFF0A1929),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Scan the QR code displayed on your FitLink watch.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: MobileScanner(
                    controller: _scannerController,
                    onDetect: _handleQRCode,
                  ),
                ),
              ),
            ),

            if (_isProcessing)
              const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(
                  color: Color(0xFF75B8FF),
                ),
              ),

            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.orangeAccent,
                  ),
                ),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
