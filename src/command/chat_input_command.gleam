//// TODO

import bot.{type Bot}
import command/command_option.{type CommandOption}
import gleam/dict.{type Dict}
import gleam/list
import interaction
import locale.{type Locale}

pub type Response {
  JsonString(String)
}

pub type Error {
  InvalidParam(String)
  NotImplemented
}

/// TODO
pub type Data {
  Data
}

pub opaque type ChatInputCommand(ctx) {
  ChatInputCommand(Command(ctx))
  ChatInputCommandTree(CommandTree(ctx))
}

pub opaque type Command(ctx) {
  Command(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    default_member_permissions: String,
    integration_types: List(interaction.InstallationContext),
    contexts: List(interaction.Context),
    nsfw: Bool,
    options: List(command_option.Definition(ctx)),
    handler: Handler(ctx),
  )
}

pub fn new(
  name name: String,
  desc description: String,
  integration_types integration_types: List(interaction.InstallationContext),
  contexts contexts: List(interaction.Context),
) {
  Command(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    default_member_permissions: "",
    integration_types:,
    contexts:,
    nsfw: False,
    options: [],
    handler: default_handler,
  )
}

pub fn name_locales(
  command: Command(ctx),
  locales name_locales: List(#(Locale, String)),
) {
  Command(..command, name_locales:)
}

pub fn default_member_permissions(
  command: Command(ctx),
  perms default_member_permissions: String,
) {
  Command(..command, default_member_permissions:)
}

pub fn nsfw(command: Command(ctx)) {
  Command(..command, nsfw: True)
}

pub fn handler(command: Command(ctx), handler handler: Handler(ctx)) {
  ChatInputCommand(Command(..command, handler:))
}

/// TODO
pub opaque type CommandTree(ctx) {
  CommandTree(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    default_member_permissions: String,
    integration_types: List(interaction.InstallationContext),
    contexts: List(interaction.Context),
    nsfw: Bool,
    sub_commands: List(SubCommandNode(ctx)),
  )
}

pub fn new_tree(
  name name: String,
  desc description: String,
  integration_types integration_types: List(interaction.InstallationContext),
  contexts contexts: List(interaction.Context),
) {
  CommandTree(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    default_member_permissions: "",
    integration_types:,
    contexts:,
    nsfw: False,
    sub_commands: [],
  )
}

pub fn tree_locales(
  tree: CommandTree(ctx),
  locales: List(#(Locale, String, String)),
) {
  let name_locales = list.map(locales, fn(l) { #(l.0, l.1) })
  let description_locales = list.map(locales, fn(l) { #(l.0, l.2) })

  CommandTree(..tree, name_locales:, description_locales:)
}

pub fn tree_default_member_permissions(
  tree: CommandTree(ctx),
  default_member_permissions: String,
) {
  CommandTree(..tree, default_member_permissions:)
}

pub fn tree_nsfw(tree: CommandTree(ctx)) {
  CommandTree(..tree, nsfw: True)
}

pub fn tree_sub_commands(
  tree: CommandTree(ctx),
  sub_commands: List(SubCommandNode(ctx)),
) {
  ChatInputCommandTree(CommandTree(..tree, sub_commands:))
}

pub opaque type SubCommandNode(ctx) {
  CommandGroupNode(CommandGroup(ctx))
  SubCommandNode(SubCommand(ctx))
}

pub opaque type CommandGroup(ctx) {
  CommandGroup(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    sub_commands: List(SubCommandNode(ctx)),
  )
}

pub fn new_command_group(name name: String, desc description: String) {
  CommandGroup(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    sub_commands: [],
  )
}

pub fn command_group_locales(
  group: CommandGroup(ctx),
  locales: List(#(Locale, String, String)),
) {
  let name_locales = list.map(locales, fn(l) { #(l.0, l.1) })
  let description_locales = list.map(locales, fn(l) { #(l.0, l.2) })

  CommandGroup(..group, name_locales:, description_locales:)
}

pub fn command_group_sub_commands(
  group: CommandGroup(ctx),
  sub_commands: List(SubCommandNode(ctx)),
) {
  CommandGroupNode(CommandGroup(..group, sub_commands:))
}

pub opaque type SubCommand(ctx) {
  SubCommand(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    options: List(command_option.Definition(ctx)),
    handler: Handler(ctx),
  )
}

pub fn new_sub_command(name name: String, desc description: String) {
  SubCommand(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    options: [],
    handler: default_handler,
  )
}

pub fn sub_command_locales(
  sub: SubCommand(ctx),
  locales: List(#(Locale, String, String)),
) {
  let name_locales = list.map(locales, fn(l) { #(l.0, l.1) })
  let description_locales = list.map(locales, fn(l) { #(l.0, l.2) })

  SubCommand(..sub, name_locales:, description_locales:)
}

pub fn sub_command_options(
  sub: SubCommand(ctx),
  options: List(command_option.Definition(ctx)),
) {
  SubCommand(..sub, options:)
}

pub fn sub_command_handler(sub: SubCommand(ctx), handler: Handler(ctx)) {
  SubCommandNode(SubCommand(..sub, handler:))
}

pub type Handler(ctx) =
  fn(interaction.AppCommand(Data), Bot, ctx, Dict(String, CommandOption)) ->
    Result(Response, Error)

fn default_handler(_, _, _, _) {
  Error(NotImplemented)
}

pub fn run(
  command: Command(ctx),
  interaction: interaction.AppCommand(Data),
  bot: Bot,
  ctx: ctx,
  options: Dict(String, CommandOption),
) {
  command.handler(interaction, bot, ctx, options)
}
