import gleam/json.{type Json}

/// `name`
pub type Partial {
  Partial(id: String, name: String, animated: Bool)
}

pub fn partial_json(partial: Partial) -> Json {
  let Partial(id:, name:, animated:) = partial

  [
    #("id", json.string(id)),
    #("name", json.string(name)),
    #("animated", json.bool(animated)),
  ]
  |> json.object
}
