import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt;

// //issa baba
// final basicToken =
//     'Basic MjhiNmYyZmU0MDQzYjc2NDprOGhlcVFBcVhWSFJ5Qmp4ZDhSdXR2R09KaFRDMWpPS04wZUVrVVRKZXRBPQ==';
// final privateKey = '68768f0e10309ad966da2da23afeefb8';
// final publicKey = '28b6f2fe4043b764';

//
// mazyad
final basicToken =
    'Basic MTI5ZGEwZDZlMjI4MzNlMDptdThMZW5uS3p1eTIrTFpRVEQvREk4U1pZVVVSM21VVGZHdEpoRnZnR3ZVPQ==';
final privateKey = 'b1917428742ffaa5c12b8754434dcef9';
final publicKey = '129da0d6e22833e0';

dynamic decrypt(String encryptedText, String privateKey, String publicKey) {
  final keyObj = encrypt.Key.fromUtf8(privateKey);
  final ivObj = encrypt.IV.fromUtf8(publicKey);
  final encrypter = encrypt.Encrypter(
    encrypt.AES(keyObj, mode: encrypt.AESMode.cbc),
  );

  try {
    final decrypted = encrypter.decrypt(
      encrypt.Encrypted.fromBase64(encryptedText),
      iv: ivObj,
    );
    return decrypted;
  } catch (e) {
    return 'Error....................';
  }
}

String encryptData(
  Map<String, dynamic> data,
  String privateKey,
  String publicKey,
) {
  final key = encrypt.Key.fromUtf8(privateKey);
  final iv = encrypt.IV.fromUtf8(publicKey);
  final encrypter = encrypt.Encrypter(
    encrypt.AES(key, mode: encrypt.AESMode.cbc),
  );
  try {
    String jsonString = json.encode(data);
    final encrypted = encrypter.encrypt(jsonString, iv: iv);
    final encryptedText = encrypted.base64;
    return encryptedText;
  } catch (e) {
    return 'Error....................';
  }
}
