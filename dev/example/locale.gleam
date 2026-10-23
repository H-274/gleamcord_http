import example/commands
import gleam/dict.{type Dict}
import gleam/json
import gleam/list
import gleam/result
import gleamcord_http
import gleamcord_http/locale.{type Locale}

// You can also get names directly from the commands/message components/etc.
// if you extract them in a constant, avoiding magic strings. It does make
// files where you define commands more verbose... Might have to look into it
const translatons_lists = [
  #("greet", [
    #(locale.French, "saluer"),
    #(locale.Swedish, "hämnad"),
    #(locale.German, "grüß"),
  ]),
  #("greets a user", [
    #(locale.French, "saluer un utilisateur"),
    #(locale.Swedish, "hälsa en användare"),
    #(locale.German, "begrüße einen Nutzer"),
  ]),
  #("Next", [
    #(locale.French, "Suivant"),
    #(locale.Swedish, "Nästa"),
    #(locale.German, "Als Nächstes"),
  ]),
  // Anything else that needs to be translated for Discord
]

fn get_translations(
  translations: Dict(String, Dict(Locale, String)),
  text: String,
) {
  dict.get(translations, text)
  |> result.unwrap(dict.new())
}

pub fn example() {
  let translator = get_translations(
    list.map(translatons_lists, fn(t) { #(t.0, dict.from_list(t.1)) })
      |> dict.from_list,
    _,
  )

  echo {
    gleamcord_http.command_json(commands.hello_command, translator)
    |> json.to_string
  }
}
