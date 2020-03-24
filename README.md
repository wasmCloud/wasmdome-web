![CI](https://github.com/wascc/wasmdome-web/workflows/CI/badge.svg)

# Assembly Mechs: Beyond WasmDome

Main web application UI.

**NOTE** this is an experiment right now, don't take any of this seriously. Code taken from a demo graciously created for me by the author of [Real-Time Phoenix](https://pragprog.com/book/sbsockets/real-time-phoenix), the original can be found [here](https://github.com/sb8244/gnat-live-view-demo).

# Usage

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `cd assets && npm install`
  * Make sure your postgres database has the latest schema via `mix ecto.migrate`, configured via the following env vars:
    * DB_HOST
    * DB_NAME
    * DB_USER
    * DB_PASS
  * If you want to add your own stuff to the database, open up a second terminal and `iex -S mix` then issue Elixir commands like `Repo.insert`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
