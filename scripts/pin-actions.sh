#!/usr/bin/env bash
# Rewrites "uses: owner/repo@tag" to "uses: owner/repo@<sha> # tag"
set -euo pipefail
for f in .github/workflows/*.yml; do
  grep -oE 'uses: [^ ]+@[^ #]+' "$f" | sort -u | while read -r _ ref; do
    repo="${ref%@*}"; tag="${ref#*@}"
    [[ "$tag" =~ ^[0-9a-f]{40}$ ]] && continue
    sha=$(git ls-remote "https://github.com/$repo" "refs/tags/$tag^{}" | cut -f1)
    [ -z "$sha" ] && sha=$(git ls-remote "https://github.com/$repo" "refs/tags/$tag" | cut -f1)
    [ -z "$sha" ] && { echo "cannot resolve $ref"; continue; }
    sed -i "s|uses: $repo@$tag\$|uses: $repo@$sha # $tag|" "$f"
  done
done
