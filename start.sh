#!/usr/bin/env bash
set -euo pipefail

PORT="${PORT:-8080}"
XRAY_UUID="${XRAY_UUID:-}"
XRAY_WS_PATH="${XRAY_WS_PATH:-/vless}"
XRAY_LOGLEVEL="${XRAY_LOGLEVEL:-warning}"

if [[ -z "$XRAY_UUID" ]]; then
  echo "[ERROR] XRAY_UUID is required"
  exit 1
fi

if ! echo "$XRAY_UUID" | grep -Eq '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$'; then
  echo "[ERROR] XRAY_UUID is invalid: $XRAY_UUID"
  exit 1
fi

if [[ "${XRAY_WS_PATH}" != /* ]]; then
  XRAY_WS_PATH="/${XRAY_WS_PATH}"
fi

cat >/app/xray.json <<JSON
{
  "log": { "loglevel": "${XRAY_LOGLEVEL}" },
  "inbounds": [
    {
      "tag": "vless-ws",
      "listen": "0.0.0.0",
      "port": ${PORT},
      "protocol": "vless",
      "settings": {
        "clients": [
          { "id": "${XRAY_UUID}", "email": "railway@xray", "level": 0 }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": { "path": "${XRAY_WS_PATH}" }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls", "quic"]
      }
    }
  ],
  "outbounds": [
    { "protocol": "freedom", "tag": "direct" },
    { "protocol": "blackhole", "tag": "blocked" }
  ],
  "routing": {
    "domainStrategy": "AsIs",
    "rules": [
      { "type": "field", "protocol": ["bittorrent"], "outboundTag": "blocked" }
    ]
  }
}
JSON

xray run -test -config /app/xray.json
exec xray run -config /app/xray.json
