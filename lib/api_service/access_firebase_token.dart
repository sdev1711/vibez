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
              "private_key_id": "88e9d3e14ee8134c157fec5cb70bfdf4a16319fb",
              "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCLDlS+0kWzfY3G\nOnfMvBkMAQqkYOqgmdA8oO1tvnD1j8TeynlaFu/gqsjCGRFNSPGqLxDUmXZ038Me\nrqEt+PPbxrachTXCqRNQawmxKZ9RCpb//153d/7laa3/frzDTERdtBLV/QTrGOyH\nn6WG+/kF7Z2R5wnUR4XdE2dcM+CMvQ/w8vwjIO3mIUxIHCAlzvfd7ZZJHIbzsEDt\nAsAJ/YhvaKlvMnhl8P9oN/pRCAdXtNhJLEuSmYSBfLBTE6C9fR+stxNfdiGcRLnL\nhxvXoOfho+9JOwoSye887BlmIr4TtD9ma6OGBVp7Gu29fkTjmdJVN/ZssxvkZm+m\nl0sXfHQVAgMBAAECggEAQUiJIM03S/02AkqQ0927JJeYl3Oos52C1fP3g/5UqfTF\nSJNmRZVfKOsFNZrvNIl6a5uNG0KxCk3DHTR/F0Y5toSkVvdzNeCK4MZf1nzj/vgp\nzCXoA86iLLJgrgKiPE4iCpvv++a92GHrKgEZhTXmw5G62DTPuImbnx7s96yjT28C\nP7R6S0UEjyDTMRwuuzh1xCG+AfH+K1ZgucnsHdG9rjIyt6zCIF/wz1WTy0xrPZJB\nuVEmBbLyP8BcVXIhhPOvDXGhUy6U1dPBZG+U99kCM/GxL76z3JauhF/FsX2iwzS7\neHCojtJ0u7b5K4iI3eBo1lXTRHUGP7nV3+BbJAIuQQKBgQDCbCXiOs0ghE5LSV3S\n+zQtTtFv48VxJ3A7fASIpkUJNdcpVlBZ1/ZWYLHgHyvDqAL42dqIcaLtxL9QefaL\n6rjUMzx549mnSDyk24q+5KRQoflHxg78ML+GVcOeF+UWy7XJPuZn9RyQJ/brJOOw\nFatuw5tCTRxu3oyn3eMXubfMVwKBgQC3GQv8fSrNFNU/ai5C2qtsd8AkgF1XUVZr\nR+bey/nEDRsC4JNcWT6LWTWrKTSa7vM+QcRBaGB9jdugXZYIyHkLsreUyI73KcJl\nrSYWEI6txbEAbZtRJoMx9p1qQUzLWedPCf+zHe44CQaMfjsYAzy+b/FKmkLZ2Lhz\n1ZCymQf/cwKBgQCYSanq6HAgVkIViqQpTIb0Llays9DF70Rj86KBfut4aWndgTRz\nC0xzIE5z5TacjQ+26L3aPliGsaPBX6cUtYiM/o0SVLz54QVPhH/LQsDKP/VImQTH\n2U9L5AXT4ZeaIXqE5fYH2+DBsewhB8Yo+PBNVH5akpgA5+V4376vqNMlBQKBgFpS\n5tDVxmmJH3G7JbshOHO313eqQ2Gx5FnkDIZYRYxrkqmms8tY0zvW9FzNZQARZLmP\npAtIPGFzu6auxDbs/pnAvkONdMmFNjsGYcV8wYYEAj9d0sMDprDdIeaq9AFVBoC9\nRADOgRfvi+V+2BQOdMbVXkkZNGVXPhcWgd05FPL1AoGAIPqAqQ9tM0UL3dk6hbKV\nWfoO0sUqSM6u9ymaYvz72/opyj0UhFOOQXs+k9ex4odgOsy11ybfHTp/BwqebB3u\n392yfXIFps95AFwZy3Q1MN4FYzYZBqzAbF3QuahbR2z8OSqylQso/QG2yOqDd72Y\nqydEA1WMmKolio4mgA6Dxws=\n-----END PRIVATE KEY-----\n",
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