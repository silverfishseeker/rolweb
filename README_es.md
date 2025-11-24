[También tienes este README en inglés Spanish](README.md).

# README (Español)
Esta aplicación puede ejecutarse como un par de contenedores de Docker (modo desarrollo) o como una aplicación normal de Ruby on Rails (modo producción).  

## Modo Desarrollo  

Para ejecutarla en Docker, sigue estos pasos:  

1. Instala Docker (:p).  

3. Ejecuta `docker compose up`  en la carpeta raíz:  

4. Puedes acceder a la web en `localhost:80`. También puedes acceder a la base de datos en el puerto `5555`.  

Existe un sistema de admin dentro de la página web para modificar los datos. Debes de establecer `admin_password` en los credenciales de rails para poder acceder a él.

## Modo Producción de Docker
Puedes ejecutar esta aplicación en modo de producción simplemente usando `docker-compose.production.yml` en vez de `docker-compose.yml`. Puedes usar el comando `docker compose -f docker-compose.production.yml up` para ello. Recuerda añadir `--build` si cambies de un modo a otro para reconstruir la imagen del servidor web correspondientemente.

## Modo Producción de Verdad  
Para ejecutar esta aplicación correctamente en tu entorno personalizado, es necesario configurarla adecuadamente a través de variables de entorno. Debes revisar **VARS** y **PRODUCTION_REQUIRED_VARS** en *app/lib/env_vars*.












