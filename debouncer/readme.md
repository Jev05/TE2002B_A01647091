# MINI RETO DEBOUNCER


Un debouncer en Verilog es un circuito que se utiliza para eliminar los picos de señal que pueden ser causados por el rebote de un pulsador o interruptor. 
Un debouncer ayuda a estabilizar la señal y evitar que los picos de señal negativos interfieran con el funcionamiento del circuito.

Por medio de un contador, se confirma el estado del botón, en este caso. Si el estado del botón actual es diferente del anterior y ha durado así durante cierta cantidad de tiempo (en este caso 20 ms), entonces se determinará que el botón sí se ha presionado y solo así se tomará el dato.
De lo contrario, no se tomará en cuenta.

En este caso, se usan 2 LEDs y 4 displays para mostrar la diferencia entre un botón con debouncer y uno sin.



**SIMULACIÓN QUESTA SIM**

<img width="1897" height="997" alt="image" src="https://github.com/user-attachments/assets/6d77d6b3-abeb-4d02-ab62-8e87b75fff38" />
<img width="1904" height="927" alt="image" src="https://github.com/user-attachments/assets/dcf2c0db-fde3-4524-a68d-9d1a5f9bd12c" />




**RTL VIEWER**

<img width="1529" height="552" alt="image" src="https://github.com/user-attachments/assets/bf8eddc2-3bd0-44d4-b9e2-a0cb4a6fb07e" />


**DEMOSTRACIÓN FÍSICA**

![WhatsApp Image 2026-03-01 at 6 47 19 PM](https://github.com/user-attachments/assets/7e58679c-2c0a-4b5d-9ba7-d2d7c2f94b1e)

