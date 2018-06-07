import sys
import re

pattern = sys.argv[1]

p = re.compile(pattern)

for line in sys.stdin:
    m = p.match(line)
    if m:
        print m.group(1)
