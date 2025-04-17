# discord_framework

[![Package Version](https://img.shields.io/hexpm/v/discord_framework)](https://hex.pm/packages/discord_framework)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/discord_framework/)

```sh
gleam add discord_framework@1
```

```gleam
import discord_framework

pub fn main() {
  // TODO: An example of the project in use
}
```

Further documentation can be found at <https://hexdocs.pm/discord_framework>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```

## Goals

This is a clear outline of the goals for the project to try not to go off the rails too much and lose sight of the scope

1. This library is made to help in the creation of Discord bot frameworks that are based on Discord's HTTP API
2. This library is opinionated in regards to the creation of commands, command parameters, message components, modals, their respective handler functions and the flow within handler functions.
3. This library will not include entities/types for any data to be communicated or recieved by Discord's API outside of the opinionated concepts
4. This library will contain helper functions to help build HTTP requests to be sent to Discord's HTTP API