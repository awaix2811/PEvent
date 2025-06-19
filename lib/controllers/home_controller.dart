import 'dart:io';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:event_hub/models/events_detail_model.dart';

class HomeController extends GetxController {
  RxBool isSearching = false.obs;
  RxList<Event> searchResults = <Event>[].obs;
  final TextEditingController searchController = TextEditingController();

  // App sharing configuration
  final String appName = "Event Hub";
  final String androidLink =
      "https://play.google.com/store/apps/details?id=com.yourcompany.eventhub";
  final String iosLink = "https://apps.apple.com/app/eventhub/id123456789";
  final String shareMessage =
      "Hey! I'm using Event Hub to discover amazing events near me. Join me and let's attend events together!";

  @override
  void onClose() {
    // Clean up the controller when it's no longer needed
    searchController.dispose();
    super.onClose();
  }

  // Function to perform search
  void performSearch(String query, List<Event> allEvents) {
    if (query.isEmpty) {
      isSearching.value = false;
      searchResults.clear();
      return;
    }

    isSearching.value = true;
    searchResults.value = allEvents.where((event) {
      return event.eventsTitle.toLowerCase().contains(query.toLowerCase()) ||
          event.eventsName.toLowerCase().contains(query.toLowerCase()) ||
          event.address.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Method to clear search
  void clearSearch() {
    searchController.clear();
    performSearch('', []);
  }

  // Method to share the app
  Future<void> shareApp() async {
    // Get the appropriate store link based on platform
    String link = Platform.isAndroid ? androidLink : iosLink;

    // The full share text
    final String shareText = "$shareMessage\n\n$link";

    try {
      // Share both text and subject
      await Share.share(
        shareText,
        subject: 'Join me on $appName!',
      );
    } catch (e) {
      print("Error sharing app: $e");
      // Show a snackbar to inform the user of the error
      Get.snackbar(
        "Sharing Failed",
        "Could not share app at this time.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
