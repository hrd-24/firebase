// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/material.dart';

// class ImagePickerService {
//   final ImagePicker _picker = ImagePicker();

//   Future<File?> pickImage(ImageSource source) async {
//     final pickedFile = await _picker.pickImage(source: source);
//     if (pickedFile != null) {
//       return File(pickedFile.path);
//     }
//     return null;
//   }

//   Future<void> showImageSourceDialog(BuildContext context, Function(File) onImageSelected) async {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Wrap(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: const Text("Take a Photo"),
//               onTap: () async {
//                 File? image = await pickImage(ImageSource.camera);
//                 if (image != null) {
//                   onImageSelected(image);
//                 }
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const Text("Pick from Gallery"),
//               onTap: () async {
//                 File? image = await pickImage(ImageSource.gallery);
//                 if (image != null) {
//                   onImageSelected(image);
//                 }
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
