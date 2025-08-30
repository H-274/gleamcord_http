//// https://discord.com/developers/docs/reference#locales

import gleam/dynamic/decode

pub type Locale {
  Indonesian
  Danish
  German
  EnglishUK
  EnglisnUS
  Spanish
  SpanishLATAM
  French
  Croatian
  Italian
  Lithuanian
  Hungarian
  Dutch
  Norwegian
  Polish
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
  Ukranian
  Hindi
  Thai
  ChineseCN
  Japanese
  ChineseTW
  Korean
}

pub fn to_string(locale: Locale) -> String {
  case locale {
    Indonesian -> "id"
    Danish -> "da"
    German -> "de"
    EnglishUK -> "en-GB"
    EnglisnUS -> "en-US"
    Spanish -> "es-ES"
    SpanishLATAM -> "es-419"
    French -> "fr"
    Croatian -> "hr"
    Italian -> "it"
    Lithuanian -> "lt"
    Hungarian -> "hu"
    Dutch -> "nl"
    Norwegian -> "no"
    Polish -> "pl"
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
    Ukranian -> "uk"
    Hindi -> "hi"
    Thai -> "th"
    ChineseCN -> "zh-CN"
    Japanese -> "jp"
    ChineseTW -> "zh-TW"
    Korean -> "ko"
  }
}

pub fn from_string(locale: String) -> Result(Locale, Nil) {
  case locale {
    "id" -> Ok(Indonesian)
    "da" -> Ok(Danish)
    "de" -> Ok(German)
    "en-GB" -> Ok(EnglishUK)
    "en-US" -> Ok(EnglisnUS)
    "es-ES" -> Ok(Spanish)
    "es-419" -> Ok(SpanishLATAM)
    "fr" -> Ok(French)
    "hr" -> Ok(Croatian)
    "it" -> Ok(Italian)
    "lt" -> Ok(Lithuanian)
    "hu" -> Ok(Hungarian)
    "nl" -> Ok(Dutch)
    "no" -> Ok(Norwegian)
    "pl" -> Ok(Polish)
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
    "uk" -> Ok(Ukranian)
    "hi" -> Ok(Hindi)
    "th" -> Ok(Thai)
    "zh-CN" -> Ok(ChineseCN)
    "jp" -> Ok(Japanese)
    "zh-TW" -> Ok(ChineseTW)
    "ko" -> Ok(Korean)
    _ -> Error(Nil)
  }
}

pub fn decoder() {
  use locale_string <- decode.then(decode.string)

  case from_string(locale_string) {
    Ok(locale) -> decode.success(locale)
    _ -> decode.failure(Indonesian, "entities/locale.Locale")
  }
}
