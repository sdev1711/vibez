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
              "private_key_id": "a62eba669801ae1ce2101d2d4b9db9b2d1f4c962",
              "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDOxVQpTkjVCxYj\nxmZ1gR0aGkxjGecIGIlwpuaZSLIELfWssM53zQkNk6QatPyk8yCpXtviyvlKm1sO\nSrc5eewP6oUj92UtBphn6NXIy7KCptQ4c3iUP2RFVxJR3MAeR0hNiVlulrDtGAWv\nT1mLrETZ1GNA5+Sw1Wv6BnOjT15CUeVdgnnU2TdoT6y/AywemOEahhuooFUYKX84\n4ckdRVtYPtx/eWSknTsEnpx+pEIddMNOfow6GYWefo77OzwHa4S9deosYPYq207b\nKR2El4gURuLKybzoPIamppTonJyHuEHOr8xPbRyxcjQZXg0B+EOO1rtQoF6DtboH\n90LHhfWzAgMBAAECggEALLQa+wcy1eSct8VYN4VfnlobM73Q5j4v0Mw0xOUjn6W0\nHM7pBJuunmHSM/f3O05ZPGUG0ySg+xFVgWSD8og6kkJY4KrHFBH991Euj0gC4x5g\neYf1hM+jxR4LFunMG3+70Q+l5zPrModkCz/zky/+fr3da5X3Kogp3Rdx/tfVAC9C\nk/E5soLwo23Qevecnt2e1rs7SP6pjBkbW7aEtfOH/qXBOqVVgJP8Akvs60/adUn0\nSW3D9n2n4wWjTLbdHVPc52KNOPCYzoQkeNYCPDsaN5b4j6Ov7EhNCSLu2oHcHPIh\nIgJYeL3IebeYP6iFpzghO+vuxQvXyCMgATPmr3NwyQKBgQD+ZI8Gc7cFxOB5/T2l\nOTDrsB/z//w4defvhGMDWW1P6Nst4p4frMdtb8V0zBb31sdeCE8I3rXP1Qjg0IGM\nThzVpBd6/jepqOpKzQEN33wlSFaB8QUHbckXCOor43ZCU+fVQj3MN8LAua2rlIoc\nFy2Bo+UoqX8WmF6vn8LNaObrXQKBgQDQE7+xiWmvSsAWrw1H518AoRajmTZXYD5I\nadwxRuJKPCLW81FkjUgbMeAEURltO/3uPOE8tT8iak5goeV3o3bKNs+Urgdx2e6B\nMSUPg58gedq7CHyb5Sd5WMEgRZ7HpDVZKNkV4WLA3c2j1R/fpjF2s4ua1n4BzJvS\nTRruU29kTwKBgQC8nzERVqFBDM5ohSW9KV+lkczPbWHFN19G0AFeTWNo2b4SErKt\nx72C3lopFN5+22itxzla2U8zj8DqeI9lydFFc0rZrj71dEJsPf7nG2sAddd2t4/E\nB1oP01NWQWzBF1eRX3FUx4+GuOYVj6ir1V+vfSd/89VAmq+yRqH5DiwSHQKBgBZK\nl1XAv+a8nlmPxV93pRDfMRqztkOkFugRFzrcOi/zw1O923FnRVtMe5Ba09uE+s5E\nDWlAjZP1SZJGpdusUnSVbKWkAz4qN8f1aOABnNGQ3GL/JMJayWDRplb7vmfq6qAz\npRYYAEljOb2cfn6qQlBSKdmbswIkVmkwQ3tWyu83AoGAEgAvqFo0om+EjJuNi7vs\nohdKHbFy6Z1cqRTeOMBtpC/UvJ6fAr037JIXj9DGVqPhG0HJbdahRbZgeDpqNECa\nuY2mBrLPefpgcH2E4OlNKtADJusPwqCZZ6F9YWqb0+FK+/h2LvdjloF/9Aq5WqYX\nrPUEv0P63mJElUkWhN9uPWM=\n-----END PRIVATE KEY-----\n",
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