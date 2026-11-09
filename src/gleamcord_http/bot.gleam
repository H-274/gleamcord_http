import gleam/dict.{type Dict}
import gleam/list
import gleamcord_http.{
  type ContextCommand, type GleamcordComponent, type GleamcordModal,
  type SlashCommand,
}

pub opaque type Bot {
  Bot(
    slash_commands: Dict(String, gleamcord_http.SlashCommand),
    context_commands: Dict(String, gleamcord_http.ContextCommand),
    components: Dict(String, GleamcordComponent),
    modals: Dict(String, GleamcordModal),
  )
}

pub fn new() {
  Bot(
    slash_commands: dict.new(),
    context_commands: dict.new(),
    components: dict.new(),
    modals: dict.new(),
  )
}

pub fn add_slash_commands(bot: Bot, slash_commands: List(SlashCommand)) {
  let new_slash_commands =
    dict.from_list(list.map(slash_commands, fn(c) { #(c.name, c) }))

  Bot(..bot, slash_commands: dict.merge(bot.slash_commands, new_slash_commands))
}

pub fn add_context_commands(bot: Bot, context_commands: List(ContextCommand)) {
  let new_context_commands =
    dict.from_list(list.map(context_commands, fn(c) { #(c.name, c) }))

  Bot(
    ..bot,
    context_commands: dict.merge(bot.context_commands, new_context_commands),
  )
}

pub fn add_components(bot: Bot, components: List(GleamcordComponent)) {
  let new_components = gleamcord_http.components_dict(components)

  Bot(..bot, components: dict.merge(bot.components, new_components))
}

pub fn add_modals(bot: Bot, modals: List(GleamcordModal)) {
  let new_modals = dict.from_list(list.map(modals, fn(m) { #(m.custom_id, m) }))

  Bot(..bot, modals: dict.merge(bot.modals, new_modals))
}
