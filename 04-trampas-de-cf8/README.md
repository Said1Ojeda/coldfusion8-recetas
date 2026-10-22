# 04 · Trampas de CF8

Errores que me costaron horas. Si te sale uno de estos, aquí está la razón.

### "The add method was not found"

Guardaste objetos de Java, como un `Paragraph`, en un arreglo de CF y luego los quisiste agregar al documento. CF8 los convierte al meterlos al arreglo y ya no son lo que iText espera.

**Solución:** crea cada objeto y agrégalo de una vez, sin guardarlo en arreglos.

### "Method not found" con números

Los métodos de Java piden `int` o `float`, y CF manda `double` o `string`.

**Solución:** `javacast("int", 3)`, `javacast("float", 11)` y `javacast("string", texto)` en todo lo que le pases a Java.

### `Left()` y `Mid()` con largo 0 truenan

`left(texto, 0)` da error en CF8, no devuelve vacío. Pasa mucho cuando el texto que buscas está al inicio.

**Solución:** valida antes.

```cfm
<cfif pos GT 1>
    <cfset antes = left(texto, pos - 1)>
</cfif>
```

### Reusar el mismo objeto de Java

`obj = createObject("java", "...")` y luego `obj.init(...)` varias veces da resultados raros, porque después del primer `init` la variable ya es una instancia.

**Solución:** haz una función pequeña que cree uno nuevo cada vez.

### `cfdocument` no justifica

No importa dónde pongas `text-align: justify`, no lo respeta. Ver la [receta 01](../01-pdf-texto-justificado/).

### Campos largos vacíos

Si en SQL el texto está completo pero en CF llega vacío, es el DSN. Ver la [receta 02](../02-textos-largos-por-dsn/).

### Fuentes en iText 1.x

Las fuentes base se piden por número: 0 Courier, 1 Helvetica, 2 Times, 3 Symbol, 4 ZapfDingbats. Con Helvetica salen bien las tildes y la ñ.
