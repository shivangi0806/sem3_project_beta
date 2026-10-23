
import 'package:flutter/material.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

class WatchConnectionTest extends StatefulWidget {
  const WatchConnectionTest({super.key});

  @override
  State<WatchConnectionTest> createState() =>
      _WatchConnectionTestState();
}

class _WatchConnectionTestState
    extends State<WatchConnectionTest> {
  final WatchConnectivity _watchConnectivity = WatchConnectivity();

  String _status = 'Ready to send';
  bool _sending = false;

  // Future<void> _sendTestMessage() async {
  //   setState(() {
  //     _sending = true;
  //     _status = 'Sending test message...';
  //   });

  //   try {
  //     await _watchConnectivity.sendMessage({
  //       'type': 'connection_test',
  //       'message': 'Hello from FitLink Watch!',
  //       'timestamp': DateTime.now().toIso8601String(),
  //     });

  //     if (!mounted) return;
  //     setState(() {
  //       _status = 'Send requested. Check the phone.';
  //     });
  //   } catch (error) {
  //     if (!mounted) return;
  //     setState(() {
  //       _status = 'Error: $error';
  //     });
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         _sending = false;
  //       });
  //     }
  //   }
  // }
  
Future<void> _sendTestMessage() async {
  setState(() {
    _sending = true;
    _status = 'Checking connection...';
  });

  try {
    final supported = await _watchConnectivity.isSupported;
    final paired = await _watchConnectivity.isPaired;
    final reachable = await _watchConnectivity.isReachable;

    debugPrint('WATCH DIAGNOSTICS:');
    debugPrint('Supported: $supported');
    debugPrint('Paired: $paired');
    debugPrint('Reachable: $reachable');

    final message = {
      'type': 'connection_test',
      'message': 'Hello from FitLink Watch!',
      'timestamp': DateTime.now().toIso8601String(),
    };
     debugPrint('SENDING TEST MESSAGE: $message');
    debugPrint('Sending: $message');
    await _watchConnectivity.sendMessage(message);

    if (!mounted) return;
    setState(() {
      _status =
          'Supported: $supported\n'
          'Paired: $paired\n'
          'Reachable: $reachable\n'
          'Send call completed. Check phone.';
    });
  } catch (error, stackTrace) {
    debugPrint('WATCH SEND ERROR: $error');
    debugPrintStack(stackTrace: stackTrace);

    if (!mounted) return;
    setState(() {
      _status = 'Send failed:\n$error';
    });
  } finally {
    if (mounted) {
      setState(() => _sending = false);
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FitLink Watch Test')),
    //   body: Center(

    //     child: Padding(
    //       padding: const EdgeInsets.all(16),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Text(
    //             _status,
    //             textAlign: TextAlign.center,
    //           ),
    //           const SizedBox(height: 24),
    //           ElevatedButton(
    //             onPressed: _sending ? null : _sendTestMessage,
    //             child: Text(
    //               _sending ? 'Sending...' : 'Send Test Message',
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
        
body: SafeArea(
  child: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _status,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _sending ? null : _sendTestMessage,
              
              child: Text(
                _sending ? 'Sending...' : 'Send Test',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11),
              ),
            ),
          ),
          
        ],
      ),
    ),
  ),
),

  );}
}
