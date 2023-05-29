
# Actualización de producto.

## Verificar estado actual de la instalación

### Pasos previos de verificación

* Versiones actualmente instaladas

* Versiones disponible. En especial changelog por cambios de configuración o breaking changes.

* Ultimo backup

* Imagenes docker necesarias descargadas

### Versionado

Los cambios que incluye cada versión se encuentran disponibles en el changelog.

[https://github.com/theeye-io-team/theeye-changelog](https://github.com/theeye-io-team/theeye-changelog)

En caso de no estar completo, también se encuentra disponible en el log de GitHub de cada repositorio.

Para verificar la versión de cada componente instalado independientemente del build se puede utilizar el comando git describe.


```
$ docker exec theeye-supervisor git describe

2.3.0-4-gc96ec33

$ docker exec theeye-gateway git describe

1.3.1

$ cat /opt/theeye/web/index.html  | grep -Po 'data-version="\[0-9-.a-zA-Z\]*"'

data-version="2.3.0-6-g50eb549"

```

En caso de que las imágenes no tengan disponible el history de git o los comandos se debe verificar utilizando las variables de entorno del build con el siguiente comando:

```
docker image inspect theeye/theeye-supervisor|grep APP_VERSION
```

### Imágenes Docker

La última imágen Docker de cada componente del producto se encuentra en Docker Hub.
Para simplificar la actualización y el mantenimiento hay que mantener unificado el nombre de las imágenes locales con las imágenes en Docker Hub.

Luego de descargar/sincronizar las últimas imágenes, los nombres quedarán registradas en el filesystem de la siguiente manera.


```

$ docker images

theeye/theeye-web          latest              a6c270609981        6 days ago          431MB

theeye/theeye-supervisor   latest              9a48a17922f7        7 weeks ago         1.13GB

theeye/theeye-gateway      latest              9d6bb8171a32        7 weeks ago         1.05GB

```

En caso de ser necesario se debe actualizar el archivo docker-compose.yml para que utilizar los nombres de las imágenes oficiales.

* * *

### Estado de los dockers

```
  
$ docker ps -a  
  
CONTAINER ID        IMAGE                       COMMAND                  CREATED             STATUS              PORTS                      NAMES

7f53c98000ef        nginx                       "/docker-entrypoin..."   3 months ago        Up 3 months         0.0.0.0:8080->80/tcp       theeye-audit

b3af28522e48        theeye/theeye-supervisor:latest    "docker-entrypoint..."   3 months ago        Up 3 months         0.0.0.0:60080->60080/tcp   theeye-supervisor

3c5509b2b8eb        theeye/theeye-gateway:latest   "docker-entrypoint..."   3 months ago        Up 3 months         0.0.0.0:6080->6080/tcp     theeye-gateway

54ce38d13546        redis:latest                "docker-entrypoint..."   3 months ago        Up 3 months         6379/tcp                   theeye-redis

61120d3fd655        mongo:4.2                   "docker-entrypoint..."   3 months ago        Up 3 months         27017/tcp                  theeye-mongodb

```


### Ejemplo de instalación


se puede consultar el proceso de instalación completo que se realiza utilizando el archivo quickstart.sh del siguiente link

[https://github.com/theeye-io-team/theeye-of-sauron](https://github.com/theeye-io-team/theeye-of-sauron)

Para iniciar TheEye es conveniente utilizar un archivo docker-compose.

Se puede tomar de referencia el archivo docker-compose del quickstart del siguiente link

[https://github.com/theeye-io-team/theeye-of-sauron/blob/master/quickstart.yml](https://github.com/theeye-io-team/theeye-of-sauron/blob/master/quickstart.yml)



### Generación de archivos estáticos de la interfaz Web.


La imagen docker theeye-web se utiliza para preparar y compilar los archivos estáticos necesarios para mostrar el panel de operador web.
Dentro de la imagen se encuentran los archivos listos sin configuración.

Para obtener los archivos estáticos que se encuentran dentro de la imagen hay que correr el siguiente comando:

```

docker run --rm -dit --name 'theeye-web-export' -v $(pwd)/web:/output 'theeye/theeye-web:VERSION' sh /app/misc/quickstart/export.sh

```

Si no se elige VERSION docker asume latest

Este comando genera un directorio web dentro del directorio actual. El contenido generado es el siguiente

```

bundles/
config.js
images/
index.html
js/
styles/

```

Luego de exportar los archivos se debe completar la configuración del archivo config.js.

Se debe colocar la configuración mínima para las url’s

``` 
// basic configuration
window.config = {
  app_url: "",
  socket_url: "",
  api_url: "/api"',
  api_v3_url: "/api"',
  supervisor_api_url: "",
  grecaptcha: {
    enabled: false
  }
}
```

Más parámetros de configuración se pueden consultar el enlace de [Configuration Web](https://documentation.theeye.io/theeye-web/#/)

### Actualización

Las actualizaciones de TheEye son compatibles con versiones anteriores. Ninguna actualización deja obsoleto un agente o cliente http existente. En caso de ser necesario se indica en el changelog que cambio de configuración es necesario para poder aplicar la actualización. En algunos casos se incorporan claves a los archivos de configuración con un valor por defecto para que luego sea modificado de ser necesario.

La actualización estándar consiste en ejecutar los siguientes comandos.

1.  Descarga las últimas versiones manualmente o utilizando el comando pull  
      
```
    docker-compose pull  
```
    
2.  Luego de descargar las imágenes estamos listos para reiniciar el producto. Apagar y prender los dockers se debe hacer lo suficientemente rápido como para que esto no afecte el funcionamiento de los bots que se encuentran reportando  
      
```
    docker-compose down  
    docker-compose up -d  
```
    
3.  Verificar que todos los contenedores hayan sido iniciados y se encuentren reportando  
      
```
    docker ps -a  
```
    
4.  En caso de que algunos de los contenedores no haya iniciado utilizar el comando docker logs  
      
```
    docker logs theeye-gateway  
```
    

* * *

### Rollback

En caso de que la actualización falle y sea necesario restablecer la versión anterior a la actualización solo se deben sustituir las imagenes docker.

Para la Web es necesario solamente sustituir el directorio web por la versión anterior

* * *

## Verificación de funcionamiento del ambiente

### Docker ps

se puede consultar el estado de los contenedores.
**Nota**: docker ps corre como root


![](./images/status_1.png)

En la imagen vemos que esta todo iniciado y funcionando.

### Docker logs.

Permite detectar si hubiera algún error en los principales contenedor que son el supervisor y el gateway.


![](./images/status_2.png)

![](./images/status_3.png)

no se observan errores.

### Endpoints de status

Se puede conocer el estado de las apis utilizando los endpoints de status.

#### En el puerto 6080 local esta la interfaz web, sin pasar por proxy o balanceador de carga.

Responde con el HTML de la pagina principal

[http://127.0.0.1:60080/](http://127.0.0.1:60080/)



![](./images/status_4.png)


#### En el puerto 60080 esta la api de los bots

[http://127.0.0.1:60080/api/status](http://127.0.0.1:60080/api/status)


![](./images/status_5.png)



#### En el puerto 6080 esta el gateway de autenticación.


[http://127.0.0.1:6080/api/status](http://127.0.0.1:6080/api/status)



![](./images/status_6.png)



como se ve en las imagenes esta todo funcionando correctamente.

### login vía api.

Para el login local se debe consultar la base de datos y el servicio de cache para generar una sesion.
De esta forma nos aseguramos que el funcionamiento de ambas bases de dato es correcto


```
    curl -X POST http://user:password@localhost:6080/api/auth/login
```

la respuesta es la siguiente

```

    HTTP/1.1 200 OK
    X-Powered-By: Express
    Access-Control-Allow-Origin: *
    Access-Control-Allow-Methods: GET,PUT,PATCH,POST,DELETE,OPTIONS
    Access-Control-Allow-Credentials: true
    Access-Control-Allow-Headers: Origin, Accept, User-Agent, Accept-Charset, Cache-Control, Accept-Encoding, Content-Type, Authorization, Content-Length, X-Requested-With
    Content-Type: application/json; charset=utf-8
    Content-Length: 216
    ETag: W/"d8-ZKLqL7tneYNOie2+ercs1RZug20"
    Vary: Accept-Encoding
    Date: Mon, 29 May 2023 15:49:18 GMT
    Connection: keep-alive
    Keep-Alive: timeout=5

    {"access_token":"YYYYY","credential":"XXXXX"}

```

al devolver un access token se puede asegurar que esta funcionando OK .


Con el endpoint de profile podemos confirmar que la sesión generada es válida y nos permite acceder a todos los servicios

```

curl -X GET 'http://127.0.0.1:6080/api/session/profile?access_token=YYYYY'

```

dara una respuesta como la siguiente

```

{
  "id": "111111111111111111111111",
  "customers": [
    {
      "name": "AppTesting",
      "id": "222222222222222222222222"
    },
    {
      "name": "Administracion",
      "id": "333333333333333333333333"
    },
  ],
  "name": "I am ThEye",
  "username": "facugoncio",
  "email": "facugon@theeye.io",
  "onboardingCompleted": true,
  "current_customer": {
    "id": "222222222222222222222222",
    "name": "AppTesting",
    "display_name": "Apps"
  },
  "notifications": {
    "mute": false,
    "push": true,
    "email": true,
    "desktop": true,
    "notificationFilters": [
      {
        "topic": "job-crud"
      }
    ]
  },
  "credential": "owner",
  "protocol": "local",
  "member_id": "444444444444444444444444"
}

```
