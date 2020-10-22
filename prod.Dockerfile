FROM registry.gitlab.com/fillmasterson/apperback/elixir:1.10.4-otp-22 as builder

WORKDIR "/opt/app"

COPY ./ ./

RUN mix local.hex --force && \
    mix local.rebar --force

RUN mix deps.get

ENV MIX_ENV=prod

RUN mix release --overwrite

FROM registry.gitlab.com/fillmasterson/apperback/elixir:1.10.4-otp-22

ENV MIX_ENV=prod REPLACE_OS_VARS=true SHELL=/bin/sh

COPY --from=builder /opt/app/_build/prod/rel/apperback /opt/app

RUN apk add --no-cache tini

RUN addgroup -g 1337 apperback && \
    adduser -D -u 1337 -G apperback apperback

RUN chown -R apperback:apperback /opt/app

USER apperback

ENTRYPOINT ["/sbin/tini", "--"]

CMD /opt/app/bin/apperback start
