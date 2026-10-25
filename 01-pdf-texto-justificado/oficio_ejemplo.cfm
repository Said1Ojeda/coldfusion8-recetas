<cfprocessingdirective pageencoding="utf-8">
<!---
  oficio de ejemplo con itext, es el que sale en ejemplo-oficio.pdf
  los datos son inventados, cambia todo por lo que traigas de tu query
--->

<cfset oficio = structNew()>
<cfset oficio.institucion  = "DIRECCIÓN DE RECURSOS DE EJEMPLO">
<cfset oficio.numero       = "Oficio No. DRE-0147-2026">
<cfset oficio.fecha        = "Guatemala, 24 de octubre de 2026">
<cfset oficio.destinatario = ["Licenciada", "María Fernanda López Castillo", "Jefa de la Unidad de Archivo", "Presente"]>
<cfset oficio.asunto       = "Traslado de expedientes del primer semestre 2026">
<cfset oficio.saludo       = "Respetable licenciada:">
<cfset oficio.cuerpo = [
    "Por este medio me dirijo a usted para informarle que esta Dirección ha concluido la revisión de los expedientes correspondientes al primer semestre del año 2026, los cuales se encuentran ordenados por número de correlativo, con su respectiva hoja de trámite y el índice de documentos que contiene cada uno.",
    "En virtud de lo anterior, solicito su apoyo para programar el traslado físico de dichos expedientes a la Unidad de Archivo durante la primera semana de noviembre, de preferencia en horario de la mañana, con el fin de no interrumpir la atención al público ni las labores ordinarias de ambas dependencias.",
    "Para facilitar la recepción, se adjunta el listado de expedientes en formato digital, en el cual se indica el número de folios de cada uno y las observaciones encontradas durante la revisión. Cualquier diferencia que se identifique al momento de la entrega podrá ser aclarada de inmediato por el personal designado.",
    "Agradezco de antemano la atención prestada a la presente y quedo a su disposición para coordinar los detalles que considere necesarios."
]>
<cfset oficio.firma = ["Juan Carlos Pérez Morales", "Director de Recursos de Ejemplo"]>

<cfscript>
    // 0 izquierda 1 centro 2 derecha 3 justificado
    IZQ = 0; CENTRO = 1; DER = 2; JUSTIFICADO = 3;

    pageSize  = createObject("java", "com.lowagie.text.PageSize");
    documento = createObject("java", "com.lowagie.text.Document").init(
        pageSize.LETTER,
        javacast("float", 50), javacast("float", 50),
        javacast("float", 50), javacast("float", 50)
    );
    salida = createObject("java", "java.io.ByteArrayOutputStream").init();
    createObject("java", "com.lowagie.text.pdf.PdfWriter").getInstance(documento, salida);
    documento.open();

    fTitulo = createObject("java", "com.lowagie.text.Font").init(javacast("int", 1), javacast("float", 14), javacast("int", 1));
    fNormal = createObject("java", "com.lowagie.text.Font").init(javacast("int", 1), javacast("float", 11), javacast("int", 0));
    fNegrita = createObject("java", "com.lowagie.text.Font").init(javacast("int", 1), javacast("float", 11), javacast("int", 1));

    // crea el parrafo y lo mete de una vez, si lo guardas en un array de cf despues truena
    function agregar(texto, fuente, alineacion, espacio) {
        var p = createObject("java", "com.lowagie.text.Paragraph").init(javacast("string", texto), fuente);
        p.setAlignment(javacast("int", alineacion));
        p.setSpacingAfter(javacast("float", espacio));
        documento.add(p);
    }

    agregar(oficio.institucion, fTitulo, CENTRO, 24);
    agregar(oficio.numero, fNormal, DER, 0);
    agregar(oficio.fecha, fNormal, DER, 24);

    for (i = 1; i LTE arrayLen(oficio.destinatario); i = i + 1) {
        agregar(oficio.destinatario[i], fNormal, IZQ, 0);
    }

    // asunto con la etiqueta en negrita, van en chunks porque un paragraph solo lleva una fuente
    p = createObject("java", "com.lowagie.text.Paragraph").init();
    p.add(createObject("java", "com.lowagie.text.Chunk").init(javacast("string", "Asunto: "), fNegrita));
    p.add(createObject("java", "com.lowagie.text.Chunk").init(javacast("string", oficio.asunto), fNormal));
    p.setSpacingBefore(javacast("float", 18));
    p.setSpacingAfter(javacast("float", 18));
    documento.add(p);

    agregar(oficio.saludo, fNormal, IZQ, 10);

    // aca es donde se nota, sin el 3 esto sale como serrucho
    for (i = 1; i LTE arrayLen(oficio.cuerpo); i = i + 1) {
        agregar(oficio.cuerpo[i], fNormal, JUSTIFICADO, 10);
    }

    agregar("Atentamente,", fNormal, IZQ, 60);

    agregar(oficio.firma[1], fNegrita, CENTRO, 0);
    agregar(oficio.firma[2], fNormal, CENTRO, 0);

    documento.close();
</cfscript>

<cfheader name="Content-Disposition" value="inline; filename=oficio.pdf">
<cfcontent type="application/pdf" variable="#salida.toByteArray()#" reset="true">
