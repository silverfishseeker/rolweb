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
No tengo ni idea de por qué alguien querría poner esto en producción. Pero no se necesitan pasos especiales para ello. Tan sólo asegúrate de seguir los pasos del proveedor de hosting que estés utilizando y no olvides configurar la conexión a la base de datos en `config/database.yml` y la configuración de Minio en las credenciales de Rails.







