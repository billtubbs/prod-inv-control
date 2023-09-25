import numpy as np
import matplotlib.pyplot as plt

def calc_eoq(demand, order_cost, holding_cost):
    """Calculates the economic order quantity (EOQ)
    """
    return np.sqrt(2 * demand * order_cost / holding_cost)

demand = np.linspace(500, 1500, 31)
order_cost = 2
holding_cost = 5

# Calculate the economic order quantity
eoq = calc_eoq(demand, order_cost, holding_cost)

plt.plot(demand, eoq)
plt.plot(demand[15], eoq[15], 'o')
plt.xlabel('demand')
plt.ylabel('EOQ')
plt.title('Economic order quantity (EOQ)')
plt.grid()
plt.savefig('eoq_example_plot.pdf')
plt.show()