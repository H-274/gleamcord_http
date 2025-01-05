import gleeunit/should
import internal/crypto/ed25519

const valid_message = "ed25519_test"

const valid_signature = "5639b79cebf918d16d9acadf7ca53374e2b577cb58baa0f8ce0db3a62ac3592056cd863793c01d62d2f1456e36b3c005ce9d533063aa915dd5a3827ffa7e6d01"

const valid_key = "d5b2a4040ef85e097d60963464385b2826e0156d2acd90c967b92ca061702bb1"

pub fn bad_key_verify_test() {
  // Given
  let any_message = "any"
  let any_signature = "any"
  let bad_key = "#"
  let expected = ed25519.BadPublicKey

  // When
  let res = ed25519.verify(msg: any_message, sig: any_signature, key: bad_key)

  // Then
  res
  |> should.be_error()
  |> should.equal(expected)
}

pub fn bad_signature_verify_test() {
  // Given
  let any_message = "any"
  let bad_signature = "any"
  let expected = ed25519.BadSignature

  // When
  let res = ed25519.verify(msg: any_message, sig: bad_signature, key: valid_key)

  // Then
  res
  |> should.be_error()
  |> should.equal(expected)
}

pub fn altered_message_verify_test() {
  // Given
  let altered_message = "Altered " <> valid_message
  let expected = False

  // When
  let res =
    ed25519.verify(msg: altered_message, sig: valid_signature, key: valid_key)

  // Then
  res
  |> should.be_ok()
  |> should.equal(expected)
}

pub fn valid_message_verify_test() {
  // Given
  let expected = True

  // When
  let res =
    ed25519.verify(msg: valid_message, sig: valid_signature, key: valid_key)

  // Then
  res
  |> should.be_ok()
  |> should.equal(expected)
}
