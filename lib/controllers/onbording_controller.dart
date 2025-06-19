import 'package:event_hub/views/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  // Observable variable for current page
  final currentPage = 0.obs;

  // Page controller for PageView
  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    // Initialize the page controller
    pageController = PageController(initialPage: 0);
  }

  // Method to handle page changes
  void onPageChanged(int index) {
    currentPage.value = index;
  }

  // Method to handle dot clicks
  void onDotClicked(int index) {
    currentPage.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Method to handle next button press
  void nextPage() {
    if (currentPage.value < 2) {
      // Move to next page if not on the last page
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to SignInScreen if on the last page
      navigateToSignIn();
    }
  }

  // Method to handle skip button press
  void skipToSignIn() {
    navigateToSignIn();
  }

  // Common method to navigate to sign in screen
  void navigateToSignIn() {
    // Navigate to SignIn screen
    Get.off(() => SignInScreen());

    // Alternative ways to navigate if '/signin' route is not defined:
    // Get.off(() => const SignInScreen());
    // or
    // Get.offAll(() => const SignInScreen());
  }

  @override
  void onClose() {
    // Clean up the controller when it's no longer used
    pageController.dispose();
    super.onClose();
  }
}
