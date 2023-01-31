FROM node:14 as NODE_BUILDER
ADD ui /app/src/ui
WORKDIR /app/src/ui
RUN npm install
RUN npm run build


FROM elixir:1.14.2 AS ELIXIR_BUILDER
ENV MIX_REBAR=/app/scansfer/rebar3
RUN mkdir -p /app/scansfer
ADD Makefile rebar3 rebar.* /app/scansfer
WORKDIR /app/scansfer
RUN mix local.rebar --force rebar3 $MIX_REBAR
RUN mix local.hex --force
RUN $MIX_REBAR version
RUN make compile

ADD . /app/scansfer
COPY --from=NODE_BUILDER /app/src/priv/public /app/scansfer/priv/public
RUN $MIX_REBAR
RUN make compile
RUN make tar && mv /app/scansfer/_build/default/rel/scansfer_release/scansfer_release-*.tar.gz /app.tar.gz


FROM debian:bullseye

ENV LOG_LEVEL=info
RUN apt-get update && apt-get install -y openssl && apt-get clean
COPY --from=ELIXIR_BUILDER /app.tar.gz /app.tar.gz

WORKDIR /app
EXPOSE 8000

RUN tar -xzf /app.tar.gz

CMD ["/app/bin/scansfer_release", "foreground"]
