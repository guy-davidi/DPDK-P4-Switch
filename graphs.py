import matplotlib.pyplot as plt
Transmit_Seconds = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30] 

QoS_EveryPacket = [
    585750,
    1229430,
    1617225,
    2281235,
    2713295,
    3163655,
    3900365,
    4312110,
    4509855,
    5008400,
    10005155,
    15376985
]

total_dropped_EveryPacket = [
    153881,
    313684,
    428587,
    615262,
    749419,
    874132,
    1036382,
    1148654,
    1271146,
    1415587
]

total_sent_EveryPacket = [
    10215,
    21420,
    28309,
    39714,
    47061,
    54764,
    67618,
    74770,
    78038,
    86429
]

num_packets_EveryPacket = [
    164096,
    335104,
    456896,
    654976,
    796480,
    928896,
    1104000,
    1223424,
    1349184,
    1502016
]

# Probability
QoS_Probability = [
    1186060,
    2125760,
    2952795,
    3804375,
    5024300,
    6111645,
    7120645,
    7799645,
    9215020,
    9864905,
    19076285,
    28020855
]



# Inverse Linear

QoS_InverseLinear = [
693575,
1243890,
1626490,
2298145,
2677870,
3179415,
3581945,
4247130,
4783190,
5370575,
10160245,
15277535,
]

QoS_PapersRR = [432495, 844545, 1170950, 1496250, 2050930, 2498145, 2936390, 3481810, 3647100, 3834505, 8034385, 12124845 ]




# Plot avg, max, min, vs ro
plt.plot(Transmit_Seconds, QoS_EveryPacket, label='Default Algorithm')
plt.plot(Transmit_Seconds, QoS_Probability, label='Our Probability Algorithm')
plt.plot(Transmit_Seconds, QoS_InverseLinear, label='Our Inverse Linear Algorithm')
plt.plot(Transmit_Seconds, QoS_PapersRR, label='Paper RR')

# Add labels and title
plt.xlabel('Time of Transmission [s]')
plt.ylabel('Total QoS transmitted')
plt.title('Total QoS transmitted vs. Time of Transmission')
plt.legend()
plt.grid()
# Show the graph
plt.show()



