import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'package:event_hub/constant/colors/colors.dart';
import 'package:event_hub/views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Event Hub',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: AppColors.whiteColor,
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: AppColors.blueColor,
              selectionColor: AppColors.blueColor.withOpacity(0.5),
              selectionHandleColor: AppColors.blueColor,
            ),
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}
