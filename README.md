## Usage

`net-qr-gen` reads Wi-Fi details from a local text file and generates a scannable QR code.
No network access required. Secrets are never logged.

### Requirements

* `bash`
* One of:

  * `qrencode` (recommended)
  * Python 3 with `qrcode[pil]`

Arch:

```bash
sudo pacman -S qrencode
```

### Setup

```bash
git clone https://github.com/yourname/net-qr-gen.git
cd net-qr-gen
chmod +x qr.sh
```

Create `wifi.txt` in the same directory:

```text
SSID=MyGuestWifi
PASS=p@$$w0rd;:"\,😀

# Optional
AUTH=WPA        # WPA, WEP, or nopass
HIDDEN=true     # true or false
OUT=wifi.png
```

Notes:

* Special characters and Unicode supported
* If `AUTH=nopass`, omit `PASS`

### Generate

```bash
./qr.sh
```

The QR code image is written to the same directory.
Scan with a phone camera to join the network.

### Security

* Password read only from the local config file
* No shell history or environment leaks
* Fully offline

## ☕ Donate

Built and maintained out of passion. Always FOSS. Donations appreciated.  
[Donate via PayPal](https://www.paypal.com/donate/?business=XSNV4QP8JFY9Y&no_recurring=0&item_name=Built+and+maintained+out+of+passion.+Always+FOSS.+Donations+appreciated.+%28smtty%2C+MicLockTray%2C+awtarchy%29&currency_code=USD)