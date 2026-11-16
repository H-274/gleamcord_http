import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleamcord_http.{type Message}
import gleamcord_http/component
import gleamcord_http/discord

pub type Modal {
  Modal(
    custom_id: String,
    title: String,
    components: List(component.Label),
    handler: Handler,
  )
}

pub type Handler =
  fn(discord.ModalInteraction, Dict(String, Dynamic)) -> Response

pub type Response {
  MessageResponse(Message)
  DeferredMessageResponse(fn() -> Message)
  MessageUpdate(Message)
  DeferredMessageUpdate(fn() -> Message)
}
