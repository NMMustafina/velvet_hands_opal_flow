import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velvet_hands_opal_flow_227a/vhof/vhof_bot.dart';
import 'package:velvet_hands_opal_flow_227a/vhof/vhof_dok.dart';
import 'package:velvet_hands_opal_flow_227a/vhof/vhof_moti.dart';
import 'package:velvet_hands_opal_flow_227a/vhof/vhof_url.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardPageData> pages = [
    const _OnboardPageData(
      version: "0.1.2",
      imagePath: "assets/images/board1.png",
      title: "Embrace Handcare Joy",
      description:
      "Discover curated handcare. Track routines, visualize changes and unveil radiant, healthy hands",
      buttonText: "Continue",
    ),
    const _OnboardPageData(
      version: "0.1.3",
      imagePath: "assets/images/board2.png",
      title: "Personalized Routine Planner",
      description:
      "Schedule reminders for perfect application. Maximize product benefits and build personalized handcare habits",
      buttonText: "Continue",
    ),
    const _OnboardPageData(
      version: "0.1.4",
      imagePath: "assets/images/board3.png",
      title: "Transform Your Hands",
      description:
      "Compare images to chart your hands evolution. See progress photos and witness transformation from dry to irresistibly soft",
      buttonText: "Start",
    ),
    const _OnboardPageData(
      version: "0.1.5",
      imagePath: "assets/images/prem.png",
      title: "Upgrade to premium for the full experience just for \$0.99",
      description: "Evaluate products in your catalog\nEvaluate the result of your hand care",
      buttonText: "Get Premium for \$0.99",
    ),
  ];

  void _nextPage() {
    if (_currentPage < pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const VhofBotBar()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        controller: _controller,
        itemCount: pages.length,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemBuilder: (context, index) {
          final page = pages[index];

          if (page.version == "0.1.5") {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const VhofBotBar()),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.all(16.h),
                      child: Image.asset(
                        page.imagePath,
                        width: double.infinity,
                        height: 220.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      page.title,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.chevron_right_rounded, size: 20.sp, color: Colors.blue),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                "Evaluate products in your catalog",
                                style: TextStyle(fontSize: 16.sp, color: Colors.black),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.chevron_right_rounded, size: 20.sp, color: Colors.blue),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                "Evaluate the result of your hand care",
                                style: TextStyle(fontSize: 16.sp, color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 28.h),
                    GestureDetector(
                      onTap: _nextPage,
                      child: Container(
                        width: double.infinity,
                        height: 56.h,
                        decoration: BoxDecoration(
                          color: Color(0xFFFF813D),
                          borderRadius: BorderRadius.circular(28.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          page.buttonText,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        VhofMotiiButT(
                          onPressed: () => vhofUrl(context, VhofDokum.trend),
                          child: Text("Terms of use", style: TextStyle(fontSize: 12.sp, color: Colors.black)),
                        ),
                        Text("Restore Purchase", style: TextStyle(fontSize: 12.sp, color: Colors.black)),
                        VhofMotiiButT(
                          onPressed: () => vhofUrl(context, VhofDokum.popps),
                          child: Text("Privacy Policy", style: TextStyle(fontSize: 12.sp, color: Colors.black)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 8.h),
                  SizedBox(height: 24.h),
                  Text(
                    page.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Expanded(
                    child: Image.asset(
                      page.imagePath,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    page.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 28.h),
                  GestureDetector(
                    onTap: _nextPage,
                    child: Container(
                      width: double.infinity,
                      height: 56.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3DC6FF),
                        borderRadius: BorderRadius.circular(32.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        page.buttonText,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OnboardPageData {
  final String version;
  final String imagePath;
  final String title;
  final String description;
  final String buttonText;

  const _OnboardPageData({
    required this.version,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.buttonText,
  });
}
