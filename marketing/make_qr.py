"""Make and verify the QR code for the Miss Noha landing page."""
import sys
from pathlib import Path

import segno
import zxingcpp
from PIL import Image

URL = "https://ahmednoha110-design.github.io/miss-noha/"
OUT = Path(sys.argv[1])

qr = segno.make(URL, error="h")
qr.save(OUT / "qr-miss-noha.png", scale=24, border=4, dark="#40123F", light="#FFFFFF")
qr.save(OUT / "qr-miss-noha.svg", scale=10, border=4, dark="#40123F", light="#FFFFFF")

img = Image.open(OUT / "qr-miss-noha.png")
results = zxingcpp.read_barcodes(img)
print("size:", img.size, "version:", qr.designator)
print("decoded:", [r.text for r in results])
print("match:", any(r.text == URL for r in results))
