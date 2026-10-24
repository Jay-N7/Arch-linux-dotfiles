#!/usr/bin/env python3
"""rofi dictionary mode (called by dict.sh).

ROFI_RETV=2 -> custom input: look the word up (dictionaryapi.dev, free, no key)
ROFI_RETV=1 -> a definition row was picked: copy it and close
Tip: when definitions are showing, type a new word and press Ctrl+Enter
(or Enter if it doesn't fuzzy-match a row) to look it up.
"""
import json
import os
import subprocess
import sys
import urllib.error
import urllib.parse
import urllib.request
from html import escape

API = "https://api.dictionaryapi.dev/api/v2/entries/en/"
MAX_DEFS = 30


def out(*parts):
    sys.stdout.write("".join(parts) + "\n")


def opt(key, val):
    out("\0", key, "\x1f", val)


def row(plain, display, info):
    # entry text = plain (what rofi filters on), display = pango markup
    clean = lambda s: s.replace("\n", " ").replace("\0", "").replace("\x1f", "")
    out(clean(plain), "\0display\x1f", clean(display), "\x1finfo\x1f", clean(info))


def copy(text):
    subprocess.run(["wl-copy"], input=text.encode(), stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL)


def lookup(word):
    url = API + urllib.parse.quote(word.strip().lower())
    try:
        with urllib.request.urlopen(url, timeout=5) as r:
            return json.load(r), None
    except urllib.error.HTTPError as e:
        return None, "No definitions found" if e.code == 404 else f"HTTP {e.code}"
    except Exception as e:  # offline, DNS, timeout
        return None, f"Lookup failed ({e.__class__.__name__})"


def main():
    retv = os.environ.get("ROFI_RETV", "0")
    arg = sys.argv[1] if len(sys.argv) > 1 else ""

    if retv == "1":
        info = os.environ.get("ROFI_INFO", "")
        if info:
            copy(info)
        return

    word = arg.strip()
    if not word:
        opt("message", "Type a word and press Enter")
        out(" \0nonselectable\x1ftrue")  # keep rofi open
        return

    opt("markup-rows", "true")
    data, err = lookup(word)
    if err:
        # rofi closes a script mode that returns zero rows, so always emit one
        opt("message", "Try another word")
        out(f"{escape(word)}: {escape(err)}\0nonselectable\x1ftrue")
        return

    entry = data[0]
    phon = entry.get("phonetic") or next(
        (p.get("text") for p in entry.get("phonetics", []) if p.get("text")), "")
    opt("message", f"<b>{escape(entry.get('word', word))}</b>  {escape(phon)}"
                   "   ·   Enter copies a definition")

    n = 0
    for e in data:
        for m in e.get("meanings", []):
            pos = m.get("partOfSpeech", "")
            for d in m.get("definitions", []):
                text = d.get("definition", "")
                ex = d.get("example")
                disp = f"<i>{escape(pos)}</i>  {escape(text)}"
                if ex:
                    disp += f'  <span alpha="60%">“{escape(ex)}”</span>'
                row(f"{pos} {text}", disp, text)
                n += 1
                if n >= MAX_DEFS:
                    return


if __name__ == "__main__":
    main()
