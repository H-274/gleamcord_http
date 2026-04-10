import gleam/dict.{type Dict}
import message_component/interaction.{type Interaction, Interaction}
import message_component/interactive.{
  type Interactive, ChannelSelectVariant, InteractiveButton,
  InteractiveSelectComponent, MentionableSelectVariant, RoleSelectVariant,
  StringSelectVariant, UserSelectVariant,
}

pub fn handle_interaction(
  components: Dict(String, Interactive(state)),
  state: state,
  i: Interaction,
) {
  case i {
    Interaction(data: interaction.Button(data), ..) ->
      case dict.get(components, data.custom_id) {
        Ok(InteractiveButton(button)) -> button.handler(i, state) |> Ok
        _ -> Error(Nil)
      }
    Interaction(data: interaction.StringSelect(data), ..) ->
      case dict.get(components, data.custom_id) {
        Ok(InteractiveSelectComponent(StringSelectVariant(select))) ->
          select.handler(i, state, data.values) |> Ok
        _ -> Error(Nil)
      }
    Interaction(data: interaction.UserSelect(data), ..) ->
      case dict.get(components, data.custom_id) {
        Ok(InteractiveSelectComponent(UserSelectVariant(select))) ->
          select.handler(i, state, data.resolved) |> Ok
        _ -> Error(Nil)
      }
    Interaction(data: interaction.RoleSelect(data), ..) ->
      case dict.get(components, data.custom_id) {
        Ok(InteractiveSelectComponent(RoleSelectVariant(select))) ->
          select.handler(i, state, data.resolved) |> Ok
        _ -> Error(Nil)
      }
    Interaction(data: interaction.MentionableSelect(data), ..) ->
      case dict.get(components, data.custom_id) {
        Ok(InteractiveSelectComponent(MentionableSelectVariant(select))) ->
          select.handler(i, state, data.resolved) |> Ok
        _ -> Error(Nil)
      }
    Interaction(data: interaction.ChannelSelect(data), ..) ->
      case dict.get(components, data.custom_id) {
        Ok(InteractiveSelectComponent(ChannelSelectVariant(select))) ->
          select.handler(i, state, data.resolved) |> Ok
        _ -> Error(Nil)
      }
  }
}
