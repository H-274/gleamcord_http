import gleam/json.{type Json}

pub type TextDisplay =
  String

pub fn text_display_json(text: TextDisplay) -> json.Json {
  [#("type", json.int(10)), #("content", json.string(text))]
  |> json.object
}

// TODO eventually handle "unfurled media item"
pub type Thumbnail {
  Thumbnail(media: String, description: String, spoiler: Bool)
}

pub fn thumbnail_json(thumbnail: Thumbnail) -> Json {
  [
    #("type", json.int(11)),
    #("media", json.string(thumbnail.media)),
    #("description", json.string(thumbnail.description)),
    #("spoiler", json.bool(thumbnail.spoiler)),
  ]
  |> json.object
}

pub type MediaGallery {
  MediaGallery
}

pub fn media_gallery_json(media_gallery: MediaGallery) -> Json {
  todo
}

pub type File {
  File
}

pub fn file_json(file: File) -> Json {
  todo
}
