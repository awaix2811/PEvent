// import 'package:firebase_auth/firebase_auth.dart';
import 'package:event_hub/views/bottom_naivgation_bar_screen.dart';
import 'package:event_hub/views/onboarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      if (FirebaseAuth.instance.currentUser == null) {
        Get.offAll(() => OnboardingScreen());
      } else {
        Get.offAll(() => BottomNavigationBarScreen());
      }
    });
  }
}
