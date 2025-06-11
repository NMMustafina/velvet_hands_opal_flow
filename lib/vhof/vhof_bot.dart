import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velvet_hands_opal_flow_227a/screens/care_screen.dart';
import 'package:velvet_hands_opal_flow_227a/screens/catalog_screen.dart';
import 'package:velvet_hands_opal_flow_227a/screens/comparison_screen.dart';
import 'package:velvet_hands_opal_flow_227a/screens/settings_screen.dart';
import 'package:velvet_hands_opal_flow_227a/screens/wish_screen.dart';

class VhofBotBar extends StatefulWidget {
  const VhofBotBar({super.key, this.indexScr = 0});
  final int indexScr;

  @override
  State<VhofBotBar> createState() => _VhofBotBarState();
}

class _VhofBotBarState extends State<VhofBotBar> {
  late int _currentIndex;

  final List<Widget> screens = const [
    CatalogScreen(),
    CareScreen(),
    WishScreen(),
    ComparisonScreen(),
    SettingsScreen(),
  ];

  final List<String> labels = [
    "Catalog",
    "Care diary",
    "Wish List",
    "Comparison",
    "Settings",
  ];

  final List<String> icons = [
    "assets/icons/catalog.svg",
    "assets/icons/care.svg",
    "assets/icons/wish.svg",
    "assets/icons/comp.svg",
    "assets/icons/settings.svg",
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.indexScr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: Container(
        height: 80.h + MediaQuery.of(context).padding.bottom,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(icons.length, (index) {
            final isSelected = _currentIndex == index;

            return GestureDetector(
              onTap: () => setState(() => _currentIndex = index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10.h),
                  SvgPicture.asset(
                    icons[index],
                    width: 24.w,
                    height: 24.h,
                    colorFilter: ColorFilter.mode(
                      isSelected ? const Color(0xFF52B8F3) : Colors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    labels[index],
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isSelected ? const Color(0xFF52B8F3) : Colors.grey,
                      fontWeight:
                          isSelected ? FontWeight.w500 : FontWeight.normal,
                    ),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
