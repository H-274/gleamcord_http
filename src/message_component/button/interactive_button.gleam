import gleam/option.{type Option}
import message_component/interaction.{type Interaction}
import message_component/response.{type Response}

pub type InteractiveButton(state) {
  PrimaryButton(
    custom_id: String,
    label: String,
    emoji: Option(#(String, String, Bool)),
    disabled: Bool,
    handler: ButtonHandler(state),
  )
  SecondaryButton(
    custom_id: String,
    label: String,
    emoji: Option(#(String, String, Bool)),
    disabled: Bool,
    handler: ButtonHandler(state),
  )
  SuccessButton(
    custom_id: String,
    label: String,
    emoji: Option(#(String, String, Bool)),
    disabled: Bool,
    handler: ButtonHandler(state),
  )
  DangerButton(
    custom_id: String,
    label: String,
    emoji: Option(#(String, String, Bool)),
    disabled: Bool,
    handler: ButtonHandler(state),
  )
}

pub type ButtonHandler(state) =
  fn(Interaction, state) -> Response(state)

pub fn simple_primary(
  custom_id: String,
  label: String,
  handler: ButtonHandler(state),
) -> InteractiveButton(state) {
  PrimaryButton(
    custom_id:,
    label:,
    emoji: option.None,
    disabled: False,
    handler:,
  )
}

pub fn simple_secondary(
  custom_id: String,
  label: String,
  handler: ButtonHandler(state),
) -> InteractiveButton(state) {
  SecondaryButton(
    custom_id:,
    label:,
    emoji: option.None,
    disabled: False,
    handler:,
  )
}

pub fn simple_success(
  custom_id: String,
  label: String,
  handler: ButtonHandler(state),
) -> InteractiveButton(state) {
  SuccessButton(
    custom_id:,
    label:,
    emoji: option.None,
    disabled: False,
    handler:,
  )
}

pub fn simple_danger(
  custom_id: String,
  label: String,
  handler: ButtonHandler(state),
) -> InteractiveButton(state) {
  DangerButton(
    custom_id:,
    label:,
    emoji: option.None,
    disabled: False,
    handler:,
  )
}
