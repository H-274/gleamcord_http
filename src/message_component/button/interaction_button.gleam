import gleam/option.{type Option}
import message_component/interaction.{type Interaction}
import message_component/response.{type Response}

pub type InteractionButton(state) {
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

pub fn new_primary(
  custom_id: String,
  label: String,
  handler: ButtonHandler(state),
) -> InteractionButton(state) {
  PrimaryButton(
    custom_id:,
    label:,
    emoji: option.None,
    disabled: False,
    handler:,
  )
}

pub fn new_secondary(
  custom_id: String,
  label: String,
  handler: ButtonHandler(state),
) -> InteractionButton(state) {
  SecondaryButton(
    custom_id:,
    label:,
    emoji: option.None,
    disabled: False,
    handler:,
  )
}

pub fn new_success(
  custom_id: String,
  label: String,
  handler: ButtonHandler(state),
) -> InteractionButton(state) {
  SuccessButton(
    custom_id:,
    label:,
    emoji: option.None,
    disabled: False,
    handler:,
  )
}

pub fn new_danger(
  custom_id: String,
  label: String,
  handler: ButtonHandler(state),
) -> InteractionButton(state) {
  DangerButton(
    custom_id:,
    label:,
    emoji: option.None,
    disabled: False,
    handler:,
  )
}
