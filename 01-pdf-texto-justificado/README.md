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

## Detalles que importan

- **Usa `javacast` en todo.** CF manda los números como `double` y los métodos de iText piden `int` o `float`. Sin el cast salen errores de "method not found".
- **Valores de alineación:** 0 izquierda, 1 centro, 2 derecha, 3 justificado.
- **Fuentes:** `Font(familia, tamaño, estilo)`. La familia 1 es Helvetica. El estilo 0 es normal, 1 negrita y 2 cursiva.
- **No guardes los `Paragraph` en un arreglo de CF.** Créalos y agrégalos al documento de una vez. Ver [trampas](../04-trampas-de-cf8/).
- El PDF se arma en un `ByteArrayOutputStream`, así no hay que escribir archivos en el servidor.
