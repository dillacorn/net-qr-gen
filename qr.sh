#!/usr/bin/env bash
set -euo pipefail

# Reads Wi-Fi settings from a text file in the same directory as this script.
# File format: key=value (one per line). Lines starting with # are comments.
#
# Required:
#   SSID=YourSSID
#   PASS=YourPassword          (omit if AUTH=nopass)
#
# Optional:
#   AUTH=WPA                   (WPA, WEP, nopass)
#   HIDDEN=true                (true/false)
#   OUT=wifi-guest.png         (output PNG)
#
# Example wifi.txt:
#   SSID=GUESTATT4jtu
#   PASS=p@$$w0rd;:"\,😀
#   AUTH=WPA
#   HIDDEN=true
#   OUT=wifi-guest.png

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CFG_FILE="${CFG_FILE:-$SCRIPT_DIR/wifi.txt}"

# Load config safely: parse key=value, no eval.
SSID=""
PASS=""
AUTH="WPA"
HIDDEN="false"
OUT="wifi-guest.png"

if [[ ! -f "$CFG_FILE" ]]; then
  printf 'ERROR: config file not found: %s\n' "$CFG_FILE" >&2
  exit 1
fi

while IFS= read -r line || [[ -n "$line" ]]; do
  # strip CR (windows)
  line="${line%$'\r'}"

  # skip blanks and comments
  [[ -z "$line" ]] && continue
  [[ "${line:0:1}" == "#" ]] && continue

  # allow inline comments only if preceded by whitespace (keeps passwords like abc#123 intact)
  if [[ "$line" =~ ^([^#]*[[:space:]])#.*$ ]]; then
    line="${BASH_REMATCH[1]}"
    # trim trailing whitespace
    line="${line%"${line##*[![:space:]]}"}"
  fi

  # must be key=value
  if [[ "$line" != *"="* ]]; then
    printf 'ERROR: bad line (missing "="): %s\n' "$line" >&2
    exit 1
  fi

  key="${line%%=*}"
  val="${line#*=}"

  # trim whitespace around key only
  key="${key#"${key%%[![:space:]]*}"}"
  key="${key%"${key##*[![:space:]]}"}"

  case "$key" in
    SSID) SSID="$val" ;;
    PASS) PASS="$val" ;;
    AUTH) AUTH="$val" ;;
    HIDDEN) HIDDEN="$val" ;;
    OUT) OUT="$val" ;;
    *)
      printf 'ERROR: unknown key "%s" in %s\n' "$key" "$CFG_FILE" >&2
      exit 1
      ;;
  esac
done < "$CFG_FILE"

# Normalize and validate.
case "$AUTH" in
  WPA|WEP|nopass) ;;
  *) printf 'ERROR: AUTH must be WPA, WEP, or nopass (got: %s)\n' "$AUTH" >&2; exit 1 ;;
esac
case "$HIDDEN" in
  true|false) ;;
  *) printf 'ERROR: HIDDEN must be true or false (got: %s)\n' "$HIDDEN" >&2; exit 1 ;;
esac
if [[ -z "$SSID" ]]; then
  printf 'ERROR: SSID is required in %s\n' "$CFG_FILE" >&2
  exit 1
fi
if [[ "$AUTH" != "nopass" && -z "$PASS" ]]; then
  printf 'ERROR: PASS is required in %s (unless AUTH=nopass)\n' "$CFG_FILE" >&2
  exit 1
fi
if [[ "$AUTH" == "nopass" ]]; then
  PASS=""
fi

# Wi-Fi QR format: escape only required delimiters: \ ; , : "
wifi_qr_escape() {
  local s=$1
  s=${s//\\/\\\\}
  s=${s//;/\\;}
  s=${s//,/\\,}
  s=${s//:/\\:}
  s=${s//\"/\\\"}
  printf '%s' "$s"
}

# Build payload. Include P: only when not nopass.
if [[ "$AUTH" == "nopass" ]]; then
  PAYLOAD="$(printf 'WIFI:T:%s;S:%s;H:%s;;' \
    "$AUTH" \
    "$(wifi_qr_escape "$SSID")" \
    "$HIDDEN"
  )"
else
  PAYLOAD="$(printf 'WIFI:T:%s;S:%s;P:%s;H:%s;;' \
    "$AUTH" \
    "$(wifi_qr_escape "$SSID")" \
    "$(wifi_qr_escape "$PASS")" \
    "$HIDDEN"
  )"
fi

# Output path relative to script directory unless absolute.
case "$OUT" in
  /*) OUT_PATH="$OUT" ;;
  *) OUT_PATH="$SCRIPT_DIR/$OUT" ;;
esac

if command -v qrencode >/dev/null 2>&1; then
  qrencode -o "$OUT_PATH" -s 10 -- "$PAYLOAD"
  printf 'Wrote %s\n' "$OUT_PATH"
  exit 0
fi

python3 - <<PY
import sys
try:
    import qrcode
except Exception:
    print("Need 'qrencode' OR: python -m pip install --user 'qrcode[pil]'", file=sys.stderr)
    raise
payload = ${PAYLOAD@Q}
out_path = ${OUT_PATH@Q}
img = qrcode.make(payload)
img.save(out_path)
print(f"Wrote {out_path}")
PY
