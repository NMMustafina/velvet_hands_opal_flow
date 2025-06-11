import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/producty_model.dart';

class ReminderProductPicker extends StatelessWidget {
  final ProductyModel? selectedProduct;
  final VoidCallback onTap;

  const ReminderProductPicker({
    super.key,
    required this.selectedProduct,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: const Color(0xFFF6F6F6),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  selectedProduct?.nameee ??
                      'Select a product from the catalog',
                  style: TextStyle(
                    color: selectedProduct == null ? Colors.grey : Colors.black,
                    fontSize: 16.sp,
                  ),
                  maxLines: null,
                ),
              ),
              const SizedBox(width: 12),
              const Center(
                child: Icon(Icons.chevron_right, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
