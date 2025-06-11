import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velvet_hands_opal_flow_227a/vhof/vhof_dok.dart';
import 'package:velvet_hands_opal_flow_227a/vhof/vhof_moti.dart';
import 'package:velvet_hands_opal_flow_227a/vhof/vhof_url.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = false;
  bool showRequestDialog = false;
  bool showDeniedDialog = false;

  void _handleToggle(bool value) {
    if (value) {
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          showRequestDialog = true;
        });
      });
    } else {
      setState(() => notificationsEnabled = false);
    }
  }

  void _denyAccess() {
    setState(() {
      showRequestDialog = false;
      showDeniedDialog = true;
    });
  }

  void _cancelDenied() {
    setState(() {
      showDeniedDialog = false;
      notificationsEnabled = false;
    });
  }

  void _confirmPermission() {
    setState(() {
      showRequestDialog = false;
      notificationsEnabled = true;
    });
  }

  void _goToSettings() {
    setState(() {
      showDeniedDialog = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  _NotificationSwitch(
                    value: notificationsEnabled,
                    onChanged: _handleToggle,
                  ),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                      childAspectRatio: 1.3,
                      children: [
                        VhofMotiiButT(onPressed:(){vhofUrl(context, VhofDokum.seepr);},child:_SettingsTile(icon: 'assets/icons/restore.svg', title: 'Restore')),
                        VhofMotiiButT(onPressed:(){vhofUrl(context, VhofDokum.popps);},child:_SettingsTile(icon: 'assets/icons/priv.svg', title: 'Privacy Policy')),
                         VhofMotiiButT(onPressed: (){vhofUrl(context, VhofDokum.spees);},child:  _SettingsTile(icon: 'assets/icons/supp.svg', title: 'Support')),
                         VhofMotiiButT(onPressed: (){vhofUrl(context, VhofDokum.trend);}, child:  _SettingsTile(icon: 'assets/icons/teus.svg', title: 'Term of Use')),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showRequestDialog)
          _BlurDialog(
            title: '“Velvet Hands - Opal Flow” Would Like to Send You Push Notifications',
            subtitle: 'Turn on notifications to help you remember to take care of your hands',
            primaryText: "Don't Allow",
            secondaryText: 'OK',
            onPrimary: _denyAccess,
            onSecondary: _confirmPermission,
          ),
        if (showDeniedDialog)
          _BlurDialog(
            title: 'Access to Push Notifications has been denied',
            subtitle: 'Allow access in Settings. Turn on notifications to help you remember to take care of your hands',
            primaryText: 'Cancel',
            secondaryText: 'Settings',
            onPrimary: _cancelDenied,
            onSecondary: _goToSettings,
          )
      ],
    );
  }
}

class _NotificationSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationSwitch({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:BoxDecoration(color: Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.all(14.r),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Enable push notifications',
            style: TextStyle(fontSize: 16.sp, color: Colors.black),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blue,
            inactiveThumbColor: Colors.white,
          )
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String icon;
  final String title;

  const _SettingsTile({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(icon, width: 28.w, height: 28.h),
          SizedBox(height: 12.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class _BlurDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String primaryText;
  final String secondaryText;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;

  const _BlurDialog({
    required this.title,
    required this.subtitle,
    required this.primaryText,
    required this.secondaryText,
    required this.onPrimary,
    required this.onSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: Container(
        color: Colors.black26,
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 32.w),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 12.h),
                Text(subtitle, textAlign: TextAlign.center, style: TextStyle(fontSize: 14.sp, color: Colors.black87)),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(onPressed: onPrimary, child: Text(primaryText, style: const TextStyle(color: Colors.blue))),
                    TextButton(onPressed: onSecondary, child: Text(secondaryText, style: const TextStyle(color: Colors.blue))),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
