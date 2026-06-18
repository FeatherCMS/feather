#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(
    cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
        pwd
)"

usage() {
    cat <<'EOF'
Usage:
    scripts/format-swift-function-signatures.sh [path ...]

Formats Swift function declarations to match the workspace rule:
    - `func name(` stays on the first line
    - each parameter is placed on its own line
    - no trailing comma after the last parameter
    - `) async throws -> ReturnType {` stays on one line when present

If no path is provided, the script scans the whole workspace from the repo root.
Only `.swift` files are processed. `.build`, `.git`, and `.swiftpm` folders are skipped.

Requirements:
    - `python3`
    - `swiftc`
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit 0
fi

if ! command -v python3 >/dev/null 2>&1; then
    echo "error: python3 is required" >&2
    exit 1
fi

if ! command -v swiftc >/dev/null 2>&1; then
    echo "error: swiftc is required" >&2
    exit 1
fi

if [[ "$#" -eq 0 ]]; then
    set -- "$ROOT_DIR"
else
    normalized=()
    for target in "$@"; do
        if [[ "$target" = /* ]]; then
            normalized+=("$target")
        else
            normalized+=("$ROOT_DIR/$target")
        fi
    done
    set -- "${normalized[@]}"
fi

python3 - "$@" <<'PY'
import json
import re
import subprocess
import sys
from pathlib import Path

INDENT_STEP = b"    "
SKIP_DIRS = {".build", ".git", ".swiftpm"}


def find_func_nodes(node, out):
    if isinstance(node, dict):
        if node.get("_kind") == "func_decl" and "range" in node and "params" in node:
            out.append(node)
        for value in node.values():
            find_func_nodes(value, out)
    elif isinstance(node, list):
        for item in node:
            find_func_nodes(item, out)


def split_top_level_commas(data: bytes):
    parts = []
    start = 0
    stack = []
    i = 0
    line_comment = False
    block_comment = 0
    string_delim = None
    raw_hashes = 0
    multiline_string = False

    def starts_string(pos: int):
        nonlocal raw_hashes, multiline_string
        j = pos
        hashes = 0
        while j < len(data) and data[j:j + 1] == b"#":
            hashes += 1
            j += 1
        if data[j:j + 3] == b'"""':
            raw_hashes = hashes
            multiline_string = True
            return j + 3
        if data[j:j + 1] == b'"':
            raw_hashes = hashes
            multiline_string = False
            return j + 1
        return None

    while i < len(data):
        if line_comment:
            if data[i:i + 1] == b"\n":
                line_comment = False
            i += 1
            continue
        if block_comment:
            if data[i:i + 2] == b"/*":
                block_comment += 1
                i += 2
                continue
            if data[i:i + 2] == b"*/":
                block_comment -= 1
                i += 2
                continue
            i += 1
            continue
        if string_delim is not None:
            if multiline_string:
                if data[i:i + 3] == b'"""' and data[i + 3:i + 3 + raw_hashes] == b"#" * raw_hashes:
                    string_delim = None
                    i += 3 + raw_hashes
                    continue
                i += 1
                continue
            if data[i:i + 1] == b"\\":
                i += 2
                continue
            if data[i:i + 1] == b'"' and data[i + 1:i + 1 + raw_hashes] == b"#" * raw_hashes:
                string_delim = None
                i += 1 + raw_hashes
                continue
            i += 1
            continue
        if data[i:i + 2] == b"//":
            line_comment = True
            i += 2
            continue
        if data[i:i + 2] == b"/*":
            block_comment = 1
            i += 2
            continue
        string_end = starts_string(i)
        if string_end is not None:
            string_delim = b'"'
            i = string_end
            continue
        ch = data[i:i + 1]
        if ch in (b"(", b"[", b"{", b"<"):
            stack.append(ch)
        elif ch == b">":
            if stack and stack[-1] == b"<":
                stack.pop()
        elif ch == b")":
            if stack and stack[-1] == b"(":
                stack.pop()
        elif ch == b"]":
            if stack and stack[-1] == b"[":
                stack.pop()
        elif ch == b"}":
            if stack and stack[-1] == b"{":
                stack.pop()
        elif ch == b"," and not stack:
            parts.append(data[start:i])
            start = i + 1
        i += 1
    parts.append(data[start:])
    return parts


def collapse_ws(data: bytes) -> bytes:
    return re.sub(rb"\s+", b" ", data.strip())


def reindent_block(data: bytes, indent: bytes) -> bytes:
    lines = data.decode("utf-8").splitlines()
    if not lines:
        return b""
    return "\n".join(
        (indent.decode("utf-8") + line.strip()) if line.strip() else indent.decode("utf-8")
        for line in lines
    ).encode("utf-8")


def signature_end_without_body(source: bytes, start: int) -> int:
    newline = source.find(b"\n", start)
    return len(source) if newline == -1 else newline


def format_signature(source: bytes, node: dict):
    func_start = node["range"]["start"]
    params = node["params"]["range"]
    params_start = params["start"]
    params_end = params["end"]
    body = node.get("body")
    sig_end = body["range"]["start"] if body and "range" in body else signature_end_without_body(source, params_end + 1)

    line_start = source.rfind(b"\n", 0, func_start)
    line_start = 0 if line_start == -1 else line_start + 1
    indent_end = line_start
    while indent_end < len(source) and source[indent_end:indent_end + 1] in (b" ", b"\t"):
        indent_end += 1
    indent = source[line_start:indent_end]
    param_indent = indent + INDENT_STEP

    prefix = source[func_start:params_start].rstrip()
    params_content = source[params_start + 1:params_end].strip()
    suffix = collapse_ws(source[params_end + 1:sig_end])

    parts = []
    if params_content:
        for raw_part in split_top_level_commas(params_content):
            part = raw_part.strip()
            if part:
                parts.append(part)

    out = bytearray()
    out += prefix + b"(\n"
    for index, part in enumerate(parts):
        out += reindent_block(part, param_indent)
        if index < len(parts) - 1:
            out += b","
        out += b"\n"
    out += indent + b")"
    if suffix:
        out += b" " + suffix
    if body is not None:
        out += b" "
    return func_start, sig_end, bytes(out)


def process_file(path: Path) -> bool:
    source = path.read_bytes()
    proc = subprocess.run(
        ["swiftc", "-frontend", "-dump-parse", "-dump-ast-format", "json", str(path)],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )
    if not proc.stdout:
        return False
    try:
        ast = json.loads(proc.stdout)
    except json.JSONDecodeError:
        return False

    nodes = []
    find_func_nodes(ast, nodes)
    edits = []
    for node in nodes:
        try:
            edits.append(format_signature(source, node))
        except Exception:
            continue
    if not edits:
        return False

    edits.sort(key=lambda item: item[0], reverse=True)
    updated = source
    changed = False
    for start, end, replacement in edits:
        if updated[start:end] != replacement:
            updated = updated[:start] + replacement + updated[end:]
            changed = True
    if changed:
        path.write_bytes(updated)
    return changed


def iter_swift_files(targets):
    for target in targets:
        path = Path(target)
        if path.is_dir():
            for child in path.rglob("*.swift"):
                if any(part in SKIP_DIRS for part in child.parts):
                    continue
                yield child
        elif path.suffix == ".swift" and path.exists():
            yield path


def main(argv):
    changed_files = 0
    seen = set()
    for path in iter_swift_files(argv[1:]):
        resolved = str(path.resolve())
        if resolved in seen:
            continue
        seen.add(resolved)
        if process_file(path):
            changed_files += 1
            print(path)
    print(f"changed_files={changed_files}", file=sys.stderr)


if __name__ == "__main__":
    main(sys.argv)
PY
