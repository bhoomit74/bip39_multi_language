import '../words/chinese_simplified.dart' as chinese_simplified;
import '../words/chinese_traditional.dart' as chinese_traditional;
import '../words/czech.dart' as czech;
import '../words/english.dart' as english;
import '../words/french.dart' as french;
import '../words/italian.dart' as italian;
import '../words/japanese.dart' as japanese;
import '../words/korean.dart' as korean;
import '../words/portuguese.dart' as portuguese;
import '../words/spanish.dart' as spanish;

///Fetch word list from this [getWordList] method
List<String> getWordList(Language language) {
  switch (language) {
    case Language.english:
      return english.words;
    case Language.french:
      return french.words;
    case Language.italian:
      return italian.words;
    case Language.spanish:
      return spanish.words;
    case Language.japanese:
      return japanese.words;
    case Language.korean:
      return korean.words;
    case Language.portuguese:
      return portuguese.words;
    case Language.czech:
      return czech.words;
    case Language.chineseTraditional:
      return chinese_traditional.words;
    case Language.chineseSimplified:
      return chinese_simplified.words;
  }
}

//All languages that supported by this package
enum Language {
  english,
  french,
  italian,
  spanish,
  japanese,
  korean,
  portuguese,
  czech,
  chineseTraditional,
  chineseSimplified,
}
