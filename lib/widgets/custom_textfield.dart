import 'package:event_hub/constant/colors/colors.dart';
import 'package:event_hub/controllers/textfield_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    super.key,
    required this.text,
    required this.image,
    required this.inputType,
    this.validator,
    required this.controller,
    this.isPassword = false,
  });

  final String text;
  final String image;
  final bool isPassword;
  final TextInputType inputType;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final CustomTextFieldController textFieldController =
      Get.put(CustomTextFieldController(), tag: UniqueKey().toString());
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.aGreyColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Obx(() {
        final isCurrentlyObscured = textFieldController.isObscured.value;
        return TextFormField(
          style: GoogleFonts.nunito(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.blackColor),
          validator: validator,
          controller: controller,
          obscureText: isPassword ? isCurrentlyObscured : false,
          keyboardType: inputType,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(top: 12.h),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Image.asset(image, width: 20, height: 20),
            ),
            hintText: text,
            hintStyle: GoogleFonts.nunito(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.greyColor),
            suffixIcon: isPassword
                ? GestureDetector(
                    onTap: textFieldController.toggleVisibility,
                    child: Icon(
                      isCurrentlyObscured
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 18,
                    ),
                  )
                : null,
            border: InputBorder.none,
          ),
        );
      }),
    );
  }
}
