# gleamcord_http

> [!IMPORTANT]
> Heavy work in progress. Is incomplete (doesn't cover API fully), and subject to frequent breaking changes

---

> [!NOTE]
> This library is meant to act as an opinionated framework.
> It **does not** provide an HTTP server **or** client.

## General ideas

- This library is to define, parse, and handle interactions from Discord's HTTP API
- The main mechanism for this will be monads to make processing interactions versatile, and quickly extendable should they add new components, HTTP interactions, command variants, etc.
- This library will contain raw variants of most objects to allow end-users to quickly use new Discord API features without waiting on type bindings to be added to this library if needed
- Since this library is to use the HTTP API, it should only depend on gleam_http and gleam_json.
