#!/usr/bin/env python3
"""
tools/lint_wiki.py
LLM Wiki Health & Graph Audit Script
Scans wiki/ for frontmatter validity, broken Wikilinks, and orphan pages.
"""

import os
import re
from pathlib import Path

WIKI_DIR = Path("wiki")
REQUIRED_FRONTMATTER = ["title", "category", "evidence_tier", "last_updated"]

def parse_markdown_files():
    files = {}
    for root, _, filenames in os.walk(WIKI_DIR):
        for f in filenames:
            if f.endswith(".md"):
                filepath = Path(root) / f
                with open(filepath, "r", encoding="utf-8") as file:
                    content = file.read()
                files[filepath] = content
    return files

def audit_wiki():
    files = parse_markdown_files()
    total_files = len(files)
    print(f"\n==============================")
    print(f" LLM WIKI GRAPH LINT REPORT")
    print(f" Total Wiki Pages: {total_files}")
    print(f"==============================\n")

    all_file_stems = {p.stem: p for p in files.keys()}
    all_file_rel = {str(p.as_posix()): p for p in files.keys()}

    inbound_links = {stem: 0 for stem in all_file_stems.keys()}
    broken_links = []
    frontmatter_errors = []

    # Regex patterns
    frontmatter_pattern = re.compile(r"^---\s*\n(.*?)\n---", re.DOTALL)
    wikilink_pattern = re.compile(r"\[\[(.*?)\]\]")

    for filepath, content in files.items():
        stem = filepath.stem

        # 1. Check Frontmatter (Skip INDEX.md and LOG.md)
        if stem not in ["INDEX", "LOG"]:
            fm_match = frontmatter_pattern.search(content)
            if not fm_match:
                frontmatter_errors.append((filepath, "Missing YAML frontmatter block"))
            else:
                fm_text = fm_match.group(1)
                for req in REQUIRED_FRONTMATTER:
                    if not re.search(rf"^{req}:", fm_text, re.MULTILINE):
                        frontmatter_errors.append((filepath, f"Missing required frontmatter key: '{req}'"))

        # 2. Extract Wikilinks
        for match in wikilink_pattern.finditer(content):
            target = match.group(1).split("|")[0].split("#")[0].strip()
            if target.startswith("raw/"):
                # Reference to raw source
                continue
            
            # Resolve target stem
            target_path = Path(target)
            target_stem = target_path.stem

            if target_stem in all_file_stems:
                inbound_links[target_stem] += 1
            else:
                broken_links.append((filepath.name, target))

    # 3. Identify Orphans (0 inbound links, excluding INDEX and LOG)
    orphans = [stem for stem, count in inbound_links.items() if count == 0 and stem not in ["INDEX", "LOG"]]

    # Print Results
    print(f"[1] Frontmatter Schema Compliance:")
    if not frontmatter_errors:
        print("  ✓ All pages strictly adhere to the AGENTS.md schema.")
    else:
        for fp, err in frontmatter_errors:
            print(f"  ✗ {fp.name}: {err}")

    print(f"\n[2] Wikilink Integrity Check:")
    if not broken_links:
        print("  ✓ Zero broken links detected. All target files exist.")
    else:
        for src, tgt in broken_links:
            print(f"  ✗ Broken link in '{src}' -> Target '{tgt}' does not exist.")

    print(f"\n[3] Graph Orphan Check:")
    if not orphans:
        print("  ✓ Zero orphan pages. Every concept and protocol is cross-linked.")
    else:
        print(f"  ! Found {len(orphans)} orphan pages (0 inbound links):")
        for o in orphans:
            print(f"    - {o}.md")

    print(f"\n==============================")
    print(f" Audit Complete: Status {'HEALTHY' if not broken_links and not frontmatter_errors else 'WARNING'}")
    print(f"==============================\n")

if __name__ == "__main__":
    audit_wiki()
