import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
            'DefaultFirebaseOptions have not been configured for linux.');
      default:
        throw UnsupportedError(
            'DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBlQ9KTZ1ro4Pj7ZJIdqE1cb9FOuUe1slw',
    appId: '1:974648698523:web:bd874491b5d0caea30c83e',
    messagingSenderId: '974648698523',
    projectId: 'travel-9a335',
    authDomain: 'travel-9a335.firebaseapp.com',
    storageBucket: 'travel-9a335.appspot.com',
    measurementId: 'G-CT7T56P6DY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC2zx8gODCixBl_CI_fJO1LVHU5W1N_WB8',
    appId: '1:974648698523:android:9f48658c51f5e2e730c83e',
    messagingSenderId: '974648698523',
    projectId: 'travel-9a335',
    storageBucket: 'travel-9a335.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB6DlpH4CKXptHKtg1Py8BCCEnwtpRTuhY',
    appId: '1:974648698523:ios:5a67b0bdbf0137b530c83e',
    messagingSenderId: '974648698523',
    projectId: 'travel-9a335',
    storageBucket: 'travel-9a335.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB6DlpH4CKXptHKtg1Py8BCCEnwtpRTuhY',
    appId: '1:974648698523:ios:5a67b0bdbf0137b530c83e',
    messagingSenderId: '974648698523',
    projectId: 'travel-9a335',
    storageBucket: 'travel-9a335.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBlQ9KTZ1ro4Pj7ZJIdqE1cb9FOuUe1slw',
    appId: '1:974648698523:web:bf3a7448ebf9105c30c83e',
    messagingSenderId: '974648698523',
    projectId: 'travel-9a335',
    authDomain: 'travel-9a335.firebaseapp.com',
    storageBucket: 'travel-9a335.appspot.com',
    measurementId: 'G-F6XB48914P',
  );

}