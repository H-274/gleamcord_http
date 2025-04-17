import bot.{type Bot}
import gleam/http/request.{type Request}

pub const base_url = "https://discord.com/api/v10"

pub fn authorization_header(req: Request(_), bot: Bot(_)) {
  request.set_header(req, "Authotization", "Bot " <> bot.token)
}
