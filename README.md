# Railway Xray VLESS WS (2026)

## Required ENV
- `XRAY_UUID` (valid UUID)

## Optional ENV
- `XRAY_WS_PATH` default: `/vless`
- `XRAY_LOGLEVEL` default: `warning`

`PORT` is provided automatically by Railway.

## Deploy
1. Push this repository to GitHub.
2. In Railway: New Project -> Deploy from GitHub.
3. Set environment variables (`XRAY_UUID` at minimum).
4. Deploy and check logs.

## VLESS URL format
`vless://UUID@YOUR_DOMAIN:443?encryption=none&security=tls&type=ws&host=YOUR_DOMAIN&path=%2Fvless&sni=YOUR_DOMAIN#Railway-Xray`

Replace `UUID`, `YOUR_DOMAIN`, and path based on your env.
