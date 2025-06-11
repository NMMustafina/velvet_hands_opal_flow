import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:velvet_hands_opal_flow_227a/services/notification_service.dart';
import 'package:velvet_hands_opal_flow_227a/vhof/vhof_boar.dart';
import 'package:velvet_hands_opal_flow_227a/vhof/vhof_color.dart';

import 'models/comparison_entry.dart';
import 'models/producty_model.dart';
import 'models/reminder_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ProductyModelAdapter());
  Hive.registerAdapter(ReminderModelAdapter());
  Hive.registerAdapter(ComparisonEntryAdapter());

  final proodd = await Hive.openBox<ProductyModel>('proodd');
  final remind = await Hive.openBox<ReminderModel>('remind');
  final comparison = await Hive.openBox<ComparisonEntry>('comparison');

  GetIt.I.registerSingleton<Box<ProductyModel>>(proodd);
  GetIt.I.registerSingleton<Box<ReminderModel>>(remind);
  GetIt.I.registerSingleton<Box<ComparisonEntry>>(comparison);

  await NotificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AntiqueLedger - Precious Opus',
        theme: ThemeData(
          brightness: Brightness.light,
          appBarTheme: const AppBarTheme(
            backgroundColor: VHOFColor.bg,
            iconTheme: IconThemeData(
              color: VHOFColor.white,
            ),
          ),
          scaffoldBackgroundColor: VHOFColor.bg,
          fontFamily: 'Inter',
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
        ),
        home: const OnboardingScreen(),
      ),
    );
  }
}
