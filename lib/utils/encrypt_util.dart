import 'dart:convert';

import 'package:smart_capture_mobile/utils/constant.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:mpcore/mpcore.dart';

class EncryptUtil {
  static Future<String> encrypt(String plainText) async {
    return await Encrypt.encrypt(
            plainText: plainText,
            encryptKey: Constant.encryptKey,
            encryptIV: Constant.encryptIV) ??
        '';
  }

  static Future<String> decrypt(String base64Text) async {
    return await Encrypt.decrypt(
            base64Text: base64Text,
            encryptKey: Constant.encryptKey,
            encryptIV: Constant.encryptIV) ??
        '';
  }

  static String encryptData(String data, String sharedKey) {
    // Biến đổi chuỗi key thành 256-bit
    final key = Key.fromUtf8(
        sha256.convert(utf8.encode(sharedKey)).toString().substring(0, 32));
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    final encrypted = encrypter.encrypt(data, iv: iv);
    final encryptedText = encrypted.base64;

    return encryptedText;
  }

  static String decryptData(String encryptedDataBase64, String sharedKey) {
    // Biến đổi chuỗi key thành 256-bit
    final key = Key.fromUtf8(
        sha256.convert(utf8.encode(sharedKey)).toString().substring(0, 32));
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    final encryptedData = Encrypted.fromBase64(encryptedDataBase64);
    final decrypted = encrypter.decrypt(encryptedData, iv: iv);

    return decrypted;
  }
}
