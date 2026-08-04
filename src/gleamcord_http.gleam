import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/json
import gleam/option.{type Option}
import gleamcord_http/component/layout
import gleamcord_http/discord
import gleamcord_http/message

pub type Translator =
  fn(String) -> Dict(Locale, String)

pub fn default_translator(_: String) -> Dict(Locale, String) {
  dict.new()
}

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

pub fn locale_to_string(locale: Locale) {
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

pub fn locale_decoder() -> decode.Decoder(Locale) {
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

pub opaque type Modal {
  Modal(
    custom_id: String,
    title: String,
    components: List(layout.Label),
    handler: ModalHandler,
  )
}

pub fn modal(
  id custom_id: String,
  title title: String,
  components components: List(layout.Label),
  handler handler: ModalHandler,
) {
  Modal(custom_id:, title:, components:, handler:)
}

pub fn modal_tuple(modal modal: Modal) {
  #(modal.custom_id, modal)
}

pub fn modal_json(modal: Modal) {
  let Modal(custom_id:, title:, components:, handler: _) = modal

  [
    #("custom_id", json.string(custom_id)),
    #("title", json.string(title)),
    #("components", json.array(components, layout.label_json)),
  ]
  |> json.object
}

pub type ModalInteraction {
  ModalInteraction(
    id: String,
    application_id: String,
    data: ModalData,
    guild: Option(Dynamic),
    guild_id: Option(String),
    channel: Option(Dynamic),
    channel_id: Option(String),
    member: Option(Dynamic),
    user: Option(Dynamic),
    token: String,
    version: Int,
    message: Option(Dynamic),
    permissions: String,
    locale: Option(Locale),
    guild_locale: Option(Locale),
    entitlements: List(Dynamic),
    authorizing_integration_owners: Dict(String, Dynamic),
    context: Dynamic,
    attachment_size_limit: Int,
  )
}

pub fn modal_interaction_decoder() -> decode.Decoder(ModalInteraction) {
  use id <- decode.field("id", decode.string)
  use application_id <- decode.field("application_id", decode.string)
  use data <- decode.field("data", modal_data_decoder())
  use guild <- decode.field("guild", decode.optional(decode.dynamic))
  use guild_id <- decode.field("guild_id", decode.optional(decode.string))
  use channel <- decode.field("channel", decode.optional(decode.dynamic))
  use channel_id <- decode.field("channel_id", decode.optional(decode.string))
  use member <- decode.field("member", decode.optional(decode.dynamic))
  use user <- decode.optional_field(
    "user",
    option.None,
    decode.optional(decode.dynamic),
  )
  use token <- decode.field("token", decode.string)
  use version <- decode.field("version", decode.int)
  use message <- decode.optional_field(
    "message",
    option.None,
    decode.optional(decode.dynamic),
  )
  use permissions <- decode.optional_field("app_permissions", "", decode.string)
  use locale <- decode.field("locale", decode.optional(locale_decoder()))
  use guild_locale <- decode.field(
    "guild_locale",
    decode.optional(locale_decoder()),
  )
  use entitlements <- decode.field("entitlements", decode.list(decode.dynamic))
  use authorizing_integration_owners <- decode.field(
    "authorizing_integration_owners",
    decode.dict(decode.string, decode.dynamic),
  )
  use context <- decode.field("context", decode.dynamic)
  use attachment_size_limit <- decode.field("attachment_size_limit", decode.int)
  decode.success(ModalInteraction(
    id:,
    application_id:,
    data:,
    guild:,
    guild_id:,
    channel:,
    channel_id:,
    member:,
    user:,
    token:,
    version:,
    message:,
    permissions:,
    locale:,
    guild_locale:,
    entitlements:,
    authorizing_integration_owners:,
    context:,
    attachment_size_limit:,
  ))
}

pub type ModalData {
  ModalData(
    custom_id: String,
    components: Dict(String, String),
    resolved: Option(discord.Resolved),
  )
}

fn modal_data_decoder() -> decode.Decoder(ModalData) {
  use custom_id <- decode.field("custom_id", decode.string)
  use components <- decode.field(
    "components",
    decode.list({
      use custom_id <- decode.subfield(
        ["component", "custom_id"],
        decode.string,
      )
      use value <- decode.subfield(["component", "value"], decode.string)
      decode.success(#(custom_id, value))
    })
      |> decode.map(dict.from_list),
  )
  use resolved <- decode.optional_field(
    "resolved",
    option.None,
    decode.optional(discord.resolved_decoder()),
  )
  decode.success(ModalData(custom_id:, components:, resolved:))
}

// TODO eventually directly put values from resolved instead of string as dict value
pub type ModalHandler =
  fn(ModalInteraction, Dict(String, String)) -> ModalResponse

pub type ModalResponse {
  MessageResponse(message.New)
  DeferredMessageResponse(fn() -> message.New)
  UpdateResponse(message.New)
  DeferredUpdateResponse(fn() -> message.New)
}

pub fn handle_modal_interaction(
  modals: Dict(String, Modal),
  i: ModalInteraction,
) -> Result(ModalResponse, Nil) {
  case dict.get(modals, i.data.custom_id) {
    Ok(modal) -> modal.handler(i, i.data.components) |> Ok
    _ -> Error(Nil)
  }
}
