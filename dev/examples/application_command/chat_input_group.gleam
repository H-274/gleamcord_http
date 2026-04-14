import application_command/chat_input_group
import examples/application_command/chat_input

pub fn favourite() {
  chat_input_group.new(
    name: "favourite",
    desc: "questions about your fav. things",
    subs: [
      // --- /favourite colour <hex:string>
      chat_input.colour() |> chat_input_group.subcommand,

      chat_input_group.subcommand_group(
        name: "game",
        desc: "questions about your fav. games",
        subs: [
          // --- /favourite game adventure <title:string>
          chat_input.adventure(),
        ],
      ),
    ],
  )
}
