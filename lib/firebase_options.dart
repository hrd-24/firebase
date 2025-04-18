// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBCNgSZW6BYG-PPa7SL7E4MUB8uttOQH20',
    appId: '1:350815746161:web:24941346d98f73f482c3d0',
    messagingSenderId: '350815746161',
    projectId: 'ppkd-mp',
    authDomain: 'ppkd-mp.firebaseapp.com',
    storageBucket: 'ppkd-mp.firebasestorage.app',
    measurementId: 'G-XG72TLRKC5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAE3Q3MpbAEYfbOOpmmsLSWjpBMKh-5TGc',
    appId: '1:350815746161:android:ef975fcacbea245b82c3d0',
    messagingSenderId: '350815746161',
    projectId: 'ppkd-mp',
    storageBucket: 'ppkd-mp.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBCNgSZW6BYG-PPa7SL7E4MUB8uttOQH20',
    appId: '1:350815746161:web:5f2a0fc15c7accf482c3d0',
    messagingSenderId: '350815746161',
    projectId: 'ppkd-mp',
    authDomain: 'ppkd-mp.firebaseapp.com',
    storageBucket: 'ppkd-mp.firebasestorage.app',
    measurementId: 'G-CETD9Y3H5M',
  );

}