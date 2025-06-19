import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String eventsTitle;
  final String imgUrl;
  final String eventsDate;
  final String eventsDay;
  final String eventsName;
  final String address;
  final String aboutEvents;
  final String uid;
  final DateTime? createdAt;

  Event({
    required this.eventsTitle,
    required this.imgUrl,
    required this.eventsDate,
    required this.eventsDay,
    required this.eventsName,
    required this.address,
    required this.aboutEvents,
    required this.uid,
    this.createdAt,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    // Print the map for debugging
    print("Creating event from map: $map");

    // Handle createdAt field safely - it could be a Timestamp, String, or null
    DateTime? createdAtDate;
    if (map['createdAt'] != null) {
      if (map['createdAt'] is Timestamp) {
        createdAtDate = (map['createdAt'] as Timestamp).toDate();
      } else if (map['createdAt'] is String) {
        try {
          createdAtDate = DateTime.parse(map['createdAt']);
        } catch (e) {
          print("Error parsing createdAt date: $e");
        }
      }
    }

    return Event(
      eventsTitle: map['events_title'] ?? '',
      imgUrl: map['imgUrl'] ?? '',
      eventsDate: map['events_date'] ?? '',
      eventsDay: map['events_day'] ?? '',
      eventsName: map['events_name'] ?? '',
      address: map['address'] ?? '',
      aboutEvents: map['about_events'] ?? '',
      uid: map['UID'] ?? '',
      createdAt: createdAtDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'events_title': eventsTitle,
      'imgUrl': imgUrl,
      'events_date': eventsDate,
      'events_day': eventsDay,
      'events_name': eventsName,
      'address': address,
      'about_events': aboutEvents,
      'UID': uid,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }
}
