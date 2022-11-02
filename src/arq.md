# Configuración y Arquitectura Docker

## Puertos utilizados

 | Componente | Port  | Proto    |
 | ------     | ----- | -------- |
 | Gateway    | 6080  | http     |
 | Supervisor | 60080 | http     |

## Componentes de la instalación 

Componentes principales de TheEye.

Cada componente de la aplicación se ejecuta en contenedores dockers aislados.

Una instalación estándar de TheEye incluye los siguientes componentes.

   | Repositorio              | URL DockerHub                                     | URL GitHub                                          | 
   | ------------------       | -----                                             | -----                                               | 
   | theeye/theeye-gateway    | https://hub.docker.com/r/theeye/theeye-gateway    | https://github.com/theeye-io-team/theeye-gateway    | 
   | theeye/theeye-supervisor | https://hub.docker.com/r/theeye/theeye-supervisor | https://github.com/theeye-io-team/theeye-supervisor | 
   | theeye/theeye-web        | https://hub.docker.com/r/theeye/theeye-web        | https://github.com/theeye-io-team/theeye-web        | 
   | theeye/theeye-agent      | https://hub.docker.com/r/theeye/theeye-agent      | https://github.com/theeye-io-team/theeye-agent      | 
   | redis (imagen oficial)   | https://hub.docker.com/_/redis                    | N/A                                                 | 
   | mongodb (imagen oficial) | https://hub.docker.com/_/mongo                    | N/A                                                 | 

## Docker compose

Para el manejo de los servicios, el arranque/detención de la aplicación y configuración se utiliza un archivo docker-compose.yml.

* _Arrancar_: docker-compose up -d

* _Detener_: docker-compose down

*Nota*: Las últimas versiones de docker incorporan el comando docker compose. En caso de tener una versión reciente se debe reemplazar el guión por un espacio.

## Archivos de configuración

Para el funcionamiento de cada componente de la aplicación son también necesarios los archivos de configuración de cada contenedor.
Tomando como ejemplo la instalación estándar realizada con el [quickstart.sh](https://documentation.theeye.io/#/?id=install-all-theeye-components-on-a-single-machine) se pueden identificar los siguientes archivos de configuración

  | Componente        | Configuracion         | Documentacion            | 
  | -----             | -----                 | -----                    | 
  | theeye-supervisor | configs/supervisor.js | https://documentation.theeye.io/theeye-supervisor/#/setup | 
  | theeye-gateway    | configs/gateway.js    | https://documentation.theeye.io/theeye-gateway/#/setup    | 
  | theeye-agent      | agent/config.js       | https://documentation.theeye.io/theeye-agent/#/setup      | 
  | theeye-web        | web/config.js         | https://documentation.theeye.io/theeye-web/#/setup        | 

## Base de Datos.

### MongoDB

La base de datos principal es MongoDB. Se almacena la información de usuarios, organizaciones, configuración de bots, relaciones entre scripts tareas y monitores, entre otros usos.
Parte de esta información almacenada es crítica para el funcionamiento de los workflows y automatizaciones.

### Redis

Se utiliza como caché, almacenamiento de sesiones, envío de mensajes y manejo de jobs. No contiene información persistente ni crítica.

Habitualmente se utilizan directorios montados para los datos generados por los dockers.
El punto de montaje esta declaro dentro de los volumenes de cada contenedor docker

### Punto de montaje

| container | montaje            |                                   |
| ------- | -------------------- | --------------------------------- |
| mongodb | /srv/docker/mongodb4 , /opt/theeye/data | datos persistentes generados por la aplicación |
| redis | /srv/docker/redis, /opt/theeye/data     | datos de la cache                 |


## Almacenamiento de scripts

Los scripts y archivos de configuración de monitores y tareas se almacen en el directorio *uploads*.
Es crítico para el funcionamiento de los workflows.

/opt/theeye/uploads


* * *


NOTA: En las instalaciones onpremise y locales es importante hacer backup periódico de la base de datos y los archivos.


* * *

