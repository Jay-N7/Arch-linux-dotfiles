#!/usr/bin/env python3
"""Tiny safe calculator for rofi script mode (fallback for rofi-calc).

ROFI_RETV=2 -> evaluate the typed expression, show result (+ history)
ROFI_RETV=1 -> copy the selected result and close
Supports + - * / // % ** ^ (power), parentheses, math.* (sqrt, sin, log, pi, e, ...),
and "X% of Y".
"""
import ast
import math
import operator as op
import os
import re
import subprocess
import sys

HIST = os.path.join(os.environ.get("XDG_CACHE_HOME", os.path.expanduser("~/.cache")),
                    "rofi-calc-history")

OPS = {ast.Add: op.add, ast.Sub: op.sub, ast.Mult: op.mul, ast.Div: op.truediv,
       ast.FloorDiv: op.floordiv, ast.Mod: op.mod, ast.Pow: op.pow,
       ast.USub: op.neg, ast.UAdd: op.pos}
NAMES = {k: getattr(math, k) for k in dir(math) if not k.startswith("_")}
NAMES.update(abs=abs, round=round, min=min, max=max)


def ev(node):
    if isinstance(node, ast.Expression):
        return ev(node.body)
    if isinstance(node, ast.Constant) and isinstance(node.value, (int, float)):
        return node.value
    if isinstance(node, ast.BinOp) and type(node.op) in OPS:
        l, r = ev(node.left), ev(node.right)
        if isinstance(node.op, ast.Pow) and abs(r) > 10000:
            raise ValueError("exponent too large")
        return OPS[type(node.op)](l, r)
    if isinstance(node, ast.UnaryOp) and type(node.op) in OPS:
        return OPS[type(node.op)](ev(node.operand))
    if isinstance(node, ast.Name) and node.id in NAMES:
        return NAMES[node.id]
    if isinstance(node, ast.Call) and isinstance(node.func, ast.Name) \
            and node.func.id in NAMES and not node.keywords:
        return NAMES[node.func.id](*[ev(a) for a in node.args])
    raise ValueError("unsupported")


def calc(expr):
    e = expr.replace("^", "**").replace("×", "*").replace("÷", "/").replace(",", "")
    e = re.sub(r"([\d.]+)\s*%\s*of\s*", r"(\1/100)*", e, flags=re.I)
    v = ev(ast.parse(e, mode="eval"))
    if isinstance(v, float):
        if v.is_integer() and abs(v) < 1e16:
            return str(int(v))
        return f"{v:.12g}"
    return str(v)


def history():
    try:
        with open(HIST) as f:
            return [l.rstrip("\n") for l in f if l.strip()][-20:]
    except OSError:
        return []


def main():
    retv = os.environ.get("ROFI_RETV", "0")
    if retv == "1":
        val = os.environ.get("ROFI_INFO", "")
        if val:
            subprocess.run(["wl-copy"], input=val.encode(),
                           stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        return

    expr = sys.argv[1].strip() if len(sys.argv) > 1 else ""
    sys.stdout.write("\0no-custom\x1ffalse\n")
    result = None
    if expr:
        try:
            result = calc(expr)
        except Exception:
            sys.stdout.write(f"\0message\x1fCan't evaluate: {expr}\n")

    hist = history()
    if result is not None:
        line = f"{expr} = {result}"
        hist = [h for h in hist if h != line] + [line]
        os.makedirs(os.path.dirname(HIST), exist_ok=True)
        with open(HIST, "w") as f:
            f.write("\n".join(hist[-20:]) + "\n")
        sys.stdout.write("\0message\x1fEnter copies the result · type another expression\n")

    if not hist:  # rofi closes a script mode that returns zero rows
        sys.stdout.write("No result yet\0nonselectable\x1ftrue\n")
    for h in reversed(hist):
        sys.stdout.write(f"{h}\0info\x1f{h.rsplit(' = ', 1)[-1]}\n")


if __name__ == "__main__":
    main()
