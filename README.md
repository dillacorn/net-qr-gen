## Usage

`bash-qr-gen` reads Wi-Fi details from a local text file and generates a scannable QR code.
No network access required. Secrets are never logged or stored outside the config file.

### Requirements

* `bash`
* One of:

  * `qrencode` (recommended)
  * or Python 3 with `qrcode[pil]`

On Arch:

```bash
sudo pacman -S qrencode
```

### Setup

Clone the repo and make the script executable:

```bash
git clone https://github.com/yourname/bash-qr-gen.git
cd bash-qr-gen
chmod +x qr.sh
```

Create a config file named `wifi.txt` in the same directory:

```text
# Required
SSID=MyGuestWifi
PASS=p@$$w0rd;:"\,😀

# Optional
AUTH=WPA        # WPA, WEP, or nopass
HIDDEN=true     # true or false
OUT=wifi.png    # output file name
```

Notes:

* Special characters and Unicode are fully supported
* `PASS` can contain spaces, emojis, and punctuation
* If `AUTH=nopass`, omit `PASS`

### Generate the QR Code

Run the script:

```bash
./qr.sh
```

The QR code image will be written to the same directory (default: `wifi-guest.png` or the name set in `OUT`).

Scan the QR code with a phone camera to join the network instantly.

### Security Notes

* The password is only read from the local config file
* No environment variables or shell history leaks
* Works fully offline
* Designed for repeatable regeneration when credentials change

---

If you want, next logical additions would be:

* multiple profiles (`wifi-home.txt`, `wifi-guest.txt`)
* terminal QR output mode
* non-Wi-Fi generic QR payloads

But as-is, this README is complete and shippable.

## ☕ Donate

Built and maintained out of passion. Always FOSS. Donations appreciated.  
[Donate via PayPal](https://www.paypal.com/donate/?business=XSNV4QP8JFY9Y&no_recurring=0&item_name=Built+and+maintained+out+of+passion.+Always+FOSS.+Donations+appreciated.+%28smtty%2C+MicLockTray%2C+awtarchy%29&currency_code=USD)