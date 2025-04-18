import 'dart:developer';
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
              "project_id": "sign-up-lxh8y8",
              "private_key_id": "cf4ba09ba38d87537b606f23b0996e782a310c22",
              "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDSVfkwvC6OJpkd\nDiM6/NrDdfqcU04xqIqsyJFh2apNc7Me4IPrlagN/gHoXors+8C+B4K8XypZ2yvg\nXQ3SKrbYpQ+6o5ZkoK3OZs/SC3LTycsqcqEL6dyvTRQ+OI+aKWh5GpT9Ej6KIV0F\nT+gs2ubVFGb4y19Ac93WK9XoArTV8MUvrCVCb+gVHaSo7qBehXqJuxef9tDG7z52\n93Kge8GxoGLmb8PwagKljqzChJYr9uXo+brLTiQqhfXDDWAkyQRjIZBsUMKPJVZQ\nLN0RR/H0LO4UJg1NQEg9/oynKqKNikYO3VIZhkgnIAxo0sP8vM79gbGAzO+DeOox\naahpvyHfAgMBAAECggEABmZLQKpZGEYgXnvxonfTCCNszpjSRjyEi6FGmx2OSvD8\nQDJAkUhqZpKV6EYIIBHA2YdM+QJEPZuniBoMs5pNGeZbxif4CXPCFgeWxyNGCR+Y\nqN/3+m7RIhxMQ2BhLiWYYibm5ZRKhtVhCSpXPBYk89K9F1DIwyNDWqLWzUpXyjKN\nCHKAyBvO69kjuLAQoelqJ0xyWfYeLdGLHj8r1uCxngT1v/zoNertKaWFqy8QYeU2\nTYklPZ3BLYFI2WdjXmdTO3BKjxkkyKNSFzRcr7AY17ul6rVz21x1DKZ1ZNFzv1/5\nBwUvzHQWIezgBlTYKeniGIpSDv6oEvhoN0fdCAMlEQKBgQDbBURaCD/mUWfgVu6I\nQU7So30OIA8DReFIt6E1A20VbUu+QWD5uEWHIE048MP8NXpGQuyn51d3fPyBAn0u\nRt4lPWvcKWDv74xmnqcaiC/jJrIsNUbDXetOLD8Mbdr3g7vzEqwWAzNn4Pr1i/JX\nY8/fOBRVsmJNg+B6FVmU0lFb9QKBgQD12VNZ6b4gG4SFsMaqOCsXwnllXvqHafsY\ncDbnVRfaZN3JwTfZAY+sfXby1HuV/PVHvLe58z30aW72lu+dOT0Vvcdr7j2jqZkZ\nesW1sMr1Z3qLpW/HImOPXhJumX3Qa6vdg3uXzOb1EiXdtHO/LhpiPIPgpPwVl8xo\n9cs41tQWAwKBgQDVWJEXXlfYY83a8vNSGMPOXWDwxHu7RXPI4M8Qk/DLYXbZslfj\niQN5OBbg828Fm5YrIP/kIm7KPx68EI+d53x3LBiIEmqR7neGct718lkrXMNMWu0+\nW5tdv63+znfwiQspITQuERofA0GStKrxQ5H2r2rne2dUeLTOV0O2uxRzjQKBgFOx\nBeTn42c+tuBkC11K/bB67aSKrrKGa4ooOSiLGTGpgK777a0cEPLhSyrjFqc6k602\nGz1cBs07TyD2xN866waJsmeVlLowNAQufTua0Zy0+0yqpuCdXlMh7RhlfCUFYl5o\nMhy9DiqDYQyWL4j3gtfKTgKdZ4taP6XDdskEqPJNAoGASfCUrX3wyc0s24HSkF1p\nMtgCLXcXGsoFFRP2nKCjsY7D01ECP71QZSOWePToDDp+0bJobm5PmpDZjn2EmygW\n9fItJpSS6DehhcqX5I0nNvamEah2Lk6CNcTADFilVBu+Hd5ryPMcRUoBAz0MSiGt\nXT0IUPGtyNoFyK2aaP1IiNg=\n-----END PRIVATE KEY-----\n",
              "client_email": "firebase-adminsdk-1ox3x@sign-up-lxh8y8.iam.gserviceaccount.com",
              "client_id": "114790657660939795648",
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
      log('$e');
      return null;
    }
  }
}