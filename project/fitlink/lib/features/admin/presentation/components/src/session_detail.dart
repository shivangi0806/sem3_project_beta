import 'package:flutter/material.dart';

class SessionDetail extends StatelessWidget {
  final String title;
  final String value;

  const SessionDetail({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
