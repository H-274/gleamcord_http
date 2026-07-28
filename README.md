# gleamcord_http

> [!IMPORTANT]
> Heavy work in progress. Is incomplete (doesn't cover API fully), and subject to frequent breaking changes

---

> [!NOTE]
> This library is meant to act as an opinionated framework for handling and defining Discord webhook interactions (interacting with Discord's HTTP API).
> It **does not** provide an HTTP server **or** client.

## General Concepts

### Handlers

Interaction handlers have between 2 and 3 parameters.

- They will always, at least, have their respective interaction, and the bot's state.
- Chat input commands, and components that take an input have a third parameter.

#### Chat Input Handlers

They will always have a third parameter called `options`, representing **VALUE** command options from discord

> [!NOTE]
> Subcommand group and subcommand options are not present as options in this library.
> They are defined as part of a seperate variant of command called `Group`.
> This library handles routing interactions to subcommands for you.

#### Message Component Handlers

Message component handlers vary based on the variant of component used.

- Buttons only have the 2 basic handler parameters
- Selectors have 3 parameters, the third one is a `Dict` of either the string values, or of snowflake strings to use with the `Resolved` type present in the interaction.

#### Modal Component Handlers

> [!WARNING]
> Many of the components exclusive to modals are under work and may crash from hitting a `todo` statement.

Modal components don't have handlers, since all components of a modal are submitted at once.
Instead, the modal has the handler.

The modal's handler has the default 2 parameters, but also a `Dict` of the different components and their values

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
  // Replace `Nil` with your desired state or keep it if you either don't want to pass state, 
  // or if you wish to do it on a per-handler basis using their constructors
  let app = app(Nil)

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
  let assert Ok(StrVal(value: name, ..)) = dict.get(o, name_option.name)

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
