pub type Locale {
  Indonesian
  Danish
  German
  EnglishUK
  EnglishUS
  Spanish
  SpanishLATAM
  French
  Croatian
  Italian
  Lithuanian
  Hungarian
  Dutch
  Norwegian
  Poligh
  Portuguese
  Romanian
  Finnish
  Swedish
  Vietnamese
  Turkish
  Czech
  Greek
  Bulgarian
  Russian
  Ukrainian
  Hindi
  Thai
  CNChinese
  Japanese
  TWChinese
  Korean
}

pub fn to_string(locale: Locale) -> String {
  case locale {
    Indonesian -> "id"
    Danish -> "da"
    German -> "de"
    EnglishUK -> "en-GB"
    EnglishUS -> "en-US"
    Spanish -> "es-ES"
    SpanishLATAM -> "es-419"
    French -> "fr"
    Croatian -> "hr"
    Italian -> "it"
    Lithuanian -> "lt"
    Hungarian -> "hu"
    Dutch -> "nl"
    Norwegian -> "no"
    Poligh -> "pl"
    Portuguese -> "pt-BR"
    Romanian -> "ro"
    Finnish -> "fi"
    Swedish -> "sv-SE"
    Vietnamese -> "vi"
    Turkish -> "tr"
    Czech -> "cs"
    Greek -> "el"
    Bulgarian -> "bg"
    Russian -> "ru"
    Ukrainian -> "uk"
    Hindi -> "hi"
    Thai -> "th"
    CNChinese -> "zh-CN"
    Japanese -> "ja"
    TWChinese -> "zh-TW"
    Korean -> "ko"
  }
}

pub fn from_string(locale: String) -> Result(Locale, Nil) {
  case locale {
    "id" -> Ok(Indonesian)
    "da" -> Ok(Danish)
    "de" -> Ok(German)
    "en-GB" -> Ok(EnglishUK)
    "en-US" -> Ok(EnglishUS)
    "es-ES" -> Ok(Spanish)
    "es-419" -> Ok(SpanishLATAM)
    "fr" -> Ok(French)
    "hr" -> Ok(Croatian)
    "it" -> Ok(Italian)
    "lt" -> Ok(Lithuanian)
    "hu" -> Ok(Hungarian)
    "nl" -> Ok(Dutch)
    "no" -> Ok(Norwegian)
    "pl" -> Ok(Poligh)
    "pt-BR" -> Ok(Portuguese)
    "ro" -> Ok(Romanian)
    "fi" -> Ok(Finnish)
    "sv-SE" -> Ok(Swedish)
    "vi" -> Ok(Vietnamese)
    "tr" -> Ok(Turkish)
    "cs" -> Ok(Czech)
    "el" -> Ok(Greek)
    "bg" -> Ok(Bulgarian)
    "ru" -> Ok(Russian)
    "uk" -> Ok(Ukrainian)
    "hi" -> Ok(Hindi)
    "th" -> Ok(Thai)
    "zh-CN" -> Ok(CNChinese)
    "ja" -> Ok(Japanese)
    "zh-TW" -> Ok(TWChinese)
    "ko" -> Ok(Korean)
    _ -> Error(Nil)
  }
}
