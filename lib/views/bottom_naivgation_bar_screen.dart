import 'package:event_hub/constant/assets/assets.dart';
import 'package:event_hub/constant/colors/colors.dart';
import 'package:event_hub/controllers/bottom_navigation_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavigationBarScreen extends StatelessWidget {
  BottomNavigationBarScreen({super.key});
  final BottomNavigationBarController controller =
      Get.put(BottomNavigationBarController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Obx(() {
        return controller.widgetList[controller.selectedIndex.value];
      }),
      bottomNavigationBar: Obx(() => Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
            margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
            decoration: BoxDecoration(
                color: AppColors.aBlueColor,
                borderRadius: BorderRadius.circular(33.r)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Home Nav Item
                GestureDetector(
                  onTap: () => controller.isSelectedIndex(0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // SizedBox(height: 17.h),
                      SvgPicture.asset(ImageAssets.homeIcon,
                          width: 24.w,
                          height: 24.h,
                          color: AppColors.whiteColor),
                      Text('Home',
                          style: GoogleFonts.nunito(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: controller.selectedIndex == 0
                                  ? AppColors.whiteColor
                                  : Colors.transparent))
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: () => controller.isSelectedIndex(1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(ImageAssets.eventIcon,
                          width: 24.w,
                          height: 24.h,
                          color: AppColors.whiteColor),
                      Text('Events',
                          style: GoogleFonts.nunito(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: controller.selectedIndex == 1
                                  ? AppColors.whiteColor
                                  : Colors.transparent))
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => controller.isSelectedIndex(2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(ImageAssets.mapIcon,
                          width: 24.w,
                          height: 24.h,
                          color: AppColors.whiteColor),
                      Text('Map',
                          style: GoogleFonts.nunito(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: controller.selectedIndex == 2
                                  ? AppColors.whiteColor
                                  : Colors.transparent))
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: () => controller.isSelectedIndex(3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(ImageAssets.profileIcon,
                          width: 24.w,
                          height: 24.h,
                          color: AppColors.whiteColor),
                      Text('Profile',
                          style: GoogleFonts.nunito(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: controller.selectedIndex == 3
                                  ? AppColors.whiteColor
                                  : Colors.transparent))
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
