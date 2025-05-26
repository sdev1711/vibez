import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis_auth/auth_io.dart';

class NotificationAccessToken {
  static String? _token;

  //to generate token only once for an app run
  static Future<String?> get getToken async => _token ?? await _getAccessToken();

  // to get admin bearer token
  static Future<String?> _getAccessToken() async {
    try {
      const fMessagingScope =
          'https://www.googleapis.com/auth/firebase.messaging';

      final client = await clientViaServiceAccount(
        // To get Admin Json File: Go to Firebase > Project Settings > Service Accounts
        // > Click on 'Generate new private key' Btn & Json file will be downloaded

        ServiceAccountCredentials.fromJson(
            {
              "type": "service_account",
              "project_id": dotenv.env['FIREBASE_PROJECT_ID'],
              "private_key_id": dotenv.env['FIREBASE_PRIVATE_KEY_ID'],
              "private_key": dotenv.env['FIREBASE_PRIVATE_KEY'],
              "client_email": dotenv.env['FIREBASE_CLIENT_EMAIL'],
              "client_id": dotenv.env['FIREBASE_CLIENT_ID'],
              "auth_uri": "https://accounts.google.com/o/oauth2/auth",
              "token_uri": "https://oauth2.googleapis.com/token",
              "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
              "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-1ox3x%40sign-up-lxh8y8.iam.gserviceaccount.com",
              "universe_domain": "googleapis.com"
            }
        ),
        [fMessagingScope],
      );

      _token = client.credentials.accessToken.data;

      return _token;
    } catch (e) {
      log('Error getting token: ${e.toString()}');
      return null;
    }
  }
}