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

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final EventDetailController eventsController =
      Get.find<EventDetailController>();
  final TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  RxList<Event> filteredEvents = <Event>[].obs;

  @override
  void initState() {
    super.initState();
    // Initialize filtered events with all events
    filteredEvents.value = eventsController.events;

    // Listen to events list changes and update filtered list
    ever(eventsController.events, (_) {
      filterEvents(searchController.text);
    });
  }

  void filterEvents(String query) {
    if (query.isEmpty) {
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
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        child: Column(
          children: [
            SizedBox(height: 22.h),

            // Header with search toggle
            Row(
              children: [
                SizedBox(width: 12.w),
                if (!isSearching)
                  Text(
                    'Events',
                    style: GoogleFonts.nunito(
                      fontSize: 20.sp,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                if (isSearching)
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search events...',
                        hintStyle: GoogleFonts.nunito(
                          fontSize: 16.sp,
                          color: AppColors.greyColor,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                      ),
                      style: GoogleFonts.nunito(
                        fontSize: 16.sp,
                        color: AppColors.blackColor,
                      ),
                      onChanged: (value) {
                        filterEvents(value);
                      },
                    ),
                  ),
                if (!isSearching) Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isSearching = !isSearching;

                      // If closing search, clear the search text
                      if (!isSearching) {
                        searchController.clear();
                        filterEvents('');
                      }
                    });
                  },
                  child: SvgPicture.asset(
                    isSearching ? ImageAssets.backIcon : ImageAssets.searchIcon,
                    color: AppColors.blackColor,
                  ),
                ),
              ],
            ),

            SizedBox(height: 22.h),

            // Event list
            Expanded(
              child: Obx(() {
                if (eventsController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else if (eventsController.events.isEmpty) {
                  return Center(child: Text('No events available'));
                } else if (filteredEvents.isEmpty) {
                  return Center(child: Text('No events match your search'));
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
                              borderRadius: BorderRadius.circular(12.r)),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: event.imgUrl.isNotEmpty
                                    ? Image.network(
                                        event.imgUrl,
                                        width: 90.w,
                                        height: 111.h,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            ImageAssets.jazzImg,
                                            width: 90.w,
                                            height: 111.h,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      )
                                    : Image.asset(
                                        ImageAssets.jazzImg,
                                        width: 90.w,
                                        height: 111.h,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              SizedBox(width: 9.w),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dateTime,
                                      style: GoogleFonts.nunito(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.aBlueColor,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      event.eventsTitle,
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.nunito(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                    SizedBox(height: 9.h),
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
    );
  }
}
