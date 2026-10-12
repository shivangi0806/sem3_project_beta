import 'package:flutter/material.dart';

class EmptyPrivileges extends StatelessWidget {
  const EmptyPrivileges({required this.searching});

  final bool searching;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 42, horizontal: 16),
      child: Column(
        children: [
          Icon(
            searching ? Icons.search_off : Icons.shield_outlined,
            size: 42,
            color: Colors.white38,
          ),
          const SizedBox(height: 12),
          Text(
            searching ? 'No matching privileges' : 'No privileges yet',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            searching
                ? 'Try another name, description, or category.'
                : 'Add a privilege to start defining admin access.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white60),
          ),
        ],
      ),
    );
  }
}
