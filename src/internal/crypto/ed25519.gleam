import gleam/bit_array
import gleam/erlang
import gleam/result

pub type VerifyError {
  BadPublicKey
  BadSignature
  ExternalCallFailed(erlang.Crash)
}

@external(erlang, "ed25519", "verify_public")
fn verify_public(
  message: BitArray,
  signature: BitArray,
  public_key: BitArray,
) -> Bool

pub fn verify(
  m message: String,
  sig signature: String,
  key public_key: String,
) -> Result(Bool, VerifyError) {
  use public_key <- result.try(
    bit_array.base16_decode(public_key)
    |> result.replace_error(BadPublicKey),
  )
  use signature <- result.try(
    bit_array.base16_decode(signature)
    |> result.replace_error(BadSignature),
  )
  let message = bit_array.from_string(message)

  {
    use <- erlang.rescue()
    verify_public(message, signature, public_key)
  }
  |> result.map_error(ExternalCallFailed)
}
