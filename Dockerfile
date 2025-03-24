FROM debian:bookworm-slim AS build

ARG PHOENIXD_VERSION
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /app
RUN apt update && apt upgrade -y && apt install -y wget unzip
RUN wget "https://github.com/ACINQ/phoenixd/releases/download/v$PHOENIXD_VERSION/phoenixd-$PHOENIXD_VERSION-linux-x64.zip" -O phoenixd.zip
RUN unzip phoenixd.zip
RUN mv phoenixd-$PHOENIXD_VERSION-linux-x64/phoenixd /app/phoenixd
RUN chmod +x /app/phoenixd

FROM debian:bookworm-slim AS runtime

RUN apt update && apt upgrade -y && apt install -y ca-certificates
RUN adduser phoenix --uid 1000 --home /phoenix
USER phoenix:phoenix

WORKDIR /phoenix
COPY --chown=phoenix:phoenix --from=build /app/phoenixd /phoenix/phoenixd

VOLUME ["/phoenix/.phoenix"]
EXPOSE 9740

ENTRYPOINT ["/phoenix/phoenixd", "--agree-to-terms-of-service", "--http-bind-ip", "0.0.0.0"]
