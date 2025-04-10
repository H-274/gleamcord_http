import gleam/io
import interaction/application_command as ac
import interaction/application_command_param as param

pub fn chat_input_command() {
  let def =
    ac.new_definition(name: "Hello", desc: "world", integs: [Nil], contexts: [
      Nil,
    ])

  let params = [city_param()]

  use _i, params, _bot <- ac.chat_input_command(def, params)
  let city = case param.get_string(params, "city") {
    Ok(city) -> city
    _ -> "world"
  }

  io.println("Hello " <> city)
  todo as "Response logic"
}

fn city_param() {
  let builder =
    param.base(name: "city", desc: "city to greet")
    |> param.required(False)
    |> param.string_builder()
    |> param.string_min_length(2)
    |> param.string_min_length(25)

  use _i, _params, _bot <- param.string_with_autocomplete(builder)
  todo as "Autocomplete logic"
}
