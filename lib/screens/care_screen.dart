import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:velvet_hands_opal_flow_227a/screens/add_edit_reminder_page.dart';

import '../models/producty_model.dart';
import '../models/reminder_model.dart';
import '../services/notification_service.dart';

class CareScreen extends StatelessWidget {
  const CareScreen({super.key});

  String _formatTime(BuildContext context, int hour, int minute) {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String _formatDays(List<int> days) {
    const labels = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

    if (days.length == 7) return 'Daily';
    if (Set.from(days).containsAll([1, 2, 3, 4, 5]) && days.length == 5) {
      return 'Weekdays';
    }

    return days.map((d) => labels[d - 1]).join(', ');
  }

  Future<bool> _requestNotificationPermission(BuildContext context) async {
    final result = await Permission.notification.request();

    if (result.isGranted) return true;

    await showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Notifications are disabled'),
        content: const Text('Please enable them in system settings'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Open settings'),
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
            },
          ),
        ],
      ),
    );

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final reminderBox = GetIt.I.get<Box<ReminderModel>>();
    final productBox = GetIt.I.get<Box<ProductyModel>>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Care diary',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddEditReminderPage(),
                ),
              );
            },
            child: SvgPicture.asset('assets/icons/add.svg'),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: reminderBox.listenable(),
        builder: (context, Box<ReminderModel> box, _) {
          final reminders = box.values.toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          if (reminders.isEmpty) {
            return Image.asset(
              'assets/images/diary.png',
              fit: BoxFit.contain,
              width: double.infinity,
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: reminders.length,
            itemBuilder: (_, index) {
              final reminder = reminders[index];
              final product = productBox.get(reminder.productId);

              return GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AddEditReminderPage(existingReminder: reminder),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product!.nameee,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Row(
                        children: [
                          Row(
                            children: [
                              Text(
                                _formatTime(
                                    context, reminder.hour, reminder.minute),
                                style: TextStyle(fontSize: 24.sp),
                              ),
                              if (reminder.enabled) ...[
                                SizedBox(width: 8.w),
                                Icon(
                                  Icons.notifications,
                                  size: 20.sp,
                                  color: const Color(0xFF3DC6FF),
                                ),
                              ],
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Text(
                                _formatDays(reminder.weekdays),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF3DC6FF),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              GestureDetector(
                                onTap: () async {
                                  final val = !reminder.enabled;
                                  final box = GetIt.I.get<Box<ReminderModel>>();

                                  if (val) {
                                    final allowed =
                                        await _requestNotificationPermission(
                                            context);
                                    if (!allowed) return;

                                    for (final day in reminder.weekdays) {
                                      final now = DateTime.now();
                                      final time = TimeOfDay(
                                          hour: reminder.hour,
                                          minute: reminder.minute);
                                      DateTime scheduled = DateTime(
                                          now.year,
                                          now.month,
                                          now.day,
                                          time.hour,
                                          time.minute);
                                      while (scheduled.weekday != day ||
                                          scheduled.isBefore(now)) {
                                        scheduled = scheduled
                                            .add(const Duration(days: 1));
                                      }

                                      await NotificationService
                                          .scheduleNotification(
                                        id: reminder.id.hashCode + day,
                                        title: 'Reminder',
                                        body: 'Time to use ${product.nameee}',
                                        scheduledDate: scheduled,
                                      );
                                    }
                                  } else {
                                    for (final day in reminder.weekdays) {
                                      await NotificationService
                                          .cancelNotification(
                                        (reminder.id.hashCode + day).toString(),
                                      );
                                    }
                                  }

                                  await box.put(
                                    reminder.id,
                                    ReminderModel(
                                      id: reminder.id,
                                      productId: reminder.productId,
                                      hour: reminder.hour,
                                      minute: reminder.minute,
                                      weekdays: reminder.weekdays,
                                      enabled: val,
                                      createdAt: reminder.createdAt,
                                    ),
                                  );
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 48.w,
                                  height: 28.h,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 4.w),
                                  decoration: BoxDecoration(
                                    color: reminder.enabled
                                        ? const Color(0xFF3DC6FF)
                                        : const Color(0xFF939393),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  alignment: reminder.enabled
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Container(
                                    width: 20.w,
                                    height: 20.w,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
