# Timerobot

## About

Timerobot was conceived as an internal timesheet application.

It has a list of Clients, each of which may have multiple Projects.  
Each Person creates an Entry to record time worked on a date for a project, in quarter hour increments.

## Setup

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.


## Built with

  * Elixir
  * Phoenix
  * Ecto
  * Timex
  * Comeonin
  * Guardian

## Acknowledgements

Thanks to Josh Price, James Sadler and Jon Rowe for their tireless assistance with helping me solve issues.

Thanks to Andrei Chernykh for his article on simple authentication in Phoenix.  
https://medium.com/@andreichernykh/phoenix-simple-authentication-authorization-in-step-by-step-tutorial-form-dc93ea350153
