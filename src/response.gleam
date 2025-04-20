import discord/entities/choice.{type Choice}

pub type ApplicationCommand

pub type Autocomplete {
  StringChoices(List(Choice(String)))
  IntegerChoices(List(Choice(Int)))
  NumberChoices(List(Choice(Float)))
}

pub type Failure
