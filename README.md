# Garnotes - Aplicación web para la administración de notas
## Descripción
Proyecto realizado para la asignatura Administración de Sistemas. Es una aplicación web basada en Flask, que utiliza 3 servicios distintos: una imagen personalizada que funciona como aplicación web, una imagen de LDAP para la autenticación de usuarios y una imagen de CrateDB para el almacenamiento de notas.
## Requisitos
Kubernetes
## Ejecución
- Clonar el repositorio en el equipo: ```$ git clone <URL del repositorio> ```
- Moverse dentro de la carpeta clonada: ```$ cd <nombre del repositorio>```
- Ejecutar la reclamación de los volumenes persistentes para la persistencia de los datos:
  - ```$ kubectl apply -f reclamacion-vp-ldap-datos.yml```
  - ```$ kubectl apply -f reclamacion-vp-ldap-conf.yml```
  - ```$ kubectl apply -f reclamacion-vp-crate.yml```
- Ejecutar los deployments para :
  - ```$ kubectl apply -f deployment-ldap.yml```
  - ```$ kubectl apply -f deployment-crate.yml```
  - ```$ kubectl apply -f deployment-web.yml```
- Ejecutar los cluster ip:
  - ```$ kubectl apply -f clusterip-ldap.yml```
  - ```$ kubectl apply -f clusterip-crate.yml```
- Ejecutar el load balancer:
  - ```$ kubectl apply -f loadbalancer.yml```
## Funcionamiento
La aplicación está desarrollada en el Framework Flask y tiene un Login y un Registro, accesible para cualquier usuario, en el que al iniciar sesión o registrarse, la aplicación se conecta con el servidor LDAP creado e inserta o consulta, en función de lo elegido por el usuario, en el grupo usuarios de garnotes.com, creado al lanzar el servidor.
Una vez ha iniciado sesión el usuario, la aplicación envia al usuario al apartado de notas, donde esta se conectará con CrateDB y seleccionará las notas del usuario en función de un identificador basado en el nombre insertado en el usuario LDAP.
Además de ver las notas listadas en orden de nota más antigua a más reciente, el usuario podrá añadir sus notas, insertando en CrateDB el texto de esta, junto con el identificador del usuario y la fecha de inserción.
Por último, si el usuario decide cerrar sesión se cerrará la variable de sesión de Flask y el usuario tendrá que volver a iniciar sesión para poder acceder al apartado de notas ya que en caso de inentar aun metiendo la url de notas, la aplicación le reenviará al login no mostrando nada de esa parte. 
Cabe destacar, que al lanzar el servidor LDAP, se crea un usuario administrador con nombre de usuario "administrador" y contraseña "admin1234" que podrá ver las notas de todos los usuarios pero no podrá insertar ninguna
