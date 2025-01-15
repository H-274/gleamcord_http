import credentials.{type Credentials}
import gleam/int
import interaction

const absolute_min_len = 0

const absolute_max_len = 4000

pub type Response {
  JsonString(String)
}

pub type Error {
  NotImplemented
}

pub type Data {
  Data(custom_id: String, value: String)
}

pub opaque type TextInputComponent(ctx) {
  ShortInput(
    custom_id: String,
    label: String,
    min_length: Int,
    max_length: Int,
    required: Bool,
    value: String,
    placeholder: String,
    handler: Handler(ctx),
  )
  ParagraphInput(
    custom_id: String,
    label: String,
    min_length: Int,
    max_length: Int,
    required: Bool,
    value: String,
    placeholder: String,
    handler: Handler(ctx),
  )
}

pub fn new_short(custom_id: String, label: String) {
  ShortInput(
    custom_id:,
    label:,
    min_length: absolute_min_len,
    max_length: absolute_max_len,
    required: False,
    value: "",
    placeholder: "",
    handler: default_handler,
  )
}

pub fn new_paragraph(custom_id: String, label: String) {
  ParagraphInput(
    custom_id:,
    label:,
    min_length: absolute_min_len,
    max_length: absolute_max_len,
    required: False,
    value: "",
    placeholder: "",
    handler: default_handler,
  )
}

pub fn min_length(input: TextInputComponent(ctx), min_length: Int) {
  let min_length =
    int.clamp(min_length, min: absolute_min_len, max: absolute_max_len)

  case input {
    ShortInput(..) -> ShortInput(..input, min_length:)
    ParagraphInput(..) -> ParagraphInput(..input, min_length:)
  }
}

pub fn max_length(input: TextInputComponent(ctx), max_length: Int) {
  let max_length =
    int.clamp(max_length, min: absolute_min_len, max: absolute_max_len)

  case input {
    ShortInput(..) -> ShortInput(..input, max_length:)
    ParagraphInput(..) -> ParagraphInput(..input, max_length:)
  }
}

pub fn required(input: TextInputComponent(ctx)) {
  case input {
    ShortInput(..) -> ShortInput(..input, required: True)
    ParagraphInput(..) -> ParagraphInput(..input, required: True)
  }
}

pub fn value(input: TextInputComponent(ctx), value: String) {
  case input {
    ShortInput(..) -> ShortInput(..input, value:)
    ParagraphInput(..) -> ParagraphInput(..input, value:)
  }
}

pub fn placeholder(input: TextInputComponent(ctx), placeholder: String) {
  case input {
    ShortInput(..) -> ShortInput(..input, placeholder:)
    ParagraphInput(..) -> ParagraphInput(..input, placeholder:)
  }
}

pub type Handler(ctx) =
  fn(interaction.MessageComponent, Credentials, ctx, String) ->
    Result(Response, Error)

pub fn default_handler(_, _, _, _) {
  Error(NotImplemented)
}

pub fn run(
  input: TextInputComponent(ctx),
  interaction: interaction.MessageComponent,
  creds: Credentials,
  ctx: ctx,
  value: String,
) {
  input.handler(interaction, creds, ctx, value)
}
