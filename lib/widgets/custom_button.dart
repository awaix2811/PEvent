import 'package:event_hub/constant/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });
  final String text;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        decoration: BoxDecoration(
            color: AppColors.blueColor,
            borderRadius: BorderRadius.circular(15.r)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.import_contacts,
              color: Colors.transparent,
            ),
            Text(
              text,
              style: GoogleFonts.nunito(
                  fontSize: 18.sp,
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w700),
            ),
            Container(
              padding: EdgeInsets.all(4.r),
              decoration: const BoxDecoration(
                  color: AppColors.aBlueColor, shape: BoxShape.circle),
              child: const Icon(
                Icons.arrow_forward,
                color: AppColors.whiteColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
