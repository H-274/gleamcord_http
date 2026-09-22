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

const polish = "po"

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

const chinese_china = "zh-CN"

const japanese = "jp"

const chinese_taiwan = "zh-TW"

const korean = "ko"

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
  ChineseCh
  Japanese
  ChineseTw
  Korean
}

pub fn from_string(locale_string: String) -> Result(Locale, Nil) {
  case locale_string {
    locale if locale == indonesian -> Indonesian |> Ok
    locale if locale == danish -> Danish |> Ok
    locale if locale == german -> German |> Ok
    locale if locale == english_uk -> EnglishUk |> Ok
    locale if locale == english_us -> EnglishUs |> Ok
    locale if locale == spanish -> Spanish |> Ok
    locale if locale == spanish_latam -> SpanishLatam |> Ok
    locale if locale == french -> French |> Ok
    locale if locale == croatian -> Croatian |> Ok
    locale if locale == italian -> Italian |> Ok
    locale if locale == lithuanian -> Lithuanian |> Ok
    locale if locale == hungarian -> Hungarian |> Ok
    locale if locale == dutch -> Dutch |> Ok
    locale if locale == norwegian -> Norwegian |> Ok
    locale if locale == polish -> Polish |> Ok
    locale if locale == portuguese -> Portuguese |> Ok
    locale if locale == romanian -> Romanian |> Ok
    locale if locale == finnish -> Finnish |> Ok
    locale if locale == swedish -> Swedish |> Ok
    locale if locale == vietnamese -> Vietnamese |> Ok
    locale if locale == turkish -> Turkish |> Ok
    locale if locale == czech -> Czech |> Ok
    locale if locale == greek -> Greek |> Ok
    locale if locale == bulgarian -> Bulgarian |> Ok
    locale if locale == russian -> Russian |> Ok
    locale if locale == ukranian -> Ukranian |> Ok
    locale if locale == hindi -> Hindi |> Ok
    locale if locale == thai -> Thai |> Ok
    locale if locale == chinese_china -> ChineseCh |> Ok
    locale if locale == japanese -> Japanese |> Ok
    locale if locale == chinese_taiwan -> ChineseTw |> Ok
    locale if locale == korean -> Korean |> Ok
    _ -> Error(Nil)
  }
}

pub fn to_string(locale: Locale) -> String {
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
    ChineseCh -> chinese_china
    Japanese -> japanese
    ChineseTw -> chinese_china
    Korean -> korean
  }
}

pub type Translator =
  fn(String) -> Dict(Locale, String)

pub fn empty_transltor(_: String) {
  dict.new()
}
