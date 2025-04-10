import gleam/option
import interaction/application_command as ac
import interaction/application_command_param as param

pub fn chat_input_command() {
  let def =
    ac.new_definition(name: "Hello", desc: "world", integs: [Nil], contexts: [
      Nil,
    ])

  let name_param = {
    let base =
      param.BaseDefinition(
        ..param.new_base(name: "city", desc: "city to greet"),
        required: False,
      )
    let builder =
      param.StringDefBuilder(
        ..param.string_builder(base),
        min_length: option.Some(2),
        max_length: option.Some(25),
      )

    use _i, _params, _bot <- param.string_with_autocomplete(builder)
    todo as "Autocorrect logic for cities"
  }

  let params = [name_param]

  use _i, params, _bot <- ac.chat_input_command(def, params)
  let _city = case param.get_string(params, "city") {
    Ok(city) -> city
    _ -> "world"
  }

  todo as "Response logic"
}
