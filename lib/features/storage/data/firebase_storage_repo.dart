import 'dart:io';
import 'dart:typed_data';

import 'package:abhiman_assignment/features/storage/domain/storage_repo.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageRepo implements StorageRepo {
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Future<String?> uploadProfileImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, 'profile_images');
  }

  @override
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(fileBytes, fileName, "profile_images");
  }

  // Helper methods -- to upload files to storage

  // Mobile platforms (files)
  Future<String?> _uploadFile(
      String path, String fileName, String folder) async {
    try {
      // Get file
      final file = File(path);

      // Find place to store
      final storageRef = storage.ref().child('$folder/$fileName');

      // Upload
      final uploadTask = await storageRef.putFile(file);

      // Get image download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl; // Return the download URL
    } catch (e) {
      print("Error uploading file: $e");
      return null; // Return null on error
    }
  }

  // Web platforms (bytes)
  Future<String?> _uploadFileBytes(
      Uint8List fileBytes, String fileName, String folder) async {
    try {
      // Find place to store
      final storageRef = storage.ref().child('$folder/$fileName');

      // Upload
      final uploadTask = await storageRef.putData(fileBytes);

      // Get image download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl; // Return the download URL
    } catch (e) {
      print("Error uploading file bytes: $e");
      return null; // Return null on error
    }
  }

  @override
  Future<String?> uploadPostImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, 'post_images');
  }

  @override
  Future<String?> uploadPostImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(fileBytes, fileName, "post_images");
  }
}
