import example/slash_command
import gleam/dict.{type Dict}
import gleam/json
import gleam/list
import gleam/result
import gleamcord_http
import gleamcord_http/locale.{type Locale}

fn translation_lists() {
  [
    #(slash_command.greet_command.name, [
      #(locale.French, "saluer"),
      #(locale.Swedish, "hämnad"),
      #(locale.German, "grüß"),
    ]),
    #(slash_command.greet_command.description, [
      #(locale.French, "saluer un utilisateur"),
      #(locale.Swedish, "hälsa en användare"),
      #(locale.German, "begrüße einen Nutzer"),
    ]),
    // TODO
    #(slash_command.greet_target.name, []),
    #(slash_command.greet_target.description, []),
  ]
}

fn get_translations(
  translations: Dict(String, Dict(Locale, String)),
  text: String,
) {
  dict.get(translations, text)
  |> result.unwrap(dict.new())
}

pub fn example() {
  let translator = get_translations(
    list.map(translation_lists(), fn(t) { #(t.0, dict.from_list(t.1)) })
      |> dict.from_list,
    _,
  )

  echo {
    gleamcord_http.slash_command_json(slash_command.greet_command, translator)
    |> json.to_string
  }
}

pub fn no_translation() {
  echo {
    gleamcord_http.slash_command_json(
      slash_command.greet_command,
      locale.empty_translator,
    )
    |> json.to_string
  }
}
