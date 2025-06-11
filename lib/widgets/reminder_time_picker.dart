import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReminderTimePicker extends StatelessWidget {
  final TimeOfDay selectedTime;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const ReminderTimePicker({
    super.key,
    required this.selectedTime,
    required this.onTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final initialDateTime = DateTime(
      2023,
      1,
      1,
      selectedTime.hour,
      selectedTime.minute,
    );

    return Container(
      height: 180.h,
      margin: EdgeInsets.only(top: 8.h),
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.time,
        initialDateTime: initialDateTime,
        use24hFormat: false,
        onDateTimeChanged: (DateTime newDateTime) {
          onTimeChanged(TimeOfDay.fromDateTime(newDateTime));
        },
      ),
    );
  }
}
