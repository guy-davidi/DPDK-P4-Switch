import random

with open('table.txt', 'w') as file:
    for i in range(1, 256):
        ip_hex = hex(i << 24)
        ip_str = ".".join(str((i << 24) >> n & 0xFF) for n in (24, 16, 8, 0))
        class_num = random.randint(0, 300)
        line = f"match {ip_hex} action send port 0x1 class {class_num}\n"
        file.write(line)
