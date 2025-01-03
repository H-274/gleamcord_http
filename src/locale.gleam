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
