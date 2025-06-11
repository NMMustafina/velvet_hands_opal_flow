import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/comparison_entry.dart';

class ComparisonHeader extends StatelessWidget {
  final ComparisonEntry entry;

  const ComparisonHeader({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    const options = ['Worse', 'No change', 'Better'];
    final result = entry.result;

    return Row(
      children: [
        CircleAvatar(
          backgroundImage: FileImage(File(entry.photoPath)),
          radius: 24.r,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: options.map((e) {
                final isSelected = e == result;
                return Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF3DC6FF)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Text(
                        e,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal,
                          color: isSelected ? Colors.white : Colors.black,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
