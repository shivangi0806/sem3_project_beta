
import 'package:flutter/material.dart';

class AnalyticsContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const AnalyticsContainer({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
  height: double.infinity,
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: const Color(0xFF132F4C),
    borderRadius: BorderRadius.circular(16),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
      const SizedBox(height: 16),
      child,
    ],
  ),
);
    // return Container(
    //   padding: const EdgeInsets.all(16),
    //   decoration: BoxDecoration(
    //     color: const Color(0xFF132F4C),
    //     borderRadius: BorderRadius.circular(16),
    //   ),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Text(
    //             title,
    //             style: const TextStyle(
    //               color: Colors.white,
    //               fontSize: 17,
    //               fontWeight: FontWeight.w600,
    //             ),
    //           ),
    //           if (trailing != null) trailing!,
    //         ],
    //       ),

    //       const SizedBox(height: 16),

    //       child,
    //     ],
    //   ),
    // );
  }
}
