<!---
  traer textos largos de sql server por un dsn de cf8
  si el dsn no tiene activado long text retrieval los campos largos
  llegan vacios o cortados y sin acceso al administrator no se puede cambiar
  lo que funciona es pedir el campo en pedazos de 4000 y unirlos aqui
--->

<cfset dsn = "MiDSN">
<cfset idRegistro = 1>

<cfquery name="q" datasource="#dsn#">
    SELECT
        id,
        DATALENGTH(observaciones) AS bytes,
        CAST(SUBSTRING(observaciones, 1,     4000) AS NVARCHAR(4000)) AS p1,
        CAST(SUBSTRING(observaciones, 4001,  4000) AS NVARCHAR(4000)) AS p2,
        CAST(SUBSTRING(observaciones, 8001,  4000) AS NVARCHAR(4000)) AS p3,
        CAST(SUBSTRING(observaciones, 12001, 4000) AS NVARCHAR(4000)) AS p4
    FROM registros
    WHERE id = <cfqueryparam value="#idRegistro#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- a veces la consulta trae varias filas y el texto viene solo en una --->
<cfset textoCompleto = "">
<cfloop query="q">
    <cfset armado = q.p1 & q.p2 & q.p3 & q.p4>
    <cfif len(trim(armado)) GT len(trim(textoCompleto))>
        <cfset textoCompleto = armado>
    </cfif>
</cfloop>

<cfoutput>
    <p>Largo armado #len(textoCompleto)# caracteres</p>
    <div>#htmlEditFormat(textoCompleto)#</div>
</cfoutput>
