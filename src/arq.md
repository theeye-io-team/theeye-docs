# Configuración y arquitectura del producto

## Puertos utilizados

|       |                     |                                                                                                                                    |
| ----- | ------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| 80    | Http redirect a 443 | Interfaz Web                                                                                                                       |
| 6080  | http                | Interfaz Web (solo localhost)                                                                                                      |
| 60080 | http                | API (parte de los bots están actualmente funcionando con este servicio. No puede ser desactivado hasta que sean migrados al 10443) |
| 443   | https               | Interfaz Web Https / SSL                                                                                                           |
| 10443 | https               | API Https / SSL                                                                                                                    |

## NGINX Application Gateway (no docker)

Este servicio es particular de cada implementación.

Se utiliza como gateway para las solicitudes de acceso a la aplicación principalmente para servir las solicitudes encriptadas mediante certificados SSL emitidos por el banco.

Configuración estándar en /etc/nginx/

## Filesystem

Componentes principales de TheEye.

Cada componente de la aplicación se ejecuta en containers dockers aislados.

Para consultar los componentes actualmente instaladas se utiliza el siguiente comando docker standard:

```bash
docker images
```

Versiones de las imágenes docker actualmente instaladas:

| Repositorio        | Image ID     | Tag              |
| ------------------ | ------------ | ---------------- |
| theeye-api_gateway | f6f77fde1172 | 1.3.1            |
| theeye-supervisor  | c9d1ee7e7520 | 2.3.0-4-gc96ec33 |
| theeye-web         |              | 2.3.0-6-g50eb549 |
| redis              | 84c5f6e03bf0 | 6.0.5            |
| mongodb            | 0a2f1fdf242c | 4.2              |

## Docker compose

Archivo de arranque/detención de la aplicación y configuración. Se utiliza el siguiente comando docker standard.

Arrancar: docker-compose up -d

Detener: docker-compose down

Nota: Las últimas versiones de docker incorporan el comando docker compose. En caso de actualizar la versión se debe reemplazar el guión por un espacio.

|                                        |                                                      |
| -------------------------------------- | ---------------------------------------------------- |
| /opt/theeye/docker-comafi.yml          | Producción                                           |
| /opt/theeye/docker-gateway-compose.yml | Archivo de soporte para iniciar solamente el gateway |
| /opt/theeye/docker-mongodb-compose.yml | Archivo de soporte para inciar solamente mongodb     |

## Archivos de configuración

Para el funcionamiento de cada componente de la aplicación son también necesarios los archivos de configuración para cada contenedor.

/opt/theeye/configs/supervisor.js

/opt/theeye/configs/gateway.js

## Base de Datos.

### MongoDB

La base de datos es MongoDB. Se almacenan los datos de configuración de los bots. Parte de esta información almacenada es crítica para el funcionamiento de los robots y la configuración de las automatizaciones.

### Redis

El componente Redis se utiliza como caché de datos, para envío de mensajes, la conexión de sockets y para almacenamiento de las sesiones de usuario. No contiene información persistente ni crítica.

Directorios montados para los datos generados por los dockers.

|                      |                                   |
| -------------------- | --------------------------------- |
| /srv/docker/mongodb4 | datos interno de la base de datos |
| /srv/docker/redis    | datos de la cache                 |

NOTA: La base de datos MongoDB necesita backup periódico

Directorio Uploads. Almacenamiento de scripts

El directorio uploads es necesario para el almacenamiento y configuración de las instrucciones de los robots. Es crítico para el funcionamiento de los robots.

/opt/theeye/uploads

NOTA: Necesita Backup periódico

* * *

Nombre de las imágenes.
-----------------------

La última imágen Docker de cada componente del producto se encuentra en Docker Hub. Para simplificar la actualización y mantenimiento hay que mantener unificado el nombre de las imágenes locales con las imágenes en Docker Hub.

Luego de descargar/sincronizar las últimas imágenes, los nombres quedarán registradas en el filesystem de la siguiente manera.

$ docker images

…

theeye/theeye-web          latest              a6c270609981        6 days ago          431MB

theeye/theeye-supervisor   latest              9a48a17922f7        7 weeks ago         1.13GB

theeye/theeye-gateway      latest              9d6bb8171a32        7 weeks ago         1.05GB

En caso de ser necesario se debe actualizar el archivo docker-compose.yml para que utilizar los nombres de la imágenes  

* * *

Actualización de producto.

Verificar estado actual de la instalación
-----------------------------------------

