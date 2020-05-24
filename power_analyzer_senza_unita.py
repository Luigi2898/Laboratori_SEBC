from utility import *
import math

inf = input("Inserire il nome del file di input (assicurarsi di essere nella stessa cartella): ")
f = input("Inserire il nome del file di output (senza estensione): ")
clk = float(input("inserire il periodo di clock in s (xe-y): "))
unit = input("Inserire l'unità di musura del tempo nel report (di solito ps): ")

infile = open(inf, 'r')
ftxt = f + ".txt"
file = open(ftxt, 'w')
fcsv = f + ".csv"
filecsv = open(fcsv, 'w')


ls = infile.readlines()
#timeInfo = ls[2].split()
simulationTime = TimeConv(float(ls[2]),unit)
n_clk = math.ceil(simulationTime/clk)
size = len(ls)

file.write("File di input: {:s}".format(inf) + "\n\n")
file.write("Tempo di simulazione: {:e}".format(simulationTime) + "s"  + "\n\n")
file.write("Numero di cicli di clock: {:d}".format(int(n_clk)) + "\n\n")
file.write("Periodo di clock: {:e}".format(clk) + "s"  + "\n\n")
file.write("{:41s}".format("Node") + "{:15s}".format("1 probability") + "{:15s}".format("0 probability") + "{:15s}".format("Sw. activity")  + "\n\n")

print("\n")
print("File di input: {:s}".format(inf))
print("Tempo di simulazione: {:e}".format(simulationTime) + "s")
print("Numero di cicli di clock: {:d}".format(int(n_clk)))
print("Periodo di clock: {:e}".format(clk) + "s")
print("{:41s}".format("Node") + "{:15s}".format("1 probability") + "{:15s}".format("0 probability") + "{:15s}".format("Sw. activity"))

filecsv.write("node;P1;P0;Esw\n")

for l in ls[6:size-2]:
    row = l.split()
    prob1 = TimeConv(float(row[3]), unit)/simulationTime
    prob0 = TimeConv(float(row[4]), unit)/simulationTime
    Esw = float(row[1])/n_clk
    print("{:41s}".format(row[0]) + "  " + "{:05.9f}".format(prob1) + "    " + "{:05.9f}".format(prob0) + "   " + "{:05.9f}".format(Esw))
    file.write("{:41s}".format(row[0]) + "  " + "{:05.9f}".format(prob1) + "    " + "{:05.9f}".format(prob0) + "   " + "{:05.9f}".format(Esw)  + "\n")
    filecsv.write(row[0] + ";" + str(prob1) + ";" + str(prob0) + ";" + str(Esw)  + "\n")

file.close()
infile.close()
filecsv.close()
