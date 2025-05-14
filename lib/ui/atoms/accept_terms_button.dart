import 'package:flutter/material.dart';
import 'package:medired/core/router/router.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class AcceptTermsButton extends StatelessWidget {
  const AcceptTermsButton({
    required this.isAccepted,
    this.onChanged,
    super.key,
  });

  final bool isAccepted;
  final void Function(bool? value)? onChanged;

  void _showTermsAndConditions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Términos y Condiciones'),
          content: const SizedBox(
            height: 300.0, // Ajusta la altura de la ventana emergente
            child: SingleChildScrollView(
              child: Text(
                '''
Terminos y Condiciones
Esta página establece los Términos (en adelante “Términos”) que regulan el uso de los contenidos
informativos y servicios y procesos transaccionales ofrecidos disponibles en el Sitio Web de MediRed
(en adelante, el “Sitio Web”) accesible desde el nombre de dominio https://medired.do
Este documento contiene los términos, condiciones, y obligaciones de conformidad con las cuales,
Usted puede acceder y utilizar este Sitio Web y sus contenidos y servicios y procesos transaccionales
disponibles en el mismo.
Los términos “Usted”, “Ud”, “Visitante” y “Usuario” se emplean aquí para referirse a todos las
personas físicas y/o jurídicas que por cualquier razón accedan al Sitio.
Tanto el acceso como la utilización del Sitio Web y de otros servicios de Internet ofrecidos por
MediRed están sujetos a los siguientes Términos.
Lea atentamente estos Términos (“Términos”).
Al utilizar este Sitio, Usted reconoce que ha leído y comprende estos Términos y declara la aceptación
plena y sin reservas de los Términos que estén vigentes en el momento de acceso.
Usted también reconoce haber leído y comprendido las Políticas de Privacidad y consiente a que
MediRed trate sus datos personales tal y como allí se establece.
Si usted no está de acuerdo con estos Términos o con las Políticas de Privacidad, le rogamos que se
abstenga de utilizar este Sitio Web y deje de inmediato de navegarlo.
La información suministrada, y los servicios y procesos transaccionales disponibles en el Sitio Web
tienen como finalidad ofrecer información a los Usuarios y/o Visitantes de las actividades, productos
y servicios de MediRed. MediRed, titular del Sitio puede revisar y modificar estos Términos en
cualquier momento, actualizando esta página por lo que debido a que los mismos son vinculantes para
Usted, debería visitar esta página cada vez que acceda al Sitio Web para revisar los “Términos”.
Asimismo, debido a que ciertos servicios y procesos transaccionales, tipo de interacciones y
contenidos ofrecidos a los Usuarios y/o Visitantes a través del Sitio Web pueden contener normas
específicas que reglamentan, complementan y/o modifican los presentes Términos, se recomienda a
los Usuarios y/o Visitantes tomar conocimiento específico de ellas antes de la utilización de dichos
contenidos informativos, servicios y procesos transaccionales ofrecidos, así como también cualquier
tipo de interacción.
Los contenidos y la disposición de servicios y procesos transaccionales (incluyendo todo tipo de
interacciones en ambiente virtual) alojados en este Sitio Web tienen como propósito suministrar
información y posibilitar el desarrollo de ciertos procesos transaccionales con la finalidad de facilitar
el acceso y conocimiento por parte de los Usuarios y Visitantes de las actividades, productos y
servicios de MediRed.
MediRed se reserva el derecho de actualizar, modificar o eliminar la información contenida en el Sitio
Web, sin previo aviso, teniendo la libertad de limitar o anular el acceso a dicha información, ya sea de
forma temporal o definitiva.
De la misma manera MediRed procederá con la disposición de procesos transaccionales y/o la
configuración o presentación del Sitio Web y de todas las interacciones dispuestas en él. Así mismo
también se reserva el derecho de modificar, actualizar y suprimir la manera en que se presenta el
diseño del Sitio Web y la forma en que están organizados los contenidos y los servicios y procesos
transaccionales disponibles y ofrecidos.
La información proporcionada por MediRed en su Sitio Web es meramente informativa, por lo que no
seremos responsables de los daños o perjuicios que pudieran derivarse de la puesta en práctica de las
recomendaciones que proporcionamos.
Salvo que se establezca expresamente lo contrario, cualquier información, comunicación o material
que usted transmita a este Sitio Web por medio de correo electrónico u otro canal electrónico alojado
en el Sitio Web, incluyendo información, preguntas, comentarios, sugerencias será tratado como no
confidencial y no propietario y serán propiedad única y exclusiva de MediRed, quedando esta última
con la facultad de disponer de la misma.
1. Acceso del Sitio Web
El acceso al Sitio Web dado por Ud no exige su previa suscripción o registro. Sin perjuicio de ello, la
utilización de algunos contenidos informativos disponibles y el acceso a ciertos servicios y procesos
transaccionales ofrecidos mediante la ejecución de determinados tipos de interacciones que se ofrecen
a través del Sitio Web requieren su suscripción o registro. Esta suscripción o registro lo convierte en
Usuario del Sitio Web de MediRed.
2. Utilización del Sitio Web
El Visitante y/o Usuario se compromete a utilizar el Sitio Web de MediRed de conformidad con la ley,
de conformidad con estos Términos, así como con la moral y buenas costumbres generalmente
aceptadas y el orden público, así como lo estipulado en la Ley 53-07 sobre Crímenes y Delitos de Alta
Tecnología y su reglamento.
El Visitante y/o Usuario se obliga a abstenerse de utilizar el Sitio con fines o efectos ilícitos,
contrarios a lo establecido en los Términos, lesivos de los derechos e intereses de terceros, o que de
cualquier forma puedan dañar, inutilizar, sobrecargar o deteriorar el Sitio o impedir la normal
utilización del Sitio por parte de los Visitantes y/o Usuarios.
Queda estrictamente prohibida la utilización de los contenidos y servicios y procesos transaccionales
disponibles en el Sitio con cualquier propósito o de cualquier manera distinta de la permitida por
MediRed en los presentes Términos.
3. Utilización del contenido informativo y servicios y procesos transaccionales disponibles en el Sitio
Web
El uso del Sitio Web, incluyendo el acceso por los Usuarios y la navegación a través del mismo, es
libre y gratuito e implica el fiel cumplimiento de los presentes Términos.
Está disponible para los Visitantes de Internet la oportunidad de informarse sobre diferentes tipos de
contenidos informativos y se presta el servicio de contactar a MediRed al visitar nuestro Sitio Web
mediante un proceso de interacción en un ambiente electrónico.
Para los Usuarios se dispone la posibilidad de acceder a una plataforma privada propiedad de
MediRed donde se presta el servicio de acceder y ejecutar determinados procesos transaccionales
producto de la realización de determinadas interacciones.
A título meramente enunciativo y no limitativo se deja constancia que dentro de los servicios y
procesos transaccionales ofrecidos y disponibles se encuentran: (a) reportes con información general
sobre membresías, (b) posibilidad de modificaciones de datos de clientes, (c) posibilidades de
modificaciones de datos acerca de determinadas condiciones de contratación de productos y servicios,
(d) apertura de reclamos y solicitudes de modificación de una membresía (e) datos de facturación, (f)
acceso a manuales de uso, operación y gestión.
Los Usuarios contarán de diferentes perfiles de acceso para interactuar con la plataforma privada
transaccional. Dichos perfiles serán previamente definidos por MediRed.
Los presentes Términos son aplicables a todos los Usuarios y/o Visitantes que utilicen el Sitio.
En caso de que en el futuro se incluyan nuevas secciones en el Sitio que presten servicios y procesos
transaccionales específicos, MediRed podría incluir en los mismos Términos específicos, aplicables a
dichas secciones bien con prioridad sobre los presentes Términos, o bien complementando los
mismos.
4. Conducta del Visitante y/o Usuario
Algunos elementos que forman parte de la información ofrecida en el Sitio Web de MediRed solo
están disponibles para aquellos Usuarios que se hayan registrado en nuestra base de datos a los cuales
MediRed les haya asignado y proporcionado un nombre de usuario y contraseña.
Al registrarse en nuestro Sitio Web, Usted declara que tiene al menos 18 años de edad.
No podrá facilitar ni utilizar una contraseña, dirección de correo electrónico o cualquier otro tipo de
información de cualquier otra persona sin la autorización previa del titular, quedando Usted en todo
momento como responsable de dicho uso.
Cuando se registra en nuestra base de datos está aceptando proporcionar información personal
verdadera, precisa, actual y completa.
Usted es responsable de mantener la confidencialidad de su cuenta y contraseña y de restringir el
acceso a su dispositivo desde el cual accede a Internet, y acepta asumir la responsabilidad de todas las
actividades que se realicen utilizando su cuenta, incluyendo la selección y utilización de todos los
contenidos, la ejecución de determinados procesos transaccionales productos de la realización de
determinados tipos de interacciones en la plataforma privada de MediRed alojada en el Sitio.
Los Visitantes y/o Usuarios Solo podrán utilizar los servicios ofrecidos (contenidos, transacciones e
interacciones) de acuerdo con estos Términos.
MediRed se reserva el derecho de denegar el servicio y/o cerrar cuentas, incluyendo, a título
meramente enunciativo y no taxativo, la implementación de dichas medidas por actividades realizadas
por cualquier Usuario y que infrinjan estos Términos.
Se prohíbe a los Visitantes y/o Usuarios violar o intentar violar la seguridad del Sitio, incluyendo pero
no limitándose a: (a) acceder de manera ilícita o permitir el acceso ilícito de terceros al sistema o a
datos que no estén destinados a tal Usuario o entrar en un servidor o cuenta cuyo acceso no está
autorizado al Usuario, (b) afectar, evaluar o probar la vulnerabilidad de un sistema o red, o violar las
medidas de seguridad o identificación sin la adecuada autorización, (c) intentar impedir el servicio a
cualquier Usuario y/o Visitante, anfitrión o red, incluyendo sin limitación, mediante el envío de virus
al Sitio, o mediante saturación, envíos masivos (“flooding”), “spamming”, bombardeo de correo o
bloqueos del sistema (“crashing”), (d) enviar correos no pedidos, incluyendo promociones y/o
publicidad de productos o servicios, o (e) falsificar cualquier cabecera de paquete TCP/IP o cualquier
parte de la información de la cabecera de cualquier correo electrónico, o (f) recoger información sobre
otros Usuarios, incluyendo contraseñas, nombres de Usuario, cuentas u otra información.
Las violaciones de la seguridad del sistema, de la red o de las leyes que regulan la materia pueden
comprometer su responsabilidad tanto civil como penal.
MediRed investigará los casos en los que hubieran podido producirse tales violaciones y puede
dirigirse a cooperar con la autoridad competente para perseguir a los Usuarios y Visitantes
involucrados en tales violaciones, para buscar la sanción aplicable al mismo.
El Visitante y/o Usuario que incumpla de forma no intencional o culpablemente cualquiera de las
precedentes obligaciones responderá de todos los daños y perjuicios que cause.
5. Devolución o Cancelación de transacciones
Para cancelar o solicitar la devolución de las transacciones realizadas a través de MediRed debe
comunicarse con servicio al cliente, (809) 896-7711.
6. Uso de nombres de Usuarios y contraseñas
El acceso y uso de ciertas secciones del Sitio Web requieren de un nombre de Usuario y una
contraseña.
Como parte del proceso de acceso a la plataforma transaccional y de ejecución de reportes, debe
ingresar un nombre de Usuario y una contraseña, y facilitar a MediRed información exacta, completa
y actualizada.
Cualquier persona que conozca su nombre de usuario y contraseña puede acceder a la plataforma
privada del Sitio Web y a la información allí disponible para Usted. En consecuencia, debe mantener
en secreto estos datos.
Al aceptar estos Términos, Usted consiente ser el único responsable de la confidencialidad y uso de su
respectivo nombre de Usuario y contraseña, así como de cualquier comunicación hecha a través del
Internet utilizando su nombre de Usuario y contraseña.
Usted notificará inmediatamente a MediRed cualquier pérdida o robo de su contraseña o cualquier uso
no autorizado de ésta.
MediRed se reserva el derecho a eliminar o cambiar una contraseña en cualquier momento y por
cualquier motivo.
7. Uso del correo electrónico
Usted puede utilizar el correo electrónico para ponerse en contacto con MediRed, para los fines
señalados en los presentes Términos y en la Políticas de Privacidad.
A pesar de que es deseo de MediRed atender los correos electrónicos recibidos con prontitud,
MediRed no garantiza la respuesta efectiva los mismos, ya que dependerá del volumen de
correspondencia recibida y de la complejidad de las cuestiones planteadas.
MediRed no garantiza tampoco el funcionamiento del correo electrónico, tanto en la recepción como
en el envío, por estar fuera de su control.
Toda la información recibida por esta vía por parte de los Usuarios y/o Visitantes del Sitio Web de
MediRed será tratada conforme a lo establecido en la Políticas de Privacidad.
8. Sugerencias
MediRed agradece su opinión y sugerencias sobre cómo mejorar su Sitio Web y la experiencia de un
Visitante y/o Usuario en él.
No obstante, se considerará que cualquier idea, sugerencia, información, know-how, material u otro
contenido (en adelante conjuntamente, “Sugerencias”) recibidos a través del Sitio conlleva la
concesión a MediRed de un derecho y licencia no exclusivos, gratuitos, perpetuos e irrevocables para
adoptar, publicar, reproducir, transmitir, difundir, distribuir, copiar, utilizar, crear obras derivadas,
exhibir, en el territorio mundial (en todo o parte), las Sugerencias, o actuar sobre la base de tales
Sugerencias sin necesidad de aprobación o precio adicionales, en cualquier forma, medio o tecnología
actualmente conocidos o por desarrollar, durante la vigencia de los derechos que puedan existir sobre
dichas Sugerencias.
Usted renuncia por los presentes Términos a reclamar en contra de lo establecido en este apartado.
9. Contenidos de terceros
El Sitio Web puede contener enlaces a otros sitios de Internet y a recursos de terceros que son
completamente independientes a este Sitio. Se hace esto para facilitarte la localización de información
y complementar los servicios ofrecidos por MediRed en su Sitio.
MediRed no se responsabiliza ni garantiza, en modo alguno, la exactitud, insuficiencia o autenticidad
de la información suministrada por cualquier persona o entidad, física o jurídica, con o sin
personalidad jurídica propia, a través de dichos enlaces de hipertexto.
MediRed no garantiza que los enlaces a otros lugares sean exactos en el momento de su acceso. Estos
enlaces se proporcionan Solo para su conveniencia.
Las eventuales referencias que se hagan en este Sitio a cualquier producto, servicio, proceso, enlace,
hipertexto o cualquier otra información que sean de titularidad de terceros, no constituye o implican
respaldo, patrocinio o recomendación por parte de MediRed.
Usted es el único responsable de comprender cualquier término y condición que pudieran aplicarse
durante su visita en el sitio de un tercero.
El establecimiento del hipervínculo no implica en ningún caso la existencia de relación comercial
alguna entre MediRed y el titular de la página web en la que se establezca el mismo.
No se establecerán hipervínculos al Sitio en páginas web que incluyan información o contenidos
ilícitos, inmorales o contrarios a las buenas costumbres, al orden público, a los usos aceptados en
Internet o que de cualquier forma contravengan derechos de terceros.
10. Modificaciones en el Sitio Web de MediRed
Nos reservamos el derecho de ocasionalmente modificar o interrumpir, de manera temporal o
permanente, la información y servicios y procesos transaccionales disponibles por MediRed en el
Sitio Web corporativo con o sin notificación previa.
Usted está de acuerdo en que MediRed no será responsable frente a Usted o frente a cualquier tercero
por cualquier modificación, suspensión o interrupción de la información y servicios y procesos
transaccionales disponibles, incluyendo la posibilidad de generar transacciones como producto de la
ejecución de determinado tipo de interacciones.
11. Fallos
MediRed no se responsabiliza de los posibles daños o perjuicios que se pudieran derivar de
interferencias, omisiones, interrupciones, virus informáticos, averías telefónicas o desconexiones en el
funcionamiento operativo del sistema seleccionado por el Usuario y/o Visitante motivados por causas
ajenas; de retrasos o bloqueos en el uso o de cualquier otra causa que impida el correcto suministro de
servicio del sistema elegido causado por deficiencias o sobrecargas de líneas telefónicas o sobrecargas
en el centro de proceso de datos de MediRed, en los servidores de Internet o en otros sistemas
electrónicos, así como de daños que puedan ser causados por terceras personas mediante
intromisiones ilegítimas en el sistema elegido, fuera del control de MediRed.
MediRed no se hace responsable de los posibles errores que se pudieran producir por el hecho de
utilizar versiones de navegadores no actualizadas, o de las consecuencias que se pudieran derivar del
mal funcionamiento o incorrecta utilización del navegador. MediRed no garantiza que ninguna
información, software u otro material accesible desde el Sitio Web accesible desde el dominio
https://medired.do esté libre de virus.
Usted expresamente exime y libera a MediRed y a sus proveedores de cualquier reclamación por
daños derivados de una causa que esté fuera de su control, incluyendo -a efectos enunciativos y no
limitativos: (a) fallos en los equipamientos electrónicos o mecánicos, (b) fallos en las líneas de
comunicación, telefónicas u otros problemas de interconexión, (c) infección con virus informáticos,
(d) accesos no autorizados, (e) robos, (f) errores de los operadores, (g) problemas climatológicos,
terremotos u otras catástrofes naturales, (h) huelgas u otros conflictos laborales, (i) guerras, terrorismo
y (j) restricciones gubernamentales.
12. Servidor seguro
Los formularios de contenidos alojados en el Sitio Web están configurados para que el Usuario y/o
Visitante puedan enviar información con total seguridad y confianza. Todos los datos enviados a
través de nuestros formularios serán encriptados a través de nuestro servidor seguro para proteger su
confidencialidad.
13. Discrepancias de documentos en versión electrónica
MediRed no se responsabiliza de las posibles discrepancias que puedan surgir entre la versión de
cualquier documento impreso y la versión electrónica de los mismos publicados en su Sitio Web.
14. Propiedad intelectual
Todos los contenidos, aplicaciones y signos distintivos incluidos; tales como textos, gráficos,
logotipos, iconos de botones, marcas, sonidos, videos, nombres, nombres de dominio, secuencias de
códigos autoejecutables, imágenes, como así también la compilación de los mismos, y todos los
programas de ordenador utilizados en este Sitio son propiedad de MediRed, o de sus proveedores o
compañías vinculadas y están protegidos por las leyes de propiedad intelectual de República
Dominicana y por los correspondientes acuerdos internacionales; o en su caso, MediRed cuenta con
licencia de uso, y gozan, en consecuencia, de la protección propia de los derechos sobre la propiedad
intelectual e industrial.
Usted acepta respetar todos los avisos y/o derechos de autor u otras restricciones contenidas en este
Sitio Web y no los modificará de ningún modo.
Salvo que se permita explícitamente, de conformidad con las leyes de propiedad intelectual, Usted no
podrá modificar, aplicar técnicas de ingeniería inversa, publicar, transmitir, visualizar, participar en la
transferencia o venta o crear trabajos derivados, ni de cualquier otra forma explotar comercialmente o
facilitar a un tercero el contenido (información como tal, reportes producto de transacciones y
formularios de datos) del Sitio Web o de las publicaciones sin la autorización expresa por escrito de
MediRed.
No le concedemos ninguna licencia, expresa o tácita, de propiedad intelectual de MediRed, excepto
que estos Términos así lo autoricen expresamente.
Usted no copiará ni adaptará el código HTML que MediRed ha creado para generar sus páginas web
que componen el Sitio Web. Dicho código se haya protegido también por los derechos de propiedad
intelectual de MediRed.
Cualquier otro nombre, logotipo o icono que identifique a MediRed o a sus productos o servicios son
marcas propiedad de MediRed.
Los nombres y marcas de productos de terceros y los nombres y marcas de terceras empresas
mencionadas o publicadas en el Sitio Web son nombres y marcas de sus respectivos propietarios.
15. Asunción de riesgos
Usted utiliza Internet asumiendo su propio riesgo y con sujeción a toda la legislación o normativa
local, nacional o internacional aplicable. Sin perjuicio de que MediRed ha procurado crear un Sitio
Web seguro y fiable, la confidencialidad de cualquier comunicación o material transmitido a/del Sitio
en Internet no puede ser garantizada.
En consecuencia, MediRed y sus proveedores no serán responsables de la seguridad de la información
transmitida vía Internet, de la exactitud de la información contenida en el Sitio, o de las consecuencias
de confiar en dicha información.
MediRed y sus proveedores no tendrán ninguna responsabilidad por interrupciones o falta de
funcionamiento de Internet, de la red o de servicios de alojamiento. Usted asume en exclusiva todo el
riesgo que pueda derivar de su utilización de la Web.
16. Exclusión de responsabilidad y garantías
La información y los servicios y procesos transaccionales disponibles y ofrecidos por MediRed a
través de su Sitio y todos los contenidos se brindan en términos de “como estén” y “como estén
disponibles”.
MediRed expresamente excluye toda garantía de cualquier tipo, ya sea expresa o tácita.
MediRed no otorga ninguna garantía de que la calidad de cualquier contenido y/o servicio y proceso
transaccional ofrecido, u otro material obtenido por Usted a través del Sitio satisfagan las necesidades
y expectativas de los Visitantes y/o Usuarios, ni que la información y/o servicios y procesos
transaccionales ofrecidos serán ininterrumpidos, oportunos, seguros o estarán libre de errores, ni que
los resultados que puedan obtenerse de la utilización de la información y servicios y procesos
transaccionales disponibles y ofrecidos serán precisos o confiables.
MediRed no se responsabiliza del mal uso que se realice de los contenidos y servicios y procesos
transaccionales ofrecidos en el Sitio, ni de los daños o perjuicios que se deriven del acceso o uso
indebido de la información y los resultados de las interacciones de dicho Sitio Web; tanto al navegar
en su dominio público, como en su plataforma transaccional privada.
Usted es consciente y acepta que ninguna información o consejo, ya sea oral o escrito, facilitado por
MediRed o por cualquiera de sus empleados o relacionados en relación con el Sitio constituye una
declaración o una garantía a menos que dicha información o consejo esté cubierto por estos Términos.
MediRed y sus proveedores y relacionados no serán bajo ninguna circunstancia responsables de
ningún daño especial, directo, indirecto, incidental o consecuencial de cualquier tipo, incluyendo (a
modo enunciativo y no limitativo) compensaciones, reembolsos o daños por las pérdidas o gastos
ocasionados, deterioro de la reputación comercial, pérdida de información y costos financieros.
En la medida de lo que lo que permite la ley, MediRed y sus proveedores y relacionados se excluyen
de cualquier responsabilidad por cualquier daño directo derivado del uso de su Sitio Web, sus
contenidos y servicios y procesos transaccionales ofrecidos.
17. Límite de responsabilidad
En ningún caso MediRed, de conformidad con cualquier fundamento legal, será responsable por
ningún daño directo, indirecto, emergente, punitivo o consecuencial.
MediRed no se responsabiliza por los daños y perjuicios de toda naturaleza que puedan deberse a la
falta de exactitud, exhaustividad, actualidad, así como a errores u omisiones de los que pudieran
adolecer los contenidos informativos y servicios y procesos transaccionales disponibles y ofrecidos de
este Sitio Web u otros contenidos y procesos transaccionales e interacciones que deriven en procesos
transaccionales a los que se pueda acceder a través del mismo.
MediRed no asume ningún deber o compromiso de verificar, ni de vigilar sus contenidos (procesos
transaccionales e interacciones) e informaciones.
Asimismo, MediRed no garantiza la disponibilidad, continuidad ni la infalibilidad del funcionamiento
del Sitio Web, y en consecuencia excluye, en la máxima medida permitida por la legislación vigente,
cualquier responsabilidad por los daños y perjuicios de toda naturaleza que puedan deberse a la falta
de disponibilidad o de continuidad del funcionamiento del Sitio Web y de los servicios y procesos
transaccionales habilitados en el mismo, así como a los errores en el acceso a las distintas páginas web
desde las que, en su caso se presten dichos servicios.
Aun cuando MediRed realizará razonables esfuerzos para incluir información precisa y actualizada en
este Sitio Web, los errores y omisiones pueden ocurrir algunas veces. MediRed no garantiza ni avala
la precisión del contenido de este sitio.
MediRed tampoco asume alguna responsabilidad por algún daño o virus que pueda infectar su
dispositivo desde donde accede a Internet u otra propiedad como resultado de su acceso, uso o
navegación en el Sitio Web o su descarga de algún material, información, texto, imágenes, video o
audio de este Sitio Web.
MediRed no garantiza ni avala que su uso de materiales exhibidos en este sitio no infrinja derechos de
terceras partes que no pertenezcan o estén afiliadas a MediRed.
18. Exoneración de responsabilidad
La información respecto a los productos y servicios que ofrece MediRed en el Sitio Web corporativo
accesible desde el nombre de dominio https://medired.do no refleja todos los términos y condiciones
aplicables a cada uno de los productos y/o servicios comercializados por MediRed.
La información provista en el Sitio Solo tiene un carácter indicativo, orientativo y estimativo.
MediRed no garantiza la total actualización y/o exactitud y/o disponibilidad en todo momento de los
contenidos y servicios y procesos transaccionales disponibles y ofrecidos en su Sitio Web, si bien hace
todo lo posible para que así sea.
Igualmente MediRed no garantiza la utilidad de su Sitio o de sus servicios y procesos transaccionales
disponibles y ofrecidos para ninguna actividad en particular por lo que el acceso al Sitio y el uso de
sus contenidos se realizan bajo la responsabilidad del Usuario y/o Visitante.
MediRed no garantiza, ni avala el uso o los resultados del uso de los materiales en el Sitio Web en
términos de su exactitud, precisión, confiabilidad u otros.
Se exonera a MediRed de responsabilidad ante cualquier daño o perjuicio que pudiera sufrir el
Usuario y/o Visitante como consecuencia de errores, defectos u omisiones en la información facilitada
o de la imposibilidad de efectuar adecuadamente procesos transaccionales o en el caso de que
producto de las interacciones dirigidas a consolidar transacciones se obtengan información
inconsistente y/o errónea.
Usted acepta defender, exonerar y liberar de toda responsabilidad a MediRed, sus licenciantes,
proveedores y cualquier tercero proveedor de contenidos a la información y servicios y procesos
transaccionales ofrecidos y sus respectivos consejeros, directivos, empleados y relacionados, por
cualquier demanda, pérdida, gasto, daños y costos, incluyendo los honorarios razonables de abogados,
que deriven de la utilización de la información y los servicios y procesos transaccionales ofrecidos por
MediRed en el Sitio y que resulten de la violación de estos Términos o de cualquier actividad
relacionada con su cuenta (incluyendo conducta negligente o ilícita) por su parte o por la parte de
cualquier Usuario y/o Visitante que acceda a nuestro Sitio por medio de su cuenta.
19. Indemnización
Usted acepta indemnizar y mantener libre e indemne a MediRed y sus relacionados, todas sus filiales,
y cualquiera de sus directivos, administradores, empleados, accionistas, representantes legales,
relacionados, sucesores y cesionarios por cualquier daño, responsabilidad, costos y gastos (incluyendo
honorarios razonables de abogados y profesionales y costas de litigios) que sean consecuencia de
reclamaciones de terceros basadas o relativas al uso de su Sitio Web o a una infracción de estos
Términos cometida por Usted.
20. Control
MediRed tiene el derecho, pero no la obligación, de controlar los servicios y procesos transaccionales
disponibles y ofrecidos para determinar el cumplimiento de estos Términos y de cualquier otra norma
de funcionamiento establecida por MediRed, así como para cumplir con cualquier ley, reglamento o
requerimiento legal aplicable.
Sin limitar lo anterior, tendremos el derecho de eliminar cualquier contenido y/o servicio y proceso
transaccional que, discrecionalmente, creamos que viole las disposiciones de nuestros Términos.
21. Resolución
MediRed puede, discrecionalmente y sin responsabilidad alguna, cancelar su nombre de Usuario y
contraseña, impedir la utilización de la información y servicios y procesos transaccionales disponibles
y ofrecidos por cualquier motivo, incluyendo, a título meramente enunciativo y no limitativo, el caso
de que MediRed considere que Usted ha violado o ha actuado en contra de la letra o del espíritu de
estos Términos. Cualquier cancelación del acceso a la información y servicios y procesos
transaccionales ofrecidos, de conformidad con cualquier disposición de estos Términos, puede
efectuarse sin notificación previa.
MediRed puede desactivar o eliminar inmediatamente su cuenta y toda la información relacionada y/o
prohibir cualquier acceso a la información y/o servicios y procesos transaccionales ofrecidos en el
futuro.
MediRed se reserva el derecho de denegar el acceso a su Sitio Web o a parte del mismo en cualquier
momento y por cualquier motivo.
22. Vigencia y notificación de cambios
Estos Términos serán efectivos desde el primer momento en que ingrese al Sitio Web.
En el futuro, MediRed puede revisar o modificar estos Términos para mantenerlos al día en relación a
la información y servicios y procesos transaccionales disponibles y ofrecidos en el Sitio.
Visite la página web Términos periódicamente para informarse acerca de cualquier cambio.
La fecha de actualización se utiliza para alertarle acerca de las modificaciones recientes.
Su acceso o utilización de la información y servicios y procesos transaccionales disponibles y
ofrecidos por MediRed posteriores a dicha actualización se entenderá como su consentimiento para
estar sujeto a dichos cambios.
23. Conocimiento y consentimiento
Al utilizar el Sitio Web de MediRed, usted declara que ha leído y comprendido estos Términos, y que
acepta estar vinculado por sus condiciones.
Usted también reconoce haber leído y comprendido las Políticas de Privacidad y autoriza a MediRed a
la utilización de sus datos personales.
Si desea contactar con MediRed en relación a estos Términos o la Políticas de Privacidad, por favor,
contacte con:
MediRed
Av. Abraham Lincoln 1003, Santo Domingo, D.N 10014
Tel. (809) 896-7711
E-mail: info@medired.do
Sitio Web: https://medired.do
24. Renuncia
El hecho de no reclamar el cumplimiento estricto de cualquiera de las condiciones de estos Términos
no se considerará como una renuncia de derechos frente a infracciones o incumplimientos posteriores
de las mismas. La falta de ejercicio por MediRed de un derecho derivado de los Términos no supone
una renuncia al ejercicio de cualquier otro derecho o del mismo derecho en un momento posterior.
25. Totalidad del acuerdo y reserva de derechos
Sus derechos a utilizar determinados materiales disponibles en o a través del Sitio Web corporativo de
MediRed pueden estar sujetos a diferentes acuerdos escritos suscritos con MediRed (en adelante
“Otros Acuerdos”).
Determinadas páginas o elementos del Sitio, con contenido y servicios y procesos transaccionales
disponibles y ofrecidos por MediRed, pueden tener condiciones diferentes o adicionales (en adelante
“Condiciones Particulares”), que le serán indicadas cuando acceda a dichas páginas o elementos, y se
considerará que usted ha aceptado las Condiciones Particulares si accede a las páginas o elementos y
las utiliza. En caso de conflicto entre estos Términos y las Condiciones Particulares, las Condiciones
Particulares prevalecerán en cuanto a su aplicación a dichas páginas o elementos. En caso de conflicto
entre estos Términos y uno o varios Otros Acuerdos, las condiciones de dichos Otros Acuerdos serán
de aplicación.
Con la excepción de cualesquiera Condiciones Particulares u Otros Acuerdos, estos Términos
representan, junto con la Políticas de Privacidad, la totalidad del acuerdo suscrito entre Usted y
MediRed en relación con su utilización del material disponible en o a través del Sitio Web
corporativo, y deja sin efecto toda comunicación o propuesta anterior o coetánea, ya fueran
electrónicas, orales o escritas, entre Usted y MediRed relativas al Sitio.
Cualquier derecho que no haya sido expresamente concedido por los presentes Términos queda
reservado.
26. Legislación aplicable
Estos Términos de Uso se rigen por las leyes de la República Dominicana, muy particularmente, de la
Ley No. 53-07 de fecha 10 de abril de 2007 sobre Delitos y Crímenes de Alta Tecnología y su
reglamento.
Cualquier demanda derivada de estos Términos se someterá exclusivamente a la jurisdicción de los
juzgados y tribunales de la ciudad de Santo Domingo, República Dominicana.
                
                ''', // Puedes ajustar el contenido aquí
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
            activeColor: AppColors.blueBackground,
            value: isAccepted,
            onChanged: onChanged),
        const Text(
          'Acepto los',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        TextButton(
          onPressed: () => _launchUrl(Uri.parse('/documents/Terminos%20y%20Condiciones.pdf')),
          child: const Text(
            'Términos y Condiciones',
            style: TextStyle(
              color: Color.fromRGBO(114, 146, 228, 1),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _launchUrl(_url) async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
}
