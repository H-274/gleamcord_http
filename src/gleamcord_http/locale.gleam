import gleam/dict.{type Dict}

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

pub fn to_string(locale: Locale) {
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

pub fn from_string(locale: String) {
  case locale {
    l if l == indonesian -> Ok(Indonesian)
    l if l == danish -> Ok(Danish)
    l if l == german -> Ok(German)
    l if l == english_uk -> Ok(EnglishUK)
    l if l == english_us -> Ok(EnglishUS)
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

pub type Translator =
  fn(String) -> Dict(Locale, String)

pub fn empty_translator(_: String) {
  dict.new()
}
