import 'package:event_hub/constant/colors/colors.dart';
import 'package:event_hub/constant/list.dart';
import 'package:event_hub/controllers/onbording_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final OnboardingController controller = Get.put(OnboardingController());

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: 1.sh,
          child: Column(
            children: [
              SizedBox(height: 22.h),
              SizedBox(
                // height: 51.h,
                height: 0.60.sh,
                child: PageView.builder(
                  controller: controller.pageController,
                  itemCount: listOfIntroImg.length,
                  onPageChanged: (index) {
                    controller.currentPage.value = index;
                  },
                  itemBuilder: (context, index) {
                    return Center(
                      child: Image.asset(
                        listOfIntroImg[index],
                        width: 270.w,
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                ),
              ),
              // Bottom blue container
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.aBlueColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(48.r),
                      topRight: Radius.circular(48.r),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 33.h),
                        // Title text
                        Text(
                          listOfIntroText[controller.currentPage.value],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        // Description text
                        Text(
                          listOfIntroDes[controller.currentPage.value],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 15.h),
                        // Bottom navigation
                        Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Skip button
                              TextButton(
                                onPressed: () => controller.skipToSignIn(),
                                child: Text(
                                  'Skip',
                                  style: GoogleFonts.nunito(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        AppColors.whiteColor.withOpacity(0.4),
                                  ),
                                ),
                              ),
                              // Page indicator
                              SmoothPageIndicator(
                                controller: controller.pageController,
                                count: listOfIntroImg.length,
                                effect: WormEffect(
                                  dotHeight: 6.h,
                                  dotWidth: 6.w,
                                  activeDotColor: AppColors.whiteColor,
                                  dotColor:
                                      AppColors.whiteColor.withOpacity(0.5),
                                ),
                                onDotClicked: (index) {
                                  controller.pageController.animateToPage(
                                    index,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                              ),
                              // Next button
                              TextButton(
                                onPressed: () => controller.nextPage(),
                                child: Text(
                                  'Next',
                                  style: GoogleFonts.nunito(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
