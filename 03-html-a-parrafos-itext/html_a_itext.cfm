<!---
  convertir el html que viene de la base a parrafos de itext justificados
  soporta p, br, ul, ol, li, strong, b y las entidades mas comunes
  todo lo demas se quita y queda solo el texto
--->

<cfset htmlOriginal = "<p>El evaluado demostr&oacute; <strong>dominio t&eacute;cnico</strong> en las pruebas aplicadas y buena disposici&oacute;n durante todo el proceso.</p><ul><li>Experiencia en an&aacute;lisis de datos</li><li>Manejo de <b>SQL Server</b></li></ul><p>Se recomienda continuar con la siguiente fase.</p>">

<cfscript>
    function decodificar(texto) {
        var r = texto;
        var i = 0;
        var buscar  = listToArray("&aacute;,&eacute;,&iacute;,&oacute;,&uacute;,&Aacute;,&Eacute;,&Iacute;,&Oacute;,&Uacute;,&ntilde;,&Ntilde;,&uuml;,&Uuml;,&iquest;,&iexcl;,&quot;,&lt;,&gt;,&nbsp;,&##39;");
        var cambiar = listToArray("#chr(225)#,#chr(233)#,#chr(237)#,#chr(243)#,#chr(250)#,#chr(193)#,#chr(201)#,#chr(205)#,#chr(211)#,#chr(218)#,#chr(241)#,#chr(209)#,#chr(252)#,#chr(220)#,#chr(191)#,#chr(161)#,"",<,>, ,'");
        for (i = 1; i LTE arrayLen(buscar); i = i + 1) {
            r = replace(r, buscar[i], cambiar[i], "all");
        }
        // el amp va de ultimo para no romper las otras entidades
        return replace(r, "&amp;", "&", "all");
    }

    // siempre un chunk nuevo, reusar el mismo objeto en cf da problemas
    function nuevoChunk(texto, fuente) {
        return createObject("java", "com.lowagie.text.Chunk").init(javacast("string", texto), fuente);
    }

    // agrega un pedazo de texto al parrafo respetando las marcas de negrita
    function agregarConNegritas(parrafo, texto, normal, negrita) {
        var resto = texto;
        var inicio = 0;
        var fin = 0;

        inicio = find("[[B]]", resto);
        while (inicio GT 0) {
            // ojo que left con largo 0 truena en cf8
            if (inicio GT 1) {
                parrafo.add(nuevoChunk(left(resto, inicio - 1), normal));
            }
            resto = mid(resto, inicio + 5, len(resto));
            fin = find("[[/B]]", resto);
            if (fin EQ 0) { fin = len(resto) + 1; }
            if (fin GT 1) {
                parrafo.add(nuevoChunk(left(resto, fin - 1), negrita));
            }
            if (fin + 6 LTE len(resto)) {
                resto = mid(resto, fin + 6, len(resto));
            } else {
                resto = "";
            }
            inicio = find("[[B]]", resto);
        }
        if (len(resto)) {
            parrafo.add(nuevoChunk(resto, normal));
        }
    }

    // primero marco negritas y saltos, luego quito todas las etiquetas
    t = reReplaceNoCase(htmlOriginal, "<(strong|b)(\s[^>]*)?>", "[[B]]", "all");
    t = reReplaceNoCase(t, "</(strong|b)>", "[[/B]]", "all");
    t = reReplaceNoCase(t, "<li[^>]*>", chr(10) & "@@LI@@", "all");
    t = reReplaceNoCase(t, "</?(p|br|ul|ol|li|div)[^>]*>", chr(10), "all");
    t = reReplace(t, "<[^>]*>", "", "all");
    t = decodificar(t);
    lineas = listToArray(t, chr(10));

    pageSize  = createObject("java", "com.lowagie.text.PageSize");
    documento = createObject("java", "com.lowagie.text.Document").init(
        pageSize.LETTER,
        javacast("float", 50), javacast("float", 50),
        javacast("float", 50), javacast("float", 50)
    );
    salida = createObject("java", "java.io.ByteArrayOutputStream").init();
    createObject("java", "com.lowagie.text.pdf.PdfWriter").getInstance(documento, salida);
    documento.open();

    fNormal  = createObject("java", "com.lowagie.text.Font").init(javacast("int", 1), javacast("float", 11), javacast("int", 0));
    fNegrita = createObject("java", "com.lowagie.text.Font").init(javacast("int", 1), javacast("float", 11), javacast("int", 1));

    for (i = 1; i LTE arrayLen(lineas); i = i + 1) {
        linea = trim(lineas[i]);
        if (len(linea)) {
            p = createObject("java", "com.lowagie.text.Paragraph").init();
            p.setAlignment(javacast("int", 3));
            p.setSpacingAfter(javacast("float", 6));

            if (left(linea, 6) EQ "@@LI@@") {
                linea = trim(mid(linea, 7, len(linea)));
                p.setIndentationLeft(javacast("float", 18));
                p.add(nuevoChunk(chr(8226) & " ", fNormal));
            }

            if (len(linea)) {
                agregarConNegritas(p, linea, fNormal, fNegrita);
            }
            documento.add(p);
        }
    }

    documento.close();
</cfscript>

<cfheader name="Content-Disposition" value="inline; filename=html_a_pdf.pdf">
<cfcontent type="application/pdf" variable="#salida.toByteArray()#" reset="true">
