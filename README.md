# Bugzilla

Welcome to Bugzilla!

The goal of this project is to take various concepts of web software design and apply them to in a elixir application.

## Project description

Bugzilla is a simple project management solution similar to Pivotaltracker.
In bugzilla you can create projects, which have stories.
Each story can have tasks and comments.
Story also has status from `started` to `finished`.
Project owners can also invite other users (registered or unregistered).
Invitation emails are sent to invited users asking them to join the project.

## Demo

Demo is available at https://bugzilla.uk.to . Go and check it out!


## Development Requirements

- elixir
- docker
- nodejs
- postgresql

To install them run:

    brew install elixir nodejs docker docker-compose postgresql

## Development Setup

Development setup is rather simple. There is a `bin/setup` script that takes care of most of the stuff.

    docker-compose up -d
    source .env.dev
    ./bin/setup
    mix phx.server

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Production Deployment

To deploy to production you have a helper script `docker/deploy.sh`.
This script automatically builds the docker images of elixir release locally.
It then runs docker-compose to start all the required app containers.

    cp docker/app.env.example docker/app.env
    vim docker/app.env # edit env vars
    ./docker/deploy.sh

## What is implemented

- auth system using `phx_gen_auth` modified to app requirements.
    - login
    - registration
    - email confirmation
    - password recovery via email
    - resend confirmation instructions via email
    - cancel account from profile settings
    - update email from profile settings with reconfirmation via email
    - update password in profile settings
    - welcome email
- email sending using `bamboo`, `premailex` and `mailjet`
- email styled using https://github.com/leemunroe/responsive-html-email-template
- project member invitation system via email
- design based on customized `Bootstrap 4`
- user role system with access management
- story state system
- header with profile menu
- sidebar with app modules
- friendly project URLs with slug eg `/projects/bugzilla/current`
- terms page
- privacy page
- product page with product layout
- logged in app pages with app layout
- auth pages with auth layout
- slim templates using `slimex`
- development using `docker-compose` local services
- enums using `ecto_enum`
- phoenix flashes using `bootstrap 4 toast component`
- validations using ecto changeset and styled bootstrap 4 input tags
- production deployment using elixir releases and docker image
- bug tracking using `sentry`
- redirect back using `navigation_history`
