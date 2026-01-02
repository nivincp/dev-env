#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${1:-.}"
OUTPUT_FILE="${2:-context.md}"

OUTPUT_FILE="$(realpath "$OUTPUT_FILE")"

: > "$OUTPUT_FILE"

find "$ROOT_DIR" -type f -print0 \
  | sort -z \
  | while IFS= read -r -d '' file; do

    FILE_PATH="$(realpath "$file")"

    # Skip the output file itself
    if [[ "$FILE_PATH" == "$OUTPUT_FILE" ]]; then
      continue
    fi

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

    {
      echo ""
      echo "---"
      echo "### \`$FILE_PATH\`"
      echo ""
      echo '```'
      cat "$file"
      echo '```'
      echo ""
    } >> "$OUTPUT_FILE"

done