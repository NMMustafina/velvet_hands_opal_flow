import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:velvet_hands_opal_flow_227a/screens/select_product_screen.dart';

import '../models/producty_model.dart';
import '../models/reminder_model.dart';
import '../services/notification_service.dart';
import '../widgets/reminder_days_selector.dart';
import '../widgets/reminder_product_picker.dart';
import '../widgets/reminder_time_picker.dart';
import '../widgets/reminder_toggle.dart';

class AddEditReminderPage extends StatefulWidget {
  final ReminderModel? existingReminder;

  const AddEditReminderPage({super.key, this.existingReminder});

  @override
  State<AddEditReminderPage> createState() => _AddEditReminderPageState();
}

class _AddEditReminderPageState extends State<AddEditReminderPage> {
  bool isEnabled = false;
  TimeOfDay selectedTime = TimeOfDay.now();
  final Set<int> selectedDays = {};
  ProductyModel? selectedProduct;
  late final String reminderId;
  late final DateTime createdAt;

  bool get canSave => selectedProduct != null && selectedDays.isNotEmpty;

  DateTime _nextWeekdayDate(int weekday, TimeOfDay time) {
    final now = DateTime.now();
    var result = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    while (result.weekday != weekday || result.isBefore(now)) {
      result = result.add(const Duration(days: 1));
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    if (widget.existingReminder != null) {
      final r = widget.existingReminder!;
      reminderId = r.id;
      createdAt = r.createdAt;
      selectedTime = TimeOfDay(hour: r.hour, minute: r.minute);
      selectedDays.addAll(r.weekdays);
      isEnabled = r.enabled;
      selectedProduct = GetIt.I.get<Box<ProductyModel>>().get(r.productId);
    } else {
      reminderId = const Uuid().v4();
      createdAt = DateTime.now();
    }
  }

  Future<bool> _requestNotificationPermission() async {
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

  void _saveReminder() async {
    if (!canSave || selectedProduct == null) return;

    final allowed = await _requestNotificationPermission();
    if (!allowed) return;

    final reminder = ReminderModel(
      id: reminderId,
      productId: selectedProduct!.id,
      hour: selectedTime.hour,
      minute: selectedTime.minute,
      weekdays: selectedDays.toList()..sort(),
      enabled: isEnabled,
      createdAt: createdAt,
    );

    final box = GetIt.I.get<Box<ReminderModel>>();
    await box.put(reminderId, reminder);

    await NotificationService.cancelNotification(reminderId);

    if (isEnabled) {
      for (final day in selectedDays) {
        final scheduledDate = _nextWeekdayDate(day, selectedTime);
        await NotificationService.scheduleNotification(
          id: reminderId.hashCode + day,
          title: 'Reminder',
          body: 'Time to use ${selectedProduct!.nameee}',
          scheduledDate: scheduledDate,
        );
      }
    }

    if (mounted) Navigator.pop(context, true);
  }

  void _deleteReminder() async {
    final confirm = await showCupertinoDialog<bool>(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Delete reminder?'),
        actions: [
          CupertinoDialogAction(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final box = GetIt.I.get<Box<ReminderModel>>();
      await box.delete(widget.existingReminder!.id);

      for (final day in widget.existingReminder!.weekdays) {
        await NotificationService.cancelNotification(
          (widget.existingReminder!.id.hashCode + day).toString(),
        );
      }

      if (context.mounted) Navigator.pop(context);
    }
  }

  void _pickProduct() async {
    final result = await Navigator.push<ProductyModel>(
      context,
      MaterialPageRoute(builder: (_) => const SelectProductScreen()),
    );

    if (result != null) {
      setState(() => selectedProduct = result);
    }
  }

  void _toggleDay(int day) {
    setState(() {
      if (selectedDays.contains(day)) {
        selectedDays.remove(day);
      } else {
        selectedDays.add(day);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingReminder != null;

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Center(child: SvgPicture.asset('assets/icons/back.svg')),
        ),
        title: Text(
          isEditing ? 'Edit reminder' : 'Reminder',
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: isEditing
            ? [
                Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: GestureDetector(
                    onTap: _deleteReminder,
                    child: Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF6F6F6),
                      ),
                      child: const Center(
                        child: Icon(
                          CupertinoIcons.trash,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                )
              ]
            : null,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            ReminderToggle(
              isEnabled: isEnabled,
              onChanged: (val) async {
                if (val) {
                  final allowed = await _requestNotificationPermission();
                  if (!allowed) return;
                }
                setState(() => isEnabled = val);
              },
            ),
            SizedBox(height: 12.h),
            ReminderTimePicker(
              selectedTime: selectedTime,
              onTimeChanged: (newTime) {
                setState(() => selectedTime = newTime);
              },
            ),
            SizedBox(height: 16.h),
            ReminderDaysSelector(
              selectedDays: selectedDays,
              onToggleDay: _toggleDay,
            ),
            SizedBox(height: 24.h),
            ReminderProductPicker(
              selectedProduct: selectedProduct,
              onTap: _pickProduct,
            ),
            const Spacer(),
            GestureDetector(
              onTap: canSave ? _saveReminder : null,
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 54.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.r),
                  color: canSave
                      ? const Color(0xFF3DC6FF)
                      : Colors.blue.withOpacity(0.4),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
