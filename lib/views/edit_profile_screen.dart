import 'dart:io';

import 'package:event_hub/constant/assets/assets.dart';
import 'package:event_hub/constant/colors/colors.dart';
import 'package:event_hub/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 22.h),
                // Header with back button and title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: SvgPicture.asset(
                        ImageAssets.backIcon,
                      ),
                    ),
                    Text(
                      'Edit Profile',
                      style: GoogleFonts.nunito(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackColor),
                    ),
                    const Icon(
                      Icons.track_changes,
                      color: Colors.transparent,
                    )
                  ],
                ),
                SizedBox(height: 44.h),

                // Profile image section
                Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 12.h),
                      child: GestureDetector(
                        onTap: () {
                          controller.getImage();
                        },
                        child: SizedBox(
                          width: 121.w,
                          height: 122.h,
                          child: Obx(() {
                            // Show loading indicator while uploading
                            if (controller.isLoading.value) {
                              return const CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: CircularProgressIndicator(
                                  color: AppColors.blueColor,
                                ),
                              );
                            }
                            // If there's a local file path, show that image
                            else if (controller.ImagePath.isNotEmpty) {
                              return CircleAvatar(
                                backgroundImage: FileImage(
                                    File(controller.ImagePath.toString())),
                              );
                            }
                            // If there's a remote URL but no local file, show the remote image
                            else if (controller.imageUrl.isNotEmpty) {
                              return CircleAvatar(
                                backgroundImage:
                                    NetworkImage(controller.imageUrl.value),
                              );
                            }
                            // If no image is available, show the default image
                            else {
                              return const CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/images/profile-img.png"),
                              );
                            }
                          }),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 111.h,
                      left: 87.w,
                      child: GestureDetector(
                        onTap: () {
                          controller.getImage();
                        },
                        child: SvgPicture.asset(ImageAssets.cameraIcon),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 22.h),

                // Username field
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Username',
                      style: GoogleFonts.nunito(
                        fontSize: 14.sp,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.greyColor),
                        color: AppColors.whiteColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12.r)),
                    child: TextFormField(
                      controller: controller.userController.nameController,
                      style: GoogleFonts.nunito(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.blackColor),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 19.w),
                          hintText: controller.userController.user['name'] ??
                              'Enter username',
                          hintStyle: GoogleFonts.nunito(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.greyColor),
                          border: InputBorder.none),
                    ),
                  ),
                ),

                // Email field
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.greyColor),
                        color: AppColors.whiteColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12.r)),
                    child: TextFormField(
                      controller: controller.userController.emailController,
                      style: GoogleFonts.nunito(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.blackColor),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 19.w),
                          hintText: controller.userController.user['email'] ??
                              'Enter email',
                          hintStyle: GoogleFonts.nunito(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.greyColor),
                          border: InputBorder.none),
                    ),
                  ),
                ),

                // Location field
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.greyColor),
                        color: AppColors.whiteColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12.r)),
                    child: TextFormField(
                      controller: controller.userController.phoneController,
                      style: GoogleFonts.nunito(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.blackColor),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 19.w),
                          hintText:
                              controller.userController.user['phoneNumber'] ??
                                  'Enter location',
                          hintStyle: GoogleFonts.nunito(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.greyColor),
                          border: InputBorder.none),
                    ),
                  ),
                ),

                // Save button
                Padding(
                  padding:
                      EdgeInsets.only(right: 12.w, top: 12.h, bottom: 20.h),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () {
                        controller.updateUser();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 33.w, vertical: 12.h),
                        decoration: BoxDecoration(
                            color: AppColors.blueColor,
                            borderRadius: BorderRadius.circular(12.r)),
                        child: Obx(
                          () => controller.isLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Save',
                                  style: GoogleFonts.nunito(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.whiteColor),
                                ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
