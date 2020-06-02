import sys

outfile = open(sys.argv[1], "w")
for arg in sys.argv[2:]:
    print(arg)
    infile = open(arg, 'r')
    ls = infile.readlines()
    arg = arg.replace("power_", "")
    tag = arg.replace(".txt", "")
    for l in ls:
        if "Cell Internal Power" in l:
            sped = l.split()
            CIP = sped[4]
        #print(CIP)
        if "Net Switching Power" in l:
            sped = l.split()
            NSP = sped[4]
        #print(NSP)
        if "Total Dynamic Power" in l:
            sped = l.split()
            TDP = sped[4]
        #print(TDP)
        if "Cell Leakage Power" in l:
            sped = l.split()
            CLP = sped[4]
        #print(CLP)
        if "clock_network" in l:
            sped = l.split()
            CNIP = sped[1]
            CNSP = sped[2]
            CNLP = sped[3]
            CNTP = sped[4]
            #print(CNIP)
            #print(CNSP)
            #print(CNLP)
            #print(CNTP)
        if "register" in l:
            sped = l.split()
            REGIP = sped[1]
            REGSP = sped[2]
            REGLP = sped[3]
            REGTP = sped[4]
            #print(REGIP)
            #print(REGSP)
            #print(REGLP)
            #print(REGTP)
        if "combinational" in l:
            sped = l.split()
            COIP = sped[1]
            COSP = sped[2]
            COLP = sped[3]
            COTP = sped[4]
            #print(COIP)
            #print(COSP)
            #print(COLP)
            #print(COTP)
    outfile.write(tag + "," + CIP + "," + NSP + "," + TDP + "," + CLP + "," + CNIP + "," + CNSP + "," + CNLP + "," + CNTP + "," + REGIP + "," + REGSP + "," + REGLP + "," + REGTP + "," + COIP + "," + COSP + "," + COLP + "," + COTP + "," + str(float(CNIP) + float(REGIP) + float(COIP)) + "," + str(float(CNSP) + float(REGSP) + float(COSP)) + "," + str(float(CNLP) + float(REGLP) + float(COLP)) + "," + str(float(CNTP) + float(REGTP) + float(COTP)) + "\n")

