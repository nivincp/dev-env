#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${1:-.}"
OUTPUT_FILE="${2:-context.md}"

: > "$OUTPUT_FILE"

find "$ROOT_DIR" -type f -print0 \
  | sort -z \
  | while IFS= read -r -d '' file; do

    # Exclude common noise
    case "$file" in
      */node_modules/*|*/.git/*|*/.terraform/*|*/dist/*|*/build/*)
        continue
        ;;
    esac

    # Skip binary files
    if ! file "$file" | grep -qi text; then
      continue
    fi

    FULL_PATH="$(realpath "$file")"

    echo "" >> "$OUTPUT_FILE"
    echo "---" >> "$OUTPUT_FILE"
    echo "### \`$FULL_PATH\`" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    cat "$file" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"

done