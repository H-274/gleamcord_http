import discord/entities/choice.{type Choice}

pub type ApplicationCommand

pub type Autocomplete {
  StringChoices(List(Choice(String)))
  IntegerChoices(List(Choice(Int)))
  NumberChoices(List(Choice(Float)))
}

pub type MessageComponent

/// TODO: Work under assumption that the bot should only respond or throw?
pub type Failure
