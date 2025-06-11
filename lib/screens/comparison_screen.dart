import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

import '../models/comparison_entry.dart';
import '../widgets/comparison_header.dart';
import '../widgets/comparison_list.dart';
import '../widgets/photo_source_picker.dart';
import '../widgets/result_picker.dart';

class ComparisonScreen extends StatefulWidget {
  const ComparisonScreen({super.key});

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  late Box<ComparisonEntry> box;
  ComparisonEntry? lastEntry;

  @override
  void initState() {
    super.initState();
    box = GetIt.I.get<Box<ComparisonEntry>>();
    lastEntry = box.isNotEmpty ? box.values.last : null;
  }

  void _showPhotoPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => PhotoSourcePicker(onSelected: _handlePickedFile),
    );
  }

  Future<void> _handlePickedFile(File file) async {
    final result = await _showResultPicker(file);
    if (result == null) return;

    final entry = ComparisonEntry(
      id: DateTime.now().toIso8601String(),
      photoPath: file.path,
      result: result,
      createdAt: DateTime.now(),
    );

    await box.put(entry.id, entry);
    setState(() => lastEntry = entry);
  }

  Future<String?> _showResultPicker(File file) async {
    return showCupertinoModalPopup<String>(
      context: context,
      builder: (_) => ResultPicker(file: file),
    );
  }

  Map<String, List<ComparisonEntry>> _groupByDate() {
    final entries = box.values.toList();
    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final map = <String, List<ComparisonEntry>>{};
    for (final e in entries) {
      final date = DateFormat('yyyy-MM-dd').format(e.createdAt);
      map.putIfAbsent(date, () => []).add(e);
    }
    return map;
  }

  void _openDetail(ComparisonEntry entry) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Scaffold(
        backgroundColor: Colors.black.withOpacity(0.9),
        body: Stack(
          children: [
            Center(
              child: Image.file(
                File(entry.photoPath),
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            ),
            Positioned(
              top: 48.h,
              left: 20.w,
              child: GestureDetector(
                onTap: () async {
                  final confirm = await showCupertinoDialog<bool>(
                    context: context,
                    builder: (_) => CupertinoAlertDialog(
                      title: const Text(
                        'Delete photo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      actions: [
                        CupertinoDialogAction(
                          isDefaultAction: true,
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xFF007AFF),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context, false),
                        ),
                        CupertinoDialogAction(
                          isDestructiveAction: true,
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                              color: Color(0xFF007AFF),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context, true),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    Navigator.pop(context);
                    await box.delete(entry.id);
                    setState(() =>
                        lastEntry = box.isNotEmpty ? box.values.last : null);
                  }
                },
                child: _iconCircle(CupertinoIcons.trash, CupertinoColors.black),
              ),
            ),
            Positioned(
              top: 48.h,
              right: 20.w,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: _iconCircle(CupertinoIcons.xmark, CupertinoColors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconCircle(IconData icon, Color color) {
    return Container(
      width: 40.r,
      height: 40.r,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(icon, color: color, size: 22.r),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Comparison',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        actions: [
          GestureDetector(
            onTap: _showPhotoPicker,
            child: Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: SvgPicture.asset('assets/icons/add.svg'),
            ),
          )
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<ComparisonEntry> box, _) {
          if (box.isEmpty) {
            return Image.asset(
              'assets/images/comparison.png',
              fit: BoxFit.contain,
              width: double.infinity,
            );
          }

          final grouped = _groupByDate();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (lastEntry != null) ...[
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                  child: ComparisonHeader(entry: lastEntry!),
                ),
                SizedBox(height: 12.h),
              ],
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  children: [
                    ComparisonList(
                      grouped: grouped,
                      onTap: _openDetail,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
