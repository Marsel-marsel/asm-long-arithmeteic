from pathlib import Path
import random

FLOPPY_0 = Path("C:\Program Files (x86)\emu8086\FLOPPY_0")
SEGMENT_SIZE = 0x200

if __name__ == '__main__':
    print(f'FLOPPY_0 path set to: {FLOPPY_0}')
    with open(FLOPPY_0, 'wb') as floppy_0:
        var_1 = bytearray(random.getrandbits(8) for _ in range(0, SEGMENT_SIZE))
        var_2 = bytearray(random.getrandbits(8) for _ in range(0, SEGMENT_SIZE))
        floppy_0.seek(0)
        print(f'Write {SEGMENT_SIZE} random words to FLOPPY_0 as var_1')
        floppy_0.write(var_1)
        print(f'Write {SEGMENT_SIZE} random words to FLOPPY_0 as var_2')
        floppy_0.write(var_2)
    var_1 = int.from_bytes(var_1, byteorder='little', signed=False)
    var_2 = int.from_bytes(var_2, byteorder='little', signed=False)
    py_res = var_1 + var_2

    print("Execute emu8086 floppy_sum.asm and press enter")
    input()
    with open(FLOPPY_0, 'rb') as floppy_0:
        floppy_0.seek(SEGMENT_SIZE * 2)
        print(f'Read {SEGMENT_SIZE*2} words from FLOPPY_0 as var_1+var_2 result')
        emu_res = floppy_0.read()
        if len(emu_res) != 0:
            emu_res = int.from_bytes(emu_res, byteorder='little', signed=False)
        else:
            print("Error!")
            exit(1)

    print(f'python var_1 + var_2:\n{py_res}')
    print(f'emu8086 var_1 + var_2:\n{emu_res}')
    if py_res == emu_res:
        print('py and emu8086 var_1+var_2 results are equal')
    else:
        print('py and emu8086 var_1+var_2 results are not equal')
        exit(2)
