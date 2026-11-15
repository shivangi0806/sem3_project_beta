import 'package:flutter/material.dart';

class AnalyticsContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;
  final IconData? icon;

  const AnalyticsContainer({super.key, required this.title, required this.child, this.trailing, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF132F4C),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: .07)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .12), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          if (icon != null) ...[
            Container(width: 36, height: 36, decoration: BoxDecoration(color: const Color(0xFF5090D3).withValues(alpha: .15), borderRadius: BorderRadius.circular(11)), child: Icon(icon, color: const Color(0xFF79B8FF), size: 19)),
            const SizedBox(width: 11),
          ],
          Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: .1))),
          if (trailing != null) trailing!,
        ]),
        const SizedBox(height: 18),
        Expanded(child: child),
      ]),
    );
  }
}
