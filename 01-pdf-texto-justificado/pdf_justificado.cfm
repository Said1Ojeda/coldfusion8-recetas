<!---
  pdf con texto justificado en cf8
  cfdocument no justifica, asi que armo el pdf directo con itext
  itext 1.x ya viene dentro de cf8 en el paquete com.lowagie
--->

<cfset titulo = "Informe de prueba">
<cfset parrafos = [
    "Este es el primer parrafo del informe. Lo pongo largo a proposito para que se note que el texto llega parejo al margen derecho y no queda como serrucho, que es lo que pasa con cfdocument aunque le pongas text-align justify en el estilo.",
    "Segundo parrafo. Cada parrafo se crea y se agrega al documento en el momento, no se guardan en un arreglo antes porque cf8 convierte el objeto de java y despues truena al querer agregarlo."
]>

<cfscript>
    // carta con margenes de 50 puntos por lado
    pageSize  = createObject("java", "com.lowagie.text.PageSize");
    documento = createObject("java", "com.lowagie.text.Document").init(
        pageSize.LETTER,
        javacast("float", 50), javacast("float", 50),
        javacast("float", 50), javacast("float", 50)
    );

    // el pdf se arma en memoria y al final se manda al navegador
    salida = createObject("java", "java.io.ByteArrayOutputStream").init();
    createObject("java", "com.lowagie.text.pdf.PdfWriter").getInstance(documento, salida);
    documento.open();

    // 1 es helvetica y el ultimo numero es el estilo, 0 normal y 1 negrita
    fuenteTitulo = createObject("java", "com.lowagie.text.Font").init(
        javacast("int", 1), javacast("float", 14), javacast("int", 1)
    );
    fuenteTexto = createObject("java", "com.lowagie.text.Font").init(
        javacast("int", 1), javacast("float", 11), javacast("int", 0)
    );

    // 1 es centrado y 3 es justificado
    p = createObject("java", "com.lowagie.text.Paragraph").init(javacast("string", titulo), fuenteTitulo);
    p.setAlignment(javacast("int", 1));
    p.setSpacingAfter(javacast("float", 14));
    documento.add(p);

    for (i = 1; i LTE arrayLen(parrafos); i = i + 1) {
        p = createObject("java", "com.lowagie.text.Paragraph").init(javacast("string", parrafos[i]), fuenteTexto);
        p.setAlignment(javacast("int", 3));
        p.setSpacingAfter(javacast("float", 8));
        documento.add(p);
    }

    documento.close();
</cfscript>

<cfheader name="Content-Disposition" value="inline; filename=informe.pdf">
<cfcontent type="application/pdf" variable="#salida.toByteArray()#" reset="true">
