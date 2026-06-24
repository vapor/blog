#!/usr/bin/env python3
"""Validate every blog post has a meta `description` of a sensible length.

Search engines truncate descriptions outside roughly 70–160 characters, so we
fail CI if any post's `description:` front matter is missing or out of range.
"""
import glob
import re
import sys

MIN_LENGTH = 70
MAX_LENGTH = 160
POSTS_GLOB = "Content/posts/*.md"


def description(markdown: str) -> str | None:
    """Return the front-matter `description` (quotes stripped), or None."""
    match = re.match(r"^---\r?\n(.*?)\r?\n---\r?\n", markdown, re.S)
    if not match:
        return None
    for line in match.group(1).splitlines():
        field = re.match(r"\s*description:\s*(.*)$", line)
        if not field:
            continue
        value = field.group(1).strip()
        if len(value) >= 2 and value[0] == value[-1] and value[0] in "\"'":
            value = value[1:-1]
        return value
    return None


def main() -> int:
    issues: list[str] = []
    paths = sorted(glob.glob(POSTS_GLOB))
    if not paths:
        print(f"No posts found at {POSTS_GLOB}", file=sys.stderr)
        return 1

    for path in paths:
        name = path.rsplit("/", 1)[-1]
        with open(path, encoding="utf-8") as handle:
            desc = description(handle.read())
        if not desc:
            issues.append(f"{name}: missing description")
            continue
        length = len(desc)  # characters, not bytes
        if length < MIN_LENGTH:
            issues.append(f"{name}: too short ({length} chars, min {MIN_LENGTH})")
        elif length > MAX_LENGTH:
            issues.append(f"{name}: too long ({length} chars, max {MAX_LENGTH})")

    if issues:
        print(
            f"Meta description check failed — {len(issues)} of {len(paths)} "
            f"posts outside {MIN_LENGTH}-{MAX_LENGTH} characters:",
            file=sys.stderr,
        )
        for issue in issues:
            print(f"  - {issue}", file=sys.stderr)
        return 1

    print(f"All {len(paths)} post meta descriptions are {MIN_LENGTH}-{MAX_LENGTH} characters.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
