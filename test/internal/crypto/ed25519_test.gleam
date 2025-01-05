import gleeunit/should
import internal/crypto/ed25519

const valid_key = "b149b42f704f7be35a61c8fd6b1223948948d462759b9348992f7a830fccc910"

const valid_signature = "de00e1c9a1d1f567455bbac2d74c78f3fbeee731e355e043b9916f8044bcf0cb79c4aebea604cc26ae1f4cfa76ee7d1e7f60cdc96590bac28d6782f4970b3e03"

const valid_message = "ed25519_test"

pub fn bad_key_verify_test() {
  // Given
  let any_message = "message"
  let any_signature = "signature"
  let bad_key = "#"
  let expected = ed25519.BadPublicKey

  // When
  let res = ed25519.verify(msg: any_message, sig: any_signature, key: bad_key)

  // Then
  should.be_error(res)
  |> should.equal(expected)
}

pub fn bad_signature_verify_test() {
  // Given
  let bad_signature = "signature"
  let any_message = "message"
  let expected = ed25519.BadSignature

  // When
  let res = ed25519.verify(msg: any_message, sig: bad_signature, key: valid_key)

  // Then
  should.be_error(res)
  |> should.equal(expected)
}

pub fn altered_message_verify_test() {
  // Given
  let altered_message = "Altered Hello"
  let expected = False

  // When
  let res =
    ed25519.verify(msg: altered_message, sig: valid_signature, key: valid_key)

  // Then
  should.be_ok(res)
  |> should.equal(expected)
}

pub fn valid_message_verify_test() {
  // Given
  let expected = True

  // When
  let res =
    ed25519.verify(msg: valid_message, sig: valid_signature, key: valid_key)

  // Then
  should.be_ok(res)
  |> should.equal(expected)
}
