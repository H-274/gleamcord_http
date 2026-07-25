# gleamcord_http

> [!IMPORTANT]
> Heavy work in progress. Is incomplete (doesn't cover API fully), and subject to frequent breaking changes

---

> [!NOTE]
> This library is meant to act as an opinionated framework for handling and defining Discord webhook interactions. It **does not** provide an HTTP server **or** client.

## General Concepts

## Handling

```gleam
import gleamcord_http/bot

pub fn app(state) {
  let app =
    bot.new(state:)
    |> bot.add_commands([
      // Your commands
    ])
    |> bot.add_components([
      // Your components
    ])
    |> bot.add_modals([
      // Your modals
    ])
}

pub fn handle_interaction(interaction) {
  let app = app(todo)

  // gleamcord_http handles interaction routing, you just need to parse it
  bot.handle_interaction(app, interaction:)
}
```

## Commands

```gleam
import gleamcord_http/command.{type Command}
import gleamcord_http/command/command_options.{StringValue as StrVal}
import gleamcord_http/message
import gleam/erlang/process
import gleam/dict

// A hello world slash command
pub fn hello_world() -> Command(_) {
  let sig = command.simple_signature(name: "hello_world", desc: "basic slash command")

  use _i, _s, _o <- command.chat_input(sig:, opts: [])

  { "Hello world!" }
  |> message.NewText([])
  |> command.MessageResponse
}

// Define command options as constants
const name_option = 
  command.StringOption(
    name: "name",
    description: "name",
    required: True,
    min_len: 1,
    max_len: 100
  )

// A slash command with an option
pub fn command_options() -> Command(_) {
  let sig = command.simple_signature(name: "options", desc: "options example")
  let opts = [name_option]

  use _i, o, _s <- command.chat_input(sig:, opts:)
  // Extract options through the provided dictionary
  let assert Ok(StrVal(value: name, ..)) = dict.get(name_option.name, o)

  {"You wrote the name: " <> name}
  |> message.NewText([])
  |> command.MessageResponse
}

// Defining a user command with a deferred response
pub fn slow_user() -> Command(_) {
  let sig = command.simple_signature(name: "slow_hello", desc: "slow hello command")

  use _, _, _ <- command.user(sig:, opts: [])
  use <- command.DeferredMessageResponse

  process.sleep(10_000)

  { "Slow hello!" }
  |> message.NewText([])
}
```

## Components

Components are designed to be reuseable betweeen modals and message components. As such, they require both the `disabled` and `required` fields.

```gleam
import gleamcord_http/component/interactive.{StringSelect}
import gleam/option

const select_animals = StringSelect(
  custom_id: "select-animals",
  options: [
    interactive.SelectOption(
      label: "Dog",
      value: "DOG",
      description: "Woof woof",
      emoji: option.None,
      default: True,
    ),
    interactive.SelectOption(
      label: "Cat",
      value: "CAT",
      description: "Meow",
      emoji: option.None,
      default: False,
    ),
    interactive.SelectOption(
      label: "Fish",
      value: "FISH",
      description: "Just keep swimming",
      emoji: option.None,
      default: False,
    ),
  ],
  placeholder: "Pick some options",
  min_values: 1,
  max_values: 3,
  required: False,
  disabled: False,
)
```

### In a modal

```gleam
import gleamcord_http/component/layout
import gleamcord_http/modal
import gleamcord_http/message
import gleam/dict

pub fn modal_animals() {
  let id = "animals-modal"
  let title = "Animals"
  let components = [
    layout.Label(
      label: "Animals",
      description: "",
      component: layout.LabelStringSelect(select_animals),
    )
  ]

  use _i, _s, values <- modal.new(id:, title:, components:)
  let assert Ok(animals) = dict.get(values, select_animals.custom_id)

  echo animals

  { "Form submitted!" }
  |> message.NewText([])
  |> modal.MessageResponse
}
```

### In a message component

```gleam
import gleamcord_http/message_component
import gleamcord_http/message
import gleamcord_http/component
import gleam/string

pub fn component_animals() {
  use _i, _s, v <- message_component.StringSelect(select_animals)
  
  {"Selected: " <> string.join(v, ", ")}
  |> message.NewText([])
  |> component.MessageResponse
}
```
