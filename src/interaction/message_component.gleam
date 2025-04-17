import gleam/json.{type Json}
import gleam/option.{type Option}
import interaction.{type MessageComponentInteraction}
import interaction/response

pub type ActionRow(bot) =
  List(MessageComponent(bot))

pub opaque type MessageComponent(bot) {
  Button(ButtonComponent(bot))
  StringSelect
  TextInput
  UserSelect
  RoleSelect
  MentionableSelect
  ChannelSelect
}

pub opaque type ButtonComponent(bot) {
  PrimaryButton(Definition, disabled: Bool, handler: ButtonHandler(bot))
  SecondaryButton(Definition, disabled: Bool, handler: ButtonHandler(bot))
  SuccessButton(Definition, disabled: Bool, handler: ButtonHandler(bot))
  DangerButton(Definition, disabled: Bool, handler: ButtonHandler(bot))
  LinkButton(label: String, url: String, disabled: Bool)
  PremiumButton(sku_id: String, disabled: Bool)
}

pub type Definition {
  Definition(label: String, emoji: Option(Nil), custom_id: String)
}

pub fn styled_button(label label: String, id custom_id: String) {
  Definition(label:, emoji: option.None, custom_id:)
}

pub fn styled_button_emoji(def def: Definition, emoji emoji: Nil) {
  Definition(..def, emoji: option.Some(emoji))
}

pub fn primary_button(
  def def: Definition,
  disabled disabled: Bool,
  handler handler: ButtonHandler(_),
) {
  Button(PrimaryButton(def, disabled:, handler:))
}

pub fn secondary_button(
  def def: Definition,
  disabled disabled: Bool,
  handler handler: ButtonHandler(_),
) {
  Button(SecondaryButton(def, disabled:, handler:))
}

pub fn success_button(
  def def: Definition,
  disabled disabled: Bool,
  handler handler: ButtonHandler(_),
) {
  Button(SuccessButton(def, disabled:, handler:))
}

pub fn danger_button(
  def def: Definition,
  disabled disabled: Bool,
  handler handler: ButtonHandler(_),
) {
  Button(DangerButton(def, disabled:, handler:))
}

pub fn link_button(
  label label: String,
  url url: String,
  disabled disabled: Bool,
) {
  Button(LinkButton(label:, url:, disabled:))
}

pub fn premium_button(sku sku_id: String, disabled disabled: Bool) {
  Button(PremiumButton(sku_id:, disabled:))
}

pub type ButtonHandler(bot) =
  fn(MessageComponentInteraction, bot) ->
    Result(response.Success, response.Failure)

pub type StringSelectComponent

pub type TextInputComponent

pub type UserSelectComponent

pub type RoleSelectComponent

pub type MentionableSelectComponent

pub type ChannelSelectComponent

pub fn json_encode(component: MessageComponent(_)) -> Json {
  case component {
    Button(component) -> button_json(component)
    _ ->
      panic as "Other components are missing implementations and cannot be used"
  }
}

fn button_json(button: ButtonComponent(_)) {
  case button {
    PrimaryButton(def, disabled: disabled, ..) -> {
      let fields = [
        #("type", json.int(2)),
        #("label", json.string(def.label)),
        // #("emoji", todo as "emoji_json()"),
        #("style", json.int(1)),
        #("disabled", json.bool(disabled)),
      ]
      json.object(fields)
    }
    SecondaryButton(def, disabled: disabled, ..) -> {
      let fields = [
        #("type", json.int(2)),
        #("label", json.string(def.label)),
        // #("emoji", todo as "emoji_json()"),
        #("style", json.int(2)),
        #("disabled", json.bool(disabled)),
      ]
      json.object(fields)
    }
    SuccessButton(def, disabled: disabled, ..) -> {
      let fields = [
        #("type", json.int(2)),
        #("label", json.string(def.label)),
        // #("emoji", todo as "emoji_json()"),
        #("style", json.int(3)),
        #("disabled", json.bool(disabled)),
      ]
      json.object(fields)
    }
    DangerButton(def, disabled: disabled, ..) -> {
      let fields = [
        #("type", json.int(2)),
        #("label", json.string(def.label)),
        // #("emoji", todo as "emoji_json()"),
        #("style", json.int(4)),
        #("disabled", json.bool(disabled)),
      ]
      json.object(fields)
    }
    LinkButton(label, url, disabled) -> {
      let fields = [
        #("type", json.int(2)),
        #("label", json.string(label)),
        #("style", json.int(5)),
        #("url", json.string(url)),
        #("disabled", json.bool(disabled)),
      ]
      json.object(fields)
    }
    PremiumButton(sku_id, disabled) -> {
      let fields = [
        #("type", json.int(2)),
        #("style", json.int(6)),
        #("sku_idrl", json.string(sku_id)),
        #("disabled", json.bool(disabled)),
      ]
      json.object(fields)
    }
  }
}
