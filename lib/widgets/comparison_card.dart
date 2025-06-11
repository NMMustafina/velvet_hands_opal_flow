import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/comparison_entry.dart';

class ComparisonCard extends StatelessWidget {
  final ComparisonEntry entry;
  final VoidCallback onTap;

  const ComparisonCard({
    super.key,
    required this.entry,
    required this.onTap,
  });

  Color _getTextColor(String result) {
    switch (result) {
      case 'Better':
        return const Color(0xFF58A919);
      case 'Worse':
        return const Color(0xFFDC3333);
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: const Color(0xFFF6F6F6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.file(
                  File(entry.photoPath),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Text(
                entry.result,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: _getTextColor(entry.result),
                  decoration: TextDecoration.none,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
