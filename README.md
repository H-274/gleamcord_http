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

- They will always, at least, have their respective interaction, and interaction data
- Chat input commands, modals, and components that take an input have a third parameter.

#### Chat Input Handlers

They will always have a third parameter referred to as `options`, representing **VALUE** command options from discord

> [!NOTE]
> Subcommand group and subcommand options are not present as "options" in this library.
> They are defined as part of a seperate variant of command called `Group`.
> This library handles routing interactions to subcommands for you.

#### Message Component Handlers

Message component handlers vary based on the variant of component used.

- Buttons only have the 2 basic handler parameters
- Selectors have 3 parameters, the third one is a `Dict` of either the string values, or of snowflake strings to use with the `Resolved` type present in the interaction.

#### Modal Component Handlers

> [!WARNING]
> Many of the components exclusive to modals are under work and may crash from hitting a `todo` statement.

Modal *components* don't have handlers, since all components of a modal are submitted at once.
Instead, the *modal* has the handler.

The modal's handler has the default 2 parameters, but also a `Dict` of the different components and their values

## Handling (TODO update)

```gleam
pub fn app() {
  let app =
    bot.new()
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

pub fn handle_body(app: Bot, req_body: Dynamic) {
  let assert Ok(interaction) = deode.run(req_body, interaction.decoder())

  // gleamcord_http handles interaction routing, you just need to parse
  // the interaction from the request, using the provided decoder
  let res = bot.handle_interaction(app, interaction:)

  // ...
}
```

## Commands

```gleam
// A hello world slash command
pub fn hello_world() {
  use _i, _d, _o <- ChatCommand(
    def: command_def(name: "hello", desc: "world"),
    options: [],
  )

  todo as "Hello world!"
  |> CommandMessageResponse
}


// Define command options as constants
const name_option = 
  StringOption(
    name: "name",
    description: "name",
    required: True,
    min_len: 1,
    max_len: 100
  )

// A slash command with an option
pub fn command_options() -> Command {
  use _i, _d, _o <- ChatCommand(
    def: command_def(name: "options", desc: "options example"),
    options: [name_option],
  )
  // Extract options through the provided dictionary
  let assert Ok(name) = discord.options_string(o, name_option.name)

  {todo as {"You wrote the name: " <> name}}
  |> CommandMessageResponse
}

// Defining a user command with a deferred response
pub fn slow_hello() {
  use _i, _d, _o <- ChatCommand(
    def: command_def(name: "slow_hello", desc: "slow hello command"),
    options: [],
  )

  use <- CommandDeferredMessageResponse

  process.sleep(10_000)

  todo as "Slow hello!"
}
```

## Components (TODO update)

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
pub fn modal_animals() {
  use _i, _d, c <- Modal(custom_id: "animals-modal", title: "Animals", components: [
    component.Label(
      label: "Animals",
      description: "",
      component: component.LabelStringSelect(ice_cream_input),
    )
  ])

  let assert Ok(animals) =
    discord.component_string_select(c, select_animals.custom_id)

  todo as "Form submitted"
  |> ModalMessageResponse
}
```

### In a message component (TODO update)

```gleam
import gleamcord_http/message_component
import gleamcord_http/message
import gleamcord_http/component
import gleam/string

pub fn component_animals() {
  use _i, v <- message_component.StringSelect(select_animals)
  
  {"Selected: " <> string.join(v, ", ")}
  |> message.NewText([])
  |> component.MessageResponse
}
```
