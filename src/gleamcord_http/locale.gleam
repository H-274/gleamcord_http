import gleam/dict.{type Dict}
import gleam/dynamic/decode

const indonesian = "id"

const danish = "da"

const german = "de"

const english_uk = "en-GB"

const english_us = "en-US"

const spanish = "es-ES"

const spanish_latam = "es-419"

const french = "fr"

const croatian = "hr"

const italian = "it"

const lithuanian = "lt"

const hungarian = "hu"

const dutch = "nl"

const norwegian = "no"

const polish = "pl"

const portuguese = "pt-BR"

const romanian = "ro"

const finnish = "fi"

const swedish = "sv-SE"

const vietnamese = "vi"

const turkish = "tr"

const czech = "cs"

const greek = "el"

const bulgarian = "bg"

const russian = "ru"

const ukranian = "uk"

const hindi = "hi"

const thai = "th"

const chinese_cn = "zh-CN"

const japanese = "ja"

const chinese_tw = "zh-TW"

const korean = "ko"

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

pub fn decoder() {
  use string_locale <- decode.then(decode.string)
  case from_string(string_locale) {
    Ok(locale) -> decode.success(locale)
    Error(_) -> decode.failure(Indonesian, "Locale")
  }
}

pub fn to_string(locale: Locale) -> String {
  case locale {
    Indonesian -> indonesian
    Danish -> danish
    German -> german
    EnglishUK -> english_uk
    EnglishUS -> english_us
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

pub fn from_string(locale l: String) -> Result(Locale, Nil) {
  case l {
    _ if l == indonesian -> Ok(Indonesian)
    _ if l == danish -> Ok(Danish)
    _ if l == german -> Ok(German)
    _ if l == english_uk -> Ok(EnglishUK)
    _ if l == english_us -> Ok(EnglishUS)
    _ if l == spanish -> Ok(Spanish)
    _ if l == spanish_latam -> Ok(SpanishLATAM)
    _ if l == french -> Ok(French)
    _ if l == croatian -> Ok(Croatian)
    _ if l == italian -> Ok(Italian)
    _ if l == lithuanian -> Ok(Lithuanian)
    _ if l == hungarian -> Ok(Hungarian)
    _ if l == dutch -> Ok(Dutch)
    _ if l == norwegian -> Ok(Norwegian)
    _ if l == polish -> Ok(Polish)
    _ if l == portuguese -> Ok(Portuguese)
    _ if l == romanian -> Ok(Romanian)
    _ if l == finnish -> Ok(Finnish)
    _ if l == swedish -> Ok(Swedish)
    _ if l == vietnamese -> Ok(Vietnamese)
    _ if l == turkish -> Ok(Turkish)
    _ if l == czech -> Ok(Czech)
    _ if l == greek -> Ok(Greek)
    _ if l == bulgarian -> Ok(Bulgarian)
    _ if l == russian -> Ok(Russian)
    _ if l == ukranian -> Ok(Ukranian)
    _ if l == hindi -> Ok(Hindi)
    _ if l == thai -> Ok(Thai)
    _ if l == chinese_cn -> Ok(ChineseCN)
    _ if l == japanese -> Ok(Japanese)
    _ if l == chinese_tw -> Ok(ChineseTW)
    _ if l == korean -> Ok(Korean)
    _ -> Error(Nil)
  }
}

pub type Translator =
  fn(String) -> Dict(Locale, String)

pub fn empty_translator(_: String) {
  dict.new()
}
