import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_hub/models/events_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class EventDetailController extends GetxController {
  var isLoading = false.obs;
  var events = <Event>[].obs;
  var selectedEvent = Rx<Event?>(null);
  final String eventsDocId = 'ZayrwNRGJH7ng9xE1qW2';

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      isLoading(true);
      print("Starting to fetch events");
      var eventsDoc = await FirebaseFirestore.instance
          .collection('events')
          .doc(eventsDocId)
          .get();

      if (!eventsDoc.exists) {
        print("Events document not found");
        return;
      }

      print("Found events document: ${eventsDoc.id}");
      Map<String, dynamic> docData = eventsDoc.data() ?? {};
      print("Document data: $docData");
      events.clear();
      List<dynamic>? eventsDataArray;
      String? foundFieldName;
      docData.forEach((key, value) {
        if (key.trim().contains('events_data') && value is List) {
          eventsDataArray = value;
          foundFieldName = key;
        }
      });

      if (eventsDataArray == null) {
        print("Document doesn't contain events_data array or similar field");
        print("Available fields in document: ${docData.keys.toList()}");
        return;
      }

      print("Found events data array with field name: '$foundFieldName'");
      print("Array contains ${eventsDataArray!.length} items");
      for (var i = 0; i < eventsDataArray!.length; i++) {
        var eventData = eventsDataArray![i];
        print("Processing item $i: $eventData");

        if (eventData is Map<String, dynamic>) {
          try {
            Event event = Event(
              eventsTitle: eventData['events_title'] ?? '',
              imgUrl: eventData['imgUrl'] ?? '',
              eventsDate: eventData['events_date'] ?? '',
              eventsDay: eventData['events_day'] ?? '',
              eventsName: eventData['events_name'] ?? '',
              address: eventData['address'] ?? '',
              aboutEvents: eventData['about_events'] ?? '',
              uid: docData['Uid'] ?? '',
              createdAt: null,
            );
            events.add(event);
            print("Event added: ${event.eventsTitle}");
            print("- Image URL: ${event.imgUrl}");
          } catch (e) {
            print("Error creating event: $e");
            print("Problematic event data: $eventData");
          }
        } else {
          print("Event data at index $i is not a map: $eventData");
        }
      }

      print("Loaded ${events.length} events successfully");
    } catch (e) {
      print('Error fetching events: ${e.toString()}');
      Get.snackbar(
        'Error',
        'Failed to load events',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  void setSelectedEvent(Event event) {
    selectedEvent.value = event;
    print("Selected event: ${event.eventsTitle}");
  }

  // New method for sharing event details
  Future<void> shareEvent() async {
    if (selectedEvent.value == null) {
      print("No event selected to share");
      return;
    }

    final event = selectedEvent.value!;

    try {
      // Create event details to share
      final String eventTitle = event.eventsTitle;
      final String eventDate = event.eventsDate;
      final String eventDay = event.eventsDay;
      final String eventVenue = event.eventsName;
      final String eventAddress = event.address;

      // Construct the share message
      final String shareText = "Join me at: $eventTitle\n\n"
          "📅 Date: $eventDate ($eventDay)\n"
          "📍 Venue: $eventVenue\n"
          "🗺️ Address: $eventAddress\n\n"
          "Get the Event Hub app to RSVP and find more events!";

      // Add your app link
      final String appLink = Platform.isAndroid
          ? "https://play.google.com/store/apps/details?id=com.example.event_hub"
          : "https://apps.apple.com/app/eventhub/id123456789";

      final String fullShareText = "$shareText\n\n$appLink";

      print("Sharing event: $eventTitle");

      // Share the event details
      await Share.share(
        fullShareText,
        subject: 'Invitation: $eventTitle',
      );
    } catch (e) {
      print("Error sharing event: $e");
      Get.snackbar(
        "Sharing Failed",
        "Could not share this event at this time.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
