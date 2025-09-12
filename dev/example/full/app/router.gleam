import bot.{type Bot}
import discord
import example/full/app/web
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, bot: Bot, context: Nil) -> Response {
  use req <- web.middleware(req)

  case wisp.path_segments(req) {
    ["discord-bot", ..] -> discord.handle_request(req, bot, context)

    _ -> wisp.not_found()
  }
}
