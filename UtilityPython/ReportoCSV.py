import sys

#power_report_TOTAL_UBUSINV8_100_DATA.txt
#power_reportUBUSINV8_100_DATA.txt

def splitBPCT(BusParCapType):
	B = ""
	C = ""
	T = ""
	P = ""
	(B, C, T) = BusParCapType.split("_")
	if "T0" in B:
		P = B.replace("T0", "")
		P = P.replace("MOD", "")
		B = B.replace(P, "")
	else : 
		for cc in B:
			if cc.isdigit():
				P = P + cc
	return (B, P, C, T)

nameOutFileNet = open("outNET.csv", "w")
nameOutFileCell = open("outCELL.csv", "w")

for eachArg in sys.argv[1:len(sys.argv)]:
	if eachArg.find("_TOTAL_") == -1:
		inf = eachArg.replace(".txt", "")
		print(inf)
		outfNet = inf + "_net.csv"
		outfCell = inf + "_cell.csv"
		busParCapType = inf.replace("power_reportUBUS", "")
		inf = inf + ".txt"
		(bus, par, cap, typeAn) = splitBPCT(busParCapType)
		nameOutFileNet.write(outfNet + "," + bus + "," + par + "," + cap + "," + typeAn + "\n")
		nameOutFileCell.write(outfCell + "," + bus + "," + par + "," + cap + "," + typeAn + "\n")
		infile = open(inf, 'r')
		outNet = open(outfNet, "w")
		outCell = open(outfCell, "w")
		ls = infile.readlines()
		net = False
		ok_net = False
		cell = False
		ok_cell = False
		for line in ls:
			lineSplitted = line.split()
			try:
				if lineSplitted[0] == "Net":
					net = True
				if net and lineSplitted[0] == "--------------------------------------------------------------------------------" and ok_net:
					ok_net = False
					net = False
				if net and ok_net:
					outNet.write(lineSplitted[0] + "," + lineSplitted[1] + "," + lineSplitted[2] + "," + lineSplitted[3] + "," + lineSplitted[4] + "\n")
				if net and lineSplitted[0] == "--------------------------------------------------------------------------------":
					ok_net = True
				if lineSplitted[0] == "Cell" and lineSplitted[1] == "Power":
					cell = True
					#outNet.write("Net,TotalNetLoad,StaticProb,ToggleRate\n")
				if cell and lineSplitted[0] == "--------------------------------------------------------------------------------" and ok_cell:
					ok_cell = False
					cell = False
				if cell and ok_cell:
					outCell.write(lineSplitted[0] + "," + lineSplitted[1] + "," + lineSplitted[2] + "," + lineSplitted[3] + "," + lineSplitted[5] + "\n")
				if cell and lineSplitted[0] == "--------------------------------------------------------------------------------":
					ok_cell = True
			except:
				pass
		outCell.close()
		outNet.close()
		infile.close()
	else:
		inf = eachArg.replace(".txt", "")
		print(inf)
		outfTotal = "total_power.csv"
		busCapType = inf.replace("power_report_TOTAL_UBUS", "")
		inf = inf + ".txt"
		(bus, par, cap, typeAn) = splitBPCT(busCapType)
		infile = open(inf, 'r')
		outTotal = open(outfTotal, "a")
		outTotal.write(bus + "," + par + "," + cap + "," + typeAn + ",")
		ls = infile.readlines()
		table = False
		ok_net = False
		cell = False
		ok_cell = False
		for line in ls:
			lineSplitted = line.split()
			try:
				if lineSplitted[0] == "Cell" and lineSplitted[1] == "Internal":
					cell = True
				if cell and lineSplitted[0] == "Internal":
					cell = False
				if cell:
					outTotal.write(lineSplitted[4] + ",")
				if lineSplitted[0] == "Power" and lineSplitted[1] == "Group":
					table = True
				if table and (lineSplitted[0] == "register" or lineSplitted[0] == "combinational"):
					outTotal.write(lineSplitted[1] + "," + lineSplitted[2] + "," + lineSplitted[3] + "," + lineSplitted[4] + ",")
				if table and lineSplitted[0] == "Total":
					outTotal.write(lineSplitted[1] + "," + lineSplitted[3] + "," + lineSplitted[5] + "," + lineSplitted[7] + "\n")
					table = False
			except:
				pass
		outTotal.close()
		infile.close()
