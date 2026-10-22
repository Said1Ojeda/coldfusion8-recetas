# 03 · HTML a párrafos de iText

## El problema

El campo que vas a imprimir no es texto plano. Lo guardó un editor web y viene con HTML:

```html
<p>El evaluado demostr&oacute; <strong>dominio t&eacute;cnico</strong>...</p>
<ul><li>Experiencia en an&aacute;lisis de datos</li></ul>
```

Si lo mandas así al PDF salen las etiquetas, y si las quitas a lo bruto pierdes los párrafos, las viñetas y las negritas.

## La solución

En [`html_a_itext.cfm`](html_a_itext.cfm) el HTML se convierte en tres pasos:

1. **Marcar lo que importa.** `<strong>` y `<b>` se cambian por `[[B]]` y `[[/B]]`, cada `<li>` por un salto con `@@LI@@`, y `<p>`, `<br>`, `<ul>` y `<div>` por saltos de línea.
2. **Limpiar.** Se quitan las demás etiquetas y se traducen las entidades (`&eacute;` → é, `&ntilde;` → ñ, etc.). `&amp;` va de último para no romper las otras.
3. **Armar el PDF.** Cada línea es un `Paragraph` justificado. Los textos en negrita se agregan como `Chunk` con otra fuente, y las viñetas llevan sangría y un `•`.

## Limitaciones

- No soporta tablas, imágenes ni listas anidadas.
- Si el HTML trae `<strong>` sin cerrar, la negrita llega hasta el final de la línea.
- Si aparece una entidad que no está en la lista, agrégala en la función `decodificar`.
