import examples/command/command
import gleam/dict
import gleam/result
import locale

pub fn example_translator(string) {
  // Could be data fetched from actor, external query, etc.
  // So that the localizations are refreshed automatically when
  // the command is updated/registered anew
  let localizations =
    dict.from_list([
      // You may have to extract the name to constants in another file
      // to avoid import cycles
      #(command.greet_name, dict.from_list([#(locale.French, "saluer")])),
      #(
        command.greet_desc,
        dict.from_list([#(locale.French, "saluer l'utilisateur")]),
      ),
    ])

  dict.get(localizations, string)
  |> result.unwrap(dict.new())
}
