import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_hub/constant/colors/colors.dart';
import 'package:event_hub/models/events_detail_model.dart';
import 'package:event_hub/views/bottom_naivgation_bar_screen.dart';
import 'package:event_hub/views/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  var isRegisterLoading = false.obs;
  var isLoginLoading = false.obs;
  var isGoogleLoading = false.obs;
  final forgotPasswordEmailController = TextEditingController();
  final isResetLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  TextEditingController emailController = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  final RxBool isSecureText = true.obs;
  void toggleSecureText() {
    isSecureText.value = !isSecureText.value;
  }

  Future<void> sendSignInLink(String email) async {
    final ActionCodeSettings actionCodeSettings = ActionCodeSettings(
      url: 'https://asad-d64d9.firebaseapp.com',
      handleCodeInApp: true,
      androidPackageName: 'com.example.event_hub',
      androidInstallApp: true,
      androidMinimumVersion: '21',
      iOSBundleId: 'com.example.eventHub',
    );

    try {
      await auth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );
      Get.snackbar("Success", "Email link sent to $email",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Failed to send email link",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> signInWithEmailLink(String email, String link) async {
    try {
      final UserCredential userCredential =
          await auth.signInWithEmailLink(email: email, emailLink: link);

      if (userCredential.user != null) {
        final user = userCredential.user!;
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (!userDoc.exists) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            "email": user.email,
            "uid": user.uid,
            "createdAt": FieldValue.serverTimestamp(),
            "provider": "email-link"
          });
        }
        Get.offAll(() => BottomNavigationBarScreen());
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Sign-in Failed", e.message ?? "Error signing in",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void register() async {
    try {
      if (passwordController.text != confirmpasswordController.text) {
        Get.snackbar("Password Error", "Passwords do not match",
            backgroundColor: AppColors.redColor,
            snackPosition: SnackPosition.BOTTOM,
            titleText: Text(
              "Password Mismatch",
              style: GoogleFonts.montserrat(color: AppColors.whiteColor),
            ),
            messageText: Text(
              "Please ensure both passwords are the same.",
              style: GoogleFonts.montserrat(color: AppColors.whiteColor),
            ));
        return;
      }
      isRegisterLoading(true);

      var credentials = await auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (credentials.user != null) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(credentials.user!.uid)
            .set({
          "username": username.text,
          "email": emailController.text,
          "uid": credentials.user!.uid,
          "createdAt": FieldValue.serverTimestamp(),
        });

        Get.snackbar("Success", "Account created successfully",
            backgroundColor: Colors.green, snackPosition: SnackPosition.BOTTOM);

        Get.off(() => BottomNavigationBarScreen());
      } else {
        Get.snackbar("Registration Failed", "User could not be created",
            backgroundColor: AppColors.redColor,
            snackPosition: SnackPosition.BOTTOM,
            titleText: Text(
              "Account Creation Failed",
              style: GoogleFonts.montserrat(
                color: AppColors.whiteColor,
              ),
            ),
            messageText: Text(
              "There was an issue with creating your account. Please try again.",
              style: GoogleFonts.montserrat(
                color: AppColors.whiteColor,
              ),
            ));
      }
    } catch (e) {
      String errorMessage = "An error occurred during registration.";
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = "This email is already registered.";
            break;
          case 'invalid-email':
            errorMessage = "Please provide a valid email address.";
            break;
          case 'weak-password':
            errorMessage =
                "Password is too weak. Please use a stronger password.";
            break;
          default:
            errorMessage = e.message ?? "Authentication failed.";
            break;
        }
      }

      Get.snackbar("Registration Failed", errorMessage,
          backgroundColor: AppColors.redColor,
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isRegisterLoading(false);
    }
  }

  void login() async {
    try {
      isLoginLoading(true);
      await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Get.offAll(() => BottomNavigationBarScreen());
    } catch (e) {
      String errorMessage = "Failed to sign in. Please check your credentials.";
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = "No user found with this email.";
            break;
          case 'wrong-password':
            errorMessage = "Wrong password provided.";
            break;
          case 'invalid-email':
            errorMessage = "Please provide a valid email address.";
            break;
          case 'user-disabled':
            errorMessage = "This user account has been disabled.";
            break;
          default:
            errorMessage = e.message ?? "Authentication failed.";
            break;
        }
      }

      Get.snackbar("Login Failed", errorMessage,
          backgroundColor: AppColors.redColor,
          snackPosition: SnackPosition.BOTTOM,
          titleText: Text(
            "Login Failed",
            style: GoogleFonts.montserrat(
              color: AppColors.whiteColor,
            ),
          ),
          messageText: Text(
            errorMessage,
            style: GoogleFonts.montserrat(
              color: AppColors.whiteColor,
            ),
          ));
    } finally {
      isLoginLoading(false);
    }
  }

  Future<UserCredential?> loginWithGoogle() async {
    try {
      isGoogleLoading(true);

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user!.uid)
            .set({
          "username": userCredential.user!.displayName ?? "",
          "email": userCredential.user!.email ?? "",
          "uid": userCredential.user!.uid,
          "photoUrl": userCredential.user!.photoURL,
          "createdAt": FieldValue.serverTimestamp(),
          "provider": "google"
        });
      }

      Get.offAll(() => BottomNavigationBarScreen());
      return userCredential;
    } catch (e) {
      Get.snackbar("Google Sign-in Error",
          "An unexpected error occurred. Please try again.",
          backgroundColor: AppColors.redColor,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return null;
    } finally {
      isGoogleLoading(false);
    }
  }

  void logout() async {
    try {
      await auth.signOut();
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
      emailController.clear();
      passwordController.clear();
      Get.offAll(() => SignInScreen());
    } catch (e) {
      Get.snackbar("Logout Failed", "Failed to log out. Please try again.",
          backgroundColor: AppColors.redColor,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> sendPasswordResetEmail() async {
    try {
      isResetLoading.value = true;
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: forgotPasswordEmailController.text.trim(),
      );
      Get.snackbar(
        'Success',
        'Password reset link sent to your email',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.back();
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
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send password reset email',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isResetLoading.value = false;
    }
  }

  Future<void> addEventToUser(String uid, Event event) async {
    try {
      DocumentReference eventDocRef =
          FirebaseFirestore.instance.collection('events').doc(uid);

      Map<String, dynamic> eventMap = {
        'events_title': event.eventsTitle,
        'imgUrl': event.imgUrl,
        'events_date': event.eventsDate,
        'events_day': event.eventsDay,
        'events_name': event.eventsName,
        'address': event.address,
        'about_events': event.aboutEvents,
      };

      DocumentSnapshot docSnapshot = await eventDocRef.get();

      if (docSnapshot.exists) {
        Map<String, dynamic> docData =
            docSnapshot.data() as Map<String, dynamic>;

        if (docData.containsKey('events_data')) {
          await eventDocRef.update({
            'events_data': FieldValue.arrayUnion([eventMap])
          });
        } else {
          await eventDocRef.update({
            'events_data': [eventMap]
          });
        }
      } else {
        await eventDocRef.set({
          'Uid': uid,
          'createdAt': FieldValue.serverTimestamp(),
          'events_data': [eventMap]
        });
      }

      print("Event added successfully!");
    } catch (e) {
      print("Error adding event: $e");
      throw e;
    }
  }
}
