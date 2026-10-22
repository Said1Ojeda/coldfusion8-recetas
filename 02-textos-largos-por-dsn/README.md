# 02 · Textos largos por DSN

## El problema

Tienes un campo `NVARCHAR(MAX)`, `TEXT` o `NTEXT` en SQL Server. En el Management Studio el texto está completo, pero en ColdFusion llega **vacío** o cortado.

Pasa porque el DSN no tiene activada la opción *Enable long text retrieval (CLOB)*, o porque su *buffer* es más chico que tu texto. Si no tienes acceso al ColdFusion Administrator, no la puedes cambiar.

## La solución

Pedir el campo en pedazos de 4000 caracteres convertidos a `NVARCHAR(4000)`, que el driver sí entrega bien, y unirlos en CF:

```sql
CAST(SUBSTRING(observaciones, 1,    4000) AS NVARCHAR(4000)) AS p1,
CAST(SUBSTRING(observaciones, 4001, 4000) AS NVARCHAR(4000)) AS p2
```

```cfm
<cfset textoCompleto = q.p1 & q.p2 & q.p3 & q.p4>
```

Agrega tantos pedazos como necesite tu texto más largo. `DATALENGTH` te ayuda a calcularlo, pero ojo, en `NVARCHAR` devuelve bytes, o sea el doble de caracteres.

El ejemplo completo está en [`texto_largo.cfm`](texto_largo.cfm).

## Bonus: el texto viene solo en una fila

Si la consulta tiene `JOIN`s y devuelve varias filas, puede que el texto venga solo en algunas. El ejemplo recorre todas y se queda con la que trae más contenido.
