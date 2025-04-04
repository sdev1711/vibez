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
              "private_key_id": "e89b255a69a0cb5f20a29c52dda4d3af1a4e1f06",
              "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC4VM3qdpNImW0k\nojjBrl6hVhadRlJ2/Z14Hrg2iAVe518kPc/MkwffwKlo9wnuKgqSiRpXsxbsko4o\nb+Zmi9URS+Jj05DY3qAGH9dE/lJYrta65B31RJnNMg7AnkJW8x6mDvzr8EffLWus\nlIYzLVLWKbccg6JEB1pUjGjqDL5JW4hVISLq5DxK+qO7GYg4ecksDhZLHLyWnixd\ndrELD3q53PySEegucEQby6nM0vNIlU0UFfsy8Ba+EuU50aRlAhXA/k/GZKNV/nXc\npJ9PykKCUrtFlBIRO3T/M54BkKcybpusu96fRBiLcKvtZ6CYAMFg9wVztuiw8AsA\nSbMLWGKFAgMBAAECggEAAiCGZMV8Axs0IXdWwNNmh6WS6rswQevAyK1QEl8E8tio\nJiapcnKi5V/XhJzPKkalaxX2bhsksVOqnMhXyAimi4XM5bqAAiSlg5ST+xmVMS1J\nUIxH1Tf2r2G7vljFKrQw/xkOrZlO9wIS60Gmf8ou2cZO9N8G/RJ5ph6dqk+91WJa\nPykNBhmgc0SM0yUqoa4EfnqIz6adhPrFuh5JSJpdvVZIwKtIFf6Md6JU18Q2CAoZ\nCqQx3+ZpGiPsEKZ5jjcu5IOLfln7JlA580HF2NeVL3RpX7Vj6OTnAwhNt/q1GE/B\nG90y0oWJU4jKlYWpmYp02nuuiDvz1ymi0CJHcXl+CQKBgQDfnm6LoahVlHocE3Ua\nR0YtKiRKEzXXrpiWUy0aLM9lP8mNiu2mFokUbo1PIXKY990FxLZcdk4j0wOiroW0\npd3DgWpm45olPVRU/GFnJfP5YvVh+2gLxOnGn21CXycTiSP/SS/WtAXboKNOP+E0\n+ReJWUHcaVZoKTYN2TcnFgVo2QKBgQDTBfpgvAX53+KVIRYpG2FrQ1I3ICV2GJWN\nnUgvESVPYNlDi30IB5vhVXe9ZbWOnYS2bi7Iw9BotAsLLD7rMmi/sL8m9BBPc4Mx\n5FV2v9JiKOUQzrHdv+Znj/2ephORywZCIp4pshUTV0Fvg0v8WcA1w/5GGK8uUTvm\nuC2vq4zbjQKBgQCdIXOmNDLX59wiDF4V2A1swRb84iDMbIgV4V5o7SHSkI7tIbk6\nIs2yCLjM6MDg0hKB8ib+M7dWnvkIAEA9nuuEbFS69aWkE0NF8I308AtOqwWoEwOa\neYSXqAEbSUdpB82+ncu6v4b6PBdkbaivE3VBcvG/kllAGe08r+x8T5H/iQKBgHxM\nWiXeurprmOB0w8Pk3+Y5mlTkN4yvgHARA/LNa6etCWzS3gv7x2LcYBKMtXvS5tg6\nYI5bYQg7fQHQxyLs52x6JK5CNtVF2jJqJ7kx1i+BnSPgTD6tCX9Y/nATrRVEfGQ6\nVeWDgwyIaf/QW9LB3wkMcFtDsPRcXydQt4BxUSAFAoGANr+BPAGvFDW/ufWh7ar+\nggukqk/2pCBHhcVxRx81HbbAAyo+/51BAw8++xksrg85GkTBlxy6rDVGtuWSzS/z\nTx4XUEenDLhUQkR8SiLIJjey/xR0d3upmgvKeQw2lWek719+8un4rkmd9ZcLBdHP\nUhCUE6STihyame1S1Q9gJns=\n-----END PRIVATE KEY-----\n",
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