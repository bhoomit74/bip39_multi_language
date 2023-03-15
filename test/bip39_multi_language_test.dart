import 'dart:typed_data';

import 'package:bip39_multi_language/bip39_multi_language.dart' as bip39;
import 'package:bip39_multi_language/src/utils/languages.dart';
import 'package:hex/hex.dart';
import 'package:test/test.dart';

void main() {
  group('invalid entropy', () {
    test('throws for empty entropy', () {
      try {
        expect(bip39.entropyToMnemonic(''), throwsArgumentError);
      } catch (err) {
        expect((err as ArgumentError).message, "Invalid entropy");
      }
    });

    test('throws for entropy that\'s not a multitude of 4 bytes', () {
      try {
        expect(bip39.entropyToMnemonic('000000'), throwsArgumentError);
      } catch (err) {
        expect((err as ArgumentError).message, "Invalid entropy");
      }
    });

    test('throws for entropy that is larger than 1024', () {
      try {
        expect(bip39.entropyToMnemonic(Uint8List(1028 + 1).join('00')),
            throwsArgumentError);
      } catch (err) {
        expect((err as ArgumentError).message, "Invalid entropy");
      }
    });
  });
  test('validateMnemonic', () {
    expect(bip39.validateMnemonic('sleep kitten'), isFalse,
        reason: 'fails for a mnemonic that is too short');

    expect(bip39.validateMnemonic('sleep kitten sleep kitten sleep kitten'),
        isFalse,
        reason: 'fails for a mnemonic that is too short');

    expect(
        bip39.validateMnemonic(
            'abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about end grace oxygen maze bright face loan ticket trial leg cruel lizard bread worry reject journey perfect chef section caught neither install industry'),
        isFalse,
        reason: 'fails for a mnemonic that is too long');

    expect(
        bip39.validateMnemonic(
            'turtle front uncle idea crush write shrug there lottery flower risky shell'),
        isFalse,
        reason: 'fails if mnemonic words are not in the word list');

    expect(
        bip39.validateMnemonic(
            'sleep kitten sleep kitten sleep kitten sleep kitten sleep kitten sleep kitten'),
        isFalse,
        reason: 'fails for invalid checksum');
  });
  group('generateMnemonic', () {
    test('can vary entropy length', () {
      final words = (bip39.generateMnemonic(strength: 160)).split(' ');
      expect(words.length, equals(15),
          reason: 'can vary generated entropy bit length');
    });

    test('requests the exact amount of data from an RNG', () {
      bip39.generateMnemonic(
          strength: 160,
          randomBytes: (int size) {
            expect(size, 160 / 8);
            return Uint8List(size);
          });
    });
  });

  group("generate mnemonics in multiple language", () {
    test("English mnemonic generation", () {
      var mnemonic = bip39.generateMnemonic(language: Language.english);
      expect(mnemonic.split(' ').length, 12);
      expect(getWordList(Language.english).contains(mnemonic.split(" ").first),
          true);
      expect(getWordList(Language.spanish).contains(mnemonic.split(" ").first),
          false);
    });

    test("Chinese Simplified mnemonic generation", () {
      var mnemonic =
          bip39.generateMnemonic(language: Language.chineseSimplified);
      expect(mnemonic.split(' ').length, 12);
      expect(
          getWordList(Language.chineseSimplified)
              .contains(mnemonic.split(" ").first),
          true);
      expect(getWordList(Language.english).contains(mnemonic.split(" ").first),
          false);
    });

    test("Chinese traditional mnemonic generation", () {
      var mnemonic =
          bip39.generateMnemonic(language: Language.chineseTraditional);
      expect(mnemonic.split(' ').length, 12);
      expect(
          getWordList(Language.chineseTraditional)
              .contains(mnemonic.split(" ").first),
          true);
      expect(getWordList(Language.english).contains(mnemonic.split(" ").first),
          false);
    });

    test("Spanish mnemonic generation", () {
      var mnemonic = bip39.generateMnemonic(language: Language.spanish);
      expect(mnemonic.split(' ').length, 12);
      expect(getWordList(Language.spanish).contains(mnemonic.split(" ").first),
          true);
      expect(
          getWordList(Language.chineseTraditional)
              .contains(mnemonic.split(" ").first),
          false);
    });

    test("Korean mnemonic generation", () {
      var mnemonic = bip39.generateMnemonic(language: Language.korean);
      expect(mnemonic.split(' ').length, 12);
      expect(getWordList(Language.korean).contains(mnemonic.split(" ").first),
          true);
      expect(getWordList(Language.spanish).contains(mnemonic.split(" ").first),
          false);
    });

    test("Italian mnemonic generation", () {
      var mnemonic = bip39.generateMnemonic(language: Language.italian);
      expect(mnemonic.split(' ').length, 12);
      expect(getWordList(Language.italian).contains(mnemonic.split(" ").first),
          true);
      expect(getWordList(Language.korean).contains(mnemonic.split(" ").first),
          false);
    });

    test("Portuguese mnemonic generation", () {
      var mnemonic = bip39.generateMnemonic(language: Language.portuguese);
      expect(mnemonic.split(' ').length, 12);
      expect(
          getWordList(Language.portuguese).contains(mnemonic.split(" ").first),
          true);
      expect(getWordList(Language.italian).contains(mnemonic.split(" ").first),
          false);
    });

    test("Czech mnemonic generation", () {
      var mnemonic = bip39.generateMnemonic(language: Language.czech);
      expect(mnemonic.split(' ').length, 12);
      expect(getWordList(Language.czech).contains(mnemonic.split(" ").first),
          true);
      expect(
          getWordList(Language.portuguese).contains(mnemonic.split(" ").first),
          false);
    });

    test("Japanese mnemonic generation", () {
      var mnemonic = bip39.generateMnemonic(language: Language.japanese);
      expect(mnemonic.split(' ').length, 12);
      expect(getWordList(Language.japanese).contains(mnemonic.split(" ").first),
          true);
      expect(getWordList(Language.english).contains(mnemonic.split(" ").first),
          false);
    });
  });

  group("Seed generation test", () {
    test("Mnemonic to seed generation", () {
      var mnemonic =
          "useless public bachelor great typical any rail resist school survey payment maze";
      var seedMatcher =
          "ae0dfe9e53d5ebd6a06a1a350800bc2aff603d459bed45359302f6ee9a6fdb82a9fe7c92b3cea9769484a396cc6454c205edcfa56dc2bb6b53bae41d42a21b3b";
      var seed = bip39.mnemonicToSeed(mnemonic);
      expect(seed, HEX.decode(seedMatcher));
    });

    test("Mnemonic to seed Hex generation", () {
      var mnemonic =
          "useless public bachelor great typical any rail resist school survey payment maze";
      var seedMatcher =
          "ae0dfe9e53d5ebd6a06a1a350800bc2aff603d459bed45359302f6ee9a6fdb82a9fe7c92b3cea9769484a396cc6454c205edcfa56dc2bb6b53bae41d42a21b3b";
      var seed = bip39.mnemonicToSeedHex(mnemonic);
      expect(seed, seedMatcher);
    });
  });
}
