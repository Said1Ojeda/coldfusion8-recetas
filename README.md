# coldfusion-recetas

Soluciones que me han funcionado en **ColdFusion 8** (sí, el de 2008) trabajando en un servidor donde no tengo acceso al ColdFusion Administrator y no puedo instalar nada.

Si llegaste aquí buscando cómo hacer algo en CF8 y todo lo que encuentras es para versiones nuevas, bienvenido. Aquí todo está probado en el motor viejo.

## Recetas

| # | Receta | Problema que resuelve |
|---|---|---|
| 01 | [PDF con texto justificado](01-pdf-texto-justificado/) | `cfdocument` ignora `text-align: justify`. Se arma el PDF directo con iText, que ya viene dentro de CF8. |
| 02 | [Textos largos por DSN](02-textos-largos-por-dsn/) | Los campos de texto largo de SQL Server llegan vacíos o cortados y no puedes tocar la configuración del DSN. |
| 03 | [HTML a párrafos de iText](03-html-a-parrafos-itext/) | Un campo guarda HTML (`<p>`, `<ul>`, `<strong>`, `&eacute;`) y lo necesitas limpio y justificado en el PDF. |
| 04 | [Trampas de CF8](04-trampas-de-cf8/) | Errores raros que me costaron horas, para que a ti no. |

## Cómo usarlas

Cada carpeta tiene un `.cfm` que puedes copiar a tu proyecto y un README que explica el porqué. Los nombres de tablas y campos son de ejemplo, cámbialos por los tuyos.

## Requisitos

- ColdFusion 8 (también debería funcionar en 9)
- Permiso para usar `createObject("java", ...)`, que en la mayoría de servidores viene activo
- SQL Server para la receta 02

Si algo no te funciona o tienes una receta que agregar, abre un issue.
