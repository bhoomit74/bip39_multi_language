import 'package:bip39_multi_language/bip39_multi_language.dart' as bip39;

main() async {
  String mnemonic = bip39.generateMnemonic(language: bip39.Language.english);
  print(mnemonic);
  var seed = bip39.mnemonicToSeedHex(mnemonic);
  print(seed);
  mnemonic = bip39.entropyToMnemonic('00000000000000000000000000000000');
  print(mnemonic);
  bool isValid = bip39.validateMnemonic(mnemonic);
  print(isValid);
  isValid = bip39.validateMnemonic('basket actual');
  print(isValid);
  String entropy = bip39.mnemonicToEntropy(mnemonic);
  print(entropy);
}