### Directorio por defecto de la instalación: /opt/theeye

### Estado de los dockers  
  
\# docker ps -a  
  
CONTAINER ID        IMAGE                       COMMAND                  CREATED             STATUS              PORTS                      NAMES

7f53c98000ef        nginx                       "/docker-entrypoin..."   3 months ago        Up 3 months         0.0.0.0:8080->80/tcp       theeye-audit

b3af28522e48        theeye-supervisor:latest    "docker-entrypoint..."   3 months ago        Up 3 months         0.0.0.0:60080->60080/tcp   theeye-supervisor

3c5509b2b8eb        theeye-api_gateway:latest   "docker-entrypoint..."   3 months ago        Up 3 months         0.0.0.0:6080->6080/tcp     theeye-gateway

54ce38d13546        redis:latest                "docker-entrypoint..."   3 months ago        Up 3 months         6379/tcp                   theeye-redis

61120d3fd655        mongo:4.2                   "docker-entrypoint..."   3 months ago        Up 3 months         27017/tcp                  theeye-mongodb

Archivos y versión del producto
-------------------------------

Se puede verificar la versión de cada componente instalado  independientemente del build. Los cambios que incluye cada versión se encuentran disponibles en el changelog.

[https://github.com/theeye-io-team/theeye-changelog](https://www.google.com/url?q=https://github.com/theeye-io-team/theeye-changelog&sa=D&source=editors&ust=1667238025769737&usg=AOvVaw1OzYBk3N7SUJ1pOEIxKNIw)

En caso de no estar completo, también se encuentra disponible en el log de GitHub de cada repositorio.

Para verificar la versión de cada componente se puede utilizar el comando git describe.

Ejemplo

\# docker exec theeye-supervisor git describe

2.3.0-4-gc96ec33

\# docker exec theeye-gateway git describe

1.3.1

\# cat /opt/theeye/web/index.html  | grep -Po 'data-version="\[0-9-.a-zA-Z\]*"'

data-version="2.3.0-6-g50eb549"

En caso de no estar disponible el history de git dentro de la imagen se debe verificar utilizando las variables de entorno del build con el siguiente comando:

docker image inspect theeye/theeye-supervisor|grep APP_VERSION

Archivos
--------

Verificar archivos existentes y las fechas de modificación

\# ls -lF /opt/theeye

total 76644

drwxr-xr-x  2 root   root       4096 Dec 22 09:59 config/

-rwxr-xr-x  1 root   root        627 Oct 10  2020 dbMigration.sh*

-rw-r--r--  1 root   root       1754 Jan 11 17:01 docker-compose.yml

-rw-r--r--  1 root   root       1472 Oct 13  2020 docker-gateway-compose.yml

-rw-r--r--  1 root   root        245 Oct 10  2020 docker-mongodb-compose.yml

drwxr-xr-x  2 root   root       4096 Apr 27 13:17 images/

drwxr-xr-x  3 root   comafi     4096 Jan 11 18:32 nginx/

-rwxr-xr-x  1 root   root   26683198 Oct  8  2019 ngrok*

drwxrwxr-x  6 comafi comafi     4096 Dec 17 21:58 old-web/

-rw-r--r--  1 root   root   51742720 Oct  9  2020 theeye\_dump\_2020-10-09.tar

drwxr-xr-x 24 root   root      12288 Apr 13 16:24 uploads/

drwxrwxr-x  6 comafi comafi     4096 Dec 22 06:49 web/

### Las imágenes correspondientes a la versión actual del producto (información tomada el 21/04/2021)

\# docker images | grep latest

theeye-api_gateway          latest              f6f77fde1172        4 months ago        1.01GB

nginx                       latest              ae2feff98a0c        4 months ago        133MB

theeye-supervisor           latest              c9d1ee7e7520        5 months ago        1.01GB

redis                       latest              84c5f6e03bf0        7 months ago        104MB

\# ls -l /opt/theeye/images/

total 2061084

-rw-r--r-- 1 root root    6953067 Nov  5 22:03 comafi.tgz

-rw-r--r-- 1 root root 1042173952 Dec 22 22:23 theeye-gateway_1.3.1.tgz

-rw-r--r-- 1 root root 1054455296 Nov  5 22:04 theeye-supervisor_2.3.0-4-gc96ec33-c9d1ee7e7520.tgz

-rw-r--r-- 1 root root    6952672 Dec 17 22:44 web_2.3.0-6-g50eb549.tgz

Imagenes Docker
---------------

Las imágenes docker están en un repositorio Docker Hub

[https://hub.docker.com/u/theeye](https://www.google.com/url?q=https://hub.docker.com/u/theeye&sa=D&source=editors&ust=1667238025775378&usg=AOvVaw1Hlo4zoRXJBjy6fX6qCaCD)

Las imágenes necesarias para la instalación completa de theeye son

Supervisor

[https://hub.docker.com/r/theeye/theeye-supervisor/tags](https://www.google.com/url?q=https://hub.docker.com/r/theeye/theeye-supervisor/tags&sa=D&source=editors&ust=1667238025776271&usg=AOvVaw3brNNI88rhsPVSUIcBAiK5)

Gateway

[https://hub.docker.com/r/theeye/theeye-gateway/tags](https://www.google.com/url?q=https://hub.docker.com/r/theeye/theeye-gateway/tags&sa=D&source=editors&ust=1667238025776771&usg=AOvVaw2ySz1lKpW3cANFfJaMy_nU)

Web

[https://hub.docker.com/r/theeye/theeye-web/tags](https://www.google.com/url?q=https://hub.docker.com/r/theeye/theeye-web/tags&sa=D&source=editors&ust=1667238025777387&usg=AOvVaw3o7FaJvlEmswbSHp2ZH4xe)

Ejemplo de instalación,
-----------------------

se puede consultar el proceso de instalación completo que se realiza utilizando el archivo quickstart.sh del siguiente link

[https://github.com/theeye-io-team/theeye-of-sauron](https://www.google.com/url?q=https://github.com/theeye-io-team/theeye-of-sauron&sa=D&source=editors&ust=1667238025778496&usg=AOvVaw1OZ6oMssoL_rchrFLyDFXr)

Para iniciar TheEye es conveniente utilizar un archivo docker-compose.

Se puede tomar de referencia el archivo docker-compose del quickstart del siguiente link

[https://github.com/theeye-io-team/theeye-of-sauron/blob/master/quickstart.yml](https://www.google.com/url?q=https://github.com/theeye-io-team/theeye-of-sauron/blob/master/quickstart.yml&sa=D&source=editors&ust=1667238025779291&usg=AOvVaw2vMKOKZfmEZ4SW8rla_jJw)

Generación de archivos estáticos de la interfaz Web.
----------------------------------------------------

La imagen docker theeye-web se utiliza para preparar y compilar los archivos estáticos necesarios para mostrar el panel de operador web. Dentro de la imagen se encuentran los archivos listos sin configuración.

Para obtener los archivos estáticos que se encuentran dentro de la imagen hay que correr el siguiente comando:

docker run --rm -dit --name 'theeye-web-export' -v $(pwd)/web:/output 'theeye/theeye-web' sh /app/misc/quickstart/export.sh

Este comando genera un directorio web dentro del directorio actual. El contenido generado es el siguiente

bundles/

config.js

images/

index.html

js/

styles/

Luego de exportar los archivos se debe completar la configuración del archivo config.js.

Se debe colocar la configuración mínima para las url’s

window.config = {

  app_url:,

  socket_url:,

  api_url:/api',

  api\_v3\_url:/api',

  supervisor\_api\_url:,

  grecaptcha: {

    enabled: false

  }

}

Más parámetros de configuración se pueden consultar en el siguiente enlace

Actualización
-------------

Las actualizaciones de TheEye son compatibles con versiones anteriores. Ninguna actualización deja obsoleto un agente o cliente http existente. En caso de ser necesario se indica en el changelog que cambio de configuración es necesario para poder aplicar la actualización. En algunos casos se incorporan claves a los archivos de configuración con un valor por defecto para que luego sea modificado de ser necesario.

La actualización estándar consiste en ejecutar los siguientes comandos.

1.  Descarga las últimas versiones manualmente o utilizando el comando pull  
      
    docker-compose pull  
    
2.  Luego de descargar las imágenes estamos listos para reiniciar el producto. Apagar y prender los dockers se debe hacer lo suficientemente rápido como para que esto no afecte el funcionamiento de los bots que se encuentran reportando  
      
    docker-compose down  
    docker-compose up -d  
    
3.  Verificar que todos los contenedores hayan sido iniciados y se encuentren reportando  
      
    docker ps -a  
    
4.  En caso de que algunos de los contenedores no haya iniciado utilizar el comando docker logs  
      
    docker logs theeye-gateway  
    

* * *
