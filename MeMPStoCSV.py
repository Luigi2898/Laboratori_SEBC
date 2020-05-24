import sys
outF = open("FalcoGay.csv", "w")
for Arg in sys.argv[1: len(sys.argv)]:
    print(Arg)
    inf = Arg.replace(".ps", "")
    inf = inf.replace("SRAM_", "")
    (row, par, mux) = inf.split("-")
    infile = open(Arg, 'r')
    fileL = infile.readlines()
    for l in fileL:
        if not(l.find("(Footprint Width)")):
            splitted = l.split(" ")
            footW = splitted[2]
            footW = footW.replace("(", "")
            footW = footW.replace(")", "")
            footW = float(footW)
        if not (l.find("(Footprint Height)")):
            splitted = l.split(" ")
            footH = splitted[2]
            footH = footH.replace("(", "")
            footH = footH.replace(")", "")
            footH = float(footH)
        if not (l.find("(        AA,AB)")):
            CAdd = fileL[fileL.index(l) + 1]
            CAdd = CAdd.replace("(", "")
            CAdd = CAdd.replace(")", "")
            CAdd = float(CAdd)
        if not (l.find("(        DA,DB)")):
            CDat = fileL[fileL.index(l) + 1]
            CDat = CDat.replace("(", "")
            CDat = CDat.replace(")", "")
            CDat = float(CDat)
        if not (l.find("(Write AC Current (EMAA=0))")):
            WCur = fileL[fileL.index(l) + 1]
            WCur = WCur.replace("(", "")
            WCur = WCur.replace(")", "")
            WCur = abs(float(WCur))
        if not (l.find("(Read AC Current (EMAA=0))")):
            RCur = fileL[fileL.index(l) + 1]
            RCur = RCur.replace("(", "")
            RCur = RCur.replace(")", "")
            RCur = abs(float(RCur))
        if not (l.find("(Deselected Current)")):
            DCur = fileL[fileL.index(l) + 1]
            DCur = DCur.replace("(", "")
            DCur = DCur.replace(")", "")
            DCur = abs(float(DCur))
        if not (l.find("(Standby Current)")):
            SCur = fileL[fileL.index(l) + 1]
            SCur = SCur.replace("(", "")
            SCur = SCur.replace(")", "")
            SCur = abs(float(SCur))
    area = footH * footW;
    outF.write(row + "," + par + "," + mux + "," + str(area) + "," + str(CAdd) + "," + str(CDat) + "," + str(WCur) + "," + str(RCur) + "," + str(DCur) + "," + str(SCur) + "\n")

outF.close()
infile.close()