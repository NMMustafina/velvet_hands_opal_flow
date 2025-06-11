import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../models/comparison_entry.dart';
import 'comparison_card.dart';

class ComparisonList extends StatelessWidget {
  final Map<String, List<ComparisonEntry>> grouped;
  final void Function(ComparisonEntry entry) onTap;

  const ComparisonList({
    super.key,
    required this.grouped,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> sections = [];

    for (final entry in grouped.entries) {
      final date = DateFormat('dd.MM.yyyy').format(DateTime.parse(entry.key));

      sections.add(
        Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              date,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      );

      sections.add(
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: entry.value.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: 0.82,
          ),
          itemBuilder: (context, index) {
            final item = entry.value[index];
            return ComparisonCard(
              entry: item,
              onTap: () => onTap(item),
            );
          },
        ),
      );

      sections.add(SizedBox(height: 12.h));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections,
    );
  }
}
