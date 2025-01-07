import gleam/dynamic.{type Dynamic}
import gleam/option.{type Option}

pub opaque type LinkButton {
  LinkButton(
    url: String,
    label: Option(String),
    emoji: Option(Dynamic),
    disabled: Bool,
  )
}

pub fn new_with_label(url: String, label: String) {
  LinkButton(
    url:,
    label: option.Some(label),
    emoji: option.None,
    disabled: False,
  )
}

pub fn new_with_emoji(url: String, emoji: Dynamic) {
  LinkButton(
    url:,
    label: option.None,
    emoji: option.Some(emoji),
    disabled: False,
  )
}

pub fn label(button: LinkButton, label: String) {
  LinkButton(..button, label: option.Some(label))
}

pub fn emoji(button: LinkButton, emoji: Dynamic) {
  LinkButton(..button, emoji: option.Some(emoji))
}

pub fn disabled(button: LinkButton) {
  LinkButton(..button, disabled: True)
}
