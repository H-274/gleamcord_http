//// https://discord.com/developers/docs/reference#locales

import gleam/dynamic/decode

pub const indonesian = "id"

pub const danish = "da"

pub const german = "de"

pub const english_uk = "en-GB"

pub const english_us = "en-US"

pub const spanish = "es-ES"

pub const spanish_latam = "es-419"

pub const french = "fr"

pub const croatian = "hr"

pub const italian = "it"

pub const lithuanian = "lt"

pub const hungarian = "hu"

pub const dutch = "nl"

pub const norwegian = "no"

pub const polish = "pl"

pub const portuguese = "pt-BR"

pub const romanian = "ro"

pub const finnish = "fi"

pub const swedish = "sv-SE"

pub const vietnamese = "vi"

pub const turkish = "tr"

pub const czech = "cs"

pub const greek = "el"

pub const bulgarian = "bg"

pub const russian = "ru"

pub const ukranian = "uk"

pub const hindi = "hi"

pub const thai = "th"

pub const chinese_cn = "zh-CN"

pub const japanese = "jp"

pub const chinese_tw = "zh-TW"

pub const korean = "ko"

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
    Indonesian -> indonesian
    Danish -> danish
    German -> german
    EnglishUK -> english_uk
    EnglisnUS -> english_us
    Spanish -> spanish
    SpanishLATAM -> spanish_latam
    French -> french
    Croatian -> croatian
    Italian -> italian
    Lithuanian -> lithuanian
    Hungarian -> hungarian
    Dutch -> dutch
    Norwegian -> norwegian
    Polish -> polish
    Portuguese -> portuguese
    Romanian -> romanian
    Finnish -> finnish
    Swedish -> swedish
    Vietnamese -> vietnamese
    Turkish -> turkish
    Czech -> czech
    Greek -> greek
    Bulgarian -> bulgarian
    Russian -> russian
    Ukranian -> ukranian
    Hindi -> hindi
    Thai -> thai
    ChineseCN -> chinese_cn
    Japanese -> japanese
    ChineseTW -> chinese_tw
    Korean -> korean
  }
}

pub fn from_string(locale: String) -> Result(Locale, Nil) {
  case locale {
    l if l == indonesian -> Ok(Indonesian)
    l if l == danish -> Ok(Danish)
    l if l == german -> Ok(German)
    l if l == english_uk -> Ok(EnglishUK)
    l if l == english_us -> Ok(EnglisnUS)
    l if l == spanish -> Ok(Spanish)
    l if l == spanish_latam -> Ok(SpanishLATAM)
    l if l == french -> Ok(French)
    l if l == croatian -> Ok(Croatian)
    l if l == italian -> Ok(Italian)
    l if l == lithuanian -> Ok(Lithuanian)
    l if l == hungarian -> Ok(Hungarian)
    l if l == dutch -> Ok(Dutch)
    l if l == norwegian -> Ok(Norwegian)
    l if l == polish -> Ok(Polish)
    l if l == portuguese -> Ok(Portuguese)
    l if l == romanian -> Ok(Romanian)
    l if l == finnish -> Ok(Finnish)
    l if l == swedish -> Ok(Swedish)
    l if l == vietnamese -> Ok(Vietnamese)
    l if l == turkish -> Ok(Turkish)
    l if l == czech -> Ok(Czech)
    l if l == greek -> Ok(Greek)
    l if l == bulgarian -> Ok(Bulgarian)
    l if l == russian -> Ok(Russian)
    l if l == ukranian -> Ok(Ukranian)
    l if l == hindi -> Ok(Hindi)
    l if l == thai -> Ok(Thai)
    l if l == chinese_cn -> Ok(ChineseCN)
    l if l == japanese -> Ok(Japanese)
    l if l == chinese_tw -> Ok(ChineseTW)
    l if l == korean -> Ok(Korean)
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
