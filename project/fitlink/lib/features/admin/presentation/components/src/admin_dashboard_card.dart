import 'package:flutter/material.dart';

class AdminDashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;

  const AdminDashboardCard({
    super.key,
    required this.title,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        constraints: const BoxConstraints(minHeight: 120),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
