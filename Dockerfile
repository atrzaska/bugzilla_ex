# File: my_app/Dockerfile
FROM elixir:1.10-alpine as build

# install build dependencies
RUN apk add --update git build-base nodejs npm

RUN mkdir /app
WORKDIR /app

# install Hex + Rebar
RUN mix do local.hex --force, local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

# build assets
RUN mkdir assets
COPY assets/package.json assets/package-lock.json assets/
RUN cd assets && npm install
COPY assets assets
RUN cd assets && npm run deploy
RUN mkdir config
COPY config/digest.exs config/config.exs
RUN mix phx.digest

# build project
COPY priv priv
COPY lib lib
COPY config config
RUN mix compile --warnings-as-errors

# build release
# at this point we should copy the rel directory but
# we are not using it so we can omit it
# COPY rel rel
RUN mix release

# prepare release image
FROM alpine:latest AS app

# install runtime dependencies
RUN apk add --update openssl postgresql-client

EXPOSE 4000
ENV MIX_ENV=prod

# prepare app directory
RUN mkdir /app
WORKDIR /app

# copy release to app container
COPY --from=build /app/_build/prod/rel/bugzilla .
COPY entrypoint.sh .
RUN chown -R nobody: /app
USER nobody

ENV HOME=/app
CMD ["sh", "/app/entrypoint.sh"]
