import 'package:event_hub/constant/assets/assets.dart';
import 'package:event_hub/constant/colors/colors.dart';
import 'package:event_hub/controllers/auth_controller.dart';
import 'package:event_hub/views/reset_passeword_screen.dart';
import 'package:event_hub/views/sign_out_screen.dart';
import 'package:event_hub/widgets/custom_button.dart';
import 'package:event_hub/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});
  final AuthController controller = Get.put(AuthController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 22.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.arrow_back,
                    ),
                  ),
                  SizedBox(
                    height: 44.h,
                  ),
                  Text(
                    'Sign in',
                    style: GoogleFonts.nunito(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blackColor),
                  ),
                  SizedBox(
                    height: 33.h,
                  ),
                  CustomTextField(
                    text: 'abc@email.com',
                    image: ImageAssets.mailImg,
                    inputType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }

                      if (!GetUtils.isEmail(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    controller: controller.emailController,
                  ),
                  SizedBox(
                    height: 33.h,
                  ),
                  CustomTextField(
                    text: 'Your password',
                    isPassword: true,
                    image: ImageAssets.lockImg,
                    inputType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                    controller: controller.passwordController,
                  ),
                  SizedBox(
                    height: 22.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const ResetPassewordScreen());
                        },
                        child: Text(
                          'Forgot password?',
                          style: GoogleFonts.nunito(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.blueColor),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 55.h,
                  ),
                  Obx(
                    () => controller.isLoginLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.blueColor,
                            ),
                          )
                        : CustomButton(
                            text: 'SIGN IN',
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                controller.login();
                              }
                            },
                          ),
                  ),
                  SizedBox(
                    height: 33.h,
                  ),
                  Center(
                    child: Text(
                      'OR',
                      style: GoogleFonts.nunito(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.greyColor),
                    ),
                  ),
                  SizedBox(
                    height: 33.h,
                  ),
                  Obx(
                    () => controller.isGoogleLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.red,
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {
                              await controller.loginWithGoogle();
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 15.w),
                              padding: EdgeInsets.symmetric(vertical: 17.h),
                              decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color: AppColors.aWhiteColor
                                            .withOpacity(0.2),
                                        blurRadius: 15,
                                        spreadRadius: 0,
                                        offset: const Offset(15, 0))
                                  ],
                                  borderRadius: BorderRadius.circular(15.r)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    ImageAssets.googleIcon,
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    'Login with Google',
                                    style: GoogleFonts.nunito(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.aBlackColor),
                                  )
                                ],
                              ),
                            ),
                          ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.w),
                    padding: EdgeInsets.symmetric(vertical: 17.h),
                    decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.aWhiteColor.withOpacity(0.2),
                              blurRadius: 15,
                              spreadRadius: 0,
                              offset: const Offset(15, 0))
                        ],
                        borderRadius: BorderRadius.circular(15.r)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          ImageAssets.fbIcon,
                        ),
                        SizedBox(
                          width: 15.w,
                        ),
                        Text(
                          'Login with Facebook',
                          style: GoogleFonts.nunito(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.aBlackColor),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 33.h,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => SignOutScreen());
                      },
                      child: RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                  text: ' Sign up',
                                  style: GoogleFonts.nunito(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.blueColor))
                            ],
                            text: 'Don\'t have an account?',
                            style: GoogleFonts.nunito(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.aBlackColor)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
