FROM alpine:3.21

ARG XRAY_VERSION=1.8.24
ARG TARGETARCH

RUN set -eux; \
  apk add --no-cache ca-certificates curl unzip bash; \
  arch="${TARGETARCH:-amd64}"; \
  case "$arch" in \
    amd64) pkg_arch="64" ;; \
    arm64) pkg_arch="arm64-v8a" ;; \
    *) echo "Unsupported arch: $arch"; exit 1 ;; \
  esac; \
  curl -fL "https://github.com/XTLS/Xray-core/releases/download/v${XRAY_VERSION}/Xray-linux-${pkg_arch}.zip" -o /tmp/xray.zip; \
  unzip /tmp/xray.zip -d /usr/local/bin; \
  chmod +x /usr/local/bin/xray; \
  rm -f /tmp/xray.zip; \
  xray version

WORKDIR /app
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

ENV PORT=8080
ENV XRAY_WS_PATH=/vless
ENV XRAY_LOGLEVEL=warning

EXPOSE 8080
ENTRYPOINT ["/app/start.sh"]
