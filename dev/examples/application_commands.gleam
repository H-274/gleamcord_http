import application_commands.{IntegerValue as IntVal, StringValue as StrVal} as command
import gleam/dict
import gleam/list
import gleam/string

pub fn chat_input() {
  // --- /hello <string>
  let signature =
    command.signature("hello", "greets a name")
    |> command.set_options([Nil])

  use _i, opts <- command.chat_input(signature:)
  let assert Ok(StrVal(name)) = dict.get(opts, "name")

  "Hello " <> name <> "!"
}

pub fn chat_input_group() {
  command.chat_input_group("hello", "greeting commands")
  |> command.add_subcommand_group(
    command.subcommand_group("world", "greet the world", [
      // --- /hello world times <int>
      times_subcommand(),
      // --- /hello world caps
      caps_subcommand(),
    ]),
  )
  |> command.add_subcommand(
    // --- /hello name <string>
    name_subcommand(),
  )
}

fn times_subcommand() {
  let signature =
    command.signature("times", "greets the world a number of times")
    |> command.set_options([Nil])

  use _i, opts <- command.subcommand(signature:)
  let times_opt = dict.get(opts, "times")

  let times = case times_opt {
    Ok(IntVal(val)) -> val
    _ -> 1
  }

  list.repeat("Hello World!", times)
  |> string.join("\n")
}

fn caps_subcommand() {
  let signature = command.signature("caps", "greets the world in all caps")

  use _i, _opts <- command.subcommand(signature:)

  string.uppercase("Hello World!")
}

fn name_subcommand() {
  let signature =
    command.signature("name", "greet a name")
    |> command.set_options([Nil])

  use _i, opts <- command.subcommand(signature:)
  let assert Ok(StrVal(name)) = dict.get(opts, "name")

  "Hello " <> name <> "!"
}
