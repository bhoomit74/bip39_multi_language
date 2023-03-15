# BIP39_MULTI_LANGUAGE
> BIP39 multi language is a dart package used to generate random mnemonic code in ten different languages.

### Multiple language support
**English, Japanese, French, Italian, Korean, Portuguese, Spanish, chinese(simplified), chinese(traditional), czech**

### bip39
> Dart implementation of [Bitcoin BIP39](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki): Mnemonic code for generating deterministic keys
BIP39 is a design specification that specifies how cryptocurrency wallets generate the set of words (or "mnemonic codes") that comprise a mnemonic sentence, and how the wallet converts them into a binary "seed" that is used to generate encryption keys, which are then used to execute cryptocurrency transactions.

## Examples

```dart
import 'package:bip39_multi_language/bip39_multi_language.dart' as bip39;

main() async {
  //  support 10 languages with BIP39 word list
  
  String mnemonic = bip39.generateMnemonic(language: bip39.Language.english);
  //  rain number industry connect town stay such ribbon return cabbage bus spy
  
  var seed = bip39.mnemonicToSeedHex(mnemonic);
  //  229f35cde89038d4eaf78963e23f0dd57eeb3d1e970839341fc8a259f9e2499d152de1cb96d42c28f1eb2b953837111e6aedc819c759e1e599cf5534e0a4a659
  
  mnemonic = bip39.entropyToMnemonic('00000000000000000000000000000000');
  //  abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about
  
  bool isValid = bip39.validateMnemonic(mnemonic);
  //  true
  isValid = bip39.validateMnemonic('basket actual');
  //  false
  String entropy = bip39.mnemonicToEntropy(mnemonic);
  //  00000000000000000000000000000000
}
```

