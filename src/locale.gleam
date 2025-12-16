import gleam/dynamic/decode

pub type Locale {
  Indonesian
  Danish
  German
  EnglishUk
  EnglishUs
  Spanish
  SpanishLatam
  French
  Croatian
  Italian
  Lituanian
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
  ChineseCh
  Japanese
  ChineseTw
  Korean
}

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

const chinese_ch = "zh-CN"

const japanese = "ja"

const chinese_tw = "zh-TW"

const korean = "ko"

pub fn string(locale: Locale) {
  case locale {
    Indonesian -> indonesian
    Danish -> danish
    German -> german
    EnglishUk -> english_uk
    EnglishUs -> english_us
    Spanish -> spanish
    SpanishLatam -> spanish_latam
    French -> french
    Croatian -> croatian
    Italian -> italian
    Lituanian -> lithuanian
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
    ChineseCh -> chinese_ch
    Japanese -> japanese
    ChineseTw -> chinese_tw
    Korean -> korean
  }
}

pub fn decoder() -> decode.Decoder(Locale) {
  use string <- decode.then(decode.string)
  case string {
    s if s == indonesian -> decode.success(Indonesian)
    s if s == danish -> decode.success(Danish)
    s if s == german -> decode.success(German)
    s if s == english_uk -> decode.success(EnglishUk)
    s if s == english_us -> decode.success(EnglishUs)
    s if s == spanish -> decode.success(Spanish)
    s if s == spanish_latam -> decode.success(SpanishLatam)
    s if s == french -> decode.success(French)
    s if s == croatian -> decode.success(Croatian)
    s if s == italian -> decode.success(Italian)
    s if s == lithuanian -> decode.success(Lituanian)
    s if s == hungarian -> decode.success(Hungarian)
    s if s == dutch -> decode.success(Dutch)
    s if s == norwegian -> decode.success(Norwegian)
    s if s == polish -> decode.success(Polish)
    s if s == portuguese -> decode.success(Portuguese)
    s if s == romanian -> decode.success(Romanian)
    s if s == finnish -> decode.success(Finnish)
    s if s == swedish -> decode.success(Swedish)
    s if s == vietnamese -> decode.success(Vietnamese)
    s if s == turkish -> decode.success(Turkish)
    s if s == czech -> decode.success(Czech)
    s if s == greek -> decode.success(Greek)
    s if s == bulgarian -> decode.success(Bulgarian)
    s if s == russian -> decode.success(Russian)
    s if s == ukranian -> decode.success(Ukranian)
    s if s == hindi -> decode.success(Hindi)
    s if s == thai -> decode.success(Thai)
    s if s == chinese_ch -> decode.success(ChineseCh)
    s if s == japanese -> decode.success(Japanese)
    s if s == chinese_tw -> decode.success(ChineseTw)
    s if s == korean -> decode.success(Korean)
    _ -> decode.failure(Indonesian, "Locale")
  }
}
