# 01 · PDF con texto justificado

## El problema

En ColdFusion 8, `cfdocument` ignora `text-align: justify`. Le puedes poner el estilo en línea, en una clase o en un `<div>`, y el texto sale alineado a la izquierda igual. Para informes formales eso no pasa.

## La solución

CF8 trae por dentro **iText 1.x** (el paquete `com.lowagie`). Con `createObject("java", ...)` se puede armar el PDF directo, párrafo por párrafo, y ahí sí se puede justificar.

```cfm
p = createObject("java", "com.lowagie.text.Paragraph").init(javacast("string", texto), fuente);
p.setAlignment(javacast("int", 3)); // 3 = justificado
documento.add(p);
```

El ejemplo completo está en [`pdf_justificado.cfm`](pdf_justificado.cfm).

## Ejemplo: un oficio

[`oficio_ejemplo.cfm`](oficio_ejemplo.cfm) arma un oficio completo: encabezado centrado, número y fecha a la derecha, destinatario, asunto con la etiqueta en negrita, cuerpo justificado y firma centrada.

**[Ver cómo queda el PDF](ejemplo-oficio.pdf)**. Los datos son inventados.

Fíjate en el cuerpo: todos los renglones llegan parejo al margen derecho, menos el último de cada párrafo. Así se ve un documento formal. Con `cfdocument` ese mismo texto sale alineado a la izquierda, con el borde derecho disparejo.

Algunas cosas que usa el oficio y que no están en el ejemplo corto:

- **Varias alineaciones en la misma hoja.** Cada `Paragraph` lleva la suya, así que el encabezado, la fecha y el cuerpo pueden ir distintos.
- **Negrita a media línea.** Un `Paragraph` solo tiene una fuente, así que para "**Asunto:** texto normal" se arma con dos `Chunk`.
- **Espacios entre bloques** con `setSpacingBefore` y `setSpacingAfter`, en vez de meter párrafos vacíos.
- **Tildes.** `<cfprocessingdirective pageencoding="utf-8">` al inicio del archivo, si no CF8 lee mal las tildes del código.

## Detalles que importan

- **Usa `javacast` en todo.** CF manda los números como `double` y los métodos de iText piden `int` o `float`. Sin el cast salen errores de "method not found".
- **Valores de alineación:** 0 izquierda, 1 centro, 2 derecha, 3 justificado.
- **Fuentes:** `Font(familia, tamaño, estilo)`. La familia 1 es Helvetica. El estilo 0 es normal, 1 negrita y 2 cursiva.
- **No guardes los `Paragraph` en un arreglo de CF.** Créalos y agrégalos al documento de una vez. Ver [trampas](../04-trampas-de-cf8/).
- El PDF se arma en un `ByteArrayOutputStream`, así no hay que escribir archivos en el servidor.
