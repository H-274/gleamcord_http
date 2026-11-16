import gleam/int
import gleam/string
import gleamcord_http
import gleamcord_http/command
import gleamcord_http/component
import gleamcord_http/discord

pub fn ping_command() {
  use _i, _o <- command.slash(name: "ping", desc: "pongs", opts: [])

  "Pong!"
  |> gleamcord_http.basic_text_message
  |> command.MessageResponse
}

pub fn admin_tree() {
  command.slash_group(name: "admin", desc: "admin_commands", sub: [
    command.SubElement(admin_ban()),

    command.SubGroupElement(
      name: "get",
      description: "obtain user info",
      sub_commands: [admin_get_roles()],
    ),
  ])
}

fn admin_ban() {
  use _i, _o <- command.SubCommand(
    name: "ban",
    description: "bans user",
    options: [
      command.UserOption(
        name: "target",
        description: "user to ban",
        required: True,
      ),
    ],
  )

  "User has been banned"
  |> gleamcord_http.basic_text_message
  |> command.MessageResponse
}

fn admin_get_roles() {
  use _i, _o <- command.SubCommand(
    name: "roles",
    description: "obtain user roles",
    options: [
      command.UserOption(
        name: "target",
        description: "user to query",
        required: True,
      ),
    ],
  )

  "get user roles"
  |> gleamcord_http.basic_text_message
  |> command.MessageResponse
}

pub fn report_user() {
  use _i <- command.guild_user("report")

  "user successfully reported"
  |> gleamcord_http.basic_text_message
  |> command.MessageResponse
}

pub fn report_message() {
  use _i <- command.guild_message("report")

  "message successfully reported"
  |> gleamcord_http.basic_text_message
  |> command.MessageResponse
}

fn colour_hex() {
  command.StringAutocompleteOption(
    name: "colour",
    description: "colour in hex `RRGGBB`",
    required: True,
    min_length: 6,
    max_length: 6,
    autocomplete: hex_autocomplete,
  )
}

fn hex_autocomplete(_i, _o, partial) {
  let partial = string.uppercase(partial)
  let len = string.length(partial)
  case int.base_parse(partial, 16) {
    Error(_) -> [#("000000", "000000")]
    Ok(v) if v < 0 -> [#("000000", "000000")]
    Ok(v) if v > 0xFFFFFF -> {
      let start = string.drop_end(partial, 6)
      let end = string.drop_start(partial, 6)
      [#(start, start), #(end, end)]
    }
    Ok(_) if len < 6 -> {
      let pad_black = string.pad_end(partial, 6, "0")
      let pad_white = string.pad_end(partial, 6, "F")
      [#(pad_black, pad_black), #(pad_white, pad_white)]
    }
    Ok(_) -> [#(partial, partial)]
  }
}

pub fn colour() {
  use _i, o <- command.slash(name: "colour", desc: "search for a colour", opts: [
    colour_hex(),
  ])
  let assert Ok(colour) = discord.string_value(o, colour_hex().name)

  case int.base_parse(colour, 16), string.length(colour) {
    Error(_), 6 -> [gleamcord_http.MessageText("Not a valid hex value")]
    Ok(v), 6 if v < 0 -> [gleamcord_http.MessageText("Hex must be positive")]
    Ok(_), 6 -> colour_components(colour)
    _, _ -> [
      gleamcord_http.MessageText("Hex must be 6 chars long"),
    ]
  }
  |> gleamcord_http.basic_component_message
  |> command.MessageResponse
}

fn colour_components(colour: String) {
  [
    gleamcord_http.MessageText("You chose: #" <> colour),
    gleamcord_http.MessageSeparator(component.SmallSeparator(True)),
    gleamcord_http.MessageMedia(
      component.MediaGallery([
        component.GalleryItem(
          media_url: "https://singlecolorimage.com/get/" <> colour <> "/150x150",
          description: "#" <> colour,
          spoiler: False,
        ),
      ]),
    ),
  ]
}
