import sys
import serial
from PIL import Image, ImageDraw

inphexFilename = "../data/input.hex"
port = sys.argv[1]


ser = serial.Serial(
    port=port,
    baudrate=9600,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_ONE,
    bytesize=serial.EIGHTBITS,
    timeout=1
)
if(not ser.isOpen()):
    print("Error while open serial port")
    exit(-1)


ifhex = open(inphexFilename)
n = int(ifhex.readline())

print("Writing:")
i = 0
inpshape = []
for line in ifhex:
    inpt = bytes.fromhex(line)
    inpshape.append(inpt)
    print(i, inpt, sep=' ') 
    i += 1
    ser.write(inpt)

print("Reading:")
N = n*n

resshape = []
i = 0
while i < N:
    a = ser.read(1)
    print(i, a.hex(), sep=' ')
    resshape.append(a.hex())
    i += 1


H = n * 100
W = 2 * n * 100 + 100
image = Image.new("RGB", (W,H), (255,255,255))
draw = ImageDraw.Draw(image)

x = 0
y = 0
j = 0
for i in range(N-1 , -1, -1):
    x0 = j % n * 100
    y0 = j // n * 100
    x1 = j % n * 100 + 100
    y1 = j // n * 100 + 100

    x2 = x0 + H + 100
    x3 = x1 + H + 100

    if(inpshape[j] == b'\x01'):
        draw.rectangle([x0, y0, x1, y1], fill="blue", outline=None)
    elif(inpshape[j] == b'\xff'):
        draw.rectangle([x0, y0, x1, y1], fill="white", outline=None)
    else:
        draw.rectangle([x0, y0, x1, y1], fill="red", outline=None)
        
    if(resshape[i] == '01'):
        draw.rectangle([x2, y0, x3, y1], fill="blue", outline=None)
    elif(resshape[i] == 'ff'):
        draw.rectangle([x2, y0, x3, y1], fill="white", outline=None)
    else:
        draw.rectangle([x2, y0, x3, y1], fill="red", outline=None)
    j += 1
del draw
image.show()