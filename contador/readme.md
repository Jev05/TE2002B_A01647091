# PRÁCTICA CONTADOR


El módulo implementa un contador bidireccional con rango de 0 a 100, controlado por una señal de dirección (updown). Cuando updown es alto, el contador opera de forma ascendente; cuando es bajo, opera de forma descendente.
Se puede definir un valor inicial mediante 8 switches, el cual se carga al presionar un botón load. A partir de ese valor, el contador avanza hacia el límite correspondiente: si es ascendente, cuenta hasta 100; si es descendente, cuenta hasta 0. Al alcanzar el límite, el contador continúa ciclando automáticamente en la misma dirección, repitiendo el proceso indefinidamente hasta que se cargue un nuevo valor.
Se regula la frecuencia por medio del módulo clk_div (clock divider) y se muestra el conteo por medio de los displays.

**SIMULACIÓN EN QUESTA SIM**
<img width="1919" height="1077" alt="Captura de pantalla 2026-02-20 090611" src="https://github.com/user-attachments/assets/086e1c59-3dfb-4d48-84e6-c65312e326f9" />




**RTL VIEWER**
<img width="1918" height="1079" alt="Captura de pantalla 2026-02-20 090633" src="https://github.com/user-attachments/assets/b7acd1f1-3a9d-4852-ac78-a147d1fa2803" />




**DEMOSTRACIÓN FÍSICA**

