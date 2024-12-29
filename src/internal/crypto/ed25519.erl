-module(ed25519).
-export([verify_public/3]).

verify_public(Message, Signature, PublicKey) ->
    crypto:verify(eddsa, none, Message, Signature, [PublicKey, ed25519]).
