#!/bin/bash
# Check whether any Formula/*.rb references an outdated upstream version.
# Reports current vs. latest; does not modify files.
set -euo pipefail

cd "$(dirname "$0")/.."

red()   { printf '\033[31m%s\033[0m' "$*"; }
green() { printf '\033[32m%s\033[0m' "$*"; }

report() {
  local name=$1 current=$2 latest=$3
  if [[ "$current" == "$latest" ]]; then
    printf '%-12s %s\n' "$name" "$(green "$current (current)")"
  else
    printf '%-12s %s -> %s\n' "$name" "$current" "$(red "$latest")"
  fi
}

gh_latest_tag() {
  # $1 = owner/repo. Picks the highest semver-ish tag.
  curl -fsSL "https://api.github.com/repos/$1/tags?per_page=20" \
    | grep '"name"' \
    | sed -E 's/.*"name": "v?([^"]+)".*/\1/' \
    | grep -E '^[0-9]+(\.[0-9]+)+$' \
    | sort -V \
    | tail -1
}

extract_url_version() {
  # $1 = formula path, $2 = regex with one capture group
  grep -m1 -Eo "$2" "$1" | head -1 | sed -E "s|$2|\1|"
}

# buildkite
cur=$(extract_url_version Formula/buildkite.rb 'buildkite/archive/v([0-9.]+)\.tar\.gz')
report buildkite "$cur" "$(gh_latest_tag kevinburke/buildkite)"

# envdir
cur=$(extract_url_version Formula/envdir.rb 'envdir/archive/v([0-9.]+)\.tar\.gz')
report envdir "$cur" "$(gh_latest_tag kevinburke/envdir)"

# hostsfile
cur=$(extract_url_version Formula/hostsfile.rb 'hostsfile/archive/([0-9.]+)\.tar\.gz')
report hostsfile "$cur" "$(gh_latest_tag kevinburke/hostsfile)"

# rustls-ffi
cur=$(extract_url_version Formula/rustls-ffi.rb 'rustls-ffi/archive/v([0-9.]+)\.tar\.gz')
report rustls-ffi "$cur" "$(gh_latest_tag rustls/rustls-ffi)"

# curl (uses curl.se directory listing)
cur=$(extract_url_version Formula/curl.rb 'curl-([0-9.]+)\.tar\.bz2')
latest=$(curl -fsSL https://curl.se/download/ \
  | grep -Eo 'curl-[0-9]+\.[0-9]+\.[0-9]+\.tar\.bz2' \
  | sed -E 's/curl-([0-9.]+)\.tar\.bz2/\1/' \
  | sort -V | tail -1)
report curl "$cur" "$latest"

# git (kernel.org mirror)
cur=$(extract_url_version Formula/git.rb 'git-([0-9.]+)\.tar\.xz')
latest=$(curl -fsSL https://mirrors.edge.kernel.org/pub/software/scm/git/ \
  | grep -Eo 'git-[0-9]+\.[0-9]+\.[0-9]+\.tar\.xz' \
  | sed -E 's/git-([0-9.]+)\.tar\.xz/\1/' \
  | sort -V | tail -1)
report git "$cur" "$latest"
