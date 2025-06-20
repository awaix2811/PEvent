import 'package:event_hub/chat_bot/chatbot.dart';
import 'package:event_hub/constant/assets/assets.dart';
import 'package:event_hub/constant/colors/colors.dart';
import 'package:event_hub/controllers/auth_controller.dart';
import 'package:event_hub/controllers/event_detail_controller.dart';
import 'package:event_hub/controllers/home_controller.dart';
import 'package:event_hub/controllers/user_controller.dart';
import 'package:event_hub/views/all_events_screen.dart';
import 'package:event_hub/views/event_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// ✅ Added Chat Screen import
import 'package:event_hub/chat_bot/chatbot.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthController authController = Get.put(AuthController());
  final EventDetailController eventsController =
      Get.put(EventDetailController());
  final UserController userController = Get.put(UserController());
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 44.h),
              decoration: BoxDecoration(
                  color: AppColors.blueColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(33.r),
                      bottomRight: Radius.circular(33.r))),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  children: [
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            scaffoldKey.currentState?.openDrawer();
                          },
                          child: SvgPicture.asset(ImageAssets.drawerIcon),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text('Current Location',
                                    style: GoogleFonts.nunito(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.aWhiteColor)),
                                const Icon(Icons.arrow_drop_down_outlined,
                                    color: AppColors.whiteColor)
                              ],
                            ),
                            Text('Pakistan',
                                style: GoogleFonts.nunito(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.whiteColor))
                          ],
                        ),
                        SvgPicture.asset(ImageAssets.msgIcon)
                      ],
                    ),
                    SizedBox(height: 22.h),
                    Row(
                      children: [
                        SvgPicture.asset(ImageAssets.searchIcon),
                        SizedBox(width: 12.w),
                        Container(
                          width: 1.w,
                          height: 17.h,
                          decoration:
                              BoxDecoration(color: AppColors.aWhiteColor),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: TextFormField(
                            controller: homeController.searchController,
                            keyboardType: TextInputType.text,
                            style: GoogleFonts.nunito(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.whiteColor),
                            decoration: InputDecoration(
                                hintText: 'Search...',
                                hintStyle: GoogleFonts.nunito(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        AppColors.aWhiteColor.withOpacity(0.4)),
                                border: InputBorder.none),
                            onChanged: (value) {
                              homeController.performSearch(
                                  value, eventsController.events);
                            },
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                Get.to(() => AllEventsScreen(
                                      initialSearchQuery: value,
                                    ));
                              }
                            },
                          ),
                        ),
                        Obx(() => homeController.isSearching.value
                            ? GestureDetector(
                                onTap: () {
                                  homeController.clearSearch();
                                },
                                child: Icon(Icons.close,
                                    color: AppColors.whiteColor, size: 20.sp),
                              )
                            : const SizedBox.shrink()),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: () {
                            if (homeController
                                .searchController.text.isNotEmpty) {
                              Get.to(() => AllEventsScreen(
                                  initialSearchQuery:
                                      homeController.searchController.text));
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: AppColors.aWhiteColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(Icons.search,
                                color: AppColors.whiteColor, size: 20.sp),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Obx(() => homeController.isSearching.value
                ? _buildSearchResults()
                : _buildRegularContent()),
          ],
        ),
      ),

      // ✅ Floating button to open chatbot
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => ChatBot()));
        },
        backgroundColor: AppColors.blueColor,
        child: Icon(Icons.chat),
        tooltip: 'Open AI Chatbot',
      ),

      drawer: Drawer(
        width: 242.w,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 66.h),
              userController.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: AppColors.blueColor,
                    ))
                  : Column(children: [
                      CircleAvatar(
                        maxRadius: 48,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: userController.user.isNotEmpty &&
                                userController.user["imageUrl"] != null &&
                                userController.user["imageUrl"]
                                    .toString()
                                    .isNotEmpty
                            ? NetworkImage(userController.user["imageUrl"])
                            : const AssetImage("assets/images/profile-img.png")
                                as ImageProvider,
                        onBackgroundImageError: (exception, stackTrace) {
                          print("Error loading profile image: $exception");
                        },
                      ),
                    ]),
              SizedBox(height: 6.h),
              Text(
                userController.user.isNotEmpty &&
                        userController.user["name"] != null
                    ? userController.user["name"]
                    : "No Name",
                style: GoogleFonts.nunito(
                    fontSize: 21.sp,
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 55.h),
              drawerItem(ImageAssets.drawerProIcon, 'My Profile'),
              drawerItem(ImageAssets.msgIcon, 'Message'),
              drawerItem(ImageAssets.drawerCalIcon, 'Calender'),
              drawerItem(ImageAssets.drawerConIcon, 'Contact Us'),
              drawerItem(ImageAssets.drawerSettingIcon, 'Settings'),
              drawerItem(ImageAssets.drawerHelpIcon, 'Helps & FAQs'),
              SizedBox(height: 44.h),
              GestureDetector(
                onTap: () {
                  authController.logout();
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      ImageAssets.drawerSignOutIcon,
                      color: Colors.red,
                    ),
                    SizedBox(width: 9.w),
                    Text(
                      'Sign Out',
                      style: GoogleFonts.nunito(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.red),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawerItem(String icon, String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 44.h),
      child: Row(
        children: [
          SvgPicture.asset(icon, color: AppColors.cGreyColor),
          SizedBox(width: 9.w),
          Text(
            label,
            style: GoogleFonts.nunito(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.blackColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    // ... your search results code (as in your original)
    return SizedBox(); // placeholder
  }

  Widget _buildRegularContent() {
    // ... your regular content code (as in your original)
    return SizedBox(); // placeholder
  }
}
