---
name: publish-site
description: How to change, check and deploy the Miss Noha landing page — edit index.html, verify it on a phone-width viewport, commit, push to GitHub and wait for GitHub Pages. Use this whenever the user asks to update, fix, publish, deploy, push or "ارفع" the page, or after any edit to index.html or images/, even if they don't mention GitHub.
---

# Publish the Miss Noha page

Read the `miss-noha-content` skill first if the change touches any text, fact or the form.

## Where things live

- The one working copy is `Documents\miss-noha\site` (`C:\Users\ED0W\OneDrive\المستندات\miss-noha\site`). Work there; other copies of the repo on this machine go stale.
- `index.html` (repo root) is the whole page: inline CSS and JS, Google Fonts, no build step. Images are in `images/`.
- GitHub account: **ahmednoha110-design** (the `gh` CLI is logged in as it). Use `gh`/`git` from the terminal — the claude.ai GitHub connector has been signed in to a different person's account, so don't use it to create repos or push.
- Remote: `miss-noha` → `ahmednoha110-design/miss-noha` (**public**, the only repo; `main` tracks it). The user deleted an earlier private copy on purpose — don't recreate it.
- Live page: https://ahmednoha110-design.github.io/miss-noha/ — GitHub Pages builds it from `main`.

## Steps

0. **Sync.** Run `git pull --ff-only miss-noha main`, then `git status --short`. Done when the pull succeeds and status prints nothing, so your edit starts from the latest commit. Other sessions push to this repo too; read `git log --oneline -5` so you build on their work.
1. **Edit** `index.html`. Keep `<!doctype html>` and `<html lang="ar" dir="rtl">` at the top; colors go through the `:root` tokens (light + dark blocks).
2. **Check** at phone width (375px): serve the folder (e.g. `python -m http.server 8765`) and open it in the browser pane. Confirm `document.documentElement.scrollWidth === clientWidth` (no sideways scroll), Arabic reads right-to-left, and Latin words sit correctly. One look is enough.
3. **Commit.** Run `bash scripts/check.sh` (the pre-commit hook and CI run it too), stage, then read `git diff --cached --stat` and `git diff --cached`. Done when every changed file and line is one you meant to change. Commit with a short English message ending in the attribution line the session gives you. The repo's own `user.name`/`user.email` are already set to the account's noreply address; don't change global git config.
4. **Push:**
   ```bash
   git push miss-noha main
   ```
   The network here drops DNS often ("Could not resolve host" / "error connecting to api.github.com"). Retry a few times with a short pause before reporting failure.
5. **Wait for Pages** (often 1–5 minutes):
   ```bash
   gh api repos/ahmednoha110-design/miss-noha/pages/builds/latest --jq .status
   ```
   Poll until `built`, then fetch the live URL with a cache-busting query (`?v=123`) and confirm your change is in it.
6. **claude.ai copy (if the user still uses it):** the Artifact page must not contain `<!doctype>`/`<html>` — publish a copy with the first two lines and the closing `</html>` removed. Inside claude.ai the contact form can't reach Supabase; that's expected, not a bug.

## Report

Say the commit's short hash and that it reached GitHub, whether Pages finished and the live page shows the change, and anything not verified — for example, the form wasn't submitted because that writes a real row.
