import numpy as np
import matplotlib.pyplot as plt
import math

def funcion(a,n,rnd):
    x = math.log((n/(a-1)), a)
    y = -n/(a-1)
    print(x, y)
    return (a**(rnd+x)+y).astype(int)

# Genera datos x y y para la gráfica
x = np.linspace(0, 1, 100)  # Genera 100 puntos entre -10 y 10
y = funcion(20, 19, x)

# Crea la gráfica
plt.plot(x, y)
plt.xlabel('x')
plt.ylabel('y')
plt.title('Gráfica de la función')
plt.grid(True)
plt.show()