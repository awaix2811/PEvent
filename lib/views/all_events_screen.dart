import 'package:event_hub/constant/assets/assets.dart';
import 'package:event_hub/constant/colors/colors.dart';
import 'package:event_hub/controllers/event_detail_controller.dart';
import 'package:event_hub/models/events_detail_model.dart';
import 'package:event_hub/views/event_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AllEventsScreen extends StatelessWidget {
  final String? initialSearchQuery;

  AllEventsScreen({super.key, this.initialSearchQuery});

  final EventDetailController eventsController =
      Get.find<EventDetailController>();
  final TextEditingController searchController = TextEditingController();
  final RxList<Event> filteredEvents = <Event>[].obs;
  final RxBool isFiltering = false.obs;

  void filterEvents(String query) {
    if (query.isEmpty && !isFiltering.value) {
      filteredEvents.value = eventsController.events;
    } else {
      filteredEvents.value = eventsController.events.where((event) {
        return event.eventsTitle.toLowerCase().contains(query.toLowerCase()) ||
            event.eventsName.toLowerCase().contains(query.toLowerCase()) ||
            event.address.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize filtered events with all events
    if (filteredEvents.isEmpty) {
      filteredEvents.value = eventsController.events;

      // Set initial search query if provided
      if (initialSearchQuery != null && initialSearchQuery!.isNotEmpty) {
        searchController.text = initialSearchQuery!;
        filterEvents(initialSearchQuery!);
      }
    }

    // Listen for changes in events list
    ever(eventsController.events, (_) {
      filterEvents(searchController.text);
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),

              // Back button and title
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: SvgPicture.asset(ImageAssets.backIcon),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Search',
                    style: GoogleFonts.nunito(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blackColor,
                    ),
                  )
                ],
              ),

              SizedBox(height: 22.h),

              // Search bar
              Row(
                children: [
                  SvgPicture.asset(
                    ImageAssets.searchIcon,
                    color: AppColors.aBlueColor,
                  ),
                  SizedBox(width: 12.w),
                  Container(
                    width: 1.w,
                    height: 17.h,
                    decoration:
                        const BoxDecoration(color: AppColors.aWhiteColor),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: TextFormField(
                      controller: searchController,
                      keyboardType: TextInputType.text,
                      style: GoogleFonts.nunito(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: GoogleFonts.nunito(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.aWhiteColor.withOpacity(0.4),
                        ),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        filterEvents(value);
                      },
                    ),
                  ),

                  // Filter button
                  GestureDetector(
                    onTap: () {
                      isFiltering.value = !isFiltering.value;
                      filterEvents(searchController.text);
                    },
                    child: Obx(() => Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: isFiltering.value
                                ? AppColors.aBlueColor
                                : AppColors.blueColor,
                            borderRadius: BorderRadius.circular(22.r),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(ImageAssets.filterIcon),
                              SizedBox(width: 12.w),
                              Text(
                                'Filters',
                                style: GoogleFonts.nunito(fontSize: 12.sp),
                              )
                            ],
                          ),
                        )),
                  )
                ],
              ),

              SizedBox(height: 33.h),

              // Events list
              Expanded(
                child: Obx(() {
                  if (eventsController.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.blueColor,
                      ),
                    );
                  } else if (eventsController.events.isEmpty) {
                    return const Center(child: Text('No events available'));
                  } else if (filteredEvents.isEmpty) {
                    return const Center(
                        child: Text('No events match your search'));
                  } else {
                    return ListView.separated(
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        Event event = filteredEvents[index];

                        // Format the date and time for display
                        String dateTime = '';
                        try {
                          final dateFormat = DateFormat('dd MMMM yyyy');
                          final date = dateFormat.parse(event.eventsDate);
                          dateTime = DateFormat('d MMM - EEE').format(date);

                          // Extract time from the event day if available
                          if (event.eventsDay.contains('PM') ||
                              event.eventsDay.contains('AM')) {
                            final timeRegex = RegExp(r'\d+:\d+\s*(AM|PM)');
                            final match = timeRegex.firstMatch(event.eventsDay);
                            if (match != null) {
                              dateTime += ' - ${match.group(0)}';
                            }
                          }
                        } catch (e) {
                          dateTime = event.eventsDate;
                        }

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
                                          width: 109.w,
                                          height: 122.h,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              ImageAssets.jazzImg,
                                              width: 109.w,
                                              height: 122.h,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        )
                                      : Image.asset(
                                          ImageAssets.jazzImg,
                                          width: 109.w,
                                          height: 122.h,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dateTime,
                                        style: GoogleFonts.nunito(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.aBlueColor,
                                        ),
                                      ),
                                      SizedBox(height: 12.h),
                                      Text(
                                        event.eventsTitle,
                                        textAlign: TextAlign.start,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.nunito(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.blackColor,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                              ImageAssets.locationIcon),
                                          SizedBox(width: 4.w),
                                          Expanded(
                                            child: Text(
                                              '${event.eventsName} • ${event.address}',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.nunito(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.greyColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 12.h);
                      },
                    );
                  }
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
