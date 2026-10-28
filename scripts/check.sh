#!/usr/bin/env bash
# Repo checks for the Miss Noha site. Run from anywhere: bash scripts/check.sh
# Used by the pre-commit hook (.githooks/pre-commit) and CI (.github/workflows/check.yml).
set -u
cd "$(dirname "$0")/.." || exit 2

fail=0
problem() { echo "check failed: $*" >&2; fail=1; }

# Page structure: a standalone page with one <html> element.
head -n 1 index.html | grep -qi '^<!doctype html>' || problem "index.html must start with <!doctype html>"
[ "$(grep -oi '<html' index.html | wc -l)" -eq 1 ] || problem "index.html must contain exactly one <html> tag"

# WhatsApp links: all identical, and the prefilled text is Arabic/ASCII only
# (the wa.me redirect turns emoji and other symbols into "?").
links=$(grep -o 'https://wa\.me/[^"]*' index.html | sort -u)
if [ -z "$links" ]; then
  problem "index.html has no wa.me links"
elif [ "$(echo "$links" | wc -l)" -ne 1 ]; then
  problem "wa.me links differ; keep every WhatsApp button identical:"$'\n'"$links"
elif ! echo "$links" | grep -q '?text='; then
  problem "wa.me links must carry the prefilled ?text= in the href itself"
else
  echo "$links" | perl -CS -Mutf8 -ne '
    my ($t) = /[?&]text=([^&]*)/ or exit 0;
    $t =~ s/%([0-9A-Fa-f]{2})/chr(hex $1)/ge;
    utf8::decode($t) or do { print STDERR "check failed: wa.me text is not valid UTF-8\n"; exit 1 };
    if ($t =~ /([^\x{0600}-\x{06FF}\x{20}-\x{7E}\n])/) {
      printf STDERR "check failed: wa.me text has a character WhatsApp will garble: U+%04X\n", ord $1; exit 1;
    }' || fail=1
fi

# Secrets: only the publishable Supabase key may appear in the repo.
if git ls-files -z | xargs -0 grep -IlE 'sb_secret_[A-Za-z0-9_-]{8,}|eyJ[A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{20,}' 2>/dev/null; then
  problem "a secret or JWT key is committed in the files above"
fi

# Skills are copied in as plain folders, never as symlinks or installer leftovers.
if git ls-files -s | awk '$1 == 120000 { print $4; found = 1 } END { exit !found }'; then
  problem "symlinks are tracked (listed above); copy the real files instead"
fi
git ls-files | grep -E '^(\.agents/|skills-lock\.json$)' && problem "skills CLI leftovers are tracked (listed above)"

[ "$fail" -eq 0 ] && echo "all checks passed"
exit "$fail"
