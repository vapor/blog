#!/usr/bin/env python3
"""Static content lint for blog posts. Fails CI on:

  * a meta `description` that's missing or outside the SEO-friendly length range
  * a content image without alt text (accessibility + SEO)

Runs on the source markdown — no site build required.
"""
import glob
import re
import sys

MIN_DESC = 70
MAX_DESC = 160
POSTS_GLOB = "Content/posts/*.md"


def split_front_matter(text: str):
    """Return (front-matter dict, body). Values have surrounding quotes stripped."""
    match = re.match(r"^---\r?\n(.*?)\r?\n---\r?\n(.*)$", text, re.S)
    if not match:
        return {}, text
    fields: dict[str, str] = {}
    for line in match.group(1).splitlines():
        field = re.match(r"\s*([A-Za-z0-9_]+):\s*(.*)$", line)
        if not field:
            continue
        key, value = field.group(1), field.group(2).strip()
        if len(value) >= 2 and value[0] == value[-1] and value[0] in "\"'":
            value = value[1:-1]
        fields[key] = value
    return fields, match.group(2)


def image_issues(body: str) -> list[str]:
    """Markdown/HTML images in the body that lack alt text (skips code fences)."""
    issues: list[str] = []
    in_fence = False
    for number, line in enumerate(body.splitlines(), start=1):
        if line.lstrip().startswith("```"):
            in_fence = not in_fence
            continue
        if in_fence:
            continue
        for image in re.finditer(r"!\[(.*?)\]\(", line):
            if not image.group(1).strip():
                issues.append(f"line {number}: markdown image with empty alt text")
        for image in re.finditer(r"<img\b[^>]*>", line):
            if not re.search(r'alt\s*=\s*"[^"]*\S[^"]*"', image.group(0)):
                issues.append(f"line {number}: <img> without alt text")
    return issues


def main() -> int:
    paths = sorted(glob.glob(POSTS_GLOB))
    if not paths:
        print(f"No posts found at {POSTS_GLOB}", file=sys.stderr)
        return 1

    problems: list[str] = []
    for path in paths:
        name = path.rsplit("/", 1)[-1]
        front_matter, body = split_front_matter(open(path, encoding="utf-8").read())

        desc = front_matter.get("description", "")
        if not desc:
            problems.append(f"{name}: missing description")
        elif len(desc) < MIN_DESC:
            problems.append(f"{name}: description too short ({len(desc)} chars, min {MIN_DESC})")
        elif len(desc) > MAX_DESC:
            problems.append(f"{name}: description too long ({len(desc)} chars, max {MAX_DESC})")

        for issue in image_issues(body):
            problems.append(f"{name}: {issue}")

    if problems:
        print(f"Content check failed — {len(problems)} issue(s) across {len(paths)} posts:", file=sys.stderr)
        for problem in problems:
            print(f"  - {problem}", file=sys.stderr)
        return 1

    print(f"All {len(paths)} posts pass content checks "
          f"(description {MIN_DESC}-{MAX_DESC} chars, images have alt text).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
