import 'dart:math';
import 'dart:typed_data';

import 'package:bip39_multi_language/src/utils/app_constants.dart';
import 'package:bip39_multi_language/src/utils/languages.dart';
import 'package:crypto/crypto.dart' show sha256;
import 'package:hex/hex.dart';

import '../utils/pbkdf2.dart';

const Language _defaultLanguage = Language.english;
typedef RandomBytes = Uint8List Function(int size);

///Generate random mnemonic, default language is [Language.english].
String generateMnemonic(
    {int strength = 128,
    RandomBytes randomBytes = _randomBytes,
    Language language = _defaultLanguage}) {
  assert(strength % 32 == 0);
  final entropy = randomBytes(strength ~/ 8);
  return entropyToMnemonic(HEX.encode(entropy), language: language);
}

///Get mnemonic from entropy(in Hex format), default language is [Language.english].
String entropyToMnemonic(String entropyString,
    {Language language = _defaultLanguage}) {
  final entropy = Uint8List.fromList(HEX.decode(entropyString));
  if (entropy.length < 4 || entropy.length > 32) {
    throw ArgumentError(AppConstants.invalidEntropy);
  } else if (entropy.length % 4 != 0) {
    throw ArgumentError(AppConstants.invalidEntropy);
  }
  final entropyBits = _bytesToBinary(entropy);
  final checksumBits = _deriveChecksumBits(entropy);
  final bits = entropyBits + checksumBits;
  final regex = RegExp(r".{1,11}", caseSensitive: false, multiLine: false);
  final chunks = regex
      .allMatches(bits)
      .map((match) => match.group(0)!)
      .toList(growable: false);
  List<String>? wordlist = getWordList(language);
  String words =
      chunks.map((binary) => wordlist[_binaryToByte(binary)]).join(' ');
  return words;
}

///Get seed in [Uint8List] format from mnemonic, Optionally you can provide [passphrase].
Uint8List mnemonicToSeed(String mnemonic, {String passphrase = ""}) {
  final pbkdf2 = PBKDF2();
  return pbkdf2.process(mnemonic, passphrase: passphrase);
}

///Get seed in [HEX] format from mnemonic, Optionally you can provide [passphrase].
String mnemonicToSeedHex(String mnemonic, {String passphrase = ""}) {
  return mnemonicToSeed(mnemonic, passphrase: passphrase).map((byte) {
    return byte.toRadixString(16).padLeft(2, '0');
  }).join('');
}

///Check mnemonic is valid or not, Return [bool] value.
bool validateMnemonic(String mnemonic, {Language language = _defaultLanguage}) {
  try {
    mnemonicToEntropy(mnemonic, language: language);
  } catch (e) {
    return false;
  }
  return true;
}

///Get entropy from the mnemonic,default language is [Language.english].
String mnemonicToEntropy(mnemonic, {Language language = _defaultLanguage}) {
  var words = mnemonic.split(' ');
  if (words.length % 3 != 0) {
    throw ArgumentError(AppConstants.invalidMnemonic);
  }
  final wordlist = getWordList(language);
  // convert word indices to 11 bit binary strings
  final bits = words.map((word) {
    final index = wordlist.indexOf(word);
    if (index == -1) {
      throw ArgumentError(AppConstants.invalidMnemonic);
    }
    return index.toRadixString(2).padLeft(11, '0');
  }).join('');
  // split the binary string into ent/cs
  final dividerIndex = (bits.length / 33).floor() * 32;
  final entropyBits = bits.substring(0, dividerIndex);
  final checksumBits = bits.substring(dividerIndex);

  // calculate the checksum and compare
  final regex = RegExp(r".{1,8}");
  final entropyBytes = Uint8List.fromList(regex
      .allMatches(entropyBits)
      .map((match) => _binaryToByte(match.group(0)!))
      .toList(growable: false));
  if (entropyBytes.length < 4 || entropyBytes.length > 32) {
    throw StateError(AppConstants.invalidEntropy);
  } else if (entropyBytes.length % 4 != 0) {
    throw StateError(AppConstants.invalidEntropy);
  }

  final newChecksum = _deriveChecksumBits(entropyBytes);
  if (newChecksum != checksumBits) {
    throw StateError(AppConstants.invalidChecksum);
  }
  return entropyBytes.map((byte) {
    return byte.toRadixString(16).padLeft(2, '0');
  }).join('');
}

int _binaryToByte(String binary) {
  return int.parse(binary, radix: 2);
}

String _bytesToBinary(Uint8List bytes) {
  return bytes.map((byte) => byte.toRadixString(2).padLeft(8, '0')).join('');
}

String _deriveChecksumBits(Uint8List entropy) {
  final ent = entropy.length * 8;
  final cs = ent ~/ 32;
  final hash = sha256.convert(entropy);
  return _bytesToBinary(Uint8List.fromList(hash.bytes)).substring(0, cs);
}

Uint8List _randomBytes(int size) {
  final rng = Random.secure();
  final bytes = Uint8List(size);
  for (var i = 0; i < size; i++) {
    bytes[i] = rng.nextInt(AppConstants.sizeBytes);
  }
  return bytes;
}
