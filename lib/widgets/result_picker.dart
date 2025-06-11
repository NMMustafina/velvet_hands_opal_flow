import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultPicker extends StatefulWidget {
  final File file;
  const ResultPicker({super.key, required this.file});

  @override
  State<ResultPicker> createState() => _ResultPickerState();
}

class _ResultPickerState extends State<ResultPicker> {
  String selected = 'No change';

  final List<String> options = ['Worse', 'No change', 'Better'];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24.w),
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select the intermediate result of your hand care',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.normal,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F6F6),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: options.map((e) {
                  final isSelected = selected == e;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selected = e),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
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
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.file(
                widget.file,
                width: 120.w,
                height: 120.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 24.h),
            GestureDetector(
              onTap: () => Navigator.pop(context, selected),
              child: Container(
                alignment: Alignment.center,
                height: 54.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF3DC6FF),
                  borderRadius: BorderRadius.circular(32.r),
                ),
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
