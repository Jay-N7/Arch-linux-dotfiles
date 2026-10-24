#!/usr/bin/env python3
"""rofi dictionary mode (called by dict.sh).
ROFI_RETV=2 -> look the word up   ROFI_RETV=1 -> copy the picked definition
Sources: dictionaryapi.dev, then Wiktionary as fallback. Both reject Python's
default User-Agent with HTTP 403, so every request sends its own.
"""
import json, os, re, subprocess, sys
import urllib.error, urllib.parse, urllib.request
from html import escape, unescape

UA = "rofi-spotlight-dict/1.0 (personal desktop launcher)"
API = "https://api.dictionaryapi.dev/api/v2/entries/en/"
WIKT = "https://en.wiktionary.org/api/rest_v1/page/definition/"
MAX_DEFS = 30

def out(*p): sys.stdout.write("".join(p) + "\n")
def opt(k, v): out("\0", k, "\x1f", v)
def row(disp, info):
    out(disp.replace("\n", " "), "\0", "display", "\x1f", disp,
        f"\x1finfo\x1f{info}" if info else "")
def copy(t):
    subprocess.run(["wl-copy"], input=t.encode(),
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def get_json(url):
    req = urllib.request.Request(url, headers={"User-Agent": UA, "Accept": "application/json"})
    with urllib.request.urlopen(req, timeout=5) as r:
        return json.load(r)

def strip_html(s): return unescape(re.sub(r"<[^>]+>", "", s or "")).strip()

def from_dictapi(word):
    data = get_json(API + urllib.parse.quote(word))
    e0 = data[0]
    phon = e0.get("phonetic") or next(
        (p.get("text") for p in e0.get("phonetics", []) if p.get("text")), "")
    return phon, [(m.get("partOfSpeech", ""), d.get("definition", ""), d.get("example"))
                  for e in data for m in e.get("meanings", []) for d in m.get("definitions", [])]

def from_wiktionary(word):
    data = get_json(WIKT + urllib.parse.quote(word))
    defs = []
    for sec in data.get("en", []):
        for d in sec.get("definitions", []):
            t = strip_html(d.get("definition"))
            if t:
                ex = d.get("examples") or []
                defs.append((sec.get("partOfSpeech", "").lower(), t, strip_html(ex[0]) if ex else None))
    if not defs:
        raise urllib.error.HTTPError(WIKT, 404, "not found", None, None)
    return "", defs

def lookup(word):
    errs = []
    for src in (from_dictapi, from_wiktionary):
        try:
            return src(word.strip().lower()), None
        except urllib.error.HTTPError as e:
            errs.append(e.code)
        except Exception as e:
            errs.append(e.__class__.__name__)
    if all(c == 404 for c in errs):
        return None, "No definitions found"
    return None, "Lookup failed (" + ", ".join(map(str, errs)) + ")"

def main():
    if os.environ.get("ROFI_RETV", "0") == "1":
        info = os.environ.get("ROFI_INFO", "")
        if info: copy(info)
        return
    word = (sys.argv[1] if len(sys.argv) > 1 else "").strip()
    if not word:
        opt("message", "Type a word and press Enter"); return
    opt("markup-rows", "true")
    res, err = lookup(word)
    if err:
        opt("message", f"<b>{escape(word)}</b> — {escape(err)}"); return
    phon, defs = res
    opt("message", f"<b>{escape(word)}</b>  {escape(phon)}   ·   Enter copies a definition")
    for pos, text, ex in defs[:MAX_DEFS]:
        disp = f"<i>{escape(pos)}</i>  {escape(text)}"
        if ex: disp += f'  <span alpha="60%">“{escape(ex)}”</span>'
        row(disp, text)

if __name__ == "__main__":
    main()
