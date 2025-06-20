import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBM2_ss60isL5eXzw2UoS1P5lQ-A_Wtkmg',
    appId: '1:774116593688:android:c530cad01505dd4e',
    messagingSenderId: '774116593688',
    projectId: 'mankutimmana-kagga',
    storageBucket: 'mankutimmana-kagga.firebasestorage.app',
    databaseURL: 'https://mankutimmana-kagga.firebaseio.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCCQipUWtYlUwzliHI0S14YdP0hRPUTd-I',
    appId: '1:774116593688:ios:a5cd17601cb1d66e03f36d',
    messagingSenderId: '774116593688',
    projectId: 'mankutimmana-kagga',
    storageBucket: 'mankutimmana-kagga.firebasestorage.app',
    databaseURL: 'https://mankutimmana-kagga.firebaseio.com',
    iosClientId:
        '774116593688-8r00dols5t08gt3oq042q9lestqpu5fg.apps.googleusercontent.com',
  );
}
