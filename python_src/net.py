import math
from PIL import Image, ImageDraw
import sys


inputFilename = sys.argv[1]
coefFilename = "../data/weights.hex"
inphexFilename = "../data/input.hex"
inptestFilename = "../data/testbench_input.hex"
shapesArr = []
testShape = ""
neuronNum = -1
J = []
net = []
key = {"1": 1, "0" : -1}
res = []


def Sign(num):
    if num < 0:
        return -1
    elif num >= 0:
        return 1


class Neuron:
    def __init__(self, W):
        self.S = 0
        self.W = W

    def Compute(self, Sn):
        sum = 0
        for i in range(len(Sn)):
            sum += Sn[i] * self.W[i]
        self.S = Sign(sum)
        # print("S: ", Sn, "W: ", self.W, "Sum: ", sum)
        return self.S


def ReadData():
    global inputFilename
    global shapesArr
    global testShape
    global neuronNum
    global J

    f = open(inputFilename)
    ifhex = open(inphexFilename,"w")
    itfhex = open(inptestFilename, "w")
    
    linenum = 0
    state = 0
    counter = 0
    lnumber = -1
    shape = ""
    for line in f:
        linenum += 1
        if state == 0:
            if line[:-1] == "number":
                state = 1
                continue
            elif line[:-1] == "memory":
                state = 2
                continue
            elif line[:-1] == "test":
                state = 3
                continue
            else:
                print("Error reading input file:", linenum)
                exit(-1)

        elif state == 1:
            if(lnumber < 0):
                lnumber = int(line)
                ifhex.write(str(lnumber)+'\n')
                state = 0
            else:
                print("Error reading input file (number):", linenum)
                exit(-1)
        elif state == 2:
            if(lnumber < 0):
                print("Error reading input file (memory):", linenum)
                exit(-1)
            shape = shape + line[:lnumber]
            counter += 1
            if counter == lnumber:
                counter = 0
                shapesArr.append(shape)
                shape = ""
                state = 0
        elif state == 3:
            if(lnumber < 0 or testShape != ""):
                print("Error reading input file (test):", linenum)
                exit(-1)
            for ch in line[:lnumber]:
                if(ch == '1'):
                    ifhex.write('01\n')
                    itfhex.write('0001')
                elif(ch == '0'):
                    ifhex.write('ff\n')
                    itfhex.write('ffff')

            shape = shape + line[:lnumber]
            counter += 1
            if counter == lnumber:
                testShape = shape
                shape = ""
                counter = 0
                state = 0

        else:
            continue
    neuronNum = lnumber * lnumber
    J = [[0 for j in range(neuronNum)] for i in range(neuronNum)]
    f.close()
    ifhex.close()



def ComputeWeights():
    global J
    global neuronNum
    global net

    for shape in shapesArr:
        for i in range(0, neuronNum):
            for j in range(0, neuronNum):
                if (i == j):
                    J[i][j] = 0
                else:
                    J[i][j] += key[shape[i]] * key[shape[j]]


    f = open(coefFilename, 'w')
    # print(J)
    for i in range(len(J)-1,-1,-1):
        for j in range(len(J[i])):
            f.write(J[i][j].to_bytes(2,'big', signed=True).hex().upper())
    f.close()

    for i in range(neuronNum):
        tmpNeu = Neuron(J[i])
        net.append(tmpNeu)


def ComputeOutput():
    global res
    getValue = lambda x : key[x] 
    res = list(map(getValue,testShape))
    oldres = []
    c = 0
    while oldres != res and c < 1000:
        c+=1
        # print("count", c)
        oldres = res
        res = []
        for neu in net:
            res.append(neu.Compute(oldres))

def ShowRes():
    global neuronNum
    global testShape

    L = int(neuronNum ** 0.5)
    H = L * 100
    W = 2 * H + 100
    image = Image.new("RGB", (W,H), (255,255,255))
    draw = ImageDraw.Draw(image)

    x = 0
    y = 0
    for i in range(neuronNum):
        x0 = i % L * 100
        y0 = i // L * 100
        x1 = i % L * 100 + 100
        y1 = i // L * 100 + 100

        x2 = x0 + H + 100
        x3 = x1 + H + 100

        if(testShape[i] == '0'):
            draw.rectangle([x0, y0, x1, y1], fill="white", outline=None)
        elif(testShape[i] == '1'):
            draw.rectangle([x0, y0, x1, y1], fill="black", outline=None)
        
        if(res[i] < 0):
            draw.rectangle([x2, y0, x3, y1], fill="white", outline=None)
        elif(res[i] >= 0):
            draw.rectangle([x2, y0, x3, y1], fill="black", outline=None)
        else:
            draw.rectangle([x2, y0, x3, y1], fill="red", outline=None)
    del draw
    image.show()

def Main():
    ReadData()
    ComputeWeights()
    ComputeOutput()
    ShowRes()




if __name__ == "__main__":
    Main()