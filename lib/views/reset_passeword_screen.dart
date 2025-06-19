import 'package:event_hub/constant/assets/assets.dart';
import 'package:event_hub/constant/colors/colors.dart';
import 'package:event_hub/widgets/custom_button.dart';
import 'package:event_hub/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPassewordScreen extends StatefulWidget {
  const ResetPassewordScreen({super.key});

  @override
  State<ResetPassewordScreen> createState() => _ResetPassewordScreenState();
}

class _ResetPassewordScreenState extends State<ResetPassewordScreen> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  Future<void> sendPasswordResetEmail() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      Get.snackbar(
        'Success',
        'Password reset link sent to your email',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      Future.delayed(const Duration(seconds: 2), () {
        Get.back();
      });
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'user-not-found') {
        message = 'No user found with this email';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email format';
      }

      Get.snackbar(
        'Error',
        message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send password reset email',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 17.h,
                ),
                GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: SvgPicture.asset(ImageAssets.backIcon)),
                SizedBox(
                  height: 22.h,
                ),
                Text(
                  'Reset Password',
                  style: GoogleFonts.nunito(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.blackColor),
                ),
                SizedBox(
                  height: 18.h,
                ),
                Text(
                  'Please enter your email address to request a password reset',
                  style: GoogleFonts.nunito(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor),
                ),
                SizedBox(
                  height: 29.h,
                ),
                CustomTextField(
                  text: 'abc@email.com',
                  image: ImageAssets.mailImg,
                  inputType: TextInputType.emailAddress,
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!GetUtils.isEmail(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 44.h,
                ),
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.blueColor,
                        ),
                      )
                    : CustomButton(
                        text: 'SEND',
                        onPressed: sendPasswordResetEmail,
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
