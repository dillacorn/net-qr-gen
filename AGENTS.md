# Repository instructions for net-qr-gen

Applies to this offline Wi-Fi QR generation utility.

## Implementation and credential safety

- `qr.sh` is a Bash program that reads key/value Wi-Fi details from `wifi.txt` or an explicitly selected `CFG_FILE`. It generates Wi-Fi QR output locally using `qrencode` or a Python `qrcode` fallback; preserve offline operation and the existing input/output interface.
- Treat Wi-Fi passwords, SSIDs, and QR output as potentially sensitive. Never introduce telemetry, network uploads, third-party hosted QR-generation services, debug printing of Wi-Fi payloads, or copies of users' real connection credentials in logs, commits, tests, or issue/PR descriptions.
- Preserve safe parsing without `eval` or sourcing untrusted config, correct escaping of Wi-Fi QR delimiters (backslash, semicolon, comma, colon, and quote), Unicode handling, hidden SSIDs, and `AUTH=nopass` behavior. Never accidentally expose a password through shell tracing or error output.
- Treat the tracked `wifi.txt` as example/config material, not permission to publish or alter an individual's real Wi-Fi credentials. Use invented test values and keep generated QR images out of commits unless explicitly requested.
- Preserve the user's selected output location and avoid destructive overwrites or unintended config mutation.

## Merge and release authorization

Operate autonomously within the user's approved scope. Do not add unnecessary repeat-approval checkpoints.

- Investigating, implementing, fixing, testing, committing scoped work to a feature branch, or preparing an ordinary review PR does **not** by itself authorize merging to the default branch, creating a tag, publishing a GitHub Release, distributing a build, or deploying to devices.
- An explicit instruction to merge, apply directly to `main`, tag, or release authorizes that named operation for the specified work. An approved release includes the necessary scoped merge unless the user specifies another target or restriction. Do not demand another approval for already-authorized steps.
- Authorization for an **unfinished** merge or release survives related small fixes, revisions, and testing pauses. If the user interrupts an approved release to correct something, "good to go", "working, continue", or a similarly clear signal may resume that same pending release without asking for the original approval again.
- Respect "wait", "hold off", and cancellations. A pause stops delivery until the user clearly resumes; cancellation withdraws approval. Materially different work, a changed release target, or an altered version beyond what was authorized requires renewed authorization.
- Approval is **single-use**: after the authorized merge/release finishes, it does not authorize another merge or release, including a follow-up patch. Positive feedback alone ("perfect", "that works") cannot start a new delivery operation when none is pending.
- The user may approve a merge or release without personally testing it. Run the available relevant static/automated checks, report meaningful failures, and distinguish automated validation from unperformed real-device/runtime tests. Do not impose user testing as an extra requirement if the user explicitly elects to proceed.
- Drafting release notes, suggesting a version, or preparing a branch/PR is not publication. Publishing workflows, temporary GitHub Actions release bridges, Git tags, Releases, uploads, and external release artifacts require the active authorization for that exact publication.
- Never equate approval for a GitHub Release with approval for unrelated distribution, production deployment, hardware changes, destructive data operations, credential exposure, or external-provider settings.

## Validation and releases

- Check `bash -n qr.sh` and optional ShellCheck when available; exercise delimiter/Unicode and open-network cases using synthetic test credentials and an offline QR backend when available. Do not echo or embed live passwords in test logs.
- A code change is not an automatic software release or deployment. Do not invent versions or publish tags/releases without the active user authorization.
