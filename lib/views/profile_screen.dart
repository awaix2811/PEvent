import 'package:event_hub/constant/assets/assets.dart';
import 'package:event_hub/constant/colors/colors.dart';
import 'package:event_hub/controllers/auth_controller.dart';
import 'package:event_hub/controllers/user_controller.dart';
import 'package:event_hub/views/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final UserController controller = Get.put(UserController());
  final AuthController authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.user.isEmpty && !controller.isLoading.value) {
        controller.getUser();
      }
      return Column(
        children: [
          Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 66.h, horizontal: 12.w),
              decoration: BoxDecoration(
                  color: AppColors.blueColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(33.r),
                      bottomRight: Radius.circular(33.r))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.abc,
                    color: Colors.transparent,
                  ),
                  Text(
                    'My Profile',
                    style: GoogleFonts.nunito(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.whiteColor),
                  ),
                  GestureDetector(
                    onTap: () {
                      authController.logout();
                    },
                    child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: const BoxDecoration(
                            color: AppColors.whiteColor,
                            shape: BoxShape.circle),
                        child: SvgPicture.asset(
                          ImageAssets.logOutIcon,
                          color: AppColors.blueColor,
                        )),
                  )
                ],
              )),
          SizedBox(height: 44.h),
          controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(
                  color: AppColors.blueColor,
                ))
              : Column(
                  children: [
                    CircleAvatar(
                      maxRadius: 62,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: controller.user.isNotEmpty &&
                              controller.user["imageUrl"] != null &&
                              controller.user["imageUrl"].toString().isNotEmpty
                          ? NetworkImage(controller.user["imageUrl"])
                          : const AssetImage("assets/images/profile-img.png")
                              as ImageProvider,
                      onBackgroundImageError: (exception, stackTrace) {
                        print("Error loading profile image: $exception");
                      },
                    ),
                    SizedBox(height: 12.h),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => EditProfileScreen());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.user.isNotEmpty &&
                                    controller.user["name"] != null
                                ? controller.user["name"]
                                : "No Name",
                            style: GoogleFonts.nunito(
                                fontSize: 18.sp,
                                color: AppColors.blackColor,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: 12.r),
                          SvgPicture.asset(ImageAssets.editProIcon)
                        ],
                      ),
                    ),
                    SizedBox(height: 33.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Name',
                          style: GoogleFonts.nunito(
                            fontSize: 14.sp,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 12.h),
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.aWhiteColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12.r)),
                        child: TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 19.w),
                              hintText: controller.user.isNotEmpty &&
                                      controller.user["name"] != null
                                  ? controller.user["name"]
                                  : "Not available",
                              hintStyle: GoogleFonts.nunito(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.greyColor),
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Email',
                          style: GoogleFonts.nunito(
                            fontSize: 14.sp,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 12.h),
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.aWhiteColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12.r)),
                        child: TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 19.w),
                              hintText: controller.user.isNotEmpty &&
                                      controller.user["email"] != null
                                  ? controller.user["email"]
                                  : "Not available",
                              hintStyle: GoogleFonts.nunito(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.greyColor),
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Location',
                          style: GoogleFonts.nunito(
                            fontSize: 14.sp,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 12.h),
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.aWhiteColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12.r)),
                        child: TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 19.w),
                              hintText: controller.user.isNotEmpty &&
                                      controller.user["phoneNumber"] != null
                                  ? controller.user["phoneNumber"]
                                  : "Not available",
                              hintStyle: GoogleFonts.nunito(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.greyColor),
                              border: InputBorder.none),
                        ),
                      ),
                    )
                  ],
                )
        ],
      );
    });
  }
}
