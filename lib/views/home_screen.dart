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

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthController authController = Get.put(AuthController());
  final EventDetailController eventsController =
      Get.put(EventDetailController());
  final UserController userController = Get.put(UserController());

  // Initialize the new HomeController
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
                    SizedBox(
                      height: 12.h,
                    ),
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
                                Text(
                                  'Current Location',
                                  style: GoogleFonts.nunito(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.aWhiteColor),
                                ),
                                const Icon(
                                  Icons.arrow_drop_down_outlined,
                                  color: AppColors.whiteColor,
                                )
                              ],
                            ),
                            Text(
                              'Pakistan',
                              style: GoogleFonts.nunito(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.whiteColor),
                            )
                          ],
                        ),
                        SvgPicture.asset(ImageAssets.msgIcon)
                      ],
                    ),
                    SizedBox(
                      height: 22.h,
                    ),
                    // Updated search bar with HomeController
                    Row(
                      children: [
                        SvgPicture.asset(ImageAssets.searchIcon),
                        SizedBox(
                          width: 12.w,
                        ),
                        Container(
                          width: 1.w,
                          height: 17.h,
                          decoration:
                              BoxDecoration(color: AppColors.aWhiteColor),
                        ),
                        SizedBox(
                          width: 12.w,
                        ),
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
                        // Clear button when searching
                        Obx(() => homeController.isSearching.value
                            ? GestureDetector(
                                onTap: () {
                                  homeController.clearSearch();
                                },
                                child: Icon(
                                  Icons.close,
                                  color: AppColors.whiteColor,
                                  size: 20.sp,
                                ),
                              )
                            : const SizedBox.shrink()),
                        SizedBox(width: 8.w),
                        // Search button
                        GestureDetector(
                          onTap: () {
                            if (homeController
                                .searchController.text.isNotEmpty) {
                              Get.to(() => AllEventsScreen(
                                    initialSearchQuery:
                                        homeController.searchController.text,
                                  ));
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: AppColors.aWhiteColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.search,
                              color: AppColors.whiteColor,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Show search results when searching
            Obx(() => homeController.isSearching.value
                ? _buildSearchResults()
                : _buildRegularContent()),
          ],
        ),
      ),
      drawer: Drawer(
        width: 242.w,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 66.h,
              ),
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
              SizedBox(
                height: 6.h,
              ),
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
              SizedBox(
                height: 55.h,
              ),
              Row(
                children: [
                  SvgPicture.asset(ImageAssets.drawerProIcon),
                  SizedBox(
                    width: 9.w,
                  ),
                  Text(
                    'My Profile',
                    style: GoogleFonts.nunito(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackColor),
                  )
                ],
              ),
              SizedBox(
                height: 44.h,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    ImageAssets.msgIcon,
                    color: AppColors.cGreyColor,
                  ),
                  SizedBox(
                    width: 9.w,
                  ),
                  Text(
                    'Message',
                    style: GoogleFonts.nunito(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackColor),
                  )
                ],
              ),
              SizedBox(
                height: 44.h,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    ImageAssets.drawerCalIcon,
                    color: AppColors.cGreyColor,
                  ),
                  SizedBox(
                    width: 9.w,
                  ),
                  Text(
                    'Calender',
                    style: GoogleFonts.nunito(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackColor),
                  )
                ],
              ),
              SizedBox(
                height: 44.h,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    ImageAssets.drawerConIcon,
                    color: AppColors.cGreyColor,
                  ),
                  SizedBox(
                    width: 9.w,
                  ),
                  Text(
                    'Contact Us',
                    style: GoogleFonts.nunito(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackColor),
                  )
                ],
              ),
              SizedBox(
                height: 44.h,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    ImageAssets.drawerSettingIcon,
                    color: AppColors.cGreyColor,
                  ),
                  SizedBox(
                    width: 9.w,
                  ),
                  Text(
                    'Settings',
                    style: GoogleFonts.nunito(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackColor),
                  )
                ],
              ),
              SizedBox(
                height: 44.h,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    ImageAssets.drawerHelpIcon,
                    color: AppColors.cGreyColor,
                  ),
                  SizedBox(
                    width: 9.w,
                  ),
                  Text(
                    'Helps & FAQs',
                    style: GoogleFonts.nunito(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackColor),
                  )
                ],
              ),
              SizedBox(
                height: 44.h,
              ),
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
                    SizedBox(
                      width: 9.w,
                    ),
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

  // Method to build search results
  Widget _buildSearchResults() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Search Results',
                style: GoogleFonts.nunito(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
              ),
              Text(
                '${homeController.searchResults.length} found',
                style: GoogleFonts.nunito(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.greyColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Obx(() => homeController.searchResults.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 40.h),
                      Icon(
                        Icons.search_off,
                        size: 48.sp,
                        color: AppColors.greyColor,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'No events match your search',
                        style: GoogleFonts.nunito(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.greyColor,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: homeController.searchResults.length > 4
                      ? 4
                      : homeController.searchResults.length,
                  itemBuilder: (context, index) {
                    final event = homeController.searchResults[index];

                    return GestureDetector(
                      onTap: () {
                        eventsController.setSelectedEvent(event);
                        Get.to(() => EventDetailScreen());
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: AppColors.aWhiteColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: event.imgUrl.isNotEmpty
                                  ? Image.network(
                                      event.imgUrl,
                                      width: 80.w,
                                      height: 80.h,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          ImageAssets.eventImg,
                                          width: 80.w,
                                          height: 80.h,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      ImageAssets.eventImg,
                                      width: 80.w,
                                      height: 80.h,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    event.eventsTitle,
                                    style: GoogleFonts.nunito(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.blackColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    event.eventsName,
                                    style: GoogleFonts.nunito(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.aBlueColor,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        ImageAssets.locationIcon,
                                        height: 12.h,
                                      ),
                                      SizedBox(width: 4.w),
                                      Expanded(
                                        child: Text(
                                          event.address,
                                          style: GoogleFonts.nunito(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.greyColor,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                )),

          // View all button if there are more than 4 results
          Obx(() => homeController.searchResults.length > 4
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => AllEventsScreen(
                              initialSearchQuery:
                                  homeController.searchController.text,
                            ));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: AppColors.blueColor,
                          borderRadius: BorderRadius.circular(22.r),
                        ),
                        child: Text(
                          'View All Results',
                          style: GoogleFonts.nunito(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  // Method to build regular content (when not searching)
  Widget _buildRegularContent() {
    return Column(
      children: [
        SizedBox(height: 33.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming Events',
                style: GoogleFonts.nunito(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blackColor),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => AllEventsScreen());
                },
                child: Text(
                  'See All',
                  style: GoogleFonts.nunito(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.greyColor),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 33.h),
        Obx(() {
          if (eventsController.isLoading.value) {
            return const Center(
                child: CircularProgressIndicator(
              color: AppColors.blueColor,
            ));
          } else if (eventsController.events.isEmpty) {
            return const Center(child: Text('No events available'));
          } else {
            return SizedBox(
              height: 255.h,
              child: ListView.separated(
                itemCount: eventsController.events.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final event = eventsController.events[index];
                  // Parse the event date to extract day and month
                  String day = '';
                  String month = '';
                  try {
                    final dateFormat = DateFormat('dd MMMM yyyy');
                    final date = dateFormat.parse(event.eventsDate);
                    day = DateFormat('dd').format(date);
                    month = DateFormat('MMM').format(date).toUpperCase();
                  } catch (e) {
                    final parts = event.eventsDate.split(' ');
                    if (parts.length >= 2) {
                      day = parts[0];
                      month = parts[1].toUpperCase();
                    }
                  }

                  return GestureDetector(
                    onTap: () {
                      eventsController.setSelectedEvent(event);
                      Get.to(() => EventDetailScreen());
                    },
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: event.imgUrl.isNotEmpty
                                  ? Image.network(
                                      event.imgUrl,
                                      width: 250.w,
                                      height: 150.h,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          ImageAssets.eventImg,
                                          width: 250.w,
                                          height: 150.h,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      ImageAssets.eventImg,
                                      width: 250.w,
                                      height: 150.h,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            Positioned(
                              left: 12.w,
                              top: 7.h,
                              child: Container(
                                padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(12.r)),
                                child: RichText(
                                  text: TextSpan(
                                      text: '$day\n',
                                      style: GoogleFonts.nunito(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.orangeColor),
                                      children: [
                                        TextSpan(
                                            text: month,
                                            style: GoogleFonts.nunito(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.orangeColor)),
                                      ]),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 22.h),
                        SizedBox(
                          width: 250.w,
                          child: Text(
                            event.eventsTitle,
                            style: GoogleFonts.nunito(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.blackColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            SvgPicture.asset(ImageAssets.locationIcon),
                            SizedBox(width: 5.w),
                            SizedBox(
                              width: 225.w,
                              child: Text(
                                event.address,
                                style: GoogleFonts.nunito(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.bBlackColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(width: 22.w);
                },
              ),
            );
          }
        }),
        SizedBox(height: 20.h),
        // Updated invite container with the share functionality
        Container(
          width: 328.w,
          height: 127.h,
          padding: EdgeInsets.all(18.r),
          decoration: BoxDecoration(
              color: AppColors.cyanColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r)),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invite your friends',
                    style: GoogleFonts.nunito(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blackColor),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Grow your circle.',
                    style: GoogleFonts.nunito(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.bGreyColor),
                  ),
                  SizedBox(height: 6.h),
                  // Updated INVITE button with share functionality
                  GestureDetector(
                    onTap: () {
                      homeController.shareApp();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 18.w, vertical: 9.h),
                      decoration: BoxDecoration(
                          color: AppColors.cyanColor,
                          borderRadius: BorderRadius.circular(7.r)),
                      child: Text(
                        'INVITE',
                        style: GoogleFonts.nunito(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.whiteColor),
                      ),
                    ),
                  )
                ],
              ),
              Image.asset(
                ImageAssets.giftImg,
                width: 141.w,
              )
            ],
          ),
        )
      ],
    );
  }
}
