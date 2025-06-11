import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReminderDaysSelector extends StatelessWidget {
  final Set<int> selectedDays;
  final ValueChanged<int> onToggleDay;

  const ReminderDaysSelector({
    super.key,
    required this.selectedDays,
    required this.onToggleDay,
  });

  @override
  Widget build(BuildContext context) {
    final labels = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

    return Wrap(
      spacing: 8.w,
      children: List.generate(7, (i) {
        final day = i + 1;
        final selected = selectedDays.contains(day);

        return GestureDetector(
          onTap: () => onToggleDay(day),
          child: Container(
            width: 40.w,
            height: 40.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFF6F6F6) : Colors.transparent,
              border: Border.all(
                color: selected
                    ? const Color(0xFF3DC6FF)
                    : const Color(0xFFCCCCCC),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              labels[i],
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: selected ? const Color(0xFF3DC6FF) : Colors.black,
              ),
            ),
          ),
        );
      }),
    );
  }
}
