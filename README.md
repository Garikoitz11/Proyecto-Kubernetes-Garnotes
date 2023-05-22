# Garnotes - Aplicación web para la administración de notas
## Descripción
Proyecto realizado para la asignatura Administración de Sistemas. Es una aplicación web basada en Flask, que utiliza 3 servicios distintos: una imagen personalizada que funciona como aplicación web, una imagen de LDAP para la autenticación de usuarios y una imagen de CrateDB para el almacenamiento de notas.
## Requisitos
- 1 Clúster de Kubernetes
- Kubectl
## Ejecución
- Clonar el repositorio en el equipo: ```$ git clone <URL del repositorio> ```
- Moverse dentro de la carpeta clonada: ```$ cd <nombre del repositorio>```
- Ejecutar la Reclamación de los Volúmenes Persistentes para la persistencia de los datos:
  - ```$ kubectl apply -f reclamacion-vp-ldap-datos.yml```
  - ```$ kubectl apply -f reclamacion-vp-ldap-conf.yml```
  - ```$ kubectl apply -f reclamacion-vp-crate.yml```
- Ejecutar los Deployments para ejecutar distintos contenedores:
  - ```$ kubectl apply -f deployment-ldap.yml```
  - ```$ kubectl apply -f deployment-crate.yml```
  - ```$ kubectl apply -f deployment-web.yml```
- Ejecutar los ClusterIPs para conectar diferentes objetos a nivel de clúster:
  - ```$ kubectl apply -f clusterip-ldap.yml```
  - ```$ kubectl apply -f clusterip-crate.yml```
- Ejecutar el LoadBalancer para exponer el puerto de la aplicación web al exterior del clúster:
  - ```$ kubectl apply -f loadbalancer.yml```
## Funcionamiento
La aplicación está desarrollada en el Framework Flask y tiene un Login y un Registro accesible para cualquier usuario, en el que al iniciar sesión o registrarse la aplicación se conecta con el servidor LDAP creado e inserta o consulta, en función de lo elegido por el usuario, en la unidad organizativa "usuarios" (ou=usuarios) de "garnotes.com" (dc=garnotes, dc=com).

Una vez ha iniciado sesión el usuario, la aplicación guarda el nombre de usuario en una variable de sesión de Flask y envía a este al apartado de notas, donde esta se conecta con CrateDB y selecciona las notas del usuario en función de un identificador basado en el nombre de usuario LDAP. En caso de no coincidir el nombre de usuario y contraseña con un usuario existente aparece un mensaje de error.

Además de ver las notas listadas en orden de nota más antigua a más reciente, el usuario puede añadir sus notas, insertando en CrateDB el texto de esta, junto con el identificador del usuario y la fecha de inserción.

Por último, si el usuario decide cerrar sesión se borra la variable de sesión de Flask y el usuario tendrá que volver a iniciar sesión para poder acceder al apartado de notas, ya que en caso de intentar acceder a notas, la aplicación le reenvía al login.

Cabe destacar, que al lanzar el servidor LDAP, se crea un usuario administrador con nombre de usuario "administrador" y contraseña "admin1234" que puede ver las notas de todos los usuarios, pero no puede insertar ninguna. Este usuario también se encuentra en la unidad organizativa "usuarios" (ou=usuarios) de LDAP.
