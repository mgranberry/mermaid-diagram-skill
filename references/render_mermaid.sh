#!/usr/bin/env bash
set -e

INPUT="$1"
OUTPUT="${2:-}"

# Validate input file
if [[ -z "$INPUT" ]]; then
  echo "Error: Input file path required" >&2
  exit 1
fi

if [[ ! -f "$INPUT" ]]; then
  echo "Error: Input file does not exist: $INPUT" >&2
  exit 1
fi

# Set default output path if not provided
if [[ -z "$OUTPUT" ]]; then
  OUTPUT="${INPUT%.*}.png"
fi

# Invoke mmdc via npx (diagrams carry their own classDef styles)
if ! npx --yes -p @mermaid-js/mermaid-cli mmdc -i "$INPUT" -o "$OUTPUT"; then
  echo "Error: mmdc rendering failed" >&2
  exit 1
fi

# Verify output file exists and is non-empty
if ! test -s "$OUTPUT"; then
  echo "Error: Output file is empty or does not exist: $OUTPUT" >&2
  exit 1
fi

# Success: print output path
echo "$OUTPUT"
