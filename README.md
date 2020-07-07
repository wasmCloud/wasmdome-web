![CI](https://github.com/wascc/wasmdome-web/workflows/CI/badge.svg)

# Assembly Mechs: Beyond WasmDome

_The year is 2020 and our containerized civilization is falling apart. A cruel and villainous DevOps demon named **Boylur Plait** has descended from the cloud to Earth to challenge mankind to a tournament_.

To win this tournament, _Assembly Mechs_ must compete in an absurdly over-dramatized contest. These mechs will challenge their creator's ability to write code that will outlast and defeat everything that the demon and its nearly infinite hordes pit against us. Humanity's only hope is to master a technology called **WebAssembly**, win the tournament, and prove to the cloud nemesis that this world is well protected.

## Overview

In this game, players will create Assembly Mechs to compete for supremacy in the WasmDome. Developers create a new mech by building a Rust **waSCC** actor, signing their module, and uploading it to the **WasmDome**.

Will your mech survive? Is your code good enough to stand against the most vicious enemies the cloud can muster? Upload your mech to the WasmDome and find out, watching it participate in match after match as it collaborates with other mechs to fight for humanity's survival. Will your efforts be enough to save the world? _Not likely_, but it'll be fun trying!

# Usage

To start your Phoenix server:

* Install dependencies with `mix deps.get`
* Install Node.js dependencies with `cd assets && npm install`
* Make sure your postgres database has the latest schema via `mix ecto.migrate`, configured via the following env vars:
  * `DB_HOST`
  * `DB_NAME`
  * `DB_USER`
  * `DB_PASS`
* If you want to add your own stuff to the database, open up a second terminal and `iex -S mix` then issue Elixir commands like `Repo.insert`
* Ensure that you have a [NATS](https://nats.io) server running, preferably in "leaf node" mode on `127.0.0.1` with anonymous access
* Configure your [auth0](https://auth0.com) API information with the following environment variables (auth0 has a free tier that you can use for experimenting):
  * `AUTH0_DOMAIN`
  * `AUTH0_CLIENT_ID`
  * `AUTH0_CLIENT_SECRET`
* Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
