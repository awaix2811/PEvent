import 'package:event_hub/constant/assets/assets.dart';
import 'package:event_hub/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashScreenController controller = Get.put(SplashScreenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: SvgPicture.asset(ImageAssets.appLogo)),
    );
  }
}
