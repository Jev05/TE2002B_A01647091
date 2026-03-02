# PRÁCTICA CONTROL DE SERVO MOTOR PWM



Se controla un servo motor por medio de pulsos que generan la salida PWM. Es necesario considerar los siguientes cálculos de frecuencia, considerando que el servo tiene una frecuencia de 50 Hz.
El reloj de la FPGA opera a 50 MHz, sin embargo, se utiliza un divisor de frecuencia (clk_div) para reducirlo a 5 MHz, lo que equivale a un período de 200 ns por ciclo. Dado que el servo requiere una señal PWM de 50 Hz, el período total de la señal es de 20 ms, lo que representa 100,000 ciclos del reloj dividido.
El ángulo del servo se determina por el ancho del pulso activo (duty cycle), el cual varía entre 1 ms y 2 ms, correspondiendo a los extremos de 0° y 180° respectivamente. A 5 MHz, esto equivale a 5,000 ciclos de reloj para 0° y 10,000 ciclos para 180°. 
Se puede seleccionar el ángulo deseado mediante switches, los cuales definen el ancho del pulso dentro de ese rango una ve que sehan mapeado.




**SIMULACIÓN QUESTA SIM**

**RTL VIEWER**

<img width="1545" height="535" alt="image" src="https://github.com/user-attachments/assets/73b9f858-6a11-478d-9e96-a10acf65e73b" />

<img width="1556" height="876" alt="image" src="https://github.com/user-attachments/assets/cc4a9463-ecbf-4a9a-9022-b7d424db5a40" />



**DEMOSTRACIÓN FÍSICA**

Video adjunto en el proyecto
