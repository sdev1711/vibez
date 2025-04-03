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
                "private_key_id": "5ca4ad5372effbcee3c6eb3583dbf3fb20a1067b",
                "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCeEjRjmljDEg6j\n4nqPMQOdUQEIQD/r+VpKOuqPqe/XbljdyDkITlIgGFotCkIxUPOuh2tF93WqgQJP\nb4SkrCgQr3BLYtXr73/iBKqUH9YZBg8mgwjtzI0jlWlReVyis/7GAO6lZ5fQIMFf\nHwWkgYltleBfAp69i2kHfb5g1k5uMxieYZ+meyzX6Kd9ooAeS01X2Te8sKwEqirN\nSTCxlDWNtRV2ovev9IHefqZRYeKcdbipjHWXqOf53pwasspWxpaJPeUUAC51zncv\nnlmoKLiQ+N9hZAh+R5cf4BjoGIQAvTeEiyabBQvQko0N4GepOiQPzWR3MGkFLOQQ\nemu8wNYrAgMBAAECggEABI9nONhjEdLw3oQndP9nqJ+FoBn6aMcGISNspj2zevY7\n/2n0petcgyswrsv095HroHACWupgrU07e9SDxxxlq4A5hR3nff79eXpuUVz5wuRh\n24KRkgqsp7IlGldIojOpzfHeRfdPHI9VWiEoUIP21ap/5pMfcT3Bse2haGRxBCIk\nSr8e80Kfm9O3dKXbMT4/XKJ/WJHEndoM0h8oT7g0yTNt8FGhStJxLJAdplFoaFdY\nEu4bFvZ/8DAca089mIPbDQcVdQhKZqK7Xztc1QwtgO8AvjdxK8nQ+nAclZbumuAm\n4pCFLnIF1rrQa6LueCljEWtRreRddM/8qpY/jS1gwQKBgQDL3heIMwJ6JvyYNZ4e\nxHNQ2tlvgGjSGyIaUMJ3HsY/UjYUoQGs3cuZTgKdRh5MMp3PrAuJWs9zAaSoWpfi\nm9OVb6AyY3M5mlmPOBOwzOswFWEoeBYrB0Mhup8c7EVnT+jJMZdpw1fxOwCjEI8l\nJPkSQdhcckTrb9HKojndByDhJwKBgQDGfhy6VUoXo9WW/rjwGKfhvWEX+mosScHV\nyfqpHb9FHdvqTTQHx+e8SYotuW2k+wcngkNyl5/VjbQXwWo369vGIC/07jzgD3pp\nU2zcy5PYT0rwssHaI5D+Bt3SaR1JOAn+Bh/SpZhNwSvYgbzvaY3m0WzZRuZX31xX\n6J861ol9XQKBgCTmP/Ag+3PMlq+eFM6Q1CZwVia+YTqWOqf0sh4JbeyMHsnBEqKN\nSoqm+gYpaNZ12uZ5x2THEQFJ7Nmj/BXCCpvjpmU4ZuSoMUmg5r97d54uYHWItsp2\n+Amk06PSiAVZC1NPLI6yErrQ6R6aoq4gcQyC6nxhGmRayugYUMzWu3bFAoGAFKvD\ngCArtCSKtMvYJKDcsuSO/PlGH1CbEBGVuhDv/1mpsk/R8FGAL5qU+kgKRBkkWJf3\nQDLMIWg9bg/laOd2Hr7xX5eD3W2fOOLIPoIw5mDzk/d5uqbjjaDXbvclZp+gYsTu\ngXhfURGh6E0yiNg8P+JlbIc2q8YGDt2Z333CGb0CgYBZH+jZ8EsWTJFmKGM3cCHL\nM1exKsCrHbyFRw24RkZygxAtI+SxSa3oEETO7znhbVzHnP6TF7dYCLFf/oqL88Tj\nDdlPMXDhL9ai/9MrjJeH+qATqIoYwsCfEYkFCMAwMC6gXT5mk+nSP/pwM1451z24\nw9ViQkojzPcaROl1D/0xyA==\n-----END PRIVATE KEY-----\n",
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