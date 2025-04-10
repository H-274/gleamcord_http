import gleam/io
import gleam/option
import interaction/application_command as ac
import interaction/application_command_param as param

pub fn chat_input_command() {
  let def =
    ac.new_definition(name: "Hello", desc: "world", integs: [Nil], contexts: [
      Nil,
    ])

  let name_param =
    param.StringDefBuilder(
      ..param.string_builder(
        param.BaseDefinition(
          ..param.new_base(name: "city", desc: "city to greet"),
          required: False,
        ),
      ),
      min_length: option.Some(2),
      max_length: option.Some(25),
    )
    |> param.string_with_autocomplete(city_autocomplete)

  let params = [name_param]

  use _i, params, _bot <- ac.chat_input_command(def, params)
  let city = case param.get_string(params, "city") {
    Ok(city) -> city
    _ -> "world"
  }

  io.println("Hello " <> city)
  todo as "Response logic"
}

fn city_autocomplete(_i, _params, _bot) {
  todo as "Autocompletion logic"
}
