## Descripción del Script

Este script en Bash permite gestionar la dirección MAC de la interfaz WiFi de tu sistema Linux. Ofrece las siguientes funcionalidades:

- **Guardar la MAC original**: Almacena la dirección MAC actual en un archivo para poder restaurarla más tarde.
- **Cambiar la MAC por una aleatoria**: Genera y asigna una nueva dirección MAC aleatoria a la interfaz WiFi.
- **Restaurar la MAC original**: Vuelve a asignar la dirección MAC original guardada previamente.
- **Borrar la MAC guardada**: Elimina el archivo que contiene la MAC original guardada.
- **Salir**: Finaliza la ejecución del script.

El script se ejecuta en un bucle, mostrando un menú interactivo después de cada acción, y actualiza dinámicamente la información sobre la MAC actual y si hay una MAC original guardada. Además, incluye un banner estilizado y utiliza colores ANSI para mejorar la legibilidad en la terminal.

### Requisitos

- **Permisos de root**: El script debe ejecutarse con privilegios de superusuario (`sudo`) debido a que modifica la configuración de la interfaz de red.
- **Interfaz WiFi**: Detecta automáticamente la interfaz WiFi activa (como `wlan0` o `wlo1`).

### Uso

1. Clona el repositorio o descarga el script.
2. Otorga permisos de ejecución: `chmod +x mac_changer.sh`.
3. Ejecuta el script como root: `sudo ./mac_changer.sh`.
4. Sigue las instrucciones en pantalla para seleccionar la acción deseada.
