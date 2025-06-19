import 'package:get/get.dart';

class CustomTextFieldController extends GetxController {
  RxBool isObscured = true.obs;

  void toggleVisibility() {
    isObscured.value = !isObscured.value;
  }
}
