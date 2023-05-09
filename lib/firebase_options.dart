// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAVIQA--KiIffmQqUj-Bh_JA-5EErnN7vw',
    appId: '1:843575201947:web:bdf868c8c08cd7ca2e363e',
    messagingSenderId: '843575201947',
    projectId: 'notee-note-taker',
    authDomain: 'notee-note-taker.firebaseapp.com',
    storageBucket: 'notee-note-taker.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDMy__Lfm4g2lKTCctN-p240PrI-5fMQXU',
    appId: '1:843575201947:android:b38108a3782eb1f62e363e',
    messagingSenderId: '843575201947',
    projectId: 'notee-note-taker',
    storageBucket: 'notee-note-taker.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyABP-Y_TymOgTjgq6fRUGfi0lUyEo4rcVA',
    appId: '1:843575201947:ios:aeb87c8f864339042e363e',
    messagingSenderId: '843575201947',
    projectId: 'notee-note-taker',
    storageBucket: 'notee-note-taker.appspot.com',
    iosClientId: '843575201947-rcnmsho92qs37odjsi271m1e2q3d7g6v.apps.googleusercontent.com',
    iosBundleId: 'site.bethelmmadu.notee',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyABP-Y_TymOgTjgq6fRUGfi0lUyEo4rcVA',
    appId: '1:843575201947:ios:aeb87c8f864339042e363e',
    messagingSenderId: '843575201947',
    projectId: 'notee-note-taker',
    storageBucket: 'notee-note-taker.appspot.com',
    iosClientId: '843575201947-rcnmsho92qs37odjsi271m1e2q3d7g6v.apps.googleusercontent.com',
    iosBundleId: 'site.bethelmmadu.notee',
  );
}