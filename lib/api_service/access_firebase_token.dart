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
              "private_key_id": "83a8767047b398fea7acbe3865b1575495aeaaea",
              "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC2vLWLB8HQXNpS\nF5UYVgXCUaChJQkirTtQSemCzzGktQaV0iQ0KKX6d9OLqq5XKiTQE+yuAds5/l5V\ngt6SdFBsYWEml3NgKAKEODzm0k4CCH0BXkFrPd6WMTV+Jd2iFtljKZn7mrttgn0X\n+Qps3s1usIe7ztuEvZbLrUVV0x81quT2JW0tu1mjgUYzAMCQ0CGsjMYQfcSEATbn\n887v3G2uQmw7/iXqb+yqvYMOUKL2zzvU/vZgGTn+XMCdzL6kx11y2NdjQNsmbu/+\n69Dt8bREFyd2d8Op9Fx4PUxN/r0bYqYttpcKIb3KErvsDOw7nRsWZ2WCXuSzTJ+h\n/Dcdu74rAgMBAAECggEAFlDybMGsQilswhS+MQQkXOhCERvoQzNbqID2QvLRsbcn\n0DkjEbmbF3z1uTtFYkCz0TN1toRkhO8TDydVzhXlUm8MAb4CKY6JTCNgEKJDQ41M\n0tNzcsjR+46T5U1zhR18O9dzRh5N4GBMrZZM1yHYfbmSQfXPqiTLGyGUc5g+WfvI\nzeOYyCBE13dzx5JSl6uPaz2nNt6ujISt+BZhtKH9KAh2mP3/VxfePf3fL5425YQQ\n2rc5TfPt4aRrKYFeUlzvbasCe0AMkRAisFETcQW3EbK5DCuQHHIBo1qHO36zFcxd\nCQhgnXbKKLT+A2nGAzLDTT2SEWl9hesfZ2Pszo1LRQKBgQC4eNMJdlLud0xFKnaq\nHvDX+rgDMaGMNs1vWX/a0S66l1Sq+vSU98RCAGZMya01C+YMz4wSZaLEiVL+q3ie\npsw4fHjAL7oV0YeIP5bfWTy1EnWnsVc6CC7qU+tS2QMAn+ZfVufjsLPyJubIpdRW\nNFFXnsBcdfiFH+ddon861HD8LwKBgQD9l650rYnghZUhTnUhsCj7FFRnHjIjDnRT\n4vLhdJ5ikGhik6+orbvrurrXu9p6EJ+i0U8hKXVssNOMLjivvu2rQJnSEjpgy8oZ\nGGeE7/Es899eQIqkZ2i3PHLF+YkYicTTiGmapSy/e5mjpe4Tt+nzSU8QX7CI89xU\n1lwU4l+yxQKBgArXry/DMKSrhmQaVtcw8l7/cYlehWxEXFbLH+SwntqAwo06Kt4G\nohZvB5RD1lZj2KWwHT+HkcWTfLlTQsewbhhz2HUTWRCnPBwaALgn+pV5/Eha+BGF\nIZzMSeyYrMCApX29EewkGq+E8dOhS5W1hYJs5kmI9Y59jY/HWUsP6YQpAoGARb45\nlI1FpiIW6ZoSTLmOC7+DlviPAWUwSQHZmnfgN2tPygyj+tgNHr+0MzDO3VNFFBpM\nkOo+CS54f80Wef8gjkCuDUBGHejuJAi6L61tvtczT1Cg0KY//mT5i8kdE0qQfzy9\nDnLu45qynnc8CuBBz08SF4a5nnCy4AI0QOohN6ECgYBHB/uYJ0l43yMNJqEM6NGh\nOU0ErvQjMn1ihOjPX6pCaV6juWK6oretuVFT3m4oZIcN1/Rec9hBKf1KZaRt8fS2\ntpXRc0DAe87Opw9BMUy348WdIxCEn48NAl1FEMDHiF7INeRHYgoe3nhk3JpS3Xr8\nU7CnT9NPqx9XwoD7xtkqnA==\n-----END PRIVATE KEY-----\n",
              "client_email": "sign-up-lxh8y8@appspot.gserviceaccount.com",
              "client_id": "108982918293060693442",
              "auth_uri": "https://accounts.google.com/o/oauth2/auth",
              "token_uri": "https://oauth2.googleapis.com/token",
              "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
              "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/sign-up-lxh8y8%40appspot.gserviceaccount.com",
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