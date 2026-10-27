## Project rules

- Before changing any text, fact, section or the contact form, use the `miss-noha-content` skill: only confirmed facts, ask the user when something is missing.
- To publish any change to `index.html` or `images/`, follow the `publish-site` skill.
- `marketing/` holds the QR code and QR card. Regenerate the QR with `python marketing/make_qr.py marketing` (needs `segno zxing-cpp pillow`).

## Agent skills

### Issue tracker

Issues live in GitHub Issues on ahmednoha110-design/miss-noha (via `gh`). See `docs/agents/issue-tracker.md`.

### Triage labels

Default five labels: needs-triage, needs-info, ready-for-agent, ready-for-human, wontfix. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: one `GLOSSARY.md` + `docs/adr/` at the repo root (created only when needed). See `docs/agents/domain.md`.
