# Stage 1: Gleam compiler
FROM ghcr.io/gleam-lang/gleam:v1.13.0-erlang AS gleam-stage

# Stage 2: Final image with Playwright and Gleam
FROM mcr.microsoft.com/playwright:v1.57.0-noble

# Copy Erlang/OTP and Gleam
COPY --from=gleam-stage /usr/local/lib/erlang /usr/local/lib/erlang
COPY --from=gleam-stage /usr/local/bin/erl /usr/local/bin/erl
COPY --from=gleam-stage /usr/local/bin/escript /usr/local/bin/escript
COPY --from=gleam-stage /usr/local/bin/rebar3 /usr/local/bin/rebar3
COPY --from=gleam-stage /usr/bin/gleam /usr/local/bin/gleam

WORKDIR /work

ENTRYPOINT ["/bin/sh", "-c"]
