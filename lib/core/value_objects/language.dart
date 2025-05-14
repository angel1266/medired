import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'language')
enum Language {
  @JsonValue(0)

  /// Español
  es,

  @JsonValue(1)

  /// English
  en,
}

final Map<String, Language> stringToLanguage = {
  'Español': Language.es,
  'English': Language.en,
};

final Map<Language, String> languageToString = {
  Language.es: 'Español',
  Language.en: 'English',
};
