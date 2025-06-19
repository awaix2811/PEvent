import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_hub/controllers/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final UserController userController = Get.put(UserController());

  RxString ImagePath = "".obs;
  RxString imageUrl = "".obs;
  final ImagePicker picker = ImagePicker();
  var isLoading = false.obs;
  RxBool isSelectedOption = false.obs;
  var image;

  @override
  void onInit() {
    super.onInit();
    loadExistingProfileImage();
  }

  void loadExistingProfileImage() {
    if (userController.user.isNotEmpty &&
        userController.user['imageUrl'] != null &&
        userController.user['imageUrl'].toString().isNotEmpty) {
      imageUrl.value = userController.user['imageUrl'];
      print("Loaded existing profile image URL: ${imageUrl.value}");
    } else {
      print("No existing profile image found");
    }
  }

  void switchChange(bool value) {
    isSelectedOption.value = value;
  }

  Future<void> getImage() async {
    try {
      isLoading(true);
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        image = pickedImage;
        ImagePath.value = pickedImage.path;
        print("Image selected: ${ImagePath.value}");
        await uploadImage();
      } else {
        print("No image selected");
      }
    } catch (e) {
      print("Error picking image: ${e.toString()}");
      Get.snackbar("Error", "Failed to pick image: ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }

  Future<void> uploadImage() async {
    try {
      isLoading(true);

      if (image == null) {
        print("No image to upload");
        return;
      }
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print("No authenticated user found");
        Get.snackbar(
            "Error", "You must be logged in to upload a profile image");
        return;
      }
      String uid = currentUser.uid;
      String fileName = "profile_$uid";
      Reference storageRef = FirebaseStorage.instance.ref();
      Reference imageRef = storageRef.child('profile_images/$fileName');
      // Upload file
      await imageRef.putFile(File(ImagePath.value));
      String downloadUrl = await imageRef.getDownloadURL();
      imageUrl.value = downloadUrl;
      print("Image uploaded successfully: $downloadUrl");
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'imageUrl': downloadUrl});
      userController.getUser();
      Get.snackbar("Success", "Profile image updated successfully");
    } catch (e) {
      print("Error uploading image: ${e.toString()}");
      Get.snackbar("Error", "Failed to upload image: ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateUser() async {
    try {
      isLoading(true);
      if (userController.nameController.text.isEmpty) {
        userController.nameController.text = userController.user['name'] ?? '';
      }

      if (userController.phoneController.text.isEmpty) {
        userController.phoneController.text =
            userController.user['phoneNumber'] ?? '';
      }

      if (userController.emailController.text.isEmpty) {
        userController.emailController.text =
            userController.user['email'] ?? '';
      }

      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        Get.snackbar("Error", "You must be logged in to update your profile");
        return;
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'name': userController.nameController.text,
        'phoneNumber': userController.phoneController.text,
        'email': userController.emailController.text
      });
      userController.getUser();

      Get.back();
      Get.snackbar("Success", "Profile updated successfully");
    } catch (e) {
      print("Error updating user: ${e.toString()}");
      Get.snackbar("Error", "Failed to update profile: ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }
}
