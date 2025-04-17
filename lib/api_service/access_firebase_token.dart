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

        // Paste Your Generated Json File Content
        ServiceAccountCredentials.fromJson(
            {
              "type": "service_account",
              "project_id": "sign-up-lxh8y8",
              "private_key_id": "f8625b3d8a57fa8bd68587c1e18712a2c8f0272e",
              "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDHRFtPaY57bF1C\nPeyCeQCyk5hFhHaaqby1FFyVDUFVErXY6Z/pWfAAjMXTejkDkjhf4cjW2M+KhQ/T\nMRA5nt9TMFTsVODdPfcsWNCf5cz4wEXDf8WNwwuLaJu+yYiO5IXNbvVGR/JKoyPx\nUxNpY2afRI5rmuFt+RpIAoJMhwWaHrjrJONeKM3PLaNo7dCwLXHJdfM30WJkRj6a\n00VjJvMPbjev3jqbjn3IxKuqExM7nfNZYy4xgSgflgfLyUtHYcrJguHaYz/uAxEL\nr88TDfWWh/muaPo5qSM92d2+Uyq05VRVHr+yt4B8G45OlQUkiKO6bRCNUQByEIxG\nWw/OYtPLAgMBAAECggEAETl+bxnfwBl44j36ELkm70jE09WEbxAXCMwOyK+Roynv\n4CUptoEYtuN0QjiBbyaXiuo4cyHgpseju4y1K1XpVgaKgLdBjL5LfGDc/8Vcd3Af\nV6vWxs9CUzWiqNZA4KEuU7iwqPeVIRCDDdwxhF2cRE4nxXNo4xmyROE6pCTTviOc\nl0auY5RChAyAfqnxwsjFRWqIDSOUddHxlOcFMDFmDVpljtNF7qrInvfPdqELWFDr\nJw6djw7X1xo2S3/iKFnGMe4sWxQUNxSOHnUyJFQLSpXa43YtpLEPluBXAdrKNT6x\nBdXDCheSeqqnFRXwq53qZA/PAuJjaLJ4Bu4RIzu8mQKBgQDwRPV9NK29wBbxiF8f\n34oBFSTXvdsy2tf0vhQ51rdqQwuCBMb/W0ayulv+AID4aYW4mfrxBpAhcxcJkSmn\ngFvdEuCS/dVLnNY4kzcx1VGclZMCp99/8n8Thru6wdBe9JRqt8Qq8jGmdojepJgt\nNtTClq6CmLTlTxfLV1qQK/a0/wKBgQDUUC0+vqsBOQYhfQeZa0D4ITAZAYCeuxN7\n8IMekFc2ETB2cBSfE/ZNk1ZyiMkC8bcvlj/ycEolFsevee0n20Vw0n/cS0uDHAra\nmAtondiQMnpvICgWxqhxx6kOJSVLov4RUAs7x64uJ4Ep9ZbQ5iEl39CsHGdmx8jG\nSwybO1mlNQKBgQDau/y9WordVxXMF3l6G9iYObaLzeTTPFYkEjN5oFbkH1tHp6++\nY0tOhMggyjafb/lz4IKKkI4AVbVgWU4RlpKLBZd7WiinKIYBhUxXSrt8kNMANPIM\nmihED4GyeKWI/KJtMRUef9ThlcHu5us/Jk61Q9ZlQD5XEBU6YjEpVUzI4wKBgQCF\nMiOgeIfZxYeWHNVWp5Xj1RZSqcGiU2Ue3T21QAKmldQciaY2QpTECEo0oqHQ6gnt\nncpSc6XgbNErwkdJOOPwqu6yKr6d60rX5olJwbUqibCL5NWhrFHix8rEaANk10Wj\nYN8bSuN4ayo6Q6uxNJ7ZHvfP8iXgsjfARzcKcAqGfQKBgCBFSC0UlOCLJis1QuL1\nK9GI9GnqFnUPTIAUH7N6NQ4YDXerUOeOwj1HOZoVcfVZTtqh7q5+mEgqEr+fMouA\nq1B6tOcFEa4+Z6KQPHYrwlbxkpAdtQXYj/yYJ6wo/Mn4i2Qc0YghMK1lCfIzEaYr\nQzLbngYUlTDbHFNNejd1zovZ\n-----END PRIVATE KEY-----\n",
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